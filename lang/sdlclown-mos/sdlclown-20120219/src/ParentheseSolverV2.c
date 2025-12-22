/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include "Clown_HEADERS.h"

/*
   This function "unwinds" parenthesized
   expressions - for example, "x = 2/(3 *(4+5))"
   yields

    PS_EXP1 = 4+5
    !VIRTUAL_LINE
    PS_EXP2 = 3 * PS_EXP1
    !VIRTUAL_LINE
    x = 2/ PS_EXP2
*/

char* ClownSolveParentheses(char* theString)
{
    int i;
    int exp_num = 0;
    static char outputString[3000];
    static char buffer[3000];
    static char buffer2[3000];
    char isolatedExp[3000];

    *buffer = '\0';
    *outputString = '\0';
    *buffer2 = '\0';

    i = 0;
    while(theString[i]!='\0')
    {
        if(theString[i]==']')
            strcat(buffer2, ")");
        sprintf(buffer2, "%s%c", buffer2, theString[i]);
        if(theString[i]=='[')
            strcat(buffer2, "(");
        i++;
    }

    if(strstr(buffer2, "print") || strstr(buffer2, "printIn"))
        strcpy(buffer2, KeepInsideQuotes(buffer2));

    strcpy(buffer, buffer2);

    while(strstr(buffer, "(") && strstr(buffer, ")"))
    {
        *buffer2 = '\0';
        *isolatedExp = '\0';

        i = 0;

        while(i<getLatestOpenParenthese(buffer))
            sprintf(buffer2, "%s%c", buffer2, buffer[i++]);

        if(buffer2[strlen(buffer2)-1]!='[')
            strcat(buffer2, " ");

        sprintf(buffer2, "%sPS_EXP%d", buffer2, exp_num+1);

        while(buffer[++i]!=')')
            sprintf(isolatedExp, "%s%c", isolatedExp, buffer[i]);

        while(buffer[++i]!='\0')
            sprintf(buffer2, "%s%c", buffer2, buffer[i]);

        sprintf(outputString, "%s PS_EXP%d = %s \n!VIRTUAL_LINE \n", outputString, ++exp_num, isolatedExp);

        if(!(strstr(buffer2, "(") && strstr(buffer2, ")")))
        {
            if(strstr(theString, "print"))
            {
                if(strstr(theString, "printIn"))
                    sprintf(outputString, "%s printIn \" %s \" \n", outputString, buffer2);
                else
                    sprintf(outputString, "%s print \" %s \" \n", outputString, buffer2);
            }
            else
            {
                sprintf(outputString, "%s%s\n", outputString, buffer2);
            }
        }
        strcpy(buffer, buffer2);
    }

    return (char*)outputString;
}

/* Follow utilities meant to generalise
   certain tasks used in the above
   function */

int CountParenthesePairs(char *input)
{
    int i = 0;
    int j = 0;

    for(; i<=strlen(input); i++)
        j += (input[i]=='(') | (input[i]==')');

    return (j/2)*((j%2)==0);
}

char* KeepInsideQuotes(char *input)
{
    int i = 0;
    int j = 0;
    static char KIQ_Output[1024];

    while(i<=strlen(input) && input[i]!='"')
        i++;

    for(i++; i<=strlen(input) && input[i]!='"'; i++)
        KIQ_Output[j++]=input[i];

    KIQ_Output[j] = '\0';

    return (char*)KIQ_Output;
}

int getLatestOpenParenthese(char* s)
{
    int i = 0;
    int j = 0;

    while(*s++ && ++i)
        if(*s=='(')
            j = i;

    return j;
}



