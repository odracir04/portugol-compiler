#!/bin/sh

flex lexer.lex
bison -d -Wcounterexamples parser.y
gcc -Wall lex.yy.c parser.tab.c compiler.c -o compiler
