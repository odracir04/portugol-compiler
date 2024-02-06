#include <stdio.h>
#include <stdlib.h>

extern FILE* yyin;
extern int yyparse();
extern int yylex();

int main(int argc, char** argv) {
    int retv;
    yyin = fopen(argv[1], "r");

    if (!yyin) {
        printf("FileError: Could not find file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    printf(retv == 0 ? "TEST PASSED\n" : "TEST FAILED\n");

    exit(0);
}