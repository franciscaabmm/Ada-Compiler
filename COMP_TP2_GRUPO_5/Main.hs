-- Módulo principal do compilador
-- ghc --make -o compiler Main.hs
module Main where

import System.Environment (getArgs)      -- lê argumentos da linha de comando
import System.Exit (exitFailure)         -- termina o programa em caso de erro
import System.FilePath (replaceExtension)-- manipulação de extensões de ficheiros
import qualified Lexer                   -- Análise Léxica (gera tokens)
import qualified Parser                  -- Análise Sintática (gera a AST)
import qualified AST                     -- Árvore de Sinaxe Abstrata (AST)
import qualified SymbolTable as ST       -- Tabela de Símbolos (gestão de escopo/variáveis)
import qualified Semantic as Sem         -- Análise Semântica (verificação de tipos)
import qualified TAC                     -- Código de Três Endereços (Intermédio)
import qualified MIPS                    -- Geração de Código Assembly MIPS

main :: IO ()
main = do
  args <- getArgs
  
  case args of
    [filename] -> do
      -- Ler o ficheiro de entrada
      input <- readFile filename
      
      -- ===== FASE 1: ANÁLISE LÉXICA =====
      putStrLn "=== TOKENS (Lexer) ==="
      let tokens = Lexer.alexScanTokens input ++ [Lexer.TOK_EOF] -- Adiciona EOF no fim do ficheiro
      -- alexScanTokens :: String -> [Token]
      mapM_ print tokens -- mostra todos os tokens gerados no terminal
      putStrLn ""
      
      -- ===== FASE 2: ANÁLISE SINTÁTICA =====
      putStrLn "=== Árvore de Sintaxe Abstrata (AST) ==="
      let ast = Parser.parseProgram tokens -- envia a lista de tokens para o parser
      -- parseProgram :: [Token] -> Program (AST)
      print ast
      putStrLn ""
      
      -- ===== FASE 3: ANÁLISE SEMÂNTICA =====
      putStrLn "=== Análise Semântica ==="
      case Sem.analyzeProgram ast of -- Verifica regras semânticas (tipos, declarações)
        Left errors -> do
          -- Caso encontre erros semânticos
          putStrLn "erros semânticos encontrados:"
          mapM_ print errors
          exitFailure
        
        Right symTable -> do
          -- Caso a análise seja bem sucedida
          putStrLn "Sem erros semânticos"
          putStrLn "\n=== Tabela de Símbolos ==="
          mapM_ print (ST.getAllVars symTable) -- Mostra estado final das variáveis
          putStrLn ""
          
          -- ===== FASE 4: GERAÇÃO DE CÓDIGO INTERMÉDIO (TAC) =====
          putStrLn "=== THREE-ADDRESS CODE ==="
          let tacCode = TAC.generateTAC ast symTable -- Gera código intermédio a partir da AST
          putStrLn (TAC.prettyPrintTAC tacCode)      -- Imprime o TAC de forma legível
          
          -- ===== FASE 5: GERAÇÃO DE CÓDIGO MIPS =====
          putStrLn "=== Geração de código MIPS ==="
          let mipsCode = MIPS.generateMIPS tacCode symTable -- Traduz TAC para Assembly MIPS
          
          -- Escrever ficheiro .asm
          let asmFilename = replaceExtension filename ".asm" -- Troca a extensão .ada por .asm
          MIPS.writeMIPSFile asmFilename mipsCode            -- Guarda o resultado em disco
          putStrLn $ "Código MIPS guardado em: " ++ asmFilename
          
          putStrLn "\nCompilado Corretamente!"
          putStrLn $ "Correr com: java -jar Mars4_5.jar " ++ asmFilename
      
    _ -> do
      putStrLn "Uso: compiler <input_file.ada>"
      exitFailure -- Termina se os argumentos estiverem incorretos