%{
#include "parser.tab.h"
int yywrap(void)
{
    return 1;
}
%}

%option nounput noinput

%%

"int"       { return INT; }
"bool"      { return BOOL; }
"if"        { return IF; }
"else"      { return ELSE; }
"while"     { return WHILE; }
"BcsMain"   { return BCSMAIN; }

[a-zA-Z][a-zA-Z0-9]*    { return ID; }
[0-9]+                  { return NUM; }

"<="      { return LE; }
">="      { return GE; }
"=="      { return EQ; }
"!="      { return NE; }
"<"       { return LT; }
">"       { return GT; }

"+"       { return PLUS; }
"*"       { return MULT; }
"="       { return ASSIGN; }

";"       { return SEMICOLON; }

"("       { return LPAREN; }
")"       { return RPAREN; }

"{"       { return LBRACE; }
"}"       { return RBRACE; }

[ \t\n]+  { }

%%
