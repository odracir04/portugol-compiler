#include <stdio.h>
#include <stdlib.h>

extern FILE* yyin;
extern int yyparse();
extern int yylex();

int main(int argc, char** argv) {
    FILE* file = fopen(argv[1], "r");

    if (!file) {
        printf("FileError: Could not find file");
        exit(1);
    }

    yyin = file;

    do {
        yyparse();
    } while (!feof(yyin));
    exit(0);
}