#include <stdio.h>
#include <stdlib.h>

extern FILE* yyin;
extern int yyparse();
extern int yylex();
extern int yylineno;

FILE* output;

void create_data_section() {
    char text[] = "section .data\n";
    fwrite(text, sizeof text - 1, 1, output);
}

void create_text_section() {
    char text[] = "section .text\nglobal _start\n\n_start:\n";
    fwrite(text, sizeof text - 1, 1, output);
}

void terminate_program() {
    char text[] = "\t\tMOV eax,1\n\t\tMOV ebx,1\n\t\tINT 80h\n";
    fwrite(text, sizeof text - 1, 1, output);
}

int main(int argc, char** argv) {
    int retv;
    yyin = fopen(argv[1], "r");
    output = fopen("test.asm", "w+");

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