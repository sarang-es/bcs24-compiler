%{
#include "parser.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yywrap(void)
{
    return 1;
}

static char *copyText(const char *s)
{
    char *p = malloc(strlen(s) + 1);
    if (p != NULL)
        strcpy(p, s);
    return p;
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

[a-zA-Z][a-zA-Z0-9]* {
    yylval.text = copyText(yytext);
    return ID;
}

[0-9]+ {
    yylval.text = copyText(yytext);
    return NUM;
}

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

[ \t\r\n]+  { }

.         { return yytext[0]; }

%%
