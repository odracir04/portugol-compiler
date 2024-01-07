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
"VERDADEIRO" return BOOL_LIT;
"FALSO" return BOOL_LIT;
"real" return TYPE;
"logico" return TYPE;
"inteiro" return TYPE;
"caractere" return TYPE;
\n return NEWLINE;
":" return COLON;
"." return PERIOD;
"," return COMMA;
"<-" return ARROW;
"\"" return DOUBLE_QUOTE;
[a-zA-Z][a-zA-Z0-9]* return STRING_LIT;
[0-9]+ return INT_LIT;
[0-9]+"."[0-9]+ return DOUBLE_LIT;
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