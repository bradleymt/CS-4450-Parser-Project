#ifndef PARSER_H
#define PARSER_H

#include <string>

#include "antlr4-runtime.h"
#include "PseudoPythonLexer.h"
#include "PseudoPythonParser.h"

//returns num of syntax errors
int parseFile(std::string fileName);

void printTree(antlr4::tree::ParseTree* node, PseudoPythonParser* parser, int depth);
std::string cleanText(std::string text);

#endif
