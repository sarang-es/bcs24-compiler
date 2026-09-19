%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
void yyerror(const char *s);
extern FILE *yyin;
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

void yyerror(const char *s)
{
    printf("Syntax Error\n");
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: %s <input-file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");

    if (file == NULL)
    {
        printf("Cannot open input file\n");
        return 1;
    }

    yyin = file;

    if (yyparse() == 0)
    {
        printf("Parsing Successful\n");
    }

    fclose(file);

    return 0;
}