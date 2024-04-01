#ifndef PORTUGOL_COMPILER_STRUCTURE_H
#define PORTUGOL_COMPILER_STRUCTURE_H

#include "compiler.h"

void programNameLLVM(ASTNode* node);
void programHeaderLLVM(ASTNode* node);

void programBodyLLVM(ASTNode* node);

void algorithmLLVM(ASTNode* node);
void algorithmHeaderLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder, LLVMTypeRef* returnType);
void algorithmBodyLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder, LLVMTypeRef* returnType);
void algorithmEndLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder, LLVMTypeRef* returnType);

void statementListLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder);
void statementLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder);

#endif //PORTUGOL_COMPILER_STRUCTURE_H
