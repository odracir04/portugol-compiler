%{
#include <stdlib.h>
#include <stdio.h>

int yylex();
int yyparse();
int yyerror();
%}

%start start
%token ALGORITMO
%token FIMALGORITMO
%token INICIO
%token STRING_LIT
%token VAR
%token TYPE
%token IF
%token ELSE
%token ENDIF
%token COLON
%token NEWLINE
%token COMMA
%token ARROW
%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token OPEN_CURLY
%token CLOSE_CURLY
%token MODULO
%token POWER
%token DOUBLE_QUOTE
%token BOOL_LIT
%token DOUBLE_LIT
%token INT_LIT
%token EQUALS
%token GREATER_EQUALS
%token LESS_EQUALS
%token LESS_THAN
%token GREATER_THAN
%token DIFFERENT

%left POWER
%left MODULO
%left TIMES
%left DIVIDE
%left PLUS
%left MINUS
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
ALGORITHM_START: INICIO NEWLINE | ALGORITHM_START NEWLINE;
ALGORITHM_END: FIMALGORITMO | ALGORITHM_END NEWLINE;
STATEMENT_LIST: STATEMENT | STATEMENT STATEMENT_LIST;
STATEMENT: ASSIGNMENT NEWLINE | STATEMENT NEWLINE | IFELSE NEWLINE;
ASSIGNMENT: STRING_LIT ARROW DOUBLE_QUOTE STRING_LIT DOUBLE_QUOTE
                | STRING_LIT ARROW BOOL_LIT
                | STRING_LIT ARROW MATH_EXPRESSION;
MATH_EXPRESSION: MATH_EXPRESSION PLUS MATH_EXPRESSION
                | MATH_EXPRESSION MINUS MATH_EXPRESSION
                | MATH_EXPRESSION TIMES MATH_EXPRESSION
                | MATH_EXPRESSION DIVIDE MATH_EXPRESSION
                | MATH_EXPRESSION MODULO MATH_EXPRESSION
                | MATH_EXPRESSION POWER MATH_EXPRESSION
                | OPEN_CURLY MATH_EXPRESSION CLOSE_CURLY
                | VARIABLE;
VARIABLE: INT_LIT | DOUBLE_LIT | STRING_LIT;
IFELSE: IFBEGIN STATEMENT_LIST IFEND | IFBEGIN STATEMENT_LIST ELSEBEGIN STATEMENT_LIST IFEND;
IFBEGIN: IF COMPARISON NEWLINE | IFBEGIN NEWLINE;
ELSEBEGIN: ELSE NEWLINE | ELSEBEGIN NEWLINE;
IFEND: ENDIF;
COMPARISON: MATH_EXPRESSION COMPARISON_OPERATOR MATH_EXPRESSION
            | MATH_EXPRESSION COMPARISON_OPERATOR DOUBLE_QUOTE STRING_LIT DOUBLE_QUOTE
            | MATH_EXPRESSION COMPARISON_OPERATOR BOOL_LIT
            | DOUBLE_QUOTE STRING_LIT DOUBLE_QUOTE COMPARISON_OPERATOR MATH_EXPRESSION
            | BOOL_LIT COMPARISON_OPERATOR MATH_EXPRESSION
            | DOUBLE_QUOTE STRING_LIT DOUBLE_QUOTE COMPARISON_OPERATOR BOOL_LIT
            | BOOL_LIT COMPARISON_OPERATOR DOUBLE_QUOTE STRING_LIT DOUBLE_QUOTE;
COMPARISON_OPERATOR: EQUALS | GREATER_THAN | LESS_THAN | GREATER_EQUALS | LESS_EQUALS | DIFFERENT;

%%


int yyerror() {
    return 1;
}
