-- Árvore de Sintaxe Abstrata (AST)
module AST where  
-- procedimento main com uma lista de comandos
data Program = ProgramMain [Stm]  
  deriving (Show, Eq)              -- permite imprimir e comparar programas

-- statements/comandos da linguagem
data Stm
  = SAssign String Exp            -- x := exp;
  | SIf Exp Stm (Maybe Stm)       -- if exp then stm [else stm]
  | SWhile Exp Stm                -- while exp loop stm end loop
  | SSeq [Stm]                    -- stm1; stm2; ...
  | SPutLine Exp                  -- Put_Line(exp);
  deriving (Show, Eq)             --permite exibir e comparar comandos

-- expressoes
data Exp
  = EInt Int                      -- valor inteiro
  | EBool Bool                    -- valor booleano
  | EVar String                   -- variável
  | EBinOp BinOp Exp Exp          -- operação binária  
  | EUnOp UnOp Exp                -- operação unári
  | EGetLine                      -- função Get_Line(), p ler entrada
  deriving (Show, Eq)

-- operadores binários (dois elementos)
data BinOp
  = Add | Sub | Mul | Div         -- operadores aritméticos 
  | Eq | Neq | Lt | Gt | Le | Ge  -- operadores relacionais 
    | And | Or                    -- operadores lógicos 
  deriving (Show, Eq)

-- Definição Operadores Unários 
data UnOp = Not | Neg   -- Not -> negação lógica "not" e Neg -> negação aritmética "-x"          
  deriving (Show, Eq)