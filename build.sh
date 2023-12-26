#!/bin/sh

flex lexer.lex
bison -d parser.y
gcc -Wall lex.yy.c parser.tab.c -o compiler
