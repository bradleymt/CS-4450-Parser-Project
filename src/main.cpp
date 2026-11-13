//Had some issues with MinGW and antlr4 build version, so there might be problems with compiling on different machines
#include <iostream>
#include <string>

#include "parser.h"

using namespace std;

int main(int argc, char* argv[])
{
    if (argc < 2)
    {
        cout << "Usage: python_parser <file.py>" << endl;
        return 1;
    }

    int errors = parseFile(argv[1]);

    if (errors == 0)
    {
        return 0;
    }
    return 1;
}
