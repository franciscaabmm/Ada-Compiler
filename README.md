# 🧩 Ada Compiler in Haskell

> Projeto final da cadeira de **Compiladores** na FCUP — um compilador completo para um subset de Ada, escrito de raiz em Haskell, que gera assembly MIPS executável.

**Grupo 5 · FCUP · Novembro 2025**  
Francisca Macedo · [Flávia Queiroz](https://github.com/flaviaqueiroz)

---

## 💡 Contexto

Este projeto nasceu como trabalho prático de Compiladores e acabou por ser um dos mais completos e desafiantes que fiz no curso. O objetivo era implementar **todas as fases de um compilador real** — desde ler o código-fonte até produzir assembly MIPS que corre num simulador.

A escolha do Haskell não foi por acaso: é uma linguagem que se encaixa muito bem com a natureza funcional e estrutural de um compilador. Tipos algébricos para a AST, pattern matching para as transformações — tudo fez muito sentido.

---

## 🏗️ Arquitetura

O compilador segue um pipeline clássico de 5 fases:

```
┌─────────────┐
│  Código Ada │
└──────┬──────┘
       │
       ▼
┌─────────────┐      ┌──────────────────────────────────┐
│   Lexer     │────▶ │  Sequência de Tokens            │
└─────────────┘      └───────────────┬──────────────────┘
                                    │
                                    ▼
                    ┌──────────────────────────────────┐
                    │   Parser → AST                   │
                    └───────────────┬──────────────────┘
                                    │
                                    ▼
                    ┌──────────────────────────────────┐
                    │   Análise Semântica              │
                    │   + Tabela de Símbolos           │
                    └───────────────┬──────────────────┘
                                    │
                                    ▼
                    ┌──────────────────────────────────┐
                    │   Three-Address Code (TAC)       │
                    └───────────────┬──────────────────┘
                                    │
                                    ▼
                    ┌──────────────────────────────────┐
                    │   Código Assembly MIPS (.asm)    │
                    └──────────────────────────────────┘
```

---

## 📁 Estrutura do Projeto

```
compiler/
├── Lexer.x           # Especificação do analisador léxico (Alex)
├── Parser.y          # Gramática e construção da AST (Happy)
├── AST.hs            # Tipos algébricos da Árvore Sintática Abstrata
├── Semantic.hs       # Inferência de tipos e verificação semântica
├── SymbolTable.hs    # Tabela de símbolos e gestão de offsets
├── TAC.hs            # Gerador de código intermédio (Three-Address Code)
├── MIPS.hs           # Gerador de assembly MIPS
├── Main.hs           # Pipeline principal
├── compiler.cabal    # Configuração do projeto
├── tests/            # Testes básicos (7 programas)
└── harder_tests/     # Testes avançados (20 programas)
```

---

## 🔍 Fases de Compilação em Detalhe

### 1. 🔤 Análise Léxica — `Lexer.x`

Usa **Alex** para gerar o lexer automaticamente a partir de expressões regulares. Reconhece palavras reservadas (`procedure`, `if`, `while`, `begin`, `end`...), identificadores, literais inteiros e booleanos, operadores e símbolos. Espaços e comentários são descartados aqui.

### 2. 🌳 Análise Sintática — `Parser.y`

Usa **Happy** para gerar um parser **LALR(1)**. Valida a gramática da linguagem, lida com precedência e associatividade de operadores, e constrói a AST automaticamente. Em caso de erro sintático, reporta os próximos 10 tokens para facilitar o diagnóstico.

### 3. 🧠 Análise Semântica — `Semantic.hs`

Percorre a AST e verifica:
- **Inferência de tipos** — determina o tipo de cada expressão e variável
- **Compatibilidade de tipos** — impede, por exemplo, `Int + Bool`
- **Variáveis não declaradas** — deteta uso antes de atribuição
- **Múltiplos erros** — reporta todos os erros semânticos antes de parar

```haskell
data SemanticError
  = UndeclaredVariable String
  | TypeMismatch String VarType VarType
  | UninitializedVariable String
```

Se forem encontrados erros semânticos, o compilador para aqui — não gera TAC nem MIPS.

### 4. ⚙️ Geração de TAC — `TAC.hs`

Produz **Three-Address Code**, um código intermédio simples onde cada instrução faz apenas uma operação. Usa temporários (`t0`, `t1`, ...) e labels (`L_while_start_0`, ...) para representar o fluxo de controlo.

```
L_while_start_0:
    t2 := b
    t3 := 0
    t4 := t2 != t3
    t5 := not t4
    if t5 goto L_while_end_1
    ...
    goto L_while_start_0
L_while_end_1:
```

### 5. 💾 Geração de MIPS — `MIPS.hs`

Traduz o TAC para assembly MIPS real. Utiliza:
- **`$t0`–`$t7`** para registos temporários (alocação cíclica)
- **Stack frame** para armazenar variáveis (100 bytes por padrão, cada variável com offset fixo relativo a `$sp`)
- **Syscalls** para I/O: `1` (print int), `4` (print string), `5` (read int), `10` (exit)

---

## ✅ Subset de Ada Suportado

| Categoria | Construções |
|---|---|
| Estrutura | `procedure main is begin ... end main;` |
| Tipos | `Integer`, `Boolean` |
| Atribuições | `x := expressão;` |
| Aritmética | `+` `-` `*` `/` |
| Booleanos | `and` `or` `not` |
| Comparações | `=` `/=` `<` `>` `<=` `>=` |
| Condicionais | `if ... then ... else ... end if;` |
| Ciclos | `while ... loop ... end loop;` |
| I/O | `put_line(expr)` · `get_line()` |
| Literais | inteiros · `true` · `false` |

---

## 🚀 Como Correr

**Pré-requisitos**
- GHC ≥ 8.10
- Alex ≥ 3.2
- Happy ≥ 1.19
- Cabal
- [MARS 4.5](http://courses.missouristate.edu/kenvollmar/mars/) para executar o MIPS gerado

```bash
# Compilar e correr com Cabal (recomendado)
cabal clean
cabal run -- <ficheiro.ada>

# Ou manualmente
alex Lexer.x
happy Parser.y
ghc --make -o compiler Main.hs
./compiler <ficheiro.ada>

# Executar o assembly gerado no MARS
java -jar Mars4_5.jar <ficheiro.asm>
```

---

## 📝 Exemplo Completo

**Input** (`gcd.ada`) — Máximo Divisor Comum pelo algoritmo de Euclides:
```ada
procedure main is
begin
  a := 48;
  b := 18;
  while b /= 0 loop
    temp := b;
    b := a - (a / b) * b;
    a := temp;
  end loop;
  put_line(a);
end main;
```

O compilador produz output para cada fase:

```
=== TOKENS ===              → sequência de tokens reconhecidos pelo lexer
=== AST ===                 → árvore sintática abstrata construída pelo parser
=== SEMÂNTICA ===           → "Sem erros semânticos"
=== TABELA DE SÍMBOLOS ===  → a (offset 0), b (offset 4), temp (offset 8)
=== TAC ===                 → código intermédio de 3 endereços
=== MIPS ===                → ficheiro .asm gerado com sucesso
```

**Resultado no MARS:** `6` ✅  *(MDC de 48 e 18)*

---

## 🧪 Testes

### Básicos (`tests/`)

| Teste | O que cobre |
|---|---|
| `test1.ada` | Estrutura mínima e output |
| `test2.ada` | Atribuições e aritmética |
| `test3.ada` | `if-then` simples |
| `test4.ada` | `if-then-else` |
| `test5.ada` | `while` loop |
| `test6.ada` | Leitura de input com `get_line` |
| `test7.ada` | Operações booleanas e comparações |

### Avançados (`harder_tests/`)

| Teste | O que cobre |
|---|---|
| `test1.ada` | Aritmética complexa (precedência e negativos) |
| `test2.ada` | Expressões booleanas complexas (AND, OR, NOT) |
| `test3.ada` | If-else aninhados — máximo de 3 números |
| `test4.ada` | While loops aninhados — soma triangular |
| `test5.ada` | Tabuada (múltiplos de 7) |
| `test6.ada` | Fatorial iterativo |
| `test7.ada` | Sequência de Fibonacci |
| `test8.ada` | Verificação de número primo |
| `test9.ada` | **GCD — algoritmo de Euclides** |
| `test10.ada` | Soma de dígitos de um inteiro |
| `test11.ada` | Potência (exponenciação) |
| `test12.ada` | Número perfeito (soma de divisores) |
| `test13.ada` | Inversão de número |
| `test14.ada` | Palíndromo numérico |
| `test15.ada` | Contagem de números pares |
| `test16.ada` | Sequência de Collatz (3n+1) |
| `test17.ada` | Bubble sort parcial |
| `test18.ada` | Cálculo de média |
| `test19.ada` | Sistema de classificação por ranges |
| `test20.ada` | Calculadora interativa (4 operações) |

---

## 🐛 Tratamento de Erros

O compilador tem comportamentos diferentes dependendo da fase onde ocorre o erro:

- **Léxicos** — caracteres inválidos são reportados mas não interrompem a análise; o lexer continua
- **Sintáticos** — mensagem de erro com os próximos 10 tokens como contexto
- **Semânticos** — todos os erros são listados numa única execução antes de parar; não gera TAC nem MIPS se houver erros

---

## 🧵 O que aprendi com isto

Este projeto foi daqueles que parece simples no papel e depois revela camadas e mais camadas de complexidade. A fase de geração de MIPS foi de longe a mais trabalhosa — gerir registos temporários com alocação cíclica, garantir consistência no stack frame, e lidar com particularidades da arquitetura MIPS (como o `mflo` depois de `div`) deu muito trabalho a depurar.

Mas o momento em que o compilador correu o `test9.ada` e o MARS imprimiu `6` — o resultado correto do algoritmo de Euclides — foi muito satisfatório. Ver todas as fases a funcionar em conjunto, desde código Ada até assembly a executar numa máquina virtual, foi uma das experiências mais gratificantes do curso.

O Haskell provou ser uma escolha muito boa para este tipo de projeto. O sistema de tipos apanhou imensos bugs antes de chegarem ao runtime, e os tipos algébricos para a AST tornaram o código expressivo e fácil de raciocinar.

---

## 🛠️ Stack

![Haskell](https://img.shields.io/badge/Haskell-5D4F85?style=flat&logo=haskell&logoColor=white)
![GHC](https://img.shields.io/badge/GHC-%E2%89%A58.10-purple?style=flat)
![Alex](https://img.shields.io/badge/Alex-Lexer_Generator-4A90D9?style=flat)
![Happy](https://img.shields.io/badge/Happy-LALR(1)_Parser-E8821A?style=flat)
![MIPS](https://img.shields.io/badge/Target-MIPS_Assembly-green?style=flat)
![MARS](https://img.shields.io/badge/Simulator-MARS_4.5-red?style=flat)
