#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
FILE *tacOut = NULL;

int yyparse(void);

void yyerror(const char *s)
{
    (void)s;
    printf("Syntax Error\n");
}

int main(int argc, char *argv[])
{
    if (argc < 2)
    {
        printf("Usage: %s <input-file> [output-file]\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (file == NULL)
    {
        printf("Cannot open input file: %s\n", argv[1]);
        return 1;
    }
    yyin = file;

    const char *outputFilename = (argc >= 3) ? argv[2] : "output.txt";
    tacOut = fopen(outputFilename, "w");
    if (tacOut == NULL)
    {
        printf("Cannot open output file: %s\n", outputFilename);
        fclose(file);
        return 1;
    }

    if (yyparse() == 0)
    {
        printf("Parsing Successful\n");
        printf("Three-Address Code written to %s\n", outputFilename);
    }

    fclose(tacOut);
    fclose(file);

    return 0;
}

