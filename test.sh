#!/bin/bash

flex src/lexer.lex
bison -d src/parser.y
gcc -Wall lex.yy.c parser.tab.c src/tests.c -o test_suite
./test_suite