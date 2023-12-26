%{
#include <stdlib.h>
#include <stdio.h>
int yylex();
int yyparse();
int yyerror();
extern FILE* yyin;
%}

%token ALGORITMO
%token FIMALGORITMO
%token INICIO
%token NAME
%token VAR

%%
start: HEADER ALGORITHM { printf("\nWARNING: NO VARS FOUND\n"); } | HEADER VARIABLES ALGORITHM;
HEADER: ALGORITMO NAME;
VARIABLES: VAR;
ALGORITHM: INICIO FIMALGORITMO { printf("\nCORRECT ALGORITHM STRUCTURE"); };
%%

int yyerror() { printf("ParseError: Could not parse"); exit(1); }

int main(int argc, char** argv) {
    FILE* file = fopen(argv[1], "r");

    if (!file) { printf("FileError: Could not find file"); exit(1); }

    yyin = file;

    do { yyparse(); } while (!feof(yyin));

    exit(0);
}