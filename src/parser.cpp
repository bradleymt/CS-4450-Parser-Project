#include "parser.h"

#include <iostream>
#include <fstream>

using namespace std;
using namespace antlr4;

int parseFile(string fileName)
{
    ifstream file(fileName);
    if (!file.is_open())
    {
        cout << "Error: could not open file " << fileName << endl;
        return -1;
    }


    ANTLRInputStream input(file);
    PseudoPythonLexer lexer(&input);
    CommonTokenStream tokens(&lexer);
    PseudoPythonParser parser(&tokens);

    tree::ParseTree* tree = parser.program();

    int errors = lexer.getNumberOfSyntaxErrors() + parser.getNumberOfSyntaxErrors();

    cout << "========== Parse Tree ==========" << endl;
    printTree(tree, &parser, 0);
    cout << endl;

    cout << "========== Parse Tree (LISP format) ==========" << endl;
    cout << tree->toStringTree(&parser) << endl;
    cout << endl;

    if (errors == 0)
    {
        cout << "Parsed " << fileName << " with no errors." << endl;
    }
    else
    {
        cout << "Found " << errors << " syntax error(s) in " << fileName << endl;
    }

    return errors;
}

void printTree(tree::ParseTree* node, PseudoPythonParser* parser, int depth)
{
    for (int i = 0; i < depth; i++)
    {
        cout << "  ";
    }


    //leaf nodes are tokens, everything else is a rule
    tree::TerminalNode* leaf = dynamic_cast<tree::TerminalNode*>(node);

    if (leaf != nullptr)
    {
        int type = leaf->getSymbol()->getType();
        string typeName;
        if (type == Token::EOF)
        {
            typeName = "EOF";
        }
        else
        {
            typeName = string(parser->getVocabulary().getSymbolicName(type));
        }
        cout << typeName << ": " << cleanText(leaf->getText()) << endl;
    }
    else
    {
        ParserRuleContext* rule = dynamic_cast<ParserRuleContext*>(node);
        cout << parser->getRuleNames()[rule->getRuleIndex()] << endl;


        for (int i = 0; i < (int)node->children.size(); i++)
        {
            printTree(node->children[i], parser, depth + 1);
        }
    }
}


//Newlines show up as \n instead of breaking the output
string cleanText(string text)
{
    string result = "";
    for (int i = 0; i < (int)text.length(); i++)
    {
        if (text[i] == '\n')
        {
            result += "\\n";
        }
        else if (text[i] == '\r')
        {
            result += "\\r";
        }
        else if (text[i] == '\t')
        {
            result += "\\t";
        }
        else
        {
            result += text[i];
        }
    }
    
    return result;
}
