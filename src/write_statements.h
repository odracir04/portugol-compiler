#ifndef PORTUGOL_COMPILER_WRITE_STATEMENTS_H
#define PORTUGOL_COMPILER_WRITE_STATEMENTS_H

#include "compiler.h"

bool writeBeginLLVM(ASTNode* node);
void writeParamsLLVM(ASTNode* node, char* string);
void writeEndLLVM(ASTNode* node, char* string);
void writeStatementLLVM(ASTNode* node, LLVMBasicBlockRef* block, LLVMBuilderRef* builder);
void extraParamLLVM(ASTNode* node, char* string);
void extraParamsLLVM(ASTNode* node, char* string);

#endif //PORTUGOL_COMPILER_WRITE_STATEMENTS_H
