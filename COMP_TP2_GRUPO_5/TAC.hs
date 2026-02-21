-- Geração de Three-Address Code (Código de Três Endereços)
module TAC
  ( TACInstr(..)         -- instruções TAC
  , TACOperand(..)       -- operandos (variáveis, temporários, constantes)
  , TACBinOp(..)         -- operadores binários
  , TACUnOp(..)          -- operadores unários
  , Label                -- tipo para labels de salto
  , Temp                 -- tipo para temporários (registos virtuais)
  , generateTAC          -- função principal: AST → TAC
  , prettyPrintTAC       -- impressão legível do TAC
  ) where

import AST
import SymbolTable
import qualified Data.Map as Map

-- tipo para labels (etiquetas de salto)
type Label = String

-- tipo para temporários (registos virtuais)
type Temp = String

-- operandos que podem aparecer em instruções TAC
data TACOperand
  = TVar String         -- variável do programa original
  | TTemp Temp          -- temporário gerado
  | TConst Int          -- constante inteira
  | TBoolConst Bool     -- constante booleana
  deriving (Show, Eq)

-- operadores binários TAC
data TACBinOp
  = TAdd | TSub | TMul | TDiv       -- aritméticos: +, -, *, /
  | TEq | TNeq | TLt | TGt | TLe | TGe  -- relacionais: ==, !=, <, >, <=, >=
  | TAnd | TOr                      -- lógicos: and, or
  deriving (Show, Eq)

-- operadores unários TAC
data TACUnOp
  = TNot      -- negação lógica
  | TNeg      -- negação aritmética
  deriving (Show, Eq)

-- instruções TAC (representação intermediária)
data TACInstr
  = TACBinOp Temp TACBinOp TACOperand TACOperand  -- dest := op1 op op2
  | TACUnOp Temp TACUnOp TACOperand               -- dest := op operand
  | TACCopy Temp TACOperand                       -- dest := source
  | TACIfGoto TACOperand Label                    -- if operand goto label (salta se != 0)
  | TACGoto Label                                 -- goto label
  | TACLabel Label                                -- label:
  | TACPrint TACOperand                           -- put_line(operand)
  | TACRead Temp                                  -- dest := get_line()
  | TACComment String                             -- comentários
  deriving (Show, Eq)

-- estado do gerador (mantém contadores e tabela de símbolos)
data GenState = GenState
  { tempCounter :: Int        -- contador para gerar t0, t1, t2, ...
  , labelCounter :: Int       -- contador para gerar L_*_0, L_*_1, ...
  , symbolTable :: SymbolTable
  }

-- gerar novo temporário único
newTemp :: GenState -> (Temp, GenState)
newTemp state = 
  let n = tempCounter state
      temp = "t" ++ show n
  in (temp, state { tempCounter = n + 1 })

-- gerar novo label único
newLabel :: String -> GenState -> (Label, GenState)
newLabel prefix state =
  let n = labelCounter state
      label = prefix ++ show n
  in (label, state { labelCounter = n + 1 })

-- estado inicial
initialState :: SymbolTable -> GenState
initialState table = GenState 0 0 table

-- gerar TAC para programa completo
generateTAC :: Program -> SymbolTable -> [TACInstr]
generateTAC (ProgramMain stms) table =
  let (code, _) = genStmList stms (initialState table)
  in code

-- gerar TAC para lista de statements
genStmList :: [Stm] -> GenState -> ([TACInstr], GenState)
genStmList [] state = ([], state)
genStmList (s:ss) state =
  let (code1, state1) = genStm s state
      (code2, state2) = genStmList ss state1
  in (code1 ++ code2, state2)

-- gerar TAC para um statement individual
genStm :: Stm -> GenState -> ([TACInstr], GenState)

-- atribuição: var := exp
genStm (SAssign var exp) state =
  let (expCode, expTemp, state1) = genExp exp state
      copyInstr = TACCopy var (TTemp expTemp)
  in (expCode ++ [copyInstr], state1)

-- if-then-else (usa negação da condição para saltar)
genStm (SIf cond thenStm elseStm) state =
  case elseStm of
    Nothing ->                                      -- if sem else
      let (condCode, condTemp, state1) = genExp cond state
          (labelEnd, state2) = newLabel "L_end_if_" state1
          
          (negTemp, state3) = newTemp state2
          negInstr = TACUnOp negTemp TNot (TTemp condTemp)
          condJump = TACIfGoto (TTemp negTemp) labelEnd  -- salta se falso
          
          (thenCode, state4) = case thenStm of
            SSeq stms -> genStmList stms state3
            s -> genStm s state3
          
          endLabelInstr = TACLabel labelEnd
          
      in ( condCode
           ++ [negInstr, condJump]
           ++ thenCode
           ++ [endLabelInstr]
         , state4)
    
    Just elseS ->                                   -- if com else
      let (condCode, condTemp, state1) = genExp cond state
          (labelElse, state2) = newLabel "L_else_" state1
          (labelEnd, state3) = newLabel "L_end_if_" state2
          
          (negTemp, state4) = newTemp state3
          negInstr = TACUnOp negTemp TNot (TTemp condTemp)
          condJump = TACIfGoto (TTemp negTemp) labelElse
          
          (thenCode, state5) = case thenStm of
            SSeq stms -> genStmList stms state4
            s -> genStm s state4
          
          gotoEnd = TACGoto labelEnd
          elseLabelInstr = TACLabel labelElse
          
          (elseCode, state6) = case elseS of
            SSeq stms -> genStmList stms state5
            s -> genStm s state5
          
          endLabelInstr = TACLabel labelEnd
          
      in ( condCode
           ++ [negInstr, condJump]
           ++ thenCode
           ++ [gotoEnd, elseLabelInstr]
           ++ elseCode
           ++ [endLabelInstr]
         , state6)

-- while loop
genStm (SWhile cond body) state =
  let (labelStart, state1) = newLabel "L_while_start_" state
      (labelEnd, state2) = newLabel "L_while_end_" state1
      
      startLabelInstr = TACLabel labelStart
      (condCode, condTemp, state3) = genExp cond state2
      
      (negTemp, state4) = newTemp state3
      negInstr = TACUnOp negTemp TNot (TTemp condTemp)
      condJump = TACIfGoto (TTemp negTemp) labelEnd  -- sai se falso
      
      (bodyCode, state5) = case body of
        SSeq stms -> genStmList stms state4
        s -> genStm s state4
      
      gotoStart = TACGoto labelStart
      endLabelInstr = TACLabel labelEnd
      
  in ( [startLabelInstr]
       ++ condCode
       ++ [negInstr, condJump]
       ++ bodyCode
       ++ [gotoStart]
       ++ [endLabelInstr]
     , state5)

-- sequência: begin S1; S2; ... end
genStm (SSeq stms) state = genStmList stms state

-- put_line: impressão
genStm (SPutLine exp) state =
  let (expCode, expTemp, state1) = genExp exp state
      printInstr = TACPrint (TTemp expTemp)
  in (expCode ++ [printInstr], state1)

-- gerar TAC para expressões (retorna: código, temporário com resultado, estado)
genExp :: Exp -> GenState -> ([TACInstr], Temp, GenState)

-- inteiro literal
genExp (EInt n) state =
  let (temp, state1) = newTemp state
      instr = TACCopy temp (TConst n)
  in ([instr], temp, state1)

-- booleano literal
genExp (EBool b) state =
  let (temp, state1) = newTemp state
      instr = TACCopy temp (TBoolConst b)
  in ([instr], temp, state1)

-- variável
genExp (EVar name) state =
  let (temp, state1) = newTemp state
      instr = TACCopy temp (TVar name)
  in ([instr], temp, state1)

-- operação binária: e1 op e2
genExp (EBinOp op e1 e2) state =
  let (code1, temp1, state1) = genExp e1 state
      (code2, temp2, state2) = genExp e2 state1
      (resultTemp, state3) = newTemp state2
      tacOp = convertBinOp op
      instr = TACBinOp resultTemp tacOp (TTemp temp1) (TTemp temp2)
  in (code1 ++ code2 ++ [instr], resultTemp, state3)

-- operação unária: op e
genExp (EUnOp op e) state =
  let (code, temp, state1) = genExp e state
      (resultTemp, state2) = newTemp state1
      tacOp = convertUnOp op
      instr = TACUnOp resultTemp tacOp (TTemp temp)
  in (code ++ [instr], resultTemp, state2)

-- get_line: leitura de input
genExp EGetLine state =
  let (temp, state1) = newTemp state
      instr = TACRead temp
  in ([instr], temp, state1)

-- conversão de operadores AST → TAC
convertBinOp :: BinOp -> TACBinOp
convertBinOp Add = TAdd
convertBinOp Sub = TSub
convertBinOp Mul = TMul
convertBinOp Div = TDiv
convertBinOp Eq  = TEq
convertBinOp Neq = TNeq
convertBinOp Lt  = TLt
convertBinOp Gt  = TGt
convertBinOp Le  = TLe
convertBinOp Ge  = TGe
convertBinOp And = TAnd
convertBinOp Or  = TOr

convertUnOp :: UnOp -> TACUnOp
convertUnOp Not = TNot
convertUnOp Neg = TNeg

-- impressão legível do TAC (para debug)
prettyPrintTAC :: [TACInstr] -> String
prettyPrintTAC instrs = unlines (map showInstr instrs)
  where
    showInstr (TACBinOp t op x y) = 
      "  " ++ t ++ " := " ++ showOp x ++ " " ++ showBinOp op ++ " " ++ showOp y
    
    showInstr (TACUnOp t op x) =
      "  " ++ t ++ " := " ++ showUnOp op ++ " " ++ showOp x
    
    showInstr (TACCopy t x) =
      "  " ++ t ++ " := " ++ showOp x
    
    showInstr (TACIfGoto x label) =
      "  if " ++ showOp x ++ " goto " ++ label
    
    showInstr (TACGoto label) =
      "  goto " ++ label
    
    showInstr (TACLabel label) =
      label ++ ":"
    
    showInstr (TACPrint x) =
      "  print " ++ showOp x
    
    showInstr (TACRead t) =
      "  " ++ t ++ " := read"
    
    showInstr (TACComment s) =
      "  # " ++ s
    
    showOp (TVar v) = v
    showOp (TTemp t) = t
    showOp (TConst n) = show n
    showOp (TBoolConst True) = "true"
    showOp (TBoolConst False) = "false"
    
    showBinOp TAdd = "+"
    showBinOp TSub = "-"
    showBinOp TMul = "*"
    showBinOp TDiv = "/"
    showBinOp TEq = "=="
    showBinOp TNeq = "!="
    showBinOp TLt = "<"
    showBinOp TGt = ">"
    showBinOp TLe = "<="
    showBinOp TGe = ">="
    showBinOp TAnd = "and"
    showBinOp TOr = "or"
    
    showUnOp TNot = "not"
    showUnOp TNeg = "-"