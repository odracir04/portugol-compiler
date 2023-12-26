%{
#include "parser.tab.h"
int syntax_error();
%}

%%
"inicio" { printf("INICIO"); return INICIO; }
"algoritmo" { printf("ALGORITMO"); return ALGORITMO; }
"var" { return VAR; }
"fimalgoritmo" { printf("FIM"); return FIMALGORITMO; }
[a-zA-Z][a-zA-Z0-9]+ { printf("nome"); return NAME; }

%%

int yywrap() {
    exit(1);
}

int syntax_error() {
    printf("SyntaxError: Could not tokenize");
    exit(1);
}