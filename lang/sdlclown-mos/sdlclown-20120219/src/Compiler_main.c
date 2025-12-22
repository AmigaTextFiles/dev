/* === SDL_clown v0.3.5, based on clown v0.2.5 === */

/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include <assert.h>
#include "Clown_HEADERS.h"

/* The compiler core, which does the most
   important and interesting work */

/* macros used to eliminate redundant code */
#include "Compiler_TypicalBinaryOp.h"
#include "Compiler_TypicalSubExp.h"

/*******************************************************/
FILE* source = NULL;
FILE* binary = NULL;
FILE* phase_output = NULL;

char line[1024];
char word[128];
char param[128];
char myOutput[1024];

int sub_exp_adr;

int address_of_last_variable_name = 0;
int param2, param3, parsed, test, allocated_variable_memory;
int compiling = 1;

int TemporaryData1, TemporaryData2, TemporaryData3,
    TemporaryData4, TemporaryData5, TemporaryData6;

int testVar = 0;
char hack[256];
int c, prevC;
int currentSourceLine = 0;
int compileFailed = 0;
char theSourceFile[1024];

/* storage for "logic objects" : IF and WHILE statements */
int logicObjectID;
int* logic_WaitingForClose = NULL;
int* logic_NestLevel = NULL;
int* logic_StartLine = NULL;
int* logic_CloseLine = NULL;
int* logic_Weight = NULL;
int* logic_ObjectType = NULL;   /* IF or WHILE */
int* logic_LoopAddress = NULL;	/* For WHILE statements */

int currentLogicNest = 0;

int consecutive_special_tokens = 0;

int postOp_arg = 0;
/*******************************************************/

