# portugol-compiler

> A simple compiler for the Portugol language. Project developed by Ricardo Oliveira and João Oliveira.

## Compiling Stages

### Implemented
- None...

### To be added
- Lexical analyzer using Flex
- Semantic analyzer using Bison
- Intermediate code generation to Assembly Language
- Code optimization
- Final machine code generation

## Instructions to generate the compiler

To generate the compiler simply run the following commands:

```
flex lexer.lex
bison -d parser.y
gcc lex.yy.c parser.tab.c -o compiler
```
