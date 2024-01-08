#!/bin/bash

flex lexer.lex
bison -d parser.y
gcc -Wall lex.yy.c parser.tab.c tests.c -o test_suite
./test_suite