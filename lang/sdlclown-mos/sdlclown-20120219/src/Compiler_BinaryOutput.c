/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include "Clown_HEADERS.h"

/* This converts the final assembly text to a string
   of numbers (the final bytecode), which is stored
   in the "VM_ProgramFile" module.

   It converts operation names to their opcodes and
   leaves the parameters (which have been fully
   generated at this point) intact.
*/

/*************************************************************/
int opNum;	/* Number of operations registered */
/* Stuff for the SetUpBinaryOutput (and other) algorithms */
FILE* theReferenceFile = NULL;
char numeral_str[255];
char readData[255];
char workString[255];
int BBKR_reading;
int StartSet;
int currentOpID;
int opParam1;
int opParam2;
int indexNumber;
int charNum;
int lineNum;
int totalBytes;
int currentBytes;
int theOpcode;
int tok;
/*************************************************************/

int GenerateBin(FILE* srcFile)
{
    fseek(srcFile, 0, SEEK_SET);
    lineNum=1;
    setCursor(0);
    sprintf(readData," ");
    BBKR_reading=1;
    while (BBKR_reading)
    {
        if (fscanf(srcFile,"%s", readData)==EOF)
        {
            BBKR_reading=0;
        }
        else
        {
            if (!stringRepresentsNumeral(readData))
            {
                if (strstr(readData,"!"))
                {
                    /* Read one token and do nothing */
                    fscanf(srcFile,"%d", &tok);
                }
                else
                {
                    totalBytes=getOperationBinSize(readData);
                    theOpcode=getOperationCode(readData);
                    writeToProgramFile((clown_float_t)theOpcode);
                    currentBytes=0;

                    /* Parameters */
                    while (currentBytes<totalBytes)
                    {
                        fscanf(srcFile,"%s", numeral_str);

                        if(stringRepresentsNumeral(numeral_str)==1)
                            writeToProgramFile((clown_float_t)char2int(numeral_str));

                        if(stringRepresentsNumeral(numeral_str)==2)
                            writeToProgramFile((clown_float_t)char2float(numeral_str));

                        currentBytes++;
                    }
                }
            }
            else
            {
                printf("[BinaryOutput] opcode expected, got '%s'\n", readData);
                BBKR_reading=0;
                return 0;
            }
            lineNum++;
        }
    }
    writeToProgramFile(255);
    return 1;
}

int getOperationBinSize(char* theOp)
{
    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(theOp)))
    {
    }
    else
    {
        printf("Error: operation '%s' not recognized\n", theOp);
        return 0;
    }
    return Dictionary_EntryValue(Dictionary_FetchEntry(theOp))-1;
}

int getOperationCode(char* theOp)
{
    sprintf(workString, "%s2", theOp);
    if (Dictionary_isLegalEntry(Dictionary_FetchEntry(workString)))
    {
    }
    else
    {
        printf("Error: operation '%s' not recognized\n", theOp);
        return 0;
    }
    return Dictionary_EntryValue(Dictionary_FetchEntry(workString))-1;
}

int SetUpBinaryOutput()
{
    BackupStringTable();
    SetDictionaryContents(ASSEMBLY_OUTPUT_TABLE);

    clown_state.symcount = getDefCount();
    SetDefinitionsCount(MOD_DEFINITION_COUNT);

    return 1;
}


