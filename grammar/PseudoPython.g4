//Division of roles:
//Arithmetic - Michael
//Assignment - Cole
//Data Types and Parser Integration - Bradley

grammar PseudoPython;

//INDENT and DEDENT are made by src/IndentLexer.cpp, not by a lexer rule
//IndentLexer also drops blank/coment only lines and adds a NEWLINE at the end of the file if missing
tokens { INDENT, DEDENT }

//Main program
program
    : statement* EOF
    ;


//Statements
//simple statements end with a newline, compound ones end with their block
statement
    : simpleStatement NEWLINE
    | compoundStatement
    ;

simpleStatement
    : assignment
    ;

compoundStatement
    : testBlock
    ;

//TEMPORARY, only for testing indentation until ifStatement added, don't forget to remove and replace Cole
//ex:  name:
//         x = 1
testBlock
    : NAME ':' block
    ;

//Indented block of statements, used by if/elif/else (and loops later)
block
    : NEWLINE INDENT statement+ DEDENT
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
// Changed from expression to condition since condition goes down to expression, so plain math still works
// but now also lets flag = a < b and not c parse without if statement. -Michael
value
    : condition
    | list
    ;

// Conditions
// Lowest to highest precedence: or, and, not, and comparison.
condition
    : orExpression
    ;

orExpression
    : andExpression (OR andExpression)*
    ;

andExpression
    : notExpression (AND notExpression)*
    ;

notExpression
    : NOT notExpression
    | comparison
    ;

// Chained like python (a < b < c), or a parenthesized condition like (not flag).
comparison
    : expression (comparisonOperator expression)*
    | '(' condition ')'
    ;

comparisonOperator
    : LT
    | LE
    | GT
    | GE
    | EQ
    | NE
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

// Comparison operators.
LT : '<' ;
LE : '<=' ;
GT : '>' ;
GE : '>=' ;
EQ : '==' ;
NE : '!=' ;

LPAREN   : '(' ;
RPAREN   : ')' ;
LBRACKET : '[' ;
RBRACKET : ']' ;
COMMA    : ',' ;

//Blocks
COLON    : ':' ;


//Data types
//BOOLEAN has to be above NAME or True/False get read as names
BOOLEAN
    : 'True'
    | 'False'
    ;

// Keywords for conditions.
AND : 'and' ;
OR : 'or' ;
NOT : 'not' ;

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
