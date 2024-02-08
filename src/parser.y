%{
#include <stdlib.h>
#include <stdio.h>
#include "src/compiler.h"

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
%token THEN
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

%token FUNCTION
%token ENDFUNCTION

%token RETURN

%right POWER
%left MODULO TIMES DIVIDE
%left PLUS MINUS

%left AND
%left XOR
%left OR
%left NOT

%left EQUALS GREATER_EQUALS GREATER_THAN LESS_EQUALS LESS_THAN

%union {
    struct ASTNode* node;
    char* string;
}

%type <node> start ALGORITMO_ FIMALGORITMO_ INICIO_ VAR_ TYPE_ IF_ THEN_ ELSE_ ENDIF_
%type <node> SWITCH_ CASE_ DEFAULT_ ENDSWITCH_ WRITE_ WRITE_LINE_ READ_ AND_ NOT_ OR_ XOR_
%type <node> COLON_ NEWLINE_ COMMA_ VAR_NAME_ ARROW_
%type <node> PLUS_ MINUS_ TIMES_ DIVIDE_ OPEN_CURLY_ CLOSE_CURLY_ MODULO_ POWER_
%type <node> BOOL_LIT_ DOUBLE_LIT_ INT_LIT_ STRING_LIT_
%type <node> EQUALS_ GREATER_EQUALS_ LESS_EQUALS_ LESS_THAN_ GREATER_THAN_ DIFFERENT_
%type <node> FOR_ FROM_ TO_ DO_ STEP_ ENDFOR_
%type <node> WHILE_ ENDWHILE_ DOWHILE_
%type <node> BREAK_
%type <node> PROCEDURE_ ENDPROCEDURE_
%type <node> FUNCTION_ ENDFUNCTION_
%type <node> RETURN_

%type <node> PROGRAM_HEADER PROGRAM_NAME PROGRAM_BODY FUNCTIONS_AND_VARIABLES
%type <node> VARIABLES VAR_DECLARATION_LIST VAR_DECLARATION DECLARATION MULTI_DECLARATION
%type <node> TYPE_CHECK EXTRA_VARS EXTRA_VAR FUNCTION_LIST
%type <node> ALGORITHM ALGORITHM_HEADER ALGORITHM_BODY ALGORITHM_END
%type <node> STATEMENT_LIST STATEMENT ASSIGNMENT IFELSE IFBODY ELSEBODY IFBEGIN
%type <node> IF_COMPARISON THEN_END ELSEBEGIN IFEND MATH_EXPRESSION FACTOR
%type <node> SUM DIFFERENCE TERM MULTIPLICATION DIVISION REMAINDER INTEGRAL
%type <node> EXPONAL EXPONENT PARENTHESES LITERAL LOGICAL_EXPRESSION
%type <node> DISJUNCTION CONJUNCTION XORTION COMPARISON COMPARISON_RIGHT
%type <node> COMPARISON_OPERATOR SWITCH_STATEMENT SWITCH_HEADER SWITCH_DECLARE SWITCH_BODY
%type <node> CASE_BODY CASE_LIST SWITCH_CASE CASE_BEGIN CASE_DECLARE EXTRA_CASES
%type <node> EXTRA_CASE_LIST EXTRA_CASE_DECLARE DEFAULT_CASE DEFAULT_HEAD
%type <node> WRITE_STATEMENT WRITE_BEGIN WRITE_END WRITE_PARAMS EXTRA_PARAMS
%type <node> READ_STATEMENT READ_BEGIN READ_END READ_PARAMS
%type <node> FOR_STATEMENT FOR_HEADER FOR_DECLARE_VAR FOR_DECLARE_BODY RANGE_DECLARE
%type <node> START_RANGE END_RANGE STEP_DECLARE DO_DECLARE FOR_BODY FOR_END
%type <node> WHILE_STATEMENT WHILE_HEADER WHILE_DECLARE WHILE_BODY WHILE_END
%type <node> DOWHILE_STATEMENT DOWHILE_HEADER DOWHILE_BODY DOWHILE_END
%type <node> RETURN_STATEMENT PROCEDURE_STATEMENT PROCEDURE_HEADER PROCEDURE_NAME
%type <node> PROCEDURE_DECLARE PROCEDURE_PARAMS PROCEDURE_PARAMS_BEGIN
%type <node> PROCEDURE_PARAMS_END PROCEDURE_PARAMS_LIST NEW_PARAM PROCEDURE_PARAM
%type <node> PROCEDURE_BODY PROCEDURE_ALGORITHM PROCEDURE_ALGORITHM_HEADER
%type <node> PROCEDURE_ALGORITHM_BODY FUNCTION_STATEMENT FUNCTION_HEADER FUNCTION_NAME
%type <node> FUNCTION_DECLARE FUNCTION_PARAMS FUNCTION_BODY FUNCTION_ALGORITHM
%type <node> FUNCTION_ALGORITHM_HEADER FUNCTION_ALGORITHM_BODY FUNCTION_ALGORITHM_START
%type <node> FUNCTION_CALL FUNCTION_CALL_BEGIN FUNCTION_CALL_END MULTI_PARAMS
%type <node> EXTRA_CALL_PARAMS EXTRA_CALL_PARAM

%type <string> VAR_NAME STRING_LIT
%%
start: PROGRAM_HEADER PROGRAM_BODY { $$ = createNode(TOKEN, (NodeValue) "START", $1, $2); };

PROGRAM_HEADER: PROGRAM_NAME NEWLINE_  { $$ = createNode(TOKEN, (NodeValue) "PROGRAM_HEADER", $1, $2); }
                | PROGRAM_HEADER NEWLINE_ { $$ = createNode(TOKEN, (NodeValue) "PROGRAM_HEADER", $1, $2); };
PROGRAM_BODY:   FUNCTIONS_AND_VARIABLES ALGORITHM { $$ = createNode(TOKEN, (NodeValue) "PROGRAM_BODY", $1, $2); }
                | ALGORITHM { $$ = createNode(TOKEN, (NodeValue) "PROGRAM_BODY", $1, NULL); };

PROGRAM_NAME: ALGORITMO_ VAR_NAME_ { $$ = createNode(TOKEN, (NodeValue) "PROGRAM_NAME", $1, $2); };

FUNCTIONS_AND_VARIABLES: VARIABLES {}
                        | FUNCTION_LIST {}
                        | VARIABLES FUNCTION_LIST {};

VARIABLES: VAR_ VAR_DECLARATION_LIST;   
VAR_DECLARATION_LIST: VAR_DECLARATION | VAR_DECLARATION_LIST VAR_DECLARATION;
VAR_DECLARATION: DECLARATION NEWLINE_ | VAR_DECLARATION NEWLINE_;
DECLARATION: VAR_NAME_ TYPE_CHECK {} 
            | MULTI_DECLARATION TYPE_CHECK {};
MULTI_DECLARATION: VAR_NAME_ EXTRA_VARS {};
TYPE_CHECK: COLON_ TYPE_;
EXTRA_VARS: EXTRA_VAR | EXTRA_VARS EXTRA_VAR;
EXTRA_VAR: COMMA_ VAR_NAME_;

FUNCTION_LIST: FUNCTION_STATEMENT | PROCEDURE_STATEMENT | FUNCTION_LIST FUNCTION_STATEMENT
                | FUNCTION_LIST PROCEDURE_STATEMENT | FUNCTION_LIST NEWLINE_;


ALGORITHM: ALGORITHM_HEADER ALGORITHM_BODY { $$ = createNode(TOKEN, (NodeValue) "ALGORITHM", $1, $2); };

ALGORITHM_HEADER: INICIO_ NEWLINE_ { $$ = createNode(TOKEN, (NodeValue) "ALGORITHM_HEADER", $1, $2); }
                | ALGORITHM_HEADER NEWLINE_ { $$ = createNode(TOKEN, (NodeValue) "ALGORITHM_HEADER", $1, $2); };
ALGORITHM_BODY: STATEMENT_LIST ALGORITHM_END { $$ = createNode(TOKEN, (NodeValue) "ALGORITHM_BODY", $1, $2); };
ALGORITHM_END:  FIMALGORITMO_  { $$ = createNode(TOKEN, (NodeValue) "ALGORITHM_END", $1, NULL); }
                | ALGORITHM_END NEWLINE_ { $$ = createNode(TOKEN, (NodeValue) "ALGORITHM_END", $1, $2); };


STATEMENT_LIST: STATEMENT { $$ = createNode(TOKEN, (NodeValue) "STATEMENT_LIST", $1, NULL); } 
                | STATEMENT STATEMENT_LIST { $$ = createNode(TOKEN, (NodeValue) "STATEMENT_LIST", $1, $2); };
STATEMENT: ASSIGNMENT NEWLINE_  { $$ = createNode(TOKEN, (NodeValue) "ASSIGNMENT", $1, $2); }
            | STATEMENT NEWLINE_  {}
            | IFELSE NEWLINE_ {}
            | SWITCH_STATEMENT NEWLINE_ {}
            | WRITE_STATEMENT NEWLINE_ {}
            | READ_STATEMENT NEWLINE_ {}
            | FOR_STATEMENT NEWLINE_ {}
            | WHILE_STATEMENT NEWLINE_ {}
            | DOWHILE_STATEMENT NEWLINE_ {} 
            | BREAK_ NEWLINE_ { $$ = createNode(TOKEN, (NodeValue) "BREAK", $1, $2); }
            | FUNCTION_CALL NEWLINE_ {}
            | RETURN_STATEMENT NEWLINE_ {};

ASSIGNMENT: VAR_NAME_ ASSIGN {};
ASSIGN: ARROW_ MATH_EXPRESSION {};

IFELSE: IFBODY IFEND;
IFBODY: IFBEGIN STATEMENT_LIST | IFBODY ELSEBODY;
ELSEBODY: ELSEBEGIN STATEMENT_LIST;
IFBEGIN: IF_COMPARISON THEN_END | IFBEGIN NEWLINE_;
IF_COMPARISON: IF_ LOGICAL_EXPRESSION;
THEN_END: THEN_ NEWLINE_;
ELSEBEGIN: ELSE_ NEWLINE_ | ELSEBEGIN NEWLINE_;
IFEND: ENDIF_;

MATH_EXPRESSION: FACTOR;
FACTOR: TERM
        | FACTOR SUM
        | FACTOR DIFFERENCE;
SUM: PLUS_ TERM;
DIFFERENCE: MINUS_ TERM;        
TERM: INTEGRAL
    | TERM MULTIPLICATION
    | TERM DIVISION
    | TERM REMAINDER;
MULTIPLICATION: TIMES_ INTEGRAL;
DIVISION: DIVIDE_ INTEGRAL;
REMAINDER: MODULO_ INTEGRAL;    
INTEGRAL: EXPONAL
        | INTEGRAL EXPONENT;
EXPONENT: POWER_ EXPONAL;        
EXPONAL:  LITERAL
        | VAR_NAME_
        | PARENTHESES CLOSE_CURLY_
        | FUNCTION_CALL;
PARENTHESES: OPEN_CURLY_ MATH_EXPRESSION;        
               
LITERAL: INT_LIT_ | DOUBLE_LIT_ | STRING_LIT_ | BOOL_LIT_;

LOGICAL_EXPRESSION: COMPARISON
            | NOT_ COMPARISON
            | DISJUNCTION COMPARISON
            | CONJUNCTION COMPARISON
            | XORTION COMPARISON;
DISJUNCTION: COMPARISON OR_;
CONJUNCTION: COMPARISON AND_;
XORTION: COMPARISON XOR_;            

COMPARISON: MATH_EXPRESSION COMPARISON_RIGHT | MATH_EXPRESSION;
COMPARISON_RIGHT: COMPARISON_OPERATOR MATH_EXPRESSION;
COMPARISON_OPERATOR: EQUALS_ | GREATER_THAN_ | LESS_THAN_ | GREATER_EQUALS_ | LESS_EQUALS_ | DIFFERENT_;

SWITCH_STATEMENT: SWITCH_HEADER SWITCH_BODY;
SWITCH_HEADER: SWITCH_DECLARE NEWLINE_ | SWITCH_HEADER NEWLINE_;
SWITCH_DECLARE: SWITCH_ VAR_NAME_;
SWITCH_BODY: CASE_BODY SWITCH_END;
CASE_BODY: CASE_LIST | CASE_LIST DEFAULT_CASE;
CASE_LIST: SWITCH_CASE | SWITCH_CASE CASE_LIST;
SWITCH_CASE: CASE_BEGIN STATEMENT_LIST;
CASE_BEGIN: CASE_DECLARE NEWLINE_ | CASE_DECLARE EXTRA_CASES | CASE_BEGIN NEWLINE_;
CASE_DECLARE: CASE_ LITERAL;
EXTRA_CASES: EXTRA_CASE_LIST NEWLINE_;
EXTRA_CASE_LIST: EXTRA_CASE_DECLARE | EXTRA_CASE_LIST EXTRA_CASE_DECLARE;
EXTRA_CASE_DECLARE: COMMA_ LITERAL;
DEFAULT_CASE: DEFAULT_HEAD STATEMENT_LIST;
DEFAULT_HEAD: DEFAULT_ NEWLINE_;
SWITCH_END: ENDSWITCH_;

WRITE_STATEMENT: WRITE_BEGIN WRITE_END;
WRITE_BEGIN: WRITE_ OPEN_CURLY_ | WRITE_LINE_ OPEN_CURLY_;
WRITE_END: WRITE_PARAMS CLOSE_CURLY_;
WRITE_PARAMS: VAR_NAME_ | STRING_LIT_ | VAR_NAME_ EXTRA_PARAMS | STRING_LIT_ EXTRA_PARAMS;
EXTRA_PARAMS: EXTRA_PARAM  {}
            | EXTRA_PARAMS EXTRA_PARAM {};
EXTRA_PARAM: COMMA_ STRING_LIT_ | COMMA_ VAR_NAME_;

READ_STATEMENT: READ_BEGIN READ_END;
READ_BEGIN: READ_ OPEN_CURLY_;
READ_END: READ_PARAMS CLOSE_CURLY_;
READ_PARAMS: VAR_NAME_ | VAR_NAME_ EXTRA_VARS;

FOR_STATEMENT: FOR_HEADER FOR_BODY;
FOR_HEADER: FOR_DECLARE_VAR FOR_DECLARE_BODY;
FOR_DECLARE_VAR: FOR_ VAR_NAME_;
FOR_DECLARE_BODY: RANGE_DECLARE DO_DECLARE;
RANGE_DECLARE: START_RANGE END_RANGE | RANGE_DECLARE STEP_DECLARE;
START_RANGE: FROM_ MATH_EXPRESSION;
END_RANGE: TO_ MATH_EXPRESSION;
STEP_DECLARE: STEP_ MATH_EXPRESSION;
DO_DECLARE: DO_ NEWLINE_;
FOR_BODY: STATEMENT_LIST FOR_END;
FOR_END: ENDFOR_;

WHILE_STATEMENT: WHILE_HEADER WHILE_BODY;
WHILE_HEADER: WHILE_DECLARE DO_DECLARE;
WHILE_DECLARE: WHILE_ LOGICAL_EXPRESSION;
WHILE_BODY: STATEMENT_LIST WHILE_END;
WHILE_END: ENDWHILE_;

DOWHILE_STATEMENT: DOWHILE_HEADER DOWHILE_BODY;
DOWHILE_HEADER: DOWHILE_ NEWLINE_;
DOWHILE_BODY: STATEMENT_LIST DOWHILE_END;
DOWHILE_END: TO_ LOGICAL_EXPRESSION;

RETURN_STATEMENT: RETURN_ LOGICAL_EXPRESSION;

PROCEDURE_STATEMENT: PROCEDURE_HEADER PROCEDURE_BODY;
PROCEDURE_HEADER: PROCEDURE_NAME PROCEDURE_DECLARE | PROCEDURE_HEADER NEWLINE_;
PROCEDURE_NAME: PROCEDURE_ VAR_NAME_;
PROCEDURE_DECLARE: PROCEDURE_PARAMS NEWLINE_;
PROCEDURE_PARAMS: PROCEDURE_PARAMS_BEGIN PROCEDURE_PARAMS_END;
PROCEDURE_PARAMS_BEGIN: OPEN_CURLY_ | OPEN_CURLY_ VAR_;
PROCEDURE_PARAMS_END: PROCEDURE_PARAMS_LIST CLOSE_CURLY_;
PROCEDURE_PARAMS_LIST: PROCEDURE_PARAM | PROCEDURE_PARAMS_LIST NEW_PARAM;
NEW_PARAM: COMMA_ PROCEDURE_PARAM;
PROCEDURE_PARAM: VAR_NAME_ TYPE_CHECK | MULTI_DECLARATION TYPE_CHECK;
PROCEDURE_BODY: VARIABLES PROCEDURE_ALGORITHM;
PROCEDURE_ALGORITHM: PROCEDURE_ALGORITHM_HEADER PROCEDURE_ALGORITHM_BODY;
PROCEDURE_ALGORITHM_HEADER: FUNCTION_ALGORITHM_START;
PROCEDURE_ALGORITHM_BODY: STATEMENT_LIST ENDPROCEDURE_;

FUNCTION_STATEMENT: FUNCTION_HEADER FUNCTION_BODY;
FUNCTION_HEADER: FUNCTION_NAME FUNCTION_DECLARE | FUNCTION_HEADER NEWLINE_;
FUNCTION_NAME: FUNCTION_ VAR_NAME_;
FUNCTION_DECLARE: FUNCTION_PARAMS NEWLINE_;
FUNCTION_PARAMS: TYPE_CHECK | PROCEDURE_PARAMS TYPE_CHECK;
FUNCTION_BODY: VARIABLES FUNCTION_ALGORITHM;
FUNCTION_ALGORITHM: FUNCTION_ALGORITHM_HEADER FUNCTION_ALGORITHM_BODY;
FUNCTION_ALGORITHM_HEADER: FUNCTION_ALGORITHM_START;
FUNCTION_ALGORITHM_BODY: STATEMENT_LIST ENDFUNCTION_;
FUNCTION_ALGORITHM_START: INICIO_ NEWLINE_ | FUNCTION_ALGORITHM_START NEWLINE_;

FUNCTION_CALL: FUNCTION_CALL_BEGIN FUNCTION_CALL_END;
FUNCTION_CALL_BEGIN: VAR_NAME_ OPEN_CURLY_;
FUNCTION_CALL_END: MULTI_PARAMS CLOSE_CURLY_ | MATH_EXPRESSION CLOSE_CURLY_;
MULTI_PARAMS: MATH_EXPRESSION EXTRA_CALL_PARAMS;
EXTRA_CALL_PARAMS: EXTRA_CALL_PARAM | EXTRA_CALL_PARAMS EXTRA_CALL_PARAM;
EXTRA_CALL_PARAM: COMMA_ MATH_EXPRESSION;

ALGORITMO_: ALGORITMO { $$ = createNode(KEYWORD, (NodeValue) "algoritmo", NULL, NULL); };
FIMALGORITMO_: FIMALGORITMO { $$ = createNode(KEYWORD, (NodeValue) "fimalgoritmo", NULL, NULL); };
INICIO_: INICIO { $$ = createNode(KEYWORD, (NodeValue) "inicio", NULL, NULL); };
VAR_: VAR {};
TYPE_: TYPE {};
IF_: IF {};
THEN_: THEN {};
ELSE_: ELSE {};
ENDIF_: ENDIF {};
SWITCH_: SWITCH {};
CASE_: CASE {};
DEFAULT_: DEFAULT {};
ENDSWITCH_: ENDSWITCH {};
WRITE_: WRITE {};
WRITE_LINE_: WRITE_LINE {};
READ_: READ {};
AND_: AND {};
NOT_: NOT {};
OR_: OR {};
XOR_: XOR {};
COLON_: COLON {};
NEWLINE_: NEWLINE { $$ = createNode(KEYWORD, (NodeValue) "\n", NULL, NULL); };
COMMA_: COMMA {};
VAR_NAME_: VAR_NAME { $$ = createNode(KEYWORD, (NodeValue) "var_name", NULL, NULL);};
ARROW_: ARROW {};
PLUS_: PLUS {};
MINUS_: MINUS {};
TIMES_: TIMES {};
DIVIDE_: DIVIDE {};
OPEN_CURLY_: OPEN_CURLY {};
CLOSE_CURLY_: CLOSE_CURLY {};
MODULO_: MODULO {};
POWER_: POWER {};
BOOL_LIT_: BOOL_LIT {};
DOUBLE_LIT_: DOUBLE_LIT {};
INT_LIT_: INT_LIT {};
STRING_LIT_: STRING_LIT {};
EQUALS_: EQUALS {};
GREATER_EQUALS_: GREATER_EQUALS {};
LESS_EQUALS_: LESS_EQUALS {};
LESS_THAN_: LESS_THAN {};
GREATER_THAN_: GREATER_THAN {};
DIFFERENT_: DIFFERENT {};
FOR_: FOR {};
FROM_: FROM {};
TO_: TO {};
DO_: DO {};
STEP_: STEP {};
ENDFOR_: ENDFOR {};
WHILE_: WHILE {};
ENDWHILE_: ENDWHILE {};
DOWHILE_: DOWHILE {};
BREAK_: BREAK { $$ = createNode(KEYWORD, (NodeValue) "interrompa", NULL, NULL); };
PROCEDURE_: PROCEDURE {};
ENDPROCEDURE_: ENDPROCEDURE {};
FUNCTION_: FUNCTION {};
ENDFUNCTION_: ENDFUNCTION {};
RETURN_: RETURN {};
%%


int yyerror() {
    return 1;
}
