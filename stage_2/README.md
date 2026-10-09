# Bcs24 Compiler — Stage 2: Intermediate Code Generation (TAC)

## Overview

In Stage 2, we implement **Semantic Actions and Three-Address Code (TAC) Generation** for assignment statements and arithmetic expressions in the **Bcs24** language.

The compiler takes a Bcs24 source program as input and emits intermediate code representation (Three-Address Code) to a plain text file (`output.txt`).

---

## Project Files

| File | Purpose |
| :--- | :--- |
| `lexer.l` | **Lexical Analyzer (Flex)** — passes identifier names and number literals as string semantic values (`yylval.text`). |
| `parser.y` | **Parser & Code Generator (Bison)** — grammar rules annotated with semantic actions that synthesize temporary variables (`t1`, `t2`, ...) and emit TAC instructions. |
| `main.c` | **Driver program** — opens input source file, sets up output file (`output.txt`), and invokes `yyparse()`. |
| `sample.bcs` / `sample.txt` | **Sample Bcs24 program** — test program containing 4 assignment statements with multi-operator arithmetic expressions. |
| `output.txt` | **Generated TAC** — plain text file storing the emitted Three-Address Code. |
| `Makefile` | **Build script** — automates compilation and running. |

---

## How Three-Address Code (TAC) Generation Works

### 1. Semantic Values (`%union`)
The parser defines:
```c
%union {
    char *text;
}
```
- Tokens `ID` and `NUM` carry their string representations.
- Non-terminals `aexpr`, `term`, and `factor` synthesize their variable/temporary address name in `$$`.

### 2. Temporary Variable Generation
`newTemp()` produces unique sequential variable names:
```c
t1, t2, t3, t4, ...
```

### 3. Translation Scheme for Expressions & Assignments

| Grammar Rule | Semantic Action | Emitted TAC |
| :--- | :--- | :--- |
| `factor -> ID` | `$$ = $1;` | *(none)* |
| `factor -> NUM` | `$$ = $1;` | *(none)* |
| `term -> factor` | `$$ = $1;` | *(none)* |
| `term -> term * factor` | `t = newTemp(); emit(t = $1 * $3); $$ = t;` | `t = left * right` |
| `aexpr -> term` | `$$ = $1;` | *(none)* |
| `aexpr -> aexpr + aexpr` | `t = newTemp(); emit(t = $1 + $3); $$ = t;` | `t = left + right` |
| `stmt -> ID = aexpr` | `emit($1 = $3);` | `dest = src` |

Precedence is naturally preserved: multiplications in `term` are evaluated before additions in `aexpr`.

---

## Compilation Instructions

### Using Makefile (Recommended)
```bash
# Build the bcs24_tac executable
make

# Run sample and generate output.txt
make run

# Clean build artifacts
make clean
```

### Manual Compilation
```bash
# 1. Generate parser C source and header
bison -d parser.y

# 2. Generate lexer C source
flex lexer.l

# 3. Compile and link all C sources
gcc -Wall -Wextra -o bcs24_tac parser.tab.c lex.yy.c main.c
```

---

## Running the Compiler

```bash
# Usage: ./bcs24_tac <input-file> [output-file]

# Example 1: Default output file (writes to output.txt)
./bcs24_tac sample.bcs

# Example 2: Explicit output file
./bcs24_tac sample.bcs output.txt
```

---

## Example Walkthrough

### Input Program (`sample.bcs`):
```text
BcsMain
{
int a; int b; int c; int d;
a = 5;
b = 10;
c = a + b * 2;
d = c * a + b + 3
}
```

### Generated Three-Address Code (`output.txt`):
```text
a = 5
b = 10
t1 = b * 2
t2 = a + t1
c = t2
t3 = c * a
t4 = t3 + b
t5 = t4 + 3
d = t5
```

### Trace:
1. `a = 5` $\rightarrow$ Direct assignment.
2. `b = 10` $\rightarrow$ Direct assignment.
3. `c = a + b * 2`:
   - `b * 2` is evaluated first $\rightarrow$ `t1 = b * 2`
   - `a + t1` is evaluated next $\rightarrow$ `t2 = a + t1`
   - Result is assigned to `c` $\rightarrow$ `c = t2`
4. `d = c * a + b + 3`:
   - `c * a` is evaluated first $\rightarrow$ `t3 = c * a`
   - `t3 + b` is evaluated next $\rightarrow$ `t4 = t3 + b`
   - `t4 + 3` is evaluated next $\rightarrow$ `t5 = t4 + 3`
   - Result is assigned to `d` $\rightarrow$ `d = t5`

