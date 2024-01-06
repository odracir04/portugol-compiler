%option nounput yylineno
%{
#include "parser.tab.h"
int syntax_error();
%}

%%
"inicio" return INICIO;
"algoritmo" return ALGORITMO;
"var" return VAR;
"fimalgoritmo" return FIMALGORITMO;
"real" return TYPE;
\n return NEWLINE;
":" return COLON;
"." return PERIOD;
"," return COMMA;
[a-zA-Z][a-zA-Z0-9]* return STRING_LIT;
[ \t] ;
. syntax_error();
%%

int yywrap() {
    exit(1);
}

int syntax_error() {
    printf("SyntaxError: Could not tokenize");
    exit(1);
}