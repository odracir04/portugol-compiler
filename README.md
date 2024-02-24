# portugol-compiler

> A simple compiler for the Portugol language. Project developed by Ricardo Oliveira and João Oliveira.

## Compiling Stages

### Implemented
- Lexical analyzer using Flex
- Semantic analyzer using Bison
- AST Generation in C

### To be added
- Intermediate code generation using LLVM
- Code optimization
- Final machine code generation

## Instructions to generate and use the compiler

- To generate the compiler simply run the ```build.sh``` file (please remember that you need to have flex, bison and llvm installed to run this file). Afterwards simply run the binary file with te file to be compiled as its argument.
- The compiler also comes with a test suite to assess its current status. The tests can be run by executing the ```test.sh``` file.
