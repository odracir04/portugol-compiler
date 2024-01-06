%{
#include <stdlib.h>
#include <stdio.h>

int yylex();
int yyparse();
int yyerror();

extern FILE* yyin;
extern int yylineno;
%}

%start start
%token ALGORITMO
%token FIMALGORITMO
%token INICIO
%token STRING_LIT
%token PERIOD
%token VAR
%token TYPE
%token COLON
%token NEWLINE
%token COMMA

%%

start: HEADER VARIABLES ALGORITHM | HEADER ALGORITHM;
HEADER: TITLE;
TITLE: ALGORITMO STRING_LIT NEWLINE;
VARIABLES: VAR VAR_DECLARATION_LIST;
VAR_DECLARATION_LIST: VAR_DECLARATION | VAR_DECLARATION_LIST VAR_DECLARATION;
VAR_DECLARATION: STRING_LIT COLON TYPE NEWLINE
                | STRING_LIT EXTRA_VARS COLON TYPE NEWLINE;
EXTRA_VARS: COMMA STRING_LIT | EXTRA_VARS COMMA STRING_LIT;
ALGORITHM: INICIO NEWLINE STATEMENT_LIST FIMALGORITMO;
STATEMENT_LIST: STATEMENT | STATEMENT STATEMENT_LIST;
STATEMENT: STRING_LIT NEWLINE;
%%

int yyerror() {
    printf("ParseError: Could not parse");
    exit(1);
}

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
