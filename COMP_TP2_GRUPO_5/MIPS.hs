-- Gerador de Código Assembly MIPS
module MIPS
  ( generateMIPS      -- função principal: TAC → String (código MIPS)
  , writeMIPSFile     -- função auxiliar para escrever em ficheiro
  ) where

import TAC
import SymbolTable
import qualified Data.Map as Map
import Data.List (intercalate)

-- mapeamento de temporários TAC → registos MIPS
type RegisterMap = Map.Map String String

-- estado do gerador MIPS
data MIPSState = MIPSState
  { regMap :: RegisterMap           -- mapa: nome_temporário → registo_MIPS
  , nextTempReg :: Int              -- próximo $t disponível (0-7)
  , varOffsets :: Map.Map String Int  -- mapa: nome_variável → offset_na_stack
  , mipsCode :: [String]            -- código MIPS gerado (acumulado em reverso)
  , nextStackOffset :: Int          -- próximo offset livre na stack (em bytes)
  }

-- estado inicial do gerador
initialMIPSState :: SymbolTable -> MIPSState
initialMIPSState symTable =
  let vars = getAllVars symTable
      -- criar mapa de offsets baseado nas localizações da symbol table
      offsets = Map.fromList [(varName v, varLocation v) | v <- vars]
      -- calcular próximo offset livre: máximo existente + 4 bytes
      maxOffset = if null vars then -4 else maximum (map varLocation vars)
  in MIPSState Map.empty 0 offsets [] (maxOffset + 4)

-- gerar código MIPS completo a partir de instruções TAC
generateMIPS :: [TACInstr] -> SymbolTable -> String
generateMIPS tacInstrs symTable =
  let state = initialMIPSState symTable
      finalState = foldl generateInstr state tacInstrs  -- processar cada instrução TAC
      dataSection = generateDataSection symTable
      textSection = generateTextSection (reverse $ mipsCode finalState)
  in unlines (dataSection ++ [""] ++ textSection)

-- secção .data - define dados globais e constantes
generateDataSection :: SymbolTable -> [String]
generateDataSection symTable =
  [ ".data"
  , "newline: .asciiz \"\\n\""  -- string para imprimir nova linha
  ]

-- secção .text - código executável
generateTextSection :: [String] -> [String]
generateTextSection instructions =
  [ ".text"
  , ".globl main"              -- tornar 'main' visível globalmente
  , ""
  , "main:"
  , "  # Prólogo: setup stack frame"
  , "  addi $sp, $sp, -100  # Reservar 100 bytes na stack"
  , ""
  ] ++ instructions ++
  [ ""
  , "  # Epílogo: exit"
  , "  li $v0, 10          # syscall 10 = exit"
  , "  syscall"
  ]

-- geração de instruções TAC → MIPS
generateInstr :: MIPSState -> TACInstr -> MIPSState

-- operação binária: dest := src1 op src2
generateInstr state (TACBinOp dest op src1 src2) =
  let 
      (reg1, state1) = getOperandReg src1 state       -- obter registo para primeiro operando
      (reg2, state2) = getOperandReg src2 state1      -- obter registo para segundo operando
      (destReg, state3) = allocateTempReg dest state2 -- alocar registo para destino
      instr = case op of
        TAdd -> ["  add " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]
        TSub -> ["  sub " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]
        TMul -> ["  mul " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]
        TDiv -> ["  div " ++ reg1 ++ ", " ++ reg2,    -- divide reg1/reg2
                 "  mflo " ++ destReg]                 -- quociente → destReg
        TEq  -> ["  seq " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]  -- ==
        TNeq -> ["  sne " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]  -- !=
        TLt  -> ["  slt " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]  -- <
        TGt  -> ["  sgt " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]  -- >
        TLe  -> ["  sle " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]  -- <=
        TGe  -> ["  sge " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]  -- >=
        TAnd -> ["  and " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]
        TOr  -> ["  or " ++ destReg ++ ", " ++ reg1 ++ ", " ++ reg2]
  in appendCode instr state3

