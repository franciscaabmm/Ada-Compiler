-- Análise Sintática (Parser)
-- happy Parser.y
{
module Parser (parseProgram) where 

import AST      -- Árvore Sintática Abstrata
import Lexer    -- Analisador Léxico 
}

%name parseProgram program  -- parseProgram :: [Token] -> Program
%tokentype { Token }        -- especifica o tipo de token usado que vem do lexer onde é definido do tipo Token
%error { parseError }       -- função chamada num erro de análise sintática

-- Declaração dos tokens reconhecidos 


%token
-- palavras reservadas
  procedure   { TOK_PROCEDURE } 
  main        { TOK_MAIN }
  is          { TOK_IS }
  begin       { TOK_BEGIN }
  end         { TOK_END }
  if          { TOK_IF }
  then        { TOK_THEN }
  else        { TOK_ELSE }
  while       { TOK_WHILE }
  loop        { TOK_LOOP }
  put_line    { TOK_PUT_LINE }
  get_line    { TOK_GET_LINE }
  -- operadores lógicos
  and         { TOK_AND }
  or          { TOK_OR }
  not         { TOK_NOT }
  id          { TOK_ID $$ } -- identificador 
  int         { TOK_INT $$ } -- inteiro
  bool        { TOK_BOOL $$ } -- booleano (True or False)
  ':='        { TOK_ASSIGN } -- atribuição
  ';'         { TOK_SEMI } 
  ','         { TOK_COMMA }
  '('         { TOK_LPAREN }
  ')'         { TOK_RPAREN }
  '+'         { TOK_PLUS }
  '-'         { TOK_MINUS }
  '*'         { TOK_MUL }
  '/'         { TOK_DIV }
  '='         { TOK_EQ }
  '/='        { TOK_NEQ }
  '<='        { TOK_LE }
  '>='        { TOK_GE }
  '<'         { TOK_LT }
  '>'         { TOK_GT }
  eof         { TOK_EOF } -- fim do ficheiro

-- regras de precedencia e associatividade dos operadores
%right else 
%left or
%left and
%nonassoc '=' '/=' '<' '>' '<=' '>='
%left '+' '-'
%left '*' '/'
%right not NEG

%%

program :: { Program }
  : procedure main is begin stmList end main ';' eof    { ProgramMain $5 }

stmList :: { [Stm] }
  : stm                 { [$1] } -- uma só instrução 
  | stm stmList         { $1 : $2 } -- instrução seguida de mais instruções

stm :: { Stm }
  : id ':=' exp ';'                             { SAssign $1 $3 }
  | if exp then stmList end if ';'              { SIf $2 (SSeq $4) Nothing }
  | if exp then stmList else stmList end if ';' { SIf $2 (SSeq $4) (Just (SSeq $6)) }
  | while exp loop stmList end loop ';'         { SWhile $2 (SSeq $4) }
  | put_line '(' exp ')' ';'                    { SPutLine $3 }
  | put_line '(' exp ')' ';'                    { SPutLine $3 }

-- definição das expressões
exp :: { Exp }
  : exp '+' exp         { EBinOp Add $1 $3 }
  | exp '-' exp         { EBinOp Sub $1 $3 }
  | exp '*' exp         { EBinOp Mul $1 $3 }
  | exp '/' exp         { EBinOp Div $1 $3 }
  | exp '=' exp         { EBinOp Eq $1 $3 }
  | exp '/=' exp        { EBinOp Neq $1 $3 }
  | exp '<' exp         { EBinOp Lt $1 $3 }
  | exp '>' exp         { EBinOp Gt $1 $3 }
  | exp '<=' exp        { EBinOp Le $1 $3 }
  | exp '>=' exp        { EBinOp Ge $1 $3 }
  | exp and exp         { EBinOp And $1 $3 }
  | exp or exp          { EBinOp Or $1 $3 }
  | not exp             { EUnOp Not $2 }
  | '-' exp %prec NEG   { EUnOp Neg $2 }
  | '(' exp ')'         { $2 }
  | int                 { EInt $1 }
  | bool                { EBool $1 }
  | id                  { EVar $1 }
  | get_line '(' ')'    { EGetLine }


-- Função para erros sintáticos
{
parseError :: [Token] -> a
parseError tokens = error $ "Parse error at: " ++ show (take 10 tokens) -- mostra os 10 tokens depois do erro
}