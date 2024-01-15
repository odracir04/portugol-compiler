%option nounput yylineno
%option noinput yylineno
%option noyywrap
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
"se" return IF;
"senao" return ELSE;
"fimse" return ENDIF;
"escolha" return SWITCH;
"caso" return CASE;
"outrocaso" return DEFAULT;
"fimescolha" return ENDSWITCH;
\n return NEWLINE;
":" return COLON;
"," return COMMA;
"<-" return ARROW;
"\"" return DOUBLE_QUOTE;
"+" return PLUS;
"-" return MINUS;
"*" return TIMES;
"/" return DIVIDE;
"(" return OPEN_CURLY;
")" return CLOSE_CURLY;
"%" return MODULO;
"^" return POWER;
"<>" return DIFFERENT;
"<=" return LESS_EQUALS;
">=" return GREATER_EQUALS;
"<" return LESS_THAN;
">" return GREATER_THAN;
"=" return EQUALS;
[a-zA-Z][a-zA-Z0-9]* return STRING_LIT;
[0-9]+"."[0-9]+ return DOUBLE_LIT;
"-"?[0-9]+ return INT_LIT;
[ \t] ;
. syntax_error();
%%

int syntax_error() {
    printf("SyntaxError: Could not tokenize");
    exit(1);
}