int ClownCompiler_main (char* input_filename)
{
    clown_state.compiler_error = 0;

    /* Initialize a few modules */
    assert(SetUpLogicEngine());
    assert(Dictionary_Init());
    WL_SetUp();

    /* If in interactive mode,
       retrieve the session's symbol
       dictionary */
    if (clown_state.inter)
        RetrieveBackedUpStringTable();
    else
        allocated_variable_memory = 0;

    /* "-h" option: output program info and usage */
    if(clown_state.hflag)
    {
        printf("\n SDL_Clown Script Interpreter\n %s (%s) \n Copyright %s, %s\n\n",
               CLOWN_VERSION,
               CLOWN_BUILDDATE,
               CLOWN_DATE,
               CLOWN_AUTHOR);
        printf(" Use : sdlclown [file [...]] [-i] [-h] [-a]\n");
    }
    else
    {
        /* Convert source to compiler internal format */
        if (!ReformatSource(input_filename, "formatted_source.tmp"))
            goto do_quit;

        /* Open formatted source (compiler input) */
        source=fopen("formatted_source.tmp", "r");

        /* Open compiler output */
        phase_output = fopen("ClownLinkFile", "w");

        if (source==NULL || phase_output==NULL)
        {
            printf("The compiler encountered an input/output error.\n");
        }
        else
        {
            currentSourceLine = 0;
            logicObjectID = 0;
            compiling = 1;
            compileFailed = 0;

            /* Run main parsing loop */
            while (fscanf(source, "%s", word)!=EOF && compiling)
            {
                parsed=0;

                if (allocated_variable_memory>MEMORY_QTY)
                {
                    printf("Error: out of variable/array space\n");
                    compiling = 0;
                }

                /* ====================================================================================== */

                if (strcmp(word,"input")==0)
                {
                    parsed=1;
                    fscanf(source,"%s", param);

                    /* check if parameter is an existant valid variable name */
                    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(param))
                            && Dictionary_EntryType(Dictionary_FetchEntry(param))==TYPE_VARIABLE)
                    {
                        fprintf(phase_output, "InputInt %d\n",
                                Dictionary_EntryValue(Dictionary_FetchEntry(param)));
                    }
                    else
                    {
                        printf("Error: unknown variable '%s' (line %d)\n",
                               param,
                               currentSourceLine);
                        compiling = 0;
                    }
                }

                /* ====================================================================================== */

                if (strcmp(word,"print")==0 || strcmp(word,"printIn")==0)
                {
                    parsed=1;

                    TemporaryData4=1;
                    TemporaryData5=1;
                    TemporaryData6=0;

                    fscanf(source,"%s", param);

                    if (strcmp(param,"\"")==0)
                    {
                        while (TemporaryData5)
                        {
                            param2=fgetc(source);
                            if (param2!='"')
                            {
                                if (param2=='%')
                                {
                                    fscanf(source, "%s", param);
                                    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(param))
                                            && Dictionary_EntryType(Dictionary_FetchEntry(param))==TYPE_VARIABLE)
                                    {
                                        fprintf(phase_output, "Echo %d\n",
                                                Dictionary_EntryValue(Dictionary_FetchEntry(param)));
                                        TemporaryData6=0;
                                    }
                                    else
                                    {
                                        printf("Error: unknown variable '%s' (line %d)\n",
                                               param,
                                               currentSourceLine);
                                        parsed=0;
                                    }
                                }
                                else
                                {
                                    if (TemporaryData4==1)
                                    {
                                        TemporaryData4=0;	/* First character is superflous space */
                                    }
                                    else
                                    {
                                        if (param2==' ' && TemporaryData6==1)
                                        {
                                            /* Skip superflous double
                                             spaces generated by formatter... */
                                        }
                                        else
                                        {
                                            fprintf(phase_output, "PutChar %d\n", param2);
                                        }
                                    }
                                    if (param2==' ')
                                    {
                                        TemporaryData6=1;
                                    }
                                    else
                                    {
                                        TemporaryData6=0;
                                    }
                                }
                            }
                            else
                            {
                                TemporaryData5=0;
                            }
                        }

                        parsed=1;

                        if (strcmp(word,"print")==0)
                            fprintf(phase_output, "NewLine\n");		/* print statement -> vm will output newline */
                    }
                    else
                    {
                        printf("Error: illegal syntax in print() statement (line %d)\n",
                               currentSourceLine);
                        parsed=0;
                    }
                }

                /* ====================================================================================== */

                if (strcmp(word,"BBK")==0) 		/* ClownVM assembly (undocumented !) */
                {
                    fscanf(source,"%s", param);
                    if (strcmp(param,"[")==0)
                    {
                        parsed=1;
                        TemporaryData1=1;
                        while (1)
                        {
                            fscanf(source,"%s", param);
                            if (strcmp(param,"]")==0)
                            {
                                fprintf(phase_output, "\n");
                                break;
                            }
                            else
                            {
                                if (!stringRepresentsInteger(param)
                                        && Dictionary_isLegalEntry(Dictionary_FetchEntry(param)))
                                {
                                    /* Map variable names to their compiled addresses */
                                    fprintf(phase_output, " %d",
                                            Dictionary_EntryValue(Dictionary_FetchEntry(param)));
                                }
                                else
                                {
                                    /* Add spaces at the beggining of tokens following the first */
                                    if (TemporaryData1)
                                    {
                                        /* First token */
                                        fprintf(phase_output, "%s", param);
                                        TemporaryData1=0;
                                    }
                                    else
                                    {
                                        /* Subsequent tokens */
                                        fprintf(phase_output, " %s", param);
                                    }
                                }
                            }
                        }
                    }
                    parsed=1;
                }

                /* ====================================================================================== */

                if (strcmp(word,"if")==0)
                {
                    fscanf(source,"%s", param); 	/* read expression variable */

                    /* check expression variable validity */
                    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(param))
                            && Dictionary_EntryType(Dictionary_FetchEntry(param))==TYPE_VARIABLE)
                    {

                        /* We've got a valid "if" statement */
                        parsed=1;

                        logicObjectID++;

                        TemporaryData1=Dictionary_EntryValue(Dictionary_FetchEntry(param));

                        /* store size (bytes) of bytecode within this IF/WHILE to #255 */
                        fprintf(phase_output, "Do 255 10 1 !ZONE_WEIGHT %d\n", logicObjectID);

                        /* makes #254 equal to zero */
                        fprintf(phase_output, "Do 254 10 1 0\n");

                        /* subtract expression's value from #254 */
                        fprintf(phase_output, "Do 254 30 2 %d\n", TemporaryData1);

                        /* add one to #254 */
                        fprintf(phase_output, "Do 254 20 1 1\n");

                        /* if #254 exceeds 0, jump by (#255) bytes */
                        fprintf(phase_output, "zbPtrTo 254 0 255\n");

                        currentLogicNest++;

                        /* This if/while is waiting to be matched to a '}' */
                        logic_WaitingForClose[logicObjectID]=1;

                        logic_StartLine[logicObjectID]=currentSourceLine+1;
                        logic_NestLevel[logicObjectID]=currentLogicNest;

                        logic_ObjectType[logicObjectID]=L_IF_STATEMENT;
                    }
                }

                /* ====================================================================================== */

                if (strcmp(word,"while")==0)
                {
                    /* get expression variable */
                    fscanf(source,"%s", param);

                    /* check expression variable validity */
                    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(param))
                            && Dictionary_EntryType(Dictionary_FetchEntry(param))==TYPE_VARIABLE)
                    {

                        TemporaryData1=Dictionary_EntryValue(Dictionary_FetchEntry(param));

                        /* we've got a valid "while" */
                        parsed=1;

                        logicObjectID++;

                        /*
                         * Create loop start point for WHILE
                         * more looping code is implemented in '}' parser
                         */

                        allocated_variable_memory = AllocateMoreProgramMemory();
                        Dictionary_CreateEntry("{COMPILER.RESERVED}", allocated_variable_memory, TYPE_VARIABLE);
                        logic_LoopAddress[logicObjectID]=allocated_variable_memory;
                        fprintf(phase_output, "PtrTo %d\n", allocated_variable_memory);

                        /* store size (bytes) of bytecode within this IF/WHILE to #255 */
                        fprintf(phase_output, "Do 255 10 1 !ZONE_WEIGHT %d\n", logicObjectID);

                        /* make #254 equal to zero */
                        fprintf(phase_output, "Do 254 10 1 0\n");

                        /* subtract expression value from #254 */
                        fprintf(phase_output, "Do 254 30 2 %d\n", TemporaryData1);

                        /* add one to #254 */
                        fprintf(phase_output, "Do 254 20 1 1\n");

                        /* if #254 exceeds 0, jump by (#255) bytes */
                        fprintf(phase_output, "zbPtrTo 254 0 255\n");

                        currentLogicNest++;

                        /* This IF/WHILE is waiting to be matched to a '}' */
                        logic_WaitingForClose[logicObjectID]=1;
                        logic_StartLine[logicObjectID]=currentSourceLine+1;
                        logic_NestLevel[logicObjectID]=currentLogicNest;

                        logic_ObjectType[logicObjectID]=L_WHILE_STATEMENT;

                    }
                }

                /* ====================================================================================== */

                if (strcmp(word,"}")==0)
                {
                    parsed=1;

                    TemporaryData5=0;
                    TemporaryData1=0;

                    while (TemporaryData1<logicObjectID+1)
                    {
                        if (logic_WaitingForClose[TemporaryData1] &&
                                logic_NestLevel[TemporaryData1]==currentLogicNest)
                        {
                            /*
                             * A currently unclosed IF/WHILE occured at current depth level,
                             * we can now match it to this "}" and close it
                             */
                            logic_WaitingForClose[TemporaryData1]=0;		/* close the if/while */
                            logic_CloseLine[TemporaryData1]=currentSourceLine;	/* store close-line */
                            TemporaryData5=1;			/* Remember that a match has been found */
                            TemporaryData6=TemporaryData1;	/* Store ID of matched IF/WHILE */
                            break;
                        }
                        TemporaryData1++;
                    }

                    currentLogicNest--;

                    if (!TemporaryData5)
                    {
                        /* No match found for this "}" : script syntax error */
                        compiling = 0;
                        printf("Error: unmatched '}' (line %d)\n",
                               currentSourceLine);
                    }

                    if (TemporaryData5 && logic_ObjectType[TemporaryData6]==L_WHILE_STATEMENT)
                    {
                        /* Write looping code for WHILEs */
                        fprintf(phase_output, "PtrFrom %d\n", logic_LoopAddress[TemporaryData6]);
                    }
                }

                /* ====================================================================================== */

                if (strcmp(word,"int")==0) 	  /* Declaring a variable */
                {

                    fscanf(source,"%s", param);     /* Read variable name */

                    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(param))
                            && Dictionary_EntryType(Dictionary_FetchEntry(param))==TYPE_VARIABLE)
                    {
                        /* Already exists */
                        printf("Error: multiple declarations of variable or array '%s' (line %d)\n",
                               param,
                               currentSourceLine);
                    }
                    else
                    {
                        if (ValidateVariableName(param))
                        {
                            /* Create the variable */
                            allocated_variable_memory = AllocateMoreProgramMemory();
                            Dictionary_CreateEntry(param, allocated_variable_memory, TYPE_VARIABLE);
                            address_of_last_variable_name=allocated_variable_memory;
                            parsed=1;
                        }
                        else
                        {
                            printf("Error: invalid variable name '%s' (line %d)\n",
                                   param,
                                   currentSourceLine);
                        }
                    }

                }

                /* ====================================================================================== */

                if (strcmp(word,"array")==0) 	    /* Array declaration */
                {

                    fscanf(source,"%s", param);     /* Get the array name */
                    fscanf(source, "%s", word);     /* Get array size */

                    if (strstr(param, "[") || strstr(word, "["))
                    {
                        printf("Error: bad array declaration (line %d)\n",
                               currentSourceLine);
                        compiling=0;
                    }
                    else if (!stringRepresentsInteger(word) && !strstr(param, "[") && !strstr(word, "["))
                    {
                        printf("Error: bad array declaration (line %d)\n",
                               currentSourceLine);
                        compiling=0;
                    }
                    else
                    {
                        TemporaryData2 = char2int(word);	/* convert array size param to integer */
                    }

                    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(param))
                            && Dictionary_EntryType(Dictionary_FetchEntry(param))==TYPE_VARIABLE)
                    {
                        /* Already exists */
                        printf("Error: multiple declarations of array or variable '%s' (line %d)\n",
                               param,
                               currentSourceLine);
                        compiling=0;
                    }
                    else
                    {
                        if (ValidateVariableName(param))
                        {
                            /* Create the array */
                            allocated_variable_memory = AllocateMoreProgramMemory();
                            Dictionary_CreateEntry(param, allocated_variable_memory, TYPE_VARIABLE);
                            TemporaryData1=0;
                            parsed=1;

                            /* individually allocate cells */
                            while (TemporaryData1<=TemporaryData2)
                            {
                                allocated_variable_memory = AllocateMoreProgramMemory();
                                TemporaryData1++;
                            }
                        }
                        else
                        {
                            printf("Error: invalid variable name '%s' (line %d)\n",
                                   param,
                                   currentSourceLine);
                        }
                    }

                }

                /* ====================================================================================== */

                if (strcmp(word,"Echo")==0 || strcmp(word, "echo")==0)
                {
                    parsed=1;

                    fscanf(source,"%s", param);     /* Get variable name */

                    /* check if the variable name is valid */
                    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(param))
                            && Dictionary_EntryType(Dictionary_FetchEntry(param))==TYPE_VARIABLE)
                    {
                        /* The variable actually exists, generate the code */
                        fprintf(phase_output, "Echo %d\nNewLine\n", Dictionary_EntryValue(Dictionary_FetchEntry(param)));
                    }
                    else
                    {
                        /* Undefined or wrong-typed variable */
                        printf("Error: '%s' is not a valid parameter of Echo (line %d)\n",
                               param,
                               currentSourceLine);
                        compiling = 0;
                    }
                }

                /* ====================================================================================== */

                if (strcmp(word,"end")==0)
                {
                    /* End of script indicator */
                    parsed=1;
                    compiling=0;
                    fprintf(phase_output, "End\n");
                }

                /* ====================================================================================== */

                if (strcmp(word,"!LINE")==0) 		/* Line directives create by preprocessor/formatter */
                {
                    parsed=1;
                    fscanf(source,"%d", &TemporaryData6);

                    currentSourceLine=TemporaryData6;

                    fprintf(phase_output, "!LINE %d\n", currentSourceLine);

                    /* "forget" variables mentioned on other lines */
                    address_of_last_variable_name = 0;
                    postOp_arg = 0;
                }

                /* ====================================================================================== */

                if (strcmp(word,"!VIRTUAL_LINE")==0)    /* Special indicator added by formatter */
                {
                    parsed=1;

                    /* "forget" variables mentioned on other lines */
                    address_of_last_variable_name = 0;
                    postOp_arg=0;
                }

                /* ====================================================================================== */

                if (strcmp(word,"#maparg")==0) 		/* Map clown argument to 'constant' */
                {
                    parsed=1;
                    fscanf(source, "%s", param);
                    fscanf(source, "%d", &param2);

                    if (clown_state.argv[param2+1])
                    {
                        if (Dictionary_isLegalEntry(Dictionary_FetchEntry(param)))
                        {
                            printf("Error: multiple declarations of '%s' (line %d)\n",
                                   param,
                                   currentSourceLine);
                            parsed=0;
                        }
                        else
                        {
                            if (stringRepresentsNumeral((char*)clown_state.argv[param2+1]))
                            {
                                allocated_variable_memory = AllocateMoreProgramMemory();
                                Dictionary_CreateEntry(param, allocated_variable_memory, TYPE_VARIABLE);

                                /* generate assignment */
                                    fprintf(phase_output, "Do %d 10 1 %s\n",
                                            allocated_variable_memory,
                                            (char *)clown_state.argv[param2+1]);
                            }
                            else
                            {
                                parsed=0;
                                compiling = 0;
                                printf("Error: argument %d ('%s') is not numeric\n",
                                       param2,
                                       (char *)clown_state.argv[param2+1]);
                            }
                        }
                    }
                    else
                    {
                        printf("Error: argument #%d is required\n", param2);
                        parsed=0;
                        compiling = 0;
                    }

                }

                /* ====================================================================================== */

                if (strcmp(word,"#define")==0) 		/* Define 'constant' as numeral value (imitates standard C) */
                {
                    parsed=1;
                    fscanf(source, "%s", param);
                    fscanf(source, "%s", hack);

                    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(param)))
                    {
                        printf("Error: multiple definitions of '%s' (line %d)\n",
                               param,
                               currentSourceLine);
                        compiling = 0;
                        parsed=0;
                    }
                    else
                    {
                        if(stringRepresentsNumeral(hack))
                        {
                            allocated_variable_memory = AllocateMoreProgramMemory();
                            Dictionary_CreateEntry(param, allocated_variable_memory, TYPE_VARIABLE);

                            /* generate assignment */
                                fprintf(phase_output, "Do %d 10 1 %s\n",
                                        allocated_variable_memory,
                                        hack);
                        }
                        else if(Dictionary_isLegalEntry(Dictionary_FetchEntry(hack)))
                        {
                            allocated_variable_memory = AllocateMoreProgramMemory();
                            Dictionary_CreateEntry(param, allocated_variable_memory, TYPE_VARIABLE);

                            /* generate assignment */
                            fprintf(phase_output, "Do %d 20 2 %d\n",
                                    allocated_variable_memory,
                                    Dictionary_EntryValue(Dictionary_FetchEntry(hack)));
                        }
                        else
                        {
                            printf("Error: '%s' is not numeric (line %d)\n",
                                   hack,
                                   currentSourceLine);
                            parsed = 0;
                            compiling = 0;
                        }
                    }

                }

                /*
                 * Follow the binary operators. "=", "++" and "--" have special implementations,
                 * but the others use a macro "template".
                 */

                /* PARSE ARITHMETIC "=" ------------------------------------------------------------ */

                if (strcmp(word,"=")==0)
                {
                    parsed=1;
                    fscanf(source,"%s", param);
                    param2=Dictionary_FetchEntry(param);

                    if (address_of_last_variable_name==0)
                    {
                        printf("Error: variable expected (line %d)\n", currentSourceLine);
                        compiling = 0;
                    }

                    if (Dictionary_isLegalEntry(param2))
                    {
                        /* variable */

                        postOp_arg = Dictionary_EntryValue(param2); /* For post-(increment|decrement) */

                        /* generate assignment */
                        fprintf(phase_output, "Do %d 10 2 %d\n", address_of_last_variable_name, Dictionary_EntryValue(param2));
                    }
                    else
                    {
                        if (stringRepresentsNumeral(param))
                        {
                            /* litteral */

                                fprintf(phase_output, "Do %d 10 1 %s\n", address_of_last_variable_name, 
param);

                        }
                        else
                        {
                            /* check for a sub-expression */
                            if((sub_exp_adr = subExp(source, phase_output, param)))
                            {
                                /* generate assignment */
                                fprintf(phase_output, "Do %d 10 2 %d\n",
                                        address_of_last_variable_name,
                                        sub_exp_adr);
                            }
                            else
                            {
                                printf("Error: cannot resolve '%s' (line %d)\n",
                                       param,
                                       currentSourceLine);
                                compiling = 0;
                            }
                        }
                    }

                }

                /* ------------------------------------------------------------ PARSE ARITHMETIC "=" */

                /* PARSE ARITHMETIC "+" AND "++" --------------------------------------------------- */
                if (strcmp(word,"+")==0 || strcmp(word,"+=")==0)
                {
                    parsed=1;
                    fscanf(source,"%s", param);

                    if (address_of_last_variable_name==0)
                    {
                        printf("Error: variable expected (line %d)\n",
                               currentSourceLine);
                        compiling = 0;
                    }

                    if (strcmp(param,"+")==0)
                    {
                        sprintf(param, "0");
                        /* Post-increment */
                        if(postOp_arg==0)
                            postOp_arg = address_of_last_variable_name;

                        if(postOp_arg)	/* Side-effect */
                        {
                            fprintf(phase_output, "Do %d 20 1 1\n", postOp_arg);
                        }
                    }

                    param2=Dictionary_FetchEntry(param);

                    if (Dictionary_isLegalEntry(param2))
                    {
                        /* variable */
                        fprintf(phase_output, "Do %d 20 2 %d\n", address_of_last_variable_name, Dictionary_EntryValue(param2));
                    }
                    else
                    {
                        if (stringRepresentsNumeral(param))
                        {
                            /* litteral */
                                fprintf(phase_output, "Do %d 20 1 %s\n", address_of_last_variable_name, param);
                        }
                        else
                        {
                            /* check for a sub-expression */
                            if((sub_exp_adr = subExp(source, phase_output, param)))
                            {
                                /* generate code */
                                fprintf(phase_output, "Do %d 20 2 %d\n",
                                        address_of_last_variable_name,
                                        sub_exp_adr);
                            }
                            else
                            {
                                printf("Error: cannot resolve '%s' (line %d)\n",
                                       param,
                                       currentSourceLine);
                                compiling = 0;
                            }
                        }
                    }

                }
                /* --------------------------------------------------- PARSE ARITHMETIC "+" AND "++" */

                /* PARSE ARITHMETIC "-" AND "--" --------------------------------------------------- */
                if (strcmp(word,"-")==0 || strcmp(word,"-=")==0)
                {
                    parsed=1;
                    fscanf(source,"%s", param);

                    if (address_of_last_variable_name==0)
                    {
                        printf("Error: variable expected (line %d)\n",
                               currentSourceLine);
                        compiling = 0;
                    }

                    if (strcmp(param,"-")==0)
                    {
                        sprintf(param, "0");
                        /* Post-decrement */
                        if(postOp_arg==0)
                            postOp_arg = address_of_last_variable_name;

                        if(postOp_arg)  /* Side-effect */
                        {
                            fprintf(phase_output, "Do %d 30 1 1\n", postOp_arg);
                        }
                    }

                    param2=Dictionary_FetchEntry(param);

                    if (Dictionary_isLegalEntry(param2))
                    {
                        /* variable */
                        fprintf(phase_output, "Do %d 30 2 %d\n", address_of_last_variable_name, Dictionary_EntryValue(param2));
                    }
                    else
                    {
                        if (stringRepresentsNumeral(param))
                        {
                            /* litteral */

                                fprintf(phase_output, "Do %d 30 1 %s\n", address_of_last_variable_name, param);
                        }
                        else
                        {
                            /* check for a sub-expression */
                            if((sub_exp_adr = subExp(source, phase_output, param)))
                            {
                                /* generate code */
                                fprintf(phase_output, "Do %d 20 2 %d\n",
                                        address_of_last_variable_name,
                                        sub_exp_adr);
                            }
                            else
                            {
                                printf("Error: cannot resolve '%s' (line %d)\n",
                                       param,
                                       currentSourceLine);
                                compiling = 0;
                            }
                        }
                    }

                }
                /* --------------------------------------------------- PARSE ARITHMETIC "-" AND "--" */

                /* -------------------- Simple binary operations ---------------------- */

                /* Parse arithmetic "*" */
                ParseTypicalBinaryOp(strcmp(word,"*")==0 || strcmp(word,"*=")==0, 40);

                /* Parse arithmetic "/" */
                ParseTypicalBinaryOp(strcmp(word,"/")==0 || strcmp(word,"/=")==0, 50);

                /* Parse arithmetic "%" */
                ParseTypicalBinaryOp(strcmp(word,"%")==0 || strcmp(word,"%=")==0, 90);

                /* Parse relational "==" */
                ParseTypicalBinaryOp(strcmp(word,"==")==0, 100);

                /* Parse relational "!=" */
                ParseTypicalBinaryOp(strcmp(word, "!=") == 0, 110);

                /* Parse relational ">=" */
                ParseTypicalBinaryOp(strcmp(word, ">=") == 0, 120);

                /* Parse relational "<=" */
                ParseTypicalBinaryOp(strcmp(word, "<=") == 0, 130);

                /* Parse relational ">" */
                ParseTypicalBinaryOp(strcmp(word, ">") == 0, 140);

                /* Parse relational "<" */
                ParseTypicalBinaryOp(strcmp(word, "<") == 0, 150);

                /* Parse bitwise "and" */
                ParseTypicalBinaryOp(strcmp(word, "&")==0
                                     || strcmp(word, "&=")==0
                                     || strcmp(word, "and")==0, 160);

                /* Parse bitwise "or" */
                ParseTypicalBinaryOp(strcmp(word, "|")==0
                                     || strcmp(word, "|=")==0
                                     || strcmp(word, "or")==0, 170);

                /* -------------------------------------------------------------------- */

                if (parsed)
                    consecutive_special_tokens = 0;

                if (!parsed && compiling)
                {
                    /*
                     *  The token has not been parsed as an operator or statement.
                     *  This will verify if it is a variable name. If it
                     *  isn't, clown will auto-declare it on the fly
                     */

                    if (consecutive_special_tokens++>0)
                    {
                        /*
                         *  Consecutive tokens were not parsed as opeartors or statements.
                         *  This is syntactically invalid.
                         */
                        printf("Error: illegal token '%s'; statement or operator expected (line %d)\n",
                               word,
                               currentSourceLine);
                        compiling=0;
                    }

                    if (Dictionary_isLegalEntry((param2=Dictionary_FetchEntry(word))))
                    {
                        /* Token is a known variable name */
                        address_of_last_variable_name=param2;
                    }
                    else
                    {
                        /*
                         *   Token has not been parsed as an operator, statement, or variable name,
                         *   we shall declare a new typeless variable on the fly
                         */

                        allocated_variable_memory = AllocateMoreProgramMemory();

                        if (ValidateVariableName(word))
                        {
                            Dictionary_CreateEntry(word, allocated_variable_memory, TYPE_VARIABLE);
                            address_of_last_variable_name=allocated_variable_memory;
                        }
                        else
                        {
                            printf("Error: illegal variable name '%s' (line %d)\n",
                                   word,
                                   currentSourceLine);
                            compiling = 0;
                        }
                    }
                }
            }

            if (!compiling)
            {
                clown_state.compiler_error = 1;
                compileFailed=1;
            }

            fclose(source);
            fclose(phase_output);

            /* ------------ Post-compiling ------------------------------ */

            /*
             *  Calculate compiled bytecode size, in bytes, for each line.
             *  (This is the "weight" of a line).
             *
             *  This allows the bytecode generated for ifs/whiles to jump over
             *  a block of code by increasing the program counter by the cumulative
             *  weight of the lines contained in this block.
             */

            /* Weigh individual lines */
            WeighLines("ClownLinkFile");

            /* Calculate cumulative weight of blocks contained in ifs/whiles */
            TemporaryData1=0;
            while (TemporaryData1<logicObjectID+1)
            {
                if (logic_StartLine[TemporaryData1] && logic_CloseLine[TemporaryData1])
                {
                    TemporaryData2=logic_StartLine[TemporaryData1];
                    while (TemporaryData2<logic_CloseLine[TemporaryData1]+1)
                    {
                        logic_Weight[TemporaryData1]=logic_Weight[TemporaryData1]+
                                                     getLineWeight(TemporaryData2);
                        TemporaryData2++;
                    }
                }
                TemporaryData1++;
            }

            /*
             * Generate final bytecode assembly by replacing proto-assembly
             * "insert block weight here" directives with their
             * freshly calculated values
             */
            MapLineWeights("ClownLinkFile", "ClownLinkFile2");

            /*
             * Open final bytecode assembly file before sending it to the
             * assembler or program lister ("-a" option)
             */
            source=fopen("ClownLinkFile2", "r");

            if(clown_state.inter)
                ++clown_state.inter;

            /* Load assembly opcodes dictionary */
            SetUpBinaryOutput();

            if (!compileFailed)
            {
                if (clown_state.aflag)
                {
                    /* Text output of compiled bytecode assembly */
                    ShowAssemblyCode(source);
                }
                else
                {
                    /* Send the bytecode assembly to the assembler */

                    SetUpBytecodeStorage();	    /* Set up memory storage for bytecode */

                    if (!GenerateBin(source))
                    {
                        printf("Error: could not compile bytecode \n");
                        compileFailed=1;
                    }
                }
            }

            /* ------------------------------------------------------------- */

            fclose(source);

            /* ------------ Run program in built-in ClownVM ------------------- */

            if (!compileFailed && !clown_state.aflag)
            {
                 fastVM_Run();
            }

            /* ---------------------------------------------------------------- */

        }
    }

