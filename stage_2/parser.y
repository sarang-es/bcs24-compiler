%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
void yyerror(const char *s);

extern FILE *tacOut;

static int tempCount = 0;

static char *newTemp(void)
{
    char buffer[32];
    snprintf(buffer, sizeof(buffer), "t%d", ++tempCount);
    char *result = malloc(strlen(buffer) + 1);
    if (result != NULL)
        strcpy(result, buffer);
    return result;
}

static void emitBinary(const char *dest, const char *left, const char *op, const char *right)
{
    if (tacOut != NULL)
        fprintf(tacOut, "%s = %s %s %s\n", dest, left, op, right);
}

static void emitAssign(const char *dest, const char *src)
{
    if (tacOut != NULL)
        fprintf(tacOut, "%s = %s\n", dest, src);
}
%}

%union {
    char *text;
}

%token BCSMAIN
%token INT BOOL
%token IF ELSE WHILE
%token <text> ID NUM
%token LE GE EQ NE LT GT
%token PLUS MULT ASSIGN
%token SEMICOLON
%token LPAREN RPAREN
%token LBRACE RBRACE

%type <text> aexpr term factor

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
      {
          emitAssign($1, $3);
      }
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
      {
          char *t = newTemp();
          emitBinary(t, $1, "+", $3);
          $$ = t;
      }
    | term
      {
          $$ = $1;
      }
    ;

term
    : term MULT factor
      {
          char *t = newTemp();
          emitBinary(t, $1, "*", $3);
          $$ = t;
      }
    | factor
      {
          $$ = $1;
      }
    ;

factor
    : ID
      {
          $$ = $1;
      }
    | NUM
      {
          $$ = $1;
      }
    ;

%%