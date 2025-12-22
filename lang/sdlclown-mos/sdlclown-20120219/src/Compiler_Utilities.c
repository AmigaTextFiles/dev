/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include "Clown_HEADERS.h"

/* A bunch of utilities used by the
   various ClownModules. Mostly
   string manipulation. */

/*************************/
char myWorkString[256];
int theStringLength;
int currentCharacter;
int response;
int checkLoop;
/*************************/

/* Occurences of a character in a string
   (does it exist in the C standard library ?) */
int countCharInString(char theChar, char* theString)
{
    int i = 0;
    int j = 0;

    while(i<strlen(theString))
        j += theString[i++]==theChar;

    return j;
}

char* getArrayContentsName(char* arrayString)
{
    /*
     * For a string with the syntax "arrayName[contents]",
     * returns "contents"
     */
    char* pointerOut;
    int i;
    int j;
    int level;

    i = 0;
    j = 0;
    level = 0;

    while(i<strlen(arrayString))
    {
        if(arrayString[i]==']')
            level--;
        if(level)
            myWorkString[j++] = arrayString[i];
        if(arrayString[i++]=='[')
            level++;
    }

    myWorkString[j] = '\0';

    pointerOut = myWorkString;
    return pointerOut;
}

char* getArrayName(char* arrayString)
{
    /*
     * For a string with the syntax "arrayName[contents]",
     * returns "arrayName"
     */
    char* pointerOut;
    int i;
    int j;
    int level;

    i = 0;
    j = 0;
    level = 1;

    while(i<strlen(arrayString))
    {
        if(arrayString[i]=='[')
            level--;
        if(level)
            myWorkString[j++] = arrayString[i];
        i++;
    }

    myWorkString[j] = '\0';

    pointerOut = myWorkString;
    return pointerOut;
}


int ValidateVariableName(char* theVariableName)
{
    if (strcmp(theVariableName, "if")==0 || strcmp(theVariableName, "while")==0
            || strstr(theVariableName, "[") || strstr(theVariableName, "]")
            || strstr(theVariableName, "{") || strstr(theVariableName, "}")
            || strstr(theVariableName, "!") || strcmp(theVariableName, "int")==0
            || strstr(theVariableName, "#") || strstr(theVariableName, "%")
            || strstr(theVariableName, "array") || stringRepresentsInteger(theVariableName)
            || strstr(theVariableName, "print") || strstr(theVariableName, "\"") || strstr(theVariableName, "input")
            || strstr(theVariableName, "+") || strstr(theVariableName, "-") || strstr(theVariableName, "*")
            || strstr(theVariableName, "/") || strstr(theVariableName, "&") || strstr(theVariableName, "|")
            || strstr(theVariableName, "%"))
    {
        return 0;
    }
    else
    {
        return 1;
    }
}

char* int2char(int theInteger)
{
    char* pointerOut;
    sprintf(myWorkString, "%d", theInteger);
    pointerOut=myWorkString;
    return pointerOut;
}

void CopyFile(char* pathIn, char* pathOut)
{
    FILE* myFileIn = NULL;
    FILE* myFileOut = NULL;
    int byte;
    int doLoop;
    myFileOut=fopen(pathOut,"wb");
    myFileIn=fopen(pathIn,"rb");
    byte=0;
    doLoop=1;
    if (myFileIn!=NULL && myFileOut!=NULL)
    {
        while (doLoop)
        {
            byte=fgetc(myFileIn);
            if (byte==EOF)
            {
                doLoop=0;
            }
            else
            {
                fputc(byte, myFileOut);
            }
        }
        fclose(myFileIn);
        fclose(myFileOut);
    }
    else
    {
        printf("CopyFile(%s, %s) failed !\n", pathIn, pathOut);
    }
}

int stringRepresentsInteger(char* theString)
{
    response=1;
    currentCharacter=0;

    while (currentCharacter<strlen(theString) && response)
        if (!(theString[currentCharacter]>='0' && theString[currentCharacter++]<='9'))
            response=0;

    return response;
}

int stringRepresentsNumeral(char* theString)
{
    int dots = 0;

    response=1;		/* AUTO_INT -> 1 */
    currentCharacter= -1;

    if(*theString=='-')
    {
        ++currentCharacter;
        if(!*(theString+1))	return 0;
    }

    while (++currentCharacter<strlen(theString) && response)
        if (! ((theString[currentCharacter]>='0' && theString[currentCharacter]<='9')
                || (theString[currentCharacter]=='.' && ++dots<2)))
            response=0;

    if(response && dots)
        response = 2;		/* AUTO_FLOAT -> 2 */

    return response;
}

int char2int(char *fChar)
{
    int i;
    sscanf(fChar, "%d", &i);
    return i;
}

float char2float(char* fChar)
{
    float f;
    sscanf(fChar, "%f", &f);
    return f;
}

void neat_print(char* buf)
{
    /*
     * neatly print string representation of
     * floating-point number, removing
     * trailing zeroes and the decimal
     * dot if it is not necessary
     */

    char* p = buf + strlen(buf);

    while(p-->buf && *p=='0') *p = 0;
    if(*p=='.') *p = 0;

    printf("%s", buf);
}


