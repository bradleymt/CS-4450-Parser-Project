#include "IndentLexer.h"

using namespace std;
using namespace antlr4;

IndentLexer::IndentLexer(CharStream* input) : PseudoPythonLexer(input)
{
    indents.push_back(0);  //top level of the file is indent 0
    newLine = true;        //the file starts on a new line
    indentErrors = 0;
}

int IndentLexer::getIndentErrors()
{
    return indentErrors;
}



//Some calls to the normal lexer make more than one token, like a DEDENT and then the NAME after it. They go in the queue and get handed to the parser one at a time.
unique_ptr<Token> IndentLexer::nextToken()
{
    //keep reading from the normal lexer until there is something to return
    while (ready.empty())
    {
        //get the next token (from the grammar lexer rules)
        unique_ptr<Token> token = PseudoPythonLexer::nextToken();

        if (token->getType() == NEWLINE)
        {
            //if are already at the start of a line, newline is from a blank line or a line with only a comment, so throw it away
            if (newLine)
            {
                continue;
            }

            //otherwise ends a statement, so keep
            newLine = true;
            ready.push(move(token));
        }
        else if (token->getType() == Token::EOF)
        {
            //the last line might not have a newline, but the parser needs one to end the last statement, so add a fake one
            if (!newLine)
            {
                ready.push(makeToken(token.get(), NEWLINE, "\n"));
                newLine = true;
            }

            //every block still open at the end of the file needs a DEDENT
            while (indents.back() > 0)
            {
                indents.pop_back();
                ready.push(makeToken(token.get(), PseudoPythonParser::DEDENT, "<DEDENT>"));
            }

            ready.push(move(token));
        }
        else
        {
            //a normal token(NAME, INTEGER, '=', etc)
            //if its the first one on the line, check how indented the line is
            if (newLine)
            {
                checkIndent(token.get());
                newLine = false;
            }

            ready.push(move(token));
        }
    }

    //give parser the oldest token in the queue
    unique_ptr<Token> next = move(ready.front());
    ready.pop();
    return next;
}

//Compares the indent of a new line to the current block and adds INDENT or DEDENT tokens if changed
void IndentLexer::checkIndent(Token* firstToken)
{
    //the column of the first token on the line is the same as the number of spaces/tabs before it, so that is how indented the line is(a tab counts as 1, so dont mix tabs and spaces)
    int indent = firstToken->getCharPositionInLine();

    if (indent > indents.back())
    {
        //more indented than the current block, so a new block starts
        indents.push_back(indent);
        ready.push(makeToken(firstToken, PseudoPythonParser::INDENT, "<INDENT>"));
        return;
    }

    //less indented, so close blocks until we get back to this indent (one line can close more than one block, ex: going from 8 spaces to 0)
    while (indent < indents.back())
    {
        indents.pop_back();
        ready.push(makeToken(firstToken, PseudoPythonParser::DEDENT, "<DEDENT>"));
    }

    
    //if skipped past, the line went back to an indent that no block uses, ex: a block at 8 spaces and then a line at 4 when the outer block is 0
    if (indent != indents.back())
    {
        indentErrors++;
        getErrorListenerDispatch().syntaxError(this, nullptr, firstToken->getLine(),
            indent, "indent doesn't line up with any block above it", nullptr);
    }
}


//INDENT, DEDENT, and the fake NEWLINE are not in the file, so they copy the line and column of a real token. Then eror messages still point to the right spot
unique_ptr<Token> IndentLexer::makeToken(Token* copyFrom, size_t type, string text)
{
    unique_ptr<CommonToken> token = make_unique<CommonToken>(copyFrom);
    token->setType(type);
    token->setText(text);
    return token;
}
