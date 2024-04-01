//
// Created by ricardo on 4/1/24.
//

#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <llvm-c/Core.h>
#include <stdio.h>
#include "write_statements.h"
#include "compiler.h"

extern LLVMTypeRef put;
extern LLVMValueRef putsFunc;

bool writeBeginLLVM(ASTNode* node) {
    bool res = strcmp(node->left->value.stringValue, "escreva");
    free(node->right);
    free(node->left);
    free(node);
    return res;
}

void extraParamLLVM(ASTNode* node, char* string) {
    free(node->left);
    if (node->right->type == STRING) {
        strcat(string, node->right->value.stringValue);
    }
    free(node->right);
    free(node);
}

void extraParamsLLVM(ASTNode* node, char* string) {
    extraParamLLVM(node->left, string);
    if (node->right != NULL) {
        extraParamsLLVM(node->right, string);
    }
    free(node);
}

void writeParamsLLVM(ASTNode* node, char* string) {
    if (node->left->type == STRING) {
        strcpy(string, node->left->value.stringValue);
        free(node->left);
    }
    if (node->right != NULL) {
        extraParamsLLVM(node->right, string);
    }
    free(node);
}

void writeEndLLVM(ASTNode* node, char* string) {
    writeParamsLLVM(node->left, string);
    free(node->right);
    free(node);
}

void writeStatementLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder) {
    char string[1024];
    bool line = writeBeginLLVM(node->left);
    writeEndLLVM(node->right, string);

    LLVMPositionBuilderAtEnd(*builder, *block);
    LLVMValueRef printStr = LLVMBuildGlobalStringPtr(*builder, string, "string");
    LLVMBuildCall2(*builder, put, putsFunc, &printStr, 1, "");
    free(node);
}