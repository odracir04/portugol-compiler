%{
%}

%%
ret { printf("return"); }
. { return 0; }
%%

int yywrap() {
    exit(1);
}

int main(int argc, char** argv) {
    FILE* file = fopen(argv[1], "r");

    if (!file) { printf("FileError: Input file does not exist."); exit(1); }

    yyin = file;

    while(yylex());
}