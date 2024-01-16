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

%token VAR
%token TYPE

%token IF
%token ELSE
%token ENDIF

%token SWITCH
%token CASE
%token DEFAULT
%token ENDSWITCH

%token WRITE
%token WRITE_LINE
%token READ

%token AND
%token NOT
%token OR
%token XOR

%token COLON
%token NEWLINE
%token COMMA
%token VAR_NAME
%token ARROW

%token PLUS
%token MINUS
%token TIMES
%token DIVIDE
%token OPEN_CURLY
%token CLOSE_CURLY
%token MODULO
%token POWER

%token BOOL_LIT
%token DOUBLE_LIT
%token INT_LIT
%token STRING_LIT

%token EQUALS
%token GREATER_EQUALS
%token LESS_EQUALS
%token LESS_THAN
%token GREATER_THAN
%token DIFFERENT

%token FOR
%token FROM
%token TO
%token DO
%token STEP
%token ENDFOR

%token WHILE
%token ENDWHILE
%token DOWHILE

%token BREAK

%token PROCEDURE
%token ENDPROCEDURE

%left POWER
%left MODULO
%left TIMES
%left DIVIDE
%left PLUS
%left MINUS

%left AND
%left XOR
%left OR
%left NOT
%%

start: HEADER VARIABLES ALGORITHM | HEADER ALGORITHM;
HEADER: TITLE;
TITLE: ALGORITMO VAR_NAME NEWLINE | TITLE NEWLINE;
VARIABLES: VAR VAR_DECLARATION_LIST;
VAR_DECLARATION_LIST: VAR_DECLARATION | VAR_DECLARATION_LIST VAR_DECLARATION;
VAR_DECLARATION: VAR_NAME COLON TYPE NEWLINE
                | VAR_NAME EXTRA_VARS COLON TYPE NEWLINE | VAR_DECLARATION NEWLINE;
EXTRA_VARS: COMMA VAR_NAME | EXTRA_VARS COMMA VAR_NAME;
ALGORITHM: ALGORITHM_START STATEMENT_LIST ALGORITHM_END;
ALGORITHM_START: INICIO NEWLINE | ALGORITHM_START NEWLINE;
ALGORITHM_END: FIMALGORITMO | ALGORITHM_END NEWLINE;
STATEMENT_LIST: STATEMENT | STATEMENT STATEMENT_LIST;
STATEMENT: ASSIGNMENT NEWLINE | STATEMENT NEWLINE | IFELSE NEWLINE | SWITCH_STATEMENT NEWLINE
            | WRITE_STATEMENT NEWLINE | READ_STATEMENT NEWLINE | FOR_STATEMENT NEWLINE | WHILE_STATEMENT NEWLINE
            | DOWHILE_STATEMENT NEWLINE | BREAK NEWLINE | PROCEDURE_STATEMENT NEWLINE | FUNCTION_CALL NEWLINE;
ASSIGNMENT: VAR_NAME ARROW MATH_EXPRESSION;
MATH_EXPRESSION: MATH_EXPRESSION PLUS MATH_EXPRESSION
                | MATH_EXPRESSION MINUS MATH_EXPRESSION
                | MATH_EXPRESSION TIMES MATH_EXPRESSION
                | MATH_EXPRESSION DIVIDE MATH_EXPRESSION
                | MATH_EXPRESSION MODULO MATH_EXPRESSION
                | MATH_EXPRESSION POWER MATH_EXPRESSION
                | OPEN_CURLY MATH_EXPRESSION CLOSE_CURLY
                | LITERAL
                | VAR_NAME;
LITERAL: INT_LIT | DOUBLE_LIT | STRING_LIT | BOOL_LIT;
IFELSE: IFBEGIN STATEMENT_LIST IFEND | IFBEGIN STATEMENT_LIST ELSEBEGIN STATEMENT_LIST IFEND;
IFBEGIN: IF COMPARISON NEWLINE | IFBEGIN NEWLINE;
ELSEBEGIN: ELSE NEWLINE | ELSEBEGIN NEWLINE;
IFEND: ENDIF;
COMPARISON: MATH_EXPRESSION COMPARISON_OPERATOR MATH_EXPRESSION
            | NOT COMPARISON
            | COMPARISON OR COMPARISON
            | COMPARISON AND COMPARISON
            | COMPARISON XOR COMPARISON
            | VAR_NAME
            | BOOL_LIT;
