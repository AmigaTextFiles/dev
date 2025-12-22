/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include "Clown_HEADERS.h"

/* This module is explained in Compiler_main.c
   in the parts where it is used */

/*************************/
int *lineWeight = NULL;
FILE* WL_file = NULL;
FILE* WL_outFile = NULL;
char WL_string[255];
int WL_byte;
int currentLineNumber;
/*************************/

int MapLineWeights(char* filePath, char* filePath2)
{
    /* Open file to be read, file to be written */
    WL_file=fopen(filePath,"r");
    WL_outFile=fopen(filePath2,"w");

    if (WL_file!=NULL && WL_outFile!=NULL)
    {
        /* Read file token by token */
        while (fscanf(WL_file, "%s", WL_string)!=EOF)
        {
            if (strcmp(WL_string,"!ZONE_WEIGHT")==0)
            {
                fscanf(WL_file, "%d", &WL_byte);
                fprintf(WL_outFile," %d ", getLogicObjectScopeWeight(WL_byte));
            }
            else
            {
                if (strcmp(WL_string,"!LINE")==0)
                {
                    fprintf(WL_outFile,"\n");
                }
                fprintf(WL_outFile," %s", WL_string);

            }
        }
        fclose(WL_file);
        fclose(WL_outFile);
        return 1;
    }
    else
    {
        /* Cannot open file */
        printf("[WeighLines] Input/output error\n");
        return 0;
    }
}

int WeighLines(char* filePath)
{
    /* Open file to be read */
    WL_file=fopen(filePath, "r");
    currentLineNumber=0;
    fseek(WL_file,0,SEEK_SET);

    if (WL_file!=NULL)
    {
        /* Read file token by token */
        while (fscanf(WL_file, "%s", WL_string)!=EOF)
        {
            if (strstr(WL_string,"!") && strcmp(WL_string,"!LINE")!=0)
            {
                if (strcmp(WL_string,"!ZONE_WEIGHT")==0)
                {
                    /*
                     * Will be compiled as an actual byte.
                     * Increase counter, skip next token and go on.
                     */
                    lineWeight[currentLineNumber]++;
                }
                else
                {
                    /* Special directive token. Skip next token and go on */
                }
                fscanf(WL_file, "%s", WL_string);
            }
            else
            {
                if (strcmp(WL_string,"!LINE")==0)
                    fscanf(WL_file, "%d", &currentLineNumber);
                else
                    lineWeight[currentLineNumber]++;
            }
        }
        fclose(WL_file);
        return 1;
    }
    else
    {
        /* Cannot open file */
        printf("[WeighLines] Input/output error\n");
        return 0;
    }
}

void WL_SetUp(void)
{
    lineWeight = calloc(MAX_LINE_COUNT, sizeof(int));
}

void WL_CleanUp(void)
{
    free(lineWeight);
}

int getLineWeight(int theLineNumber)
{
    return lineWeight[theLineNumber];
}


