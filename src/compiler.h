#ifndef PORTUGOL_COMPILER_COMPILER_H
#define PORTUGOL_COMPILER_COMPILER_H

#include <stdbool.h>

typedef enum {
    TOKEN, INT, STRING, DOUBLE, BOOL, KEYWORD
} NodeType;

typedef union NodeValue {
    int intValue;
    double doubleValue;
    char* stringValue;
    bool booleanValue;
} NodeValue;

typedef struct ASTNode {
    NodeType type;
    NodeValue value;
    struct ASTNode* left;
    struct ASTNode* right;
} ASTNode;

ASTNode* createNode(NodeType type, NodeValue value, ASTNode* left, ASTNode* right);

#endif //PORTUGOL_COMPILER_COMPILER_H