COMPARISON_OPERATOR: EQUALS | GREATER_THAN | LESS_THAN | GREATER_EQUALS | LESS_EQUALS | DIFFERENT;
SWITCH_STATEMENT: SWITCH_BEGIN CASE_LIST SWITCH_END | SWITCH_BEGIN CASE_LIST DEFAULT_CASE SWITCH_END;
SWITCH_BEGIN: SWITCH VAR_NAME NEWLINE | SWITCH_BEGIN NEWLINE;
CASE_LIST: SWITCH_CASE | SWITCH_CASE CASE_LIST;
SWITCH_CASE: CASE_BEGIN STATEMENT_LIST;
CASE_BEGIN: CASE LITERAL NEWLINE
            | CASE LITERAL EXTRA_CASES NEWLINE
            | CASE_BEGIN NEWLINE;
EXTRA_CASES: COMMA LITERAL | EXTRA_CASES COMMA LITERAL;
DEFAULT_CASE: DEFAULT NEWLINE STATEMENT_LIST;
SWITCH_END: ENDSWITCH;
WRITE_STATEMENT: WRITE OPEN_CURLY WRITE_PARAMS CLOSE_CURLY
                | WRITE_LINE OPEN_CURLY WRITE_PARAMS CLOSE_CURLY;
WRITE_PARAMS: VAR_NAME | STRING_LIT | VAR_NAME EXTRA_PARAMS | STRING_LIT EXTRA_PARAMS;
EXTRA_PARAMS: COMMA STRING_LIT | COMMA VAR_NAME | EXTRA_PARAMS COMMA STRING_LIT | EXTRA_PARAMS COMMA VAR_NAME;
READ_STATEMENT: READ OPEN_CURLY READ_PARAMS CLOSE_CURLY;
READ_PARAMS: VAR_NAME | VAR_NAME EXTRA_VARS;
FOR_STATEMENT: FOR_BEGIN STATEMENT_LIST FOR_END;
FOR_BEGIN: FOR VAR_NAME FROM INT_LIT TO INT_LIT DO NEWLINE
           | FOR VAR_NAME FROM INT_LIT TO INT_LIT STEP INT_LIT DO NEWLINE;
FOR_END: ENDFOR;
WHILE_STATEMENT: WHILE_BEGIN STATEMENT_LIST WHILE_END;
WHILE_BEGIN: WHILE COMPARISON DO NEWLINE;
WHILE_END: ENDWHILE;
DOWHILE_STATEMENT: DOWHILE_BEGIN STATEMENT_LIST DOWHILE_END;
DOWHILE_BEGIN: DOWHILE NEWLINE;
DOWHILE_END: TO COMPARISON;
PROCEDURE_STATEMENT: PROCEDURE_HEADER VARIABLES PROCEDURE_ALGORITHM | PROCEDURE_HEADER PROCEDURE_ALGORITHM;
PROCEDURE_HEADER: PROCEDURE VAR_NAME NEWLINE
                | PROCEDURE VAR_NAME OPEN_CURLY PROCEDURE_PARAMS_LIST CLOSE_CURLY NEWLINE
                | PROCEDURE VAR_NAME OPEN_CURLY VAR PROCEDURE_PARAMS_LIST CLOSE_CURLY NEWLINE
                | PROCEDURE_HEADER NEWLINE;
PROCEDURE_PARAMS_LIST: PROCEDURE_PARAM | PROCEDURE_PARAMS_LIST COMMA PROCEDURE_PARAM;
PROCEDURE_PARAM: VAR_NAME COLON TYPE | VAR_NAME EXTRA_VARS COLON TYPE;
PROCEDURE_ALGORITHM: ALGORITHM_START STATEMENT_LIST ENDPROCEDURE;
FUNCTION_CALL: VAR_NAME OPEN_CURLY CLOSE_CURLY
                | VAR_NAME OPEN_CURLY CALL_PARAM CLOSE_CURLY
                | VAR_NAME OPEN_CURLY CALL_PARAM EXTRA_CALL_PARAMS CLOSE_CURLY;
CALL_PARAM: LITERAL | VAR_NAME;
EXTRA_CALL_PARAMS: COMMA CALL_PARAM | EXTRA_CALL_PARAMS COMMA CALL_PARAM;
%%


int yyerror() {
    return 1;
}
