#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <llvm-c/Core.h>
#include <stdbool.h>
#include <llvm-c/BitWriter.h>
#include "compiler.h"

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

void algorithmHeaderLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder, LLVMTypeRef* returnType) {
    if (strcmp(node->left->value.stringValue, "INICIO")) {
        *returnType = LLVMInt32TypeInContext(context);
        LLVMTypeRef paramTypes[] = {};
        mainFunctionType = LLVMFunctionType(*returnType, paramTypes, 0, 0);
        LLVMValueRef mainFunction = LLVMAddFunction(module, "main", mainFunctionType);
        *block = LLVMAppendBasicBlockInContext(context, mainFunction, "entry");
        *builder = LLVMCreateBuilderInContext(context);
        
        LLVMTypeRef args[1];
        args[0] = LLVMPointerType(LLVMInt8Type(), 0);
        put = LLVMFunctionType(LLVMInt32Type(), args, 1, 0);
        putsFunc = LLVMAddFunction(module, "puts", put);
    }
    else {
        algorithmHeaderLLVM(node->left, block, builder, returnType);
    }
}

void algorithmEndLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder, LLVMTypeRef* returnType) {
    if (node->right == NULL) {
        LLVMPositionBuilderAtEnd(*builder, *block);
        LLVMValueRef returnValue = LLVMConstInt(*returnType, 0, 0);
        LLVMBuildRet(*builder, returnValue);
    }
}

bool writeBeginLLVM(ASTNode* node) {
    return strcmp(node->left->value.stringValue, "escreva");
}

char* writeParamsLLVM(ASTNode* node) {
    if (node->right == NULL) {
        if (node->left->type == STRING) {
            char* string = malloc(sizeof(node->left->value.stringValue));
            strcpy(string, node->left->value.stringValue);
            return string;
        }
    }
    return "";
}

char* writeEndLLVM(ASTNode* node) {
    return writeParamsLLVM(node->left);
}

void writeStatementLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder) {
    bool line = writeBeginLLVM(node->left);
    char* string = writeEndLLVM(node->right);
    if (line) {
        strcat(string, "\n");
    }
    LLVMPositionBuilderAtEnd(*builder, *block);
    LLVMValueRef printStr = LLVMBuildGlobalStringPtr(*builder, string, "string");
    LLVMBuildCall2(*builder, put, putsFunc, &printStr, 1, "");
}

void statementLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder) {
    if (strcmp(node->left->value.stringValue, "WRITE_STATEMENT") == 0) {
        writeStatementLLVM(node->left, block, builder);
    }
}

void statementListLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder) {
    statementLLVM(node->left, block, builder);
    if (node->right != NULL) {
        statementListLLVM(node->right, block, builder);    
    }
}

void algorithmBodyLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder, LLVMTypeRef* returnType) {
    statementListLLVM(node->left,block, builder);
    algorithmEndLLVM(node->right, block, builder, returnType);
}

void algorithmLLVM(ASTNode* node) {
    LLVMBasicBlockRef block;
    LLVMBuilderRef builder;
    LLVMTypeRef returnType;
    algorithmHeaderLLVM(node->left, &block, &builder, &returnType);
    algorithmBodyLLVM(node->right, &block, &builder, &returnType);
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
    LLVMDumpModule(module);
    LLVMDisposeModule(module);
    LLVMContextDispose(context);
}

int main(int argc, char** argv) {
    parseFile(argv[1]);
    startLLVM();
    endLLVM();
    exit(0);
}