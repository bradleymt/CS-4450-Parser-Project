This is a very good python parser.

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
- `tests/project_deliverable_1.py` - test file for delverable 1
- `tests/lists_test.py` - self explanatory
- `tests/datatypes_test.py` - self explanatory
