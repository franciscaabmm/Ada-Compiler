-- Análise Léxica (Lexer)
-- alex Lexer.x
{
module Lexer (Token(..), alexScanTokens) where
import Data.Char (toLower)
}

%wrapper "basic" -- gera a função alexScanTokens :: String -> [Token]

tokens :-

$white+                         ; -- ignora os espaços em branco
"--".*                          ; -- ignora comentários "--" até ao fim da linha

":="                            { \s -> TOK_ASSIGN } -- atribuição
"/="                            { \s -> TOK_NEQ }    
"<="                            { \s -> TOK_LE }
">="                            { \s -> TOK_GE }
";"                             { \s -> TOK_SEMI }
","                             { \s -> TOK_COMMA }
"("                             { \s -> TOK_LPAREN }
")"                             { \s -> TOK_RPAREN }
"+"                             { \s -> TOK_PLUS }
"-"                             { \s -> TOK_MINUS }
"*"                             { \s -> TOK_MUL }
"/"                             { \s -> TOK_DIV }
"="                             { \s -> TOK_EQ }
"<"                             { \s -> TOK_LT }
">"                             { \s -> TOK_GT }

[0-9]+                          { \s -> TOK_INT (read s) }        -- read converte de String para Int
[a-zA-Z_][a-zA-Z0-9_]*          { \s -> identifierOrKeyword s }   -- para identificadores ou palavras reservadas

{
data Token = TOK_PROCEDURE   -- palavras reservadas
          | TOK_MAIN 
          | TOK_IS 
          | TOK_BEGIN 
          | TOK_END 
          | TOK_IF 
          | TOK_THEN 
          | TOK_ELSE 
          | TOK_WHILE 
          | TOK_LOOP 
          | TOK_PUT_LINE 
          | TOK_GET_LINE 
          -- operadores lógicos
          | TOK_AND 
          | TOK_OR 
          | TOK_NOT 
          | TOK_ID String -- identificador 
          | TOK_INT Int   -- inteiro 
          | TOK_BOOL Bool -- booleano 
          | TOK_ASSIGN 
          | TOK_SEMI 
          | TOK_COMMA 
          | TOK_LPAREN 
          | TOK_RPAREN 
          -- operadores aritméticos 
          | TOK_PLUS 
          | TOK_MINUS 
          | TOK_MUL 
          | TOK_DIV   
          | TOK_EQ 
          | TOK_NEQ 
          | TOK_LE 
          | TOK_GE 
          | TOK_LT 
          | TOK_GT 
          | TOK_EOF
          deriving (Show, Eq)

identifierOrKeyword :: String -> Token
identifierOrKeyword s = case map toLower s of -- torna case-insensitive
  "procedure" -> TOK_PROCEDURE
  "main" -> TOK_MAIN
  "is" -> TOK_IS
  "begin" -> TOK_BEGIN
  "end" -> TOK_END
  "if" -> TOK_IF
  "then" -> TOK_THEN
  "else" -> TOK_ELSE
  "while" -> TOK_WHILE
  "loop" -> TOK_LOOP
  "put_line" -> TOK_PUT_LINE
  "get_line" -> TOK_GET_LINE
  "and" -> TOK_AND
  "or" -> TOK_OR
  "not" -> TOK_NOT
  "true" -> TOK_BOOL True
  "false" -> TOK_BOOL False
  _ -> TOK_ID s -- se não for uma das palavras reservadas identificadas acima então é identificador
}