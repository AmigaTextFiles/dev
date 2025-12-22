/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include "Clown_HEADERS.h"

int write_intfile(char *line)
{
    FILE* intfile = NULL;

    intfile=fopen("interactive_file", "w");

    if (!intfile)
    {
        printf("Error: cannot write to interactive file\n");
        return 0;
    }
    else
    {
        fputs(line, intfile);
        fclose(intfile);
        return 1;
    }
}

