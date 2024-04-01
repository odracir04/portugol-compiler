#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <llvm-c/Core.h>
#include <llvm-c/BitWriter.h>
#include "compiler.h"
#include "structure.h"

extern FILE* yyin;
extern int yyparse();
extern int yylex();
extern int yylineno;

ASTNode* rootNode;
LLVMContextRef context;
LLVMModuleRef module;
LLVMTypeRef mainFunctionType;
LLVMTypeRef put;
LLVMValueRef putsFunc;

ASTNode* createNode(NodeType type, NodeValue value, ASTNode* left, ASTNode* right) {
    ASTNode* node = (ASTNode*)malloc(sizeof(ASTNode));
    node->type = type;
    node->value = value;
    node->left = left;
    node->right = right;

    if (strcmp(value.stringValue, "START") == 0)  {
        rootNode = node;
    }
    return node;
}


bool parseFile(char* filename) {
    int retv;
    yyin = fopen(filename, "r");

    if (!yyin) {
        printf("FileError: Could not find file");
        exit(1);
    }

    do {
        retv = yyparse();
    } while (!feof(yyin));

    printf(retv == 0 ? "COMPILATION SUCCESS\n" : "COMPILATION FAILURE\n");
    return retv == 0;
}

void startLLVM() {
    programHeaderLLVM(rootNode->left);
    programBodyLLVM(rootNode->right);
}

void endLLVM() {
    LLVMWriteBitcodeToFile(module, "module.bc");
    LLVMDumpModule(module);
    LLVMDisposeModule(module);
    LLVMContextDispose(context);
    free(rootNode);
}

int main(int argc, char** argv) {
    if (!parseFile(argv[1])) return 1;
    startLLVM();
    endLLVM();
    exit(0);
}