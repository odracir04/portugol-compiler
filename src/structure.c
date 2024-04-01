//
// Created by ricardo on 4/1/24.
//

#include <llvm-c/Core.h>
#include <stdlib.h>
#include <string.h>
#include "compiler.h"
#include "write_statements.h"

extern LLVMContextRef context;
extern LLVMModuleRef module;
extern LLVMTypeRef mainFunctionType;
extern LLVMTypeRef put;
extern LLVMValueRef putsFunc;

void programNameLLVM(ASTNode* node) {
    context = LLVMContextCreate();
    module = LLVMModuleCreateWithName(node->right->value.stringValue);
    free(node->right);
    free(node->left);
    free(node);
}

void programHeaderLLVM(ASTNode* node) {
    free(node->right);
    if (strcmp(node->left->value.stringValue, "PROGRAM_HEADER") == 0) {
        programHeaderLLVM(node->left);
    }
    else {
        programNameLLVM(node->left);
        free(node);
    }
}

void algorithmEndLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder, LLVMTypeRef* returnType) {
    if (node->right == NULL) {
        LLVMPositionBuilderAtEnd(*builder, *block);
        LLVMValueRef returnValue = LLVMConstInt(*returnType, 0, 0);
        LLVMBuildRet(*builder, returnValue);
        LLVMDisposeBuilder(*builder);
        free(node->left);
    }
    else {
        algorithmEndLLVM(node->left, block, builder, returnType);
        free(node->right);
    }
    free(node);
}

void statementLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder) {
    if (strcmp(node->left->value.stringValue, "WRITE_STATEMENT") == 0) {
        writeStatementLLVM(node->left, block, builder);
    }
    free(node->right);
    free(node);
}

void statementListLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder) {
    statementLLVM(node->left, block, builder);
    if (node->right != NULL) {
        statementListLLVM(node->right, block, builder);
    }
    free(node);
}

void algorithmBodyLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder, LLVMTypeRef* returnType) {
    statementListLLVM(node->left,block, builder);
    algorithmEndLLVM(node->right, block, builder, returnType);
    free(node);
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
        free(node->left);
    }
    else {
        algorithmHeaderLLVM(node->left, block, builder, returnType);
    }
    free(node->right);
    free(node);
}

void algorithmLLVM(ASTNode* node) {
    LLVMBasicBlockRef block;
    LLVMBuilderRef builder;
    LLVMTypeRef returnType;
    algorithmHeaderLLVM(node->left, &block, &builder, &returnType);
    algorithmBodyLLVM(node->right, &block, &builder, &returnType);
    free(node);
}

void programBodyLLVM(ASTNode* node) {
    if (node->right == NULL) {
        algorithmLLVM(node->left);
    }
    else {
        // functionsAndVariablesLLVM(node->left);
        algorithmLLVM(node->right);
    }
    free(node);
}