do_quit:

    CleanUpLogicEngine();
    WL_CleanUp();

    if (!OUTPUT_DEBUG)
    {
        /* Remove temporary files */
        remove("ClownLinkFile");
        remove("ClownLinkFile2");
        remove("ClownStringTable");
        remove("TempSrc");
        remove("formatted_source.tmp");
        remove("parentheses_pass.tmp");
    }

    return 0;
}


int SetUpLogicEngine(void)
{
    /* Set up logic parser memory */
    logic_WaitingForClose = calloc(MAX_LOGICOBJECT_NUM, sizeof(int));
    logic_NestLevel 	  = calloc(MAX_LOGICOBJECT_NUM, sizeof(int));
    logic_StartLine 	  = calloc(MAX_LOGICOBJECT_NUM, sizeof(int));
    logic_CloseLine 	  = calloc(MAX_LOGICOBJECT_NUM, sizeof(int));
    logic_Weight          = calloc(MAX_LOGICOBJECT_NUM, sizeof(int));
    logic_ObjectType	  = calloc(MAX_LOGICOBJECT_NUM, sizeof(int));
    logic_LoopAddress	  = calloc(MAX_LOGICOBJECT_NUM, sizeof(int));

    if(logic_WaitingForClose==NULL || logic_NestLevel==NULL || logic_StartLine==NULL
            || logic_CloseLine==NULL || logic_Weight==NULL || logic_ObjectType==NULL
            || logic_LoopAddress==NULL)
    {
        printf("Error: could not allocate memory\n");
        return 0;
    }

    return 1;
}

