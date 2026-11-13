//Division of roles:
//Arithmetic - Cole
//Assignment - Bergie
//Data Types and Parser Integration - Bradley

grammar PythonSubset;

//Main program
program
    : statement* EOF
    ;

//Statements
statement
    : assignment NEWLINE
    ;

//Assignment
assignment
    : NAME assignmentOperator value
    ;

//Assignment operators
assignmentOperator
    : '='
    | '+='
    | '-='
    | '*='
    | '/='
    ;


//Values can be assigned
value
    : expression
    | list
    ;


//Arithmetic expressions
expression
    : term
    | expression '+' term
    | expression '-' term
    ;

term
    : factor
    | term '*' factor
    | term '/' factor
    | term '%' factor
    ;


//Individual values
factor
    : INTEGER
    | FLOAT
    | STRING
    | BOOLEAN
    | NAME
    | '(' expression ')'
    ;

//Lists

list
    : '[' listValues ']'
    ;

listValues
    : value
    | value ',' listValues
    |
    ;

//Data types
INTEGER
    : [0-9]+
    ;


FLOAT
    : [0-9]+ '.' [0-9]+
    ;

STRING
    : '"' .*? '"'
    | '\'' .*? '\''
    ;

BOOLEAN
    : 'True'
    | 'False'
    ;


NAME
    : [a-zA-Z_][a-zA-Z_0-9]*
    ;

//Newlines and whitespace
NEWLINE
    : '\r'? '\n'
    ;


WS
    : [ \t]+ -> skip
    ;