This is a very good python parser. - Bradley
I would even say it's the best one ever made. - Michael

## Requirements
- Java to run antlr
- CMake 3.16 or newer
- A C++17 compiler (used g++ from MSYS2 ucrt64)

## Building
From the project folder:

```
cmake -S . -B build -G "MinGW Makefiles"
cmake --build build
```
If you edit `grammar/PseudoPython.g4` just run `cmake --build build` again and it will rerun antlr.

If you alrady have the antlr jar you can use it instead of downloading:
`cmake -S . -B build -G "MinGW Makefiles" -DANTLR_JAR=C:/path/to/antlr-4.13.2-complete.jar`
(has to be 4.13.2 so it matches)

## Running

```
build/python_parser tests/project_deliverable_1.py
```

It prints the parse tree two ways: 
- Indented version
- One line LISP version that antlr makes

At the end it says if there were syntax error.

## Files
- `grammar/PseudoPython.g4` - the grammar (lexer and parser rules)
- `src/main.cpp` - reads file name from command line
- `src/parser.cpp`, `src/parser.h` - runs lexer and parser and prints tree
- `src/IndentLexer.cpp`, `src/IndentLexer.h` - wraps the antlr lexer to make INDENT/DEDENT tokens from indentation and skips blank lines
- `tests/project_deliverable_1.py` - test file for delverable 1
- `tests/project_deliverable_2.py` - test file for delverable 2 (if/elif/else)
- `tests/conditions_test.py` - comparisons, and/or/not, precedence
- `tests/lists_test.py` - self explanatory
- `tests/datatypes_test.py` - self explanatory
- `tests/indentation_test.py` - nested if/elif/else blocks, multi level dedents, tabs, blank/comment lines in blocks
- `tests/bad_indentation_test.py` - every section should give an indentation error
