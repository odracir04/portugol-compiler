#include "../parser.tab.h"
#include <stdio.h>
#include <stdlib.h>

extern int yylex();
extern FILE* yyin;
extern FILE* yyout;
extern char* yytext;

void token_tests() {
    printf("BEGINNING TOKEN TESTS...\n");

    yyin = fopen("tests/token_test.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    int passed = 0, failed = 0;
    int res[] = {INICIO, ALGORITMO, VAR, FIMALGORITMO, BOOL_LIT, BOOL_LIT, TYPE, TYPE,
    TYPE, TYPE, IF, ELSE, ENDIF, NEWLINE, COLON, COMMA, ARROW,
        PLUS, MINUS, TIMES, DIVIDE, OPEN_CURLY, CLOSE_CURLY, MODULO, POWER,
        GREATER_EQUALS, EQUALS, LESS_EQUALS, LESS_THAN, GREATER_THAN, DIFFERENT, NEWLINE,
        VAR_NAME, STRING_LIT, INT_LIT, DOUBLE_LIT, NEWLINE};

    int retv = yylex(), i = 0;
    while (1) {
        if (retv == res[i]) {
            passed++;
        }
        else {
            failed++;
            printf("FAILED TEST: %s\n", yytext);
        }
        i++;
        if (i >= sizeof(res) / sizeof(int)) break;
        retv = yylex();
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void structure_tests() {

    printf("BEGINNING ALGORITHM STRUCTURE TESTS...\n");

    int passed = 0, failed = 0, retv;

    yyin = fopen("tests/structure_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);

    yyin = fopen("tests/structure_test2.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 2\n");
    }

    fclose(yyin);

    yyin = fopen("tests/structure_test3.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 3\n");
    }

    fclose(yyin);

    yyin = fopen("tests/structure_test4.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 4\n");
    }

    fclose(yyin);

    yyin = fopen("tests/structure_test5.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 5\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void variable_tests() {

    printf("BEGINNING VARIABLE DECLARATION PARSER TESTS...\n");

    int passed = 0, failed = 0, retv;

    yyin = fopen("tests/variable_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);

    yyin = fopen("tests/variable_test2.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 2\n");
    }

    fclose(yyin);

    yyin = fopen("tests/variable_test3.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 3\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void math_expression_tests() {
    printf("BEGINNING MATH EXPRESSION PARSER TESTS...\n");

    int passed = 0, failed = 0, retv;

    yyin = fopen("tests/math_expression_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);

    yyin = fopen("tests/math_expression_test2.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 2\n");
    }

    fclose(yyin);

    yyin = fopen("tests/math_expression_test3.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 3\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void if_else_tests() {
    printf("BEGINNING IF ELSE CONDITIONAL TESTS...\n");

    int passed = 0, failed = 0, retv;

    yyin = fopen("tests/if_else_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);

    yyin = fopen("tests/if_else_test2.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 2\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void switch_case_tests() {

    printf("BEGINNING SWITCH CASE CONDITIONAL TESTS...\n");

    int passed = 0, failed = 0, retv;
    yyin = fopen("tests/switch_case_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void read_tests() {

    printf("BEGINNING READ TESTS...\n");

    int passed = 0, failed = 0, retv;
    yyin = fopen("tests/read_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void write_tests() {

    printf("BEGINNING WRITE TESTS...\n");

    int passed = 0, failed = 0, retv;
    yyin = fopen("tests/write_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void for_tests() {

    printf("BEGINNING FOR STATEMENT TESTS...\n");

    int passed = 0, failed = 0, retv;
    yyin = fopen("tests/for_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void while_tests() {

    printf("BEGINNING WHILE STATEMENT TESTS...\n");

    int passed = 0, failed = 0, retv;
    yyin = fopen("tests/while_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

void dowhile_tests() {

    printf("BEGINNING DO-WHILE STATEMENT TESTS...\n");

    int passed = 0, failed = 0, retv;
    yyin = fopen("tests/dowhile_test1.portugol", "r");

    if (!yyin) {
        printf("FileError: Could not find input file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    if (retv == 0) {
        passed++;
    }
    else {
        failed++;
        printf("FAILED TEST 1\n");
    }

    fclose(yyin);
    printf("\nTESTS PASSED: %d\nTESTS FAILED: %d\n\n", passed, failed);
}

int main(int argc, char** argv) {
    token_tests();
    structure_tests();
    variable_tests();
    math_expression_tests();
    if_else_tests();
    switch_case_tests();
    read_tests();
    write_tests();
    for_tests();
    while_tests();
    dowhile_tests();
    exit(EXIT_SUCCESS);
}