-- operação unária: dest := op src
generateInstr state (TACUnOp dest op src) =
  let (srcReg, state1) = getOperandReg src state
      (destReg, state2) = allocateTempReg dest state1
      instr = case op of
        TNeg -> ["  neg " ++ destReg ++ ", " ++ srcReg]  -- negação aritmética
        TNot -> ["  seq " ++ destReg ++ ", " ++ srcReg ++ ", $zero"]  -- negação lógica
  in appendCode instr state2

-- cópia: dest := src (garante que variáveis são guardadas na stack)
generateInstr state (TACCopy dest src) =
  case src of
    TConst n ->                                       -- constante inteira
      let (destReg, state1) = allocateTempReg dest state
          instr = ["  li " ++ destReg ++ ", " ++ show n]  -- load immediate
          state2 = appendCode instr state1
          state3 = if isVariable dest state2          -- se destino é variável, guardar na stack
                   then let (offset, state2a) = ensureVarOffset dest state2
                            store = ["  sw " ++ destReg ++ ", " ++ show offset ++ "($sp)"]
                        in appendCode store state2a
                   else state2
      in state3
    TBoolConst b ->                                   -- constante booleana (true/false → 1/0)
      let (destReg, state1) = allocateTempReg dest state
          val = if b then 1 else 0
          instr = ["  li " ++ destReg ++ ", " ++ show val]
          state2 = appendCode instr state1
          state3 = if isVariable dest state2
                   then let (offset, state2a) = ensureVarOffset dest state2
                            store = ["  sw " ++ destReg ++ ", " ++ show offset ++ "($sp)"]
                        in appendCode store state2a
                   else state2
      in state3
    TVar var ->                                       -- variável (ler da stack)
      let (srcOffset, state0) = ensureVarOffset var state
          (destReg, state1) = allocateTempReg dest state0
          instr = ["  lw " ++ destReg ++ ", " ++ show srcOffset ++ "($sp)"]
          state2 = appendCode instr state1
          state3 = if isVariable dest state2          -- se destino também é variável, guardar na stack
                   then let (destOffset, state2a) = ensureVarOffset dest state2
                            store = ["  sw " ++ destReg ++ ", " ++ show destOffset ++ "($sp)"]
                        in appendCode store state2a
                   else state2
      in state3
    TTemp temp ->                                     -- temporário (já em registo)
      let srcReg = getTempReg temp state
          (destReg, state1) = allocateTempReg dest state
          instr = if srcReg == destReg                -- otimização: não copiar se mesmo registo
                  then []
                  else ["  move " ++ destReg ++ ", " ++ srcReg]
          state2 = appendCode instr state1
          state3 = if isVariable dest state2
                   then let (offset, state2a) = ensureVarOffset dest state2
                            store = ["  sw " ++ destReg ++ ", " ++ show offset ++ "($sp)"]
                        in appendCode store state2a
                   else state2
      in state3

-- salto condicional: if cond goto label (salta se cond != 0)
generateInstr state (TACIfGoto cond label) =
  let (condReg, state1) = getOperandReg cond state
      instr = ["  bnez " ++ condReg ++ ", " ++ label]  -- branch if not equal zero
  in appendCode instr state1

-- salto incondicional: goto label
generateInstr state (TACGoto label) =
  let instr = ["  j " ++ label]
  in appendCode instr state

-- label: define ponto de salto
generateInstr state (TACLabel label) =
  let instr = [label ++ ":"]
  in appendCode instr state

-- print: imprime valor e nova linha (usa syscalls 1 e 4)
generateInstr state (TACPrint operand) =
  let (reg, state1) = getOperandReg operand state
      instr = [ "  # print_int"
              , "  move $a0, " ++ reg        -- argumento em $a0
              , "  li $v0, 1"                -- syscall 1 = print_int
              , "  syscall"
              , "  # print newline"
              , "  li $v0, 4"                -- syscall 4 = print_string
              , "  la $a0, newline"
              , "  syscall"
              ]
  in appendCode instr state1

