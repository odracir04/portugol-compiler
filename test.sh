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

clang -o parser_test_suite parser.tab.c lex.yy.c src/compiler.c `llvm-config --libs core`

echo "INITIATING PARSER TESTS.."
for file in ./tests/*; do
    if [ -f "$file" ]; then
        ./parser_test_suite $file
    fi
done  