#!/bin/bash

flex src/lexer.lex
bison -d src/parser.y
gcc -Wall src/lexer_test.c -o lexer_test_suite

echo "INITIATING LEXER TESTS.."
for file in ./tests/*; do
    if [ -f "$file" ]; then
        ./lexer_test_suite $file
    fi
done    