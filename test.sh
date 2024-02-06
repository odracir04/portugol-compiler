#!/bin/bash

flex src/lexer.lex
bison -d src/parser.y
gcc -Wall lex.yy.c src/lexer_test.c -o lexer_test_suite

echo "INITIATING LEXER TESTS.."
for file in ./tests/*; do
    if [ -f "$file" ]; then
        ./lexer_test_suite $file
    fi
done    

gcc -Wall lex.yy.c src/parser_test.c parser.tab.c -o parser_test_suite

echo "INITIATING PARSER TESTS.."
for file in ./tests/*; do
    if [ -f "$file" ]; then
        ./parser_test_suite $file
    fi
done  