-- read: lê inteiro do utilizador (usa syscall 5)
generateInstr state (TACRead dest) =
  let (destReg, state1) = allocateTempReg dest state
      instr = [ "  # read_int"
              , "  li $v0, 5"                -- syscall 5 = read_int
              , "  syscall"
              , "  move " ++ destReg ++ ", $v0"
              ]
      state2 = appendCode instr state1
      state3 = if isVariable dest state2     -- se destino é variável, guardar na stack
               then let (offset, state2a) = ensureVarOffset dest state2
                        store = ["  sw " ++ destReg ++ ", " ++ show offset ++ "($sp)"]
                    in appendCode store state2a
               else state2
  in state3

-- comentário: preservar comentários TAC no código MIPS
generateInstr state (TACComment text) =
  let instr = ["  # " ++ text]
  in appendCode instr state

-- obter registo para operando (gera código de load se necessário)
getOperandReg :: TACOperand -> MIPSState -> (String, MIPSState)

getOperandReg (TConst n) state =                      -- constante inteira
  let regNum = nextTempReg state `mod` 8              -- usar $t0-$t7 (circular)
      reg = "$t" ++ show regNum
      state1 = state { nextTempReg = nextTempReg state + 1 }
      state2 = appendCode ["  li " ++ reg ++ ", " ++ show n] state1
  in (reg, state2)

getOperandReg (TBoolConst b) state =                  -- constante booleana
  let val = if b then 1 else 0
      regNum = nextTempReg state `mod` 8
      reg = "$t" ++ show regNum
      state1 = state { nextTempReg = nextTempReg state + 1 }
      state2 = appendCode ["  li " ++ reg ++ ", " ++ show val] state1
  in (reg, state2)

getOperandReg (TVar var) state =                      -- variável (carregar da stack)
  let (offset, state1) = ensureVarOffset var state
      regNum = nextTempReg state1 `mod` 8
      reg = "$t" ++ show regNum
      state2 = state1 { nextTempReg = nextTempReg state1 + 1 }
      state3 = appendCode ["  lw " ++ reg ++ ", " ++ show offset ++ "($sp)"] state2
  in (reg, state3)

getOperandReg (TTemp temp) state =                    -- temporário (já em registo)
  let reg = getTempReg temp state
  in (reg, state)

-- alocar registo para temporário
allocateTempReg :: String -> MIPSState -> (String, MIPSState)
allocateTempReg temp state =
  case Map.lookup temp (regMap state) of
    Just reg -> (reg, state)                          -- temporário já tem registo
    Nothing ->
      let regNum = nextTempReg state `mod` 8          -- alocação circular $t0-$t7
          reg = "$t" ++ show regNum
          newMap = Map.insert temp reg (regMap state)
          state1 = state { regMap = newMap, nextTempReg = nextTempReg state + 1 }
      in (reg, state1)

-- obter registo de temporário (deve já existir)
getTempReg :: String -> MIPSState -> String
getTempReg temp state =
  case Map.lookup temp (regMap state) of
    Just reg -> reg
    Nothing -> error $ "Temporary " ++ temp ++ " not allocated"

-- verifica se é variável (se já existe em varOffsets)
isVariable :: String -> MIPSState -> Bool
isVariable name state = Map.member name (varOffsets state)

-- obter ou criar offset de variável na stack
ensureVarOffset :: String -> MIPSState -> (Int, MIPSState)
ensureVarOffset var state =
  case Map.lookup var (varOffsets state) of
    Just off -> (off, state)                          -- variável já tem offset
    Nothing -> 
      let newOffset = nextStackOffset state           -- criar novo offset
          newOffsets = Map.insert var newOffset (varOffsets state)
          newState = state { varOffsets = newOffsets
                           , nextStackOffset = newOffset + 4  -- +4 bytes (word)
                           }
      in (newOffset, newState)

-- adicionar instruções ao código acumulado (em ordem reversa)
appendCode :: [String] -> MIPSState -> MIPSState
appendCode instrs state =
  state { mipsCode = reverse instrs ++ mipsCode state }

-- escrever código MIPS gerado em ficheiro .asm
writeMIPSFile :: FilePath -> String -> IO ()
writeMIPSFile path code = writeFile path code