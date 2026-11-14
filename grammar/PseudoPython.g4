//Division of roles:
//Arithmetic - Michael
//Assignment - Cole
//Data Types and Parser Integration - Bradley

grammar PseudoPython;

//Main program
//Allows blank lines anywhere and the last line doesnt need a newline
program
    : NEWLINE* (statement (NEWLINE+ statement)*)? NEWLINE* EOF
    ;

//Statements
statement
    : assignment
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

// Switched from factor to unary so leading '-'s parse. -Michael
term
    : unary
    | term '*' unary
    | term '/' unary
    | term '%' unary
    ;

// Unary sign, so -5, -x, and 5 - -2 work. -Michael
unary
    : '-' unary
    | '+' unary
    | factor
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
//ex: [1, 2, 3] or [] (trailing comma supported like in python)
list
    : '[' listValues? ']'
    ;

listValues
    : value (',' value)* ','?
    ;


//Tokens
//named so the tree shows ASSIGN, PLUS, etc instead of T__0
ASSIGN        : '=' ;
PLUS_ASSIGN   : '+=' ;
MINUS_ASSIGN  : '-=' ;
TIMES_ASSIGN  : '*=' ;
DIVIDE_ASSIGN : '/=' ;

PLUS   : '+' ;
MINUS  : '-' ;
TIMES  : '*' ;
DIVIDE : '/' ;
MODULO : '%' ;

LPAREN   : '(' ;
RPAREN   : ')' ;
LBRACKET : '[' ;
RBRACKET : ']' ;
COMMA    : ',' ;


//Data types
//BOOLEAN has to be above NAME or True/False get read as names
BOOLEAN
    : 'True'
    | 'False'
    ;

FLOAT
    : [0-9]+ '.' [0-9]*
    | '.' [0-9]+
    ;

INTEGER
    : [0-9]+
    ;

//single or double quotes, \ lets you escape a quote
STRING
    : '"' ( '\\' . | ~["\\\r\n] )* '"'
    | '\'' ( '\\' . | ~['\\\r\n] )* '\''
    ;

NAME
    : [a-zA-Z_][a-zA-Z_0-9]*
    ;


//Newlines and whitespace
//\r? so windows line endings work
NEWLINE
    : '\r'? '\n'
    ;

WS
    : [ \t]+ -> skip
    ;

COMMENT
    : '#' ~[\r\n]* -> skip
    ;
