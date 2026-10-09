#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
int yyparse(void);

void yyerror(const char *s)
{
    (void)s;
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

