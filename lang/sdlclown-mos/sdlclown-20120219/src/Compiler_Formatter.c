/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include "Clown_HEADERS.h"

/*
 * This sourcefile contains multiple passes that
 * convert the source file's very free syntax
 * to a the compiler's internal syntax conventions.
 * It is essentially a bunch of hacky string
 * manipulation meant to make Compiler_main.c's
 * job easier and its code simpler.
 */

/***********************************/
int quotationMarks = 0;
char NewWord[1024];
int nest_type[2000] = {0};
char lastWhileLoopCode[2000][1024];
int i, j, k, l, m, n, o;
int inlineExpressionRefID = 0;
char outputFinal[1024];
char out[1];
void* outPointer = &out;
int DynExpCount;
int putWord = 0;
/***********************************/

int ReformatSource(char* inputFile, char* outputFile)
{
    FILE* input = NULL;
    FILE* output = NULL;
    char word[1024];
    int currentLine;
    int commentMode;
    int dummy = 0;
    int nestedness = 0;

    /* Unwind parenthesized expressions, detect syntax errors relating to this */

    if(strcmp(inputFile, "-")==0)
        input = stdin;
    else
        input=fopen(inputFile,"r");

    output=fopen("parentheses_pass.tmp","w");

    currentLine = 0;

    if (input!=NULL && output!=NULL)
    {
        while (fgets(word, 1024, input)!=NULL)
        {

            if(!strstr(word,"//") && CountParenthesePairs(word)==0 && (strstr(word, "(") || strstr(word, ")")))
            {
                printf("Error: unbalanced parentheses\n");
                printf(">> %s", word);

                fclose(input);
                fclose(output);
                return 0;
            }

            fprintf(output, " !LINE %d\n", ++currentLine);

            if(strstr(word, "while"))
                fputs(" !WHILE_LOOPCODE_START \n", output);

            if(!strstr(word, "//") && !strstr(word, "input")
                    && !strstr(word, "array") && !( ( CountParenthesePairs(word)<=1 && !strstr(word,"[") ) && strstr(word, "print"))
                    && (strstr(word, "(") || strstr(word, "[")))
            {
                fputs(ClownSolveParentheses(word), output);
            }
            else
            {
                fputs(word, output);
            }
        }

        fclose(input);
        fclose(output);

    }
    else
    {
        if(input==NULL)
        {
            printf("Error: could not open file '%s'\n", inputFile);
        }
        else
        {
            printf("Error: could not create temporary file");
        }
        return 0;
    }

    /* Remove full-line comments, reformat assembly commands */

    input=fopen("parentheses_pass.tmp","r");
    output=fopen("formatter_step0.tmp","w");

    if (input!=NULL && output!=NULL)
    {
        while (fgets(word, 1024, input)!=NULL)
        {
            /* Detect C++ style single-line comment and shebang */
            commentMode = (strstr(word,"//") || strstr(word,"#!"));

            if (commentMode==0)
            {
                if (strstr(word,"@"))
                {
                    /* Assembly instruction */
                    fputs("BBK [ ", output);
                    fputs(word, output);
                    fputs(" ] ", output);
                }
                else
                {
                    /* Write line unchanged */
                    fputs(word, output);
                }
            }

            currentLine++;
        }
        fclose(input);
        fclose(output);
    }
    else
    {
        printf("Error: cannot read/write temporary files\n");
        return 0;
    }

    /* Tokenize using reformatString() */

    input=fopen("formatter_step0.tmp","r");
    output=fopen("formatter_stepA.tmp","w");

    if (input!=NULL && output!=NULL)
    {

        while (fscanf(input, "%s", word)!=EOF)
        {
            if(!strstr(word, "!WHILE_LOOPCODE_START") && !strstr(word, "!LINE") && !strstr(word, "!VIRTUAL_LINE"))
            {
                if(strcmp(word, "while")==0)
                    fprintf(output, "!WHILE_LOOPCODE_END");
                fprintf(output, " %s ", reformatString(word));
            }
            else
            {
                fprintf(output, "\n %s ", word);
            }
        }

        fclose(input);
        fclose(output);
        remove("formatter_step0.tmp");
    }
    else
    {
        printf("Error: cannot read/write temporary files\n");
        return 0;
    }

    /*
     * This creates iteration code for while loops.
     *
     * This code, for example:
     *     while(x++<5)
     *	   {
     *		echo x;
     *	   }
     *
     * Is compiled to these pseudo-instructions:
     *     condition = (x++<5)
     *     store program counter to X
     *     if(condition)
     *     {
     *           echo x;
     *           condition = (x++<5)
     *           load program counter from X
     *     }
     *
     * This specific part of the formatter copies the
     * "x++<5" to the bottom of the generated "if" block.
     */

    input=fopen("formatter_stepA.tmp","r");
    output=fopen(outputFile,"w");

    memset(nest_type, 0, sizeof(int) * 2000);

    quotationMarks = 0;

    if (input!=NULL && output!=NULL)
    {
        while (fscanf(input, "%s", word)!=EOF)
        {
            if(strcmp(word,"\"")==0)
                quotationMarks = !quotationMarks;

            putWord = 0;

            if(!quotationMarks)
            {
                nestedness += (strcmp(word, "while")==0 || strcmp(word, "if")==0) - (strcmp(word, "}")==0);

                if(strcmp(word, "while")==0)
                    nest_type[nestedness-1]=1;

                if(strcmp(word, "if")==0)
                    nest_type[nestedness-1]=0;

                if(strcmp(word, "}")==0 && nest_type[nestedness]==1)
                    fprintf(output, " %s \n", lastWhileLoopCode[nestedness]);

            }

            if(strcmp(word, "!WHILE_LOOPCODE_START")==0)
            {
                sprintf(lastWhileLoopCode[nestedness], " ");
                while (fscanf(input, "%s", word)!=EOF)
                {
                    putWord=0;

                    if(strcmp(word, "!VIRTUAL_LINE")==0)
                    {
                        fprintf(output, "\n !VIRTUAL_LINE ");
                    }

                    if(strcmp(word, "!LINE")==0)
                    {
                        fscanf(input, "%d %s", &dummy, word);
                        fprintf(output, "\n !LINE %d ", dummy);
                    }

                    if(strcmp(word, "!WHILE_LOOPCODE_END")==0)
                    {
                        sprintf(word, " ");
                        break;
                    }

                    strcat(lastWhileLoopCode[nestedness], " ");
                    strcat(lastWhileLoopCode[nestedness], word);
                    strcat(lastWhileLoopCode[nestedness], " ");

                    if(!putWord)
                    {
                        if(strcmp(word, "!LINE")==0)
                            fprintf(output, "\n");
                        if(strcmp(word, "!VIRTUAL_LINE")==0)
                            fprintf(output, "\n");
                        fprintf(output, " %s ", word);
                        putWord=1;
                    }
                }

                if(!putWord)
                {
                    if(strcmp(word, "!LINE")==0)
                        fprintf(output, "\n");
                    if(strcmp(word, "!VIRTUAL_LINE")==0)
                        fprintf(output, "\n");
                    fprintf(output, " %s ", word);
                    putWord=1;
                }
            }

            if(!putWord)
            {
                if(strcmp(word, "!LINE")==0)
                    fprintf(output, "\n");
                if(strcmp(word, "!VIRTUAL_LINE")==0)
                    fprintf(output, "\n");
                fprintf(output, " %s ", word);
                putWord=1;
            }
        }

        fclose(input);
        fclose(output);
        remove("formatter_stepA.tmp");
        return 1;
    }
    else
    {
        printf("Error: cannot read/write temporary files\n");
        return 0;
    }
}

/*
 * "Tokenizer" function.
 *
 * For example, "x=1+1" becomes "x = 1 + 1"
 * so that the compiler can read the program
 * token-by-token by using scanf(). Nasty
 * hand-written implementation from circa 2009,
 * when I had even fewer "skills". The complexity
 * comes from the fact that certain operators have
 * a first character in common (i. e., "=" and "==").
 */
char* reformatString(char theString[])
{
    char* pointerOut;
    char outputString[1024];
    int currentChar;
    int spaceAdded;
    int specialCase;
    currentChar=0;
    specialCase=0;
    sprintf(outputString," ");

    while (currentChar<strlen(theString))
    {
        if(theString[currentChar]=='"')
            quotationMarks = !quotationMarks;

        spaceAdded=0;
        if (quotationMarks==0 &&
                (  theString[currentChar]==';'
                   || theString[currentChar]==':'
                   || theString[currentChar]=='('
                   || theString[currentChar]==')'
                   || theString[currentChar]=='{'
                   || theString[currentChar]=='@'	/* Assembly instruction */
                   || theString[currentChar]==','))
        {
            /* Remove ";", "(", ")", "{", ",", "@" from output */
            if (theString[currentChar]=='('
                    || theString[currentChar]==')'
                    || theString[currentChar]=='{'
                    || theString[currentChar]==',')
            {
                sprintf(outputString, "%s ", outputString);
            }
        }
        else
        {
            if (theString[currentChar]=='='
                    && theString[currentChar+1]!='=')
            {
                spaceAdded=1;
                if (!specialCase)
                {
                    sprintf(outputString,"%s %c ", outputString, theString[currentChar]);
                }
                else
                {
                    sprintf(outputString,"%s%c ", outputString, theString[currentChar]);
                }
                specialCase=0;
            }

            if (( (theString[currentChar]=='+' && quotationMarks==0)
                    || (theString[currentChar]=='-' && quotationMarks==0)
                    ||  theString[currentChar]=='%'
                    || (theString[currentChar]=='*' && quotationMarks==0)
                    || theString[currentChar]=='"'
                    || (theString[currentChar]=='>' && quotationMarks==0)
                    || (theString[currentChar]=='<' && quotationMarks==0)
                    || (theString[currentChar]=='!' && quotationMarks==0)
                    || (theString[currentChar]=='=' && quotationMarks==0)
                    || (theString[currentChar]=='|' && quotationMarks==0)
                    || (theString[currentChar]=='&' && quotationMarks==0)
                    || (theString[currentChar]=='/' && quotationMarks==0))
                    && !spaceAdded)
            {
                spaceAdded=1;
                if (theString[currentChar+1]!='=')
                {
                    sprintf(outputString,"%s %c ", outputString, theString[currentChar]);
                    specialCase=0;
                }
                else
                {
                    /* Special case : for expressions "+=", "-=", "*=", "/=", "%=", "&=", "|=" */
                    sprintf(outputString,"%s %c", outputString, theString[currentChar]);
                    specialCase=1;
                }

                if (theString[currentChar]=='"'
                        && theString[currentChar+1]=='=')
                {
                    sprintf(outputString, "%s ", outputString);
                }

            }

            if (!spaceAdded)
            {
                sprintf(outputString,"%s%c", outputString, theString[currentChar]);
                specialCase=0;
            }

        }

        currentChar++;
    }

    sprintf(outputFinal,"%s",outputString);
    pointerOut=outputFinal;
    return pointerOut;
}


