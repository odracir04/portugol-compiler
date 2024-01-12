#include <stdio.h>
#include <stdlib.h>

extern FILE* yyin;
extern int yyparse();
extern int yylex();
extern int yylineno;

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

    printf(retv == 0 ? "COMPILATION SUCCESS\n" : "COMPILATION FAILURE\n");

    exit(0);
}