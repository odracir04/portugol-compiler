#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE* yyin;
extern FILE* yyout;
extern char* yytext;

void token_tests() {
    FILE* infile = fopen("tests/token_test.portugol", "r");

    if (!infile) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    yyin = infile;

    int passed = 0, failed = 0;
    int res[] = {INICIO, ALGORITMO, VAR, FIMALGORITMO, BOOL_LIT, BOOL_LIT, TYPE, TYPE,
    TYPE, TYPE, NEWLINE, COLON, COMMA, ARROW, DOUBLE_QUOTE,
        PLUS, MINUS, TIMES, DIVIDE, OPEN_CURLY, CLOSE_CURLY, NEWLINE,
        STRING_LIT, INT_LIT, DOUBLE_LIT, NEWLINE};

    printf("BEGINNING TESTS...\n");
    int retv = yylex(), i = 0;
    while (retv != 0) {
        if (retv == res[i]) {
            passed++;
        }
        else {
            failed++;
            printf("FAILED TEST: %s\n", yytext);
        }
        i++;
        if (i >= sizeof(res) / sizeof(int)) break;
        retv = yylex();
    }
}
int main() {
    token_tests();
    exit(EXIT_SUCCESS);
}