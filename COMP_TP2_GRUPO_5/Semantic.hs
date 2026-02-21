-- Análise Semântica e Inferência de Tipos
module Semantic
  ( analyzeProgram    -- análise completa: AST → Either Erros SymbolTable
  , inferTypes        -- alias para analyzeProgram
  , checkSemantics    -- alias para analyzeProgram
  ) where

import AST
import SymbolTable
import qualified Data.Map as Map
import Control.Monad (foldM)

-- Estado da Análise Semântica
data SemanticState = SemanticState
  { symTable :: SymbolTable          -- tabela de símbolos em construção
  , errors :: [SemanticError]        -- lista de erros semânticos encontrados
  , nextLoc :: Int                   -- próxima localização livre (cresce de 4 em 4 bytes)
  }

-- estado inicial: tabela vazia, sem erros, primeira localização = 0
initialState :: SemanticState
initialState = SemanticState emptyTable [] 0

-- Análise do programa completo
analyzeProgram :: Program -> Either [SemanticError] SymbolTable
analyzeProgram (ProgramMain stms) =
  let finalState = analyzeStmList stms initialState
  in if null (errors finalState)
     then Right (symTable finalState)  -- sucesso: retorna tabela de símbolos
     else Left (errors finalState)     -- falha: retorna lista de erros

-- aliases para compatibilidade de interface
inferTypes :: Program -> Either [SemanticError] SymbolTable
inferTypes = analyzeProgram

checkSemantics :: Program -> Either [SemanticError] SymbolTable
checkSemantics = analyzeProgram

-- Análise de lista de statements
analyzeStmList :: [Stm] -> SemanticState -> SemanticState
analyzeStmList stms state = foldl analyzeStm state stms

-- Análise de statements individuais
analyzeStm :: SemanticState -> Stm -> SemanticState

-- atribuição: x := exp
analyzeStm state (SAssign var exp) =
  let 
      (expType, state1) = inferExpType exp state       -- inferir tipo da expressão
      table = symTable state1
      
      state2 = case lookupVar var table of
        Just info ->                                    -- variável já existe
          if varType info == expType || varType info == TUnknown
          then state1                                   -- tipos compatíveis
          else addError (TypeMismatch var (varType info) expType) state1
        
        Nothing ->                                      -- variável nova
          let loc = nextLoc state1
              newTable = insertVar var expType True loc table
          in state1 { symTable = newTable
                    , nextLoc = loc + 4                 -- próxima localização (+4 bytes)
                    }
  
  in state2

-- if-then-else: if cond then stm1 else stm2
analyzeStm state (SIf cond thenStm elseStm) =
  let 
      (condType, state1) = inferExpType cond state     -- inferir tipo da condição
      
      state2 = if condType /= TBool && condType /= TUnknown
               then addError (TypeMismatch "if condition" TBool condType) state1
               else state1                              -- condição deve ser booleana
      
      state3 = case thenStm of                          -- analisar ramo then
        SSeq stms -> analyzeStmList stms state2
        s -> analyzeStm state2 s
      
      state4 = case elseStm of                          -- analisar ramo else (opcional)
        Nothing -> state3
        Just (SSeq stms) -> analyzeStmList stms state3
        Just s -> analyzeStm state3 s
  
  in state4

-- while loop: while cond loop body end loop
analyzeStm state (SWhile cond body) =
  let 
      (condType, state1) = inferExpType cond state     -- inferir tipo da condição
      
      state2 = if condType /= TBool && condType /= TUnknown
               then addError (TypeMismatch "while condition" TBool condType) state1
               else state1                              -- condição deve ser booleana
      
      state3 = case body of                             -- analisar corpo do loop
        SSeq stms -> analyzeStmList stms state2
        s -> analyzeStm state2 s
  
  in state3

-- sequência: begin stm1; stm2; ... end
analyzeStm state (SSeq stms) = analyzeStmList stms state

-- put_line: impressão de valor (aceita qualquer tipo)
analyzeStm state (SPutLine exp) =
  let (expType, state1) = inferExpType exp state
  in state1

-- Inferência de Tipos de Expressões
inferExpType :: Exp -> SemanticState -> (VarType, SemanticState)

-- inteiro literal
inferExpType (EInt _) state = (TInt, state)

-- booleano literal
inferExpType (EBool _) state = (TBool, state)

-- variável: consultar tipo na tabela de símbolos
inferExpType (EVar name) state =
  let table = symTable state
  in case lookupVar name table of
    Just info -> (varType info, state)                  -- variável declarada
    Nothing -> 
      let state1 = addError (UndeclaredVariable name) state
      in (TUnknown, state1)                             -- variável não declarada

-- operação binária: e1 op e2
inferExpType (EBinOp op e1 e2) state =
  let 
      (t1, state1) = inferExpType e1 state              -- inferir tipos dos operandos
      (t2, state2) = inferExpType e2 state1
      
      (expectedType, resultType) = case op of           -- determinar tipos esperados
        Add -> (TInt, TInt)                             -- operadores aritméticos: Int × Int → Int
        Sub -> (TInt, TInt)
        Mul -> (TInt, TInt)
        Div -> (TInt, TInt)
        Eq  -> (TInt, TBool)                            -- operadores relacionais: Int × Int → Bool
        Neq -> (TInt, TBool)
        Lt  -> (TInt, TBool)
        Gt  -> (TInt, TBool)
        Le  -> (TInt, TBool)
        Ge  -> (TInt, TBool)
        And -> (TBool, TBool)                           -- operadores lógicos: Bool × Bool → Bool
        Or  -> (TBool, TBool)
      
      state3 = if t1 /= expectedType && t1 /= TUnknown  -- verificar operando esquerdo
               then addError (TypeMismatch "binary operator left" expectedType t1) state2
               else state2
      
      state4 = if t2 /= expectedType && t2 /= TUnknown  -- verificar operando direito
               then addError (TypeMismatch "binary operator right" expectedType t2) state3
               else state3
  
  in (resultType, state4)

-- operação unária: op e
inferExpType (EUnOp op e) state =
  let 
      (t, state1) = inferExpType e state                -- inferir tipo do operando
      
      (expectedType, resultType) = case op of
        Not -> (TBool, TBool)                           -- not: Bool → Bool
        Neg -> (TInt, TInt)                             -- negação aritmética: Int → Int
      
      state2 = if t /= expectedType && t /= TUnknown    -- verificar tipo do operando
               then addError (TypeMismatch "unary operator" expectedType t) state1
               else state1
  
  in (resultType, state2)

-- get_line: leitura de input (sempre retorna Int)
inferExpType EGetLine state = (TInt, state)

-- adicionar erro à lista de erros
addError :: SemanticError -> SemanticState -> SemanticState
addError err state = state { errors = err : errors state }