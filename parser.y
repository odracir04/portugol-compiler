%{
#include <stdlib.h>
#include <stdio.h>

int yylex();
int yyparse();
int yyerror();

extern FILE* yyin;
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
%token ARROW
%token DOUBLE_QUOTE
%token BOOL_LIT
%token DOUBLE_LIT
%token INT_LIT
%%

start: HEADER VARIABLES ALGORITHM | HEADER ALGORITHM;
HEADER: TITLE;
TITLE: ALGORITMO STRING_LIT NEWLINE | TITLE NEWLINE;
VARIABLES: VAR VAR_DECLARATION_LIST;
VAR_DECLARATION_LIST: VAR_DECLARATION | VAR_DECLARATION_LIST VAR_DECLARATION;
VAR_DECLARATION: STRING_LIT COLON TYPE NEWLINE
                | STRING_LIT EXTRA_VARS COLON TYPE NEWLINE | VAR_DECLARATION NEWLINE;
EXTRA_VARS: COMMA STRING_LIT | EXTRA_VARS COMMA STRING_LIT;
ALGORITHM: ALGORITHM_START STATEMENT_LIST ALGORITHM_END;
ALGORITHM_START: INICIO | ALGORITHM_START NEWLINE;
ALGORITHM_END: FIMALGORITMO | ALGORITHM_END NEWLINE;
STATEMENT_LIST: STATEMENT | STATEMENT STATEMENT_LIST;
STATEMENT: ASSIGNMENT NEWLINE | STATEMENT NEWLINE;
ASSIGNMENT: STRING_LIT ARROW DOUBLE_QUOTE STRING_LIT DOUBLE_QUOTE { printf("ASSIGNED STR\n"); }
                | STRING_LIT ARROW BOOL_LIT { printf("ASSIGNED BOOL\n"); }
                | STRING_LIT ARROW INT_LIT { printf("ASSIGNED INT\n"); }
                | STRING_LIT ARROW DOUBLE_LIT { printf("ASSIGNED DOUBLE\n"); };
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