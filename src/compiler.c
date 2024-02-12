#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <llvm-c/Core.h>
#include <llvm-c/BitWriter.h>
#include "compiler.h"

extern FILE* yyin;
extern int yyparse();
extern int yylex();
extern int yylineno;


ASTNode* rootNode;
LLVMContextRef context;
LLVMModuleRef module;

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


void parseFile(char* filename) {
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
}


void programNameLLVM(ASTNode* node) {
    context = LLVMContextCreate();
    module = LLVMModuleCreateWithName(node->right->value.stringValue);
}

void programHeaderLLVM(ASTNode* node) {
    if (strcmp(node->left->value.stringValue, "PROGRAM_HEADER") == 0) {
        programHeaderLLVM(node->left);
    }
    else {
        programNameLLVM(node->left);
    }
}

void algorithmHeaderLLVM(ASTNode* node, LLVMValueRef* mainFunction, LLVMTypeRef* returnType) {
    if (strcmp(node->left->value.stringValue, "INICIO")) {
        *returnType = LLVMInt32TypeInContext(context);
        LLVMTypeRef paramTypes[] = {};
        LLVMTypeRef mainFunctionType = LLVMFunctionType(*returnType, paramTypes, 0, 0);
        *mainFunction = LLVMAddFunction(module, "main", mainFunctionType);
    }
    else {
        algorithmHeaderLLVM(node->left, mainFunction, returnType);
    }
}

void algorithmEndLLVM(ASTNode* node, LLVMValueRef* mainFunction, LLVMTypeRef* returnType) {
    if (node->right == NULL) {
        LLVMBasicBlockRef entryBlock = LLVMAppendBasicBlockInContext(context, *mainFunction, "entry");
        LLVMBuilderRef builder = LLVMCreateBuilderInContext(context);
        LLVMPositionBuilderAtEnd(builder, entryBlock);
        LLVMValueRef returnValue = LLVMConstInt(*returnType, 0, 0);
        LLVMBuildRet(builder, returnValue);
    }
}

void algorithmBodyLLVM(ASTNode* node, LLVMValueRef* mainFunction, LLVMTypeRef* returnType) {
    // statementListLLVM(node->left, mainFunction);
    algorithmEndLLVM(node->right, mainFunction, returnType);
}

void algorithmLLVM(ASTNode* node) {
    LLVMValueRef mainFunction;
    LLVMTypeRef returnType;
    algorithmHeaderLLVM(node->left, &mainFunction, &returnType);
    algorithmBodyLLVM(node->right, &mainFunction, &returnType);
}

void programBodyLLVM(ASTNode* node) {
    if (node->right == NULL) {
        algorithmLLVM(node->left);
    }
    else {
        // functionsAndVariablesLLVM(node->left);
        algorithmLLVM(node->right);
    }
}

void startLLVM() {
    programHeaderLLVM(rootNode->left);
    programBodyLLVM(rootNode->right);
}

void endLLVM() {
    LLVMWriteBitcodeToFile(module, "module.bc");
    LLVMDisposeModule(module);
    LLVMContextDispose(context);
}

int main(int argc, char** argv) {
    parseFile(argv[1]);
    startLLVM();
    endLLVM();
    exit(0);
}