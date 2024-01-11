#!/bin/sh

flex src/lexer.lex
bison -d -Wcounterexamples src/parser.y
gcc -Wall lex.yy.c parser.tab.c src/compiler.c -o compiler
