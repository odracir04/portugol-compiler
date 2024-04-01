#!/bin/sh

flex src/lexer.lex
bison -d -Wcounterexamples src/parser.y
clang -o compiler parser.tab.c lex.yy.c src/compiler.c src/structure.c src/write_statements.c `llvm-config --ldflags --system-libs --libs all` -stdlib=libc -fsanitize=address
