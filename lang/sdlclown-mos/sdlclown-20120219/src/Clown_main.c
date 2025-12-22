/* === SDL_clown v0.4.0, based on clown v0.2.5 === */

/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

/*
 * Clown is a script interpreter naively written the "wrong" way
 * (no BNF, no stack, no operator precedence implementation,
 * no custom functions) by a young noob programmer, for fun.
 */

#include "Clown_HEADERS.h"

int main(int argc, char* argv[])
{
    int file_num = 0;
    int inputCh = 0;
    char inputStr[1024] = "\n";
    char inputLine[1024];
    int depth = 0;
    int prevInputCh = 0;

    clown_state.argc = argc;
    clown_state.argv = argv;

    /* Validate arguments and argument combinations */
    if(ValidateClownArgs(argc, argv))
    {
        printf("\"%s\" is an invalid option. Type \"sdlclown -h\" for help.\n",
               argv[ValidateClownArgs(argc, argv)]);
        return 0;
    }

    if( (CheckForArg(argc, argv, "-h") && CheckForArg(argc, argv, "-i"))
            || (CheckForArg(argc, argv, "-i") && FileArgs(argc, argv)!=0)
            || (CheckForArg(argc, argv, "-h") && FileArgs(argc, argv)!=0))
    {
        printf("Bad argument combination\n");
        return 0;
    }

    /* Check for help mode */
    clown_state.hflag = CheckForArg(argc, argv, "-h") || CheckForArg(argc, argv, "--help")
                        || CheckForArg(argc, argv, "--version");

    /* Check for interactive mode */
    clown_state.inter = CheckForArg(argc, argv, "-i");

    /* Check for assembly listing mode */
    clown_state.aflag = CheckForArg(argc, argv, "-a");

    if(!clown_state.aflag)
    {
        /* Start SDL stuff */
        if(!StartGraphicsManager())
            return 0;
    }

    /* Initialize clown stuff */
    fastVM_InitializeMemory();
    typeSystem_init();

    if (clown_state.inter)
    {
        /* Interactive mode */

        while (inputCh!=EOF)
        {
            if (depth==0)
            {
                if (!write_intfile(inputStr))
                {
                    printf("Input/output error\n");
                    goto do_quit;	/* clean exit */
                }
                else
                {
                    ClownCompiler_main("interactive_file");
                    remove("interactive_file");

                    if (clown_state.compiler_error)
                    {
                        /* compile failed */
                        goto do_quit;	/* clean exit */
                    }
                }

                sprintf(inputStr, " ");
            }

#ifndef NO_PROMPT
            if(depth==0)
                printf("> ");
            else
                printf("  ");
#endif

            sprintf(inputLine, " \n ");

            inputCh=getchar();

#ifdef DOUBLE_RET_TO_EOF
            if (prevInputCh==inputCh && prevInputCh=='\n')
                inputCh=EOF; /* Double return mapped to EOF */
#endif

            while (inputCh!='\n' && inputCh!=EOF)
            {
                sprintf(inputStr, "%s%c", inputStr, inputCh);
                sprintf(inputLine, "%s%c", inputLine, inputCh);
                inputCh=getchar();
            }

            sprintf(inputLine,"%s\n", inputLine);
            sprintf(inputStr,"%s\n", inputStr);

#ifdef DOUBLE_RET_TO_EOF
            prevInputCh=inputCh;
#endif

            if (strstr(inputLine,"if") || strstr(inputLine,"while"))
                depth++;

            if (strstr(inputLine,"}"))
                depth--;

            if (depth<0)
            {
                printf("Error: bad syntax\n");
                goto do_quit;	/* clean exit */
            }

        }
    }
    else
    {
        if(FileArgs(argc, argv)==0)
            ClownCompiler_main("-");

        if(FileArgs(argc, argv)==1)
            ClownCompiler_main(GetFileArg(argc, argv, 1));

        if(FileArgs(argc, argv) > 1)
        {
            while(++file_num <= FileArgs(argc, argv))
            {
                printf("%s:\n", GetFileArg(argc, argv, file_num));

                ClownCompiler_main(GetFileArg(argc, argv, file_num));

                printf("\n\n");

                /* Reset ClownVM state */
                fastVM_CleanupMemory();
                typeSystem_quit();
                fastVM_InitializeMemory();
                typeSystem_init();
            }
        }
    }

do_quit:

    printf("\n");

    fastVM_CleanupMemory();
    typeSystem_quit();

    if(!clown_state.aflag)
    {
        /* Clean up SDL stuff */
        CloseGraphicsManager();
    }

    return 0;
}