void CleanUpLogicEngine(void)
{
    /* Clean up logic engine memory */
    free(logic_WaitingForClose);
    free(logic_NestLevel);
    free(logic_StartLine);
    free(logic_CloseLine);
    free(logic_Weight);
    free(logic_ObjectType);
    free(logic_LoopAddress);
}

int getLogicObjectScopeWeight(int theObjectID)
{
    /* Interaction between logic engine and WeighLines module */
    return logic_Weight[theObjectID];
}

int AllocateMoreProgramMemory(void)
{
    int i;
    i = allocated_variable_memory+1;
    if (i==254 || i==255)
        i = 256;
    return i;
}

/* If a sub-expression is found and parsed, give the address of its value.

   Sub-expressions are used to parse:
       - the built-in single-argument functions (sqrt(), etc.)
       - unary operators

   (As far as clown is concerned, these two things are quite similar)
 */

int subExp(FILE* input, FILE* phase_output, char* name)
{
    char param[256];
    int param_val;

    /* square root function */
    ParseTypicalSubExp((strcmp(name, "sqrt")==0), "sqrt");

    /* cosine function */
    ParseTypicalSubExp((strcmp(name, "cos")==0), "cos");

    /* sine function */
    ParseTypicalSubExp((strcmp(name, "sin")==0), "sin");

    /* tangent function */
    ParseTypicalSubExp((strcmp(name, "tan")==0), "tan");

    /* unary not */
    ParseTypicalSubExp((strcmp(name, "not")==0 || strcmp(name, "!")==0), "not");

    /* unary minus */
    ParseTypicalSubExp((strcmp(name, "-")==0), "min");

    /* floor function */
    ParseTypicalSubExp((strcmp(name, "floor")==0), "floor");

    return 0;
}


