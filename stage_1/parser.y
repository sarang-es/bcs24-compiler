%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
%}

%token BCSMAIN
%token INT BOOL
%token IF ELSE WHILE
%token ID NUM
%token LE GE EQ NE LT GT
%token PLUS MULT ASSIGN
%token SEMICOLON
%token LPAREN RPAREN
%token LBRACE RBRACE


%left PLUS
%left MULT

%%

program
    : BCSMAIN LBRACE declist stmtlist RBRACE
    ;

declist
    : declist decl
    | decl
    ;

decl
    : type ID SEMICOLON
    ;

type
    : INT
    | BOOL
    ;

stmtlist
    : stmtlist SEMICOLON stmt
    | stmt
    ;

stmt
    : ID ASSIGN aexpr
    | IF LPAREN expr RPAREN LBRACE stmtlist RBRACE ELSE LBRACE stmtlist RBRACE
    | WHILE LPAREN expr RPAREN LBRACE stmtlist RBRACE
    ;

expr
    : aexpr relop aexpr
    | aexpr
    ;

relop
    : LT
    | GT
    | LE
    | GE
    | EQ
    | NE
    ;

aexpr
    : aexpr PLUS aexpr
    | term
    ;

term
    : term MULT factor
    | factor
    ;

factor
    : ID
    | NUM
    ;

%%