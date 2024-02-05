#include "../lex.yy.c"
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE* yyin;

int main(int argc, char** argv) {
    yyin = fopen(argv[1], "r");

    if (!yyin) {
        printf("FileError: Could not find file");
        exit(1);
    }

    int result;
    while (1) {
        result = yylex();
        if (result == 0) break;
    }
    printf("TEST PASSED\n");

    exit(EXIT_SUCCESS);
}