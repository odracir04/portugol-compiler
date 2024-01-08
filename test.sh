#!/bin/bash

flex lexer.lex
gcc -Wall lex.yy.c tests.c -o test_suite
./test_suite