#ifndef INDENT_LEXER_H
#define INDENT_LEXER_H

#include <memory>
#include <queue>
#include <string>
#include <vector>

#include "antlr4-runtime.h"
#include "PseudoPythonLexer.h"
#include "PseudoPythonParser.h"  //INDENT and DEDENT are only defined in the parser

//Grammar skips all spaces and tabs, so the parser can't see indentation
//Class sits between the lexer and the parser. It passes normal tokens through, but adds INDENT and DEDENT tokens when a line is indented more or less than the line before it
class IndentLexer : public PseudoPythonLexer
{
public:
    IndentLexer(antlr4::CharStream* input);

    
    //the parser calls this every time it wants the next token
    std::unique_ptr<antlr4::Token> nextToken() override;

    //number of bad dedents found
    int getIndentErrors();

private:
    //tokens that are ready to give to the parser, oldest first
    std::queue<std::unique_ptr<antlr4::Token>> ready;

    //indent level of every block we are inside, the last one is the current block
    //starts as {0} because the top of the file isn't indented
    std::vector<int> indents;

    //true when the next real token is the first one on its line
    bool newLine;

    int indentErrors;


    void checkIndent(antlr4::Token* firstToken);
    std::unique_ptr<antlr4::Token> makeToken(antlr4::Token* copyFrom, size_t type, std::string text);
};

#endif
