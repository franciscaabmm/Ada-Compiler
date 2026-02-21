-- Tabela de Símbolos do Compilador
module SymbolTable 
  ( SymbolTable              -- tipo opaco (implementação escondida)
  , VarInfo(..)              -- informação de variável (campos exportados)
  , VarType(..)              -- tipos suportados (construtores exportados)
  , emptyTable               -- criar tabela vazia
  , insertVar                -- adicionar/atualizar variável
  , lookupVar                -- procurar variável
  , getAllVars               -- obter todas as variáveis
  , typeOf                   -- obter tipo de variável (com verificação)
  , SemanticError(..)        -- erros semânticos possíveis
  ) where

import qualified Data.Map as Map
import Data.Maybe (fromMaybe)

-- tipos de variáveis suportados
data VarType 
  = TInt      -- tipo inteiro
  | TBool     -- tipo booleano
  | TUnknown  -- tipo desconhecido (usado quando há erro de tipo)
  deriving (Show, Eq)

-- informação sobre uma variável
data VarInfo = VarInfo
  { varName :: String         -- nome da variável
  , varType :: VarType        -- tipo da variável
  , varInitialized :: Bool    -- se foi inicializada
  , varLocation :: Int        -- offset na memória (múltiplos de 4)
  } deriving (Show, Eq)

-- tabela de símbolos: mapeamento de nomes → informação
type SymbolTable = Map.Map String VarInfo

-- erros semânticos possíveis
data SemanticError
  = UndeclaredVariable String                  -- variável usada mas não declarada
  | TypeMismatch String VarType VarType        -- conflito de tipos
  | UninitializedVariable String               -- variável não inicializada (não usado)
  | RedefinedVariable String                   -- variável redefinida (não usado)
  deriving (Show, Eq)

-- criar tabela vazia
emptyTable :: SymbolTable
emptyTable = Map.empty

-- inserir ou atualizar variável na tabela
insertVar :: String -> VarType -> Bool -> Int -> SymbolTable -> SymbolTable
insertVar name typ initialized loc table =
  Map.insert name (VarInfo name typ initialized loc) table

-- procurar variável na tabela
lookupVar :: String -> SymbolTable -> Maybe VarInfo
lookupVar = Map.lookup

-- obter lista de todas as variáveis
getAllVars :: SymbolTable -> [VarInfo]
getAllVars = Map.elems

-- obter tipo de variável com verificação de existência
typeOf :: String -> SymbolTable -> Either SemanticError VarType
typeOf name table = case lookupVar name table of
  Just info -> Right (varType info)              -- sucesso: retorna tipo
  Nothing   -> Left (UndeclaredVariable name)    -- erro: variável não existe

-- verificar se variável foi inicializada (não exportada)
isInitialized :: String -> SymbolTable -> Bool
isInitialized name table = case lookupVar name table of
  Just info -> varInitialized info
  Nothing   -> False

-- marcar variável como inicializada (não exportada)
markInitialized :: String -> SymbolTable -> SymbolTable
markInitialized name table = case lookupVar name table of
  Just info -> Map.insert name (info { varInitialized = True }) table
  Nothing   -> table