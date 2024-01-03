%{
#include "parser.tab.h"
int syntax_error();
%}

%%
"inicio" { return INICIO; }
"algoritmo" { return ALGORITMO; }
"var" { return VAR; }
"real" { return TYPE; }
"logico" { return TYPE; }
"inteiro" { return TYPE; }
"caractere" { return TYPE; }
"fimalgoritmo" { return FIMALGORITMO; }
":" { return COLON; }
"," { return COMMA; }
"\n" { return NEWLINE; }
[a-zA-Z][a-zA-Z0-9]* { return NAME; }

%%

int yywrap() {
    exit(1);
}

int syntax_error() {
    printf("SyntaxError: Could not tokenize");
    exit(1);
}