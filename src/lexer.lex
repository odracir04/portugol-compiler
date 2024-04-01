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
"entao" return THEN;
"senao" return ELSE;
"fimse" return ENDIF;
"escolha" return SWITCH;
"caso" return CASE;
"outrocaso" return DEFAULT;
"fimescolha" return ENDSWITCH;
"escreva" return WRITE;
"escreval" return WRITE_LINE;
"leia" return READ;
"nao" return NOT;
"e" return AND;
"ou" return OR;
"xou" return XOR;
"para" return FOR;
"de" return FROM;
"ate" return TO;
"passo" return STEP;
"faca" return DO;
"fimpara" return ENDFOR;
"enquanto" return WHILE;
"fimenquanto" return ENDWHILE;
"repita" return DOWHILE;
"interrompa" return BREAK;
"procedimento" return PROCEDURE;
"fimprocedimento" return ENDPROCEDURE;
"funcao" return FUNCTION;
"fimfuncao" return ENDFUNCTION;
"retorne" return RETURN;
\n return NEWLINE;
":" return COLON;
"," return COMMA;
"<-" return ARROW;
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
"\""[^\"]*"\""  {
#ifndef TEST
    yylval.string = (char*)malloc(sizeof(char) * (strlen(yytext) - 1));
    strncpy(yylval.string, yytext + 1, strlen(yytext) - 2);
    yylval.string[strlen(yytext) - 2] = '\0';
    return STRING_LIT;
#endif
};
[a-zA-Z_][a-zA-Z0-9_]* {
#ifndef TEST
    yylval.string = (char*)malloc(sizeof(char) * (strlen(yytext) + 1));
    strcpy(yylval.string, yytext);
    return VAR_NAME;
#endif
};
[0-9]+"."[0-9]+ return DOUBLE_LIT;
"-"?[0-9]+ return INT_LIT;
"//"[^\n]*"\n" ;
[ \t] ;
. syntax_error();
%%

int syntax_error() {
    printf("SyntaxError: Could not tokenize");
    exit(1);
}