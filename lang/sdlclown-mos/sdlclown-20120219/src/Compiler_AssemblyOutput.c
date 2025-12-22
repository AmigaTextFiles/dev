/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include "Clown_HEADERS.h"

/* Elegantly list the generated ClownVM assembly.
   This function reformats the text slightly and
   prints it out.
 */

int ShowAssemblyCode(FILE* srcFile)
{
    int lineNum=1;
    int firstNewLine;
    char readData[256];
    int dummy;
    int BBKR_reading=1;

    firstNewLine=1;
    fseek(srcFile, 0, SEEK_SET);
    sprintf(readData," ");

    while (BBKR_reading)
    {
        if (fscanf(srcFile,"%s", readData)==EOF)
        {
            BBKR_reading=0;
        }
        else
        {
            if (!stringRepresentsNumeral(readData) && !strstr(readData,"!"))
            {
                /* New instruction & new line */
                if (!firstNewLine)
                    printf("\n");
                else
                    firstNewLine=0;

                printf("@");
            }

            if (strstr(readData,"!"))
            {
                /* Read one token and do nothing */
                fscanf(srcFile,"%d", &dummy);
            }
            else
            {
                if (stringRepresentsNumeral(readData))
                {
                    /* Numbers are opcode parameters */
                    printf(" ");
                }

                printf("%s", readData);
            }

            lineNum++;
        }
    }

    printf("\n");
    return 1;
}


