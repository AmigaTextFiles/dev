/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#include "Clown_HEADERS.h"

/*******************************/
char TheStringTable[1024*1024*2];	/* 2 MB */
char TheStringTableBAK[1024*1024*2];	/* 2 MB */
int stringTableCursor = 0;
int scanAt;
int definitions = 0;
int currentDAENumber = -100;
/*******************************/

char* getDictionaryToken(void)
{
    static char token[256];

    token[0] = 0;

    while(TheStringTable[stringTableCursor]==' ' && stringTableCursor<=strlen(TheStringTable))
        stringTableCursor++;

    while(TheStringTable[stringTableCursor]!=' ' && stringTableCursor<=strlen(TheStringTable))
        sprintf(token, "%s%c", token, TheStringTable[stringTableCursor++]);

    return token;
}

int Dictionary_EntryValue(int DefinitionReference)
{
    return DefinitionReference;
}

int Dictionary_EntryType(int EntityReference)
{
    return TYPE_VARIABLE;
}

int Dictionary_isLegalEntry(int EntityReference)
{
    return ((EntityReference>0 && EntityReference<MEMORY_QTY) || EntityReference<=-100);
}

int Dictionary_Init(void)
{
    if(clown_state.inter > 1)
    {
        /* We are in interactive mode; dictionary already initialized */
        definitions = clown_state.symcount;
        return 1;
    }
    else
    {
        /* Clean up StringTable */
        sprintf(TheStringTable, " ");
        definitions = 0;
        clown_state.symcount = 0;
        return 1;
    }
}

int Dictionary_FetchEntry(char* TestName)
{
    char readToken[256];
    char readToken2[256];
    int test;

    sprintf(readToken, " ");

    /* Reset StringTable cursor */
    stringTableCursor = 0;
    scanAt=1;

    /* Scavenge dictionnary for matching expression */
    while (scanAt<=definitions)
    {
        strcpy(readToken, getDictionaryToken());
        strcpy(readToken2, getDictionaryToken());

        test = char2int(readToken2);

        if (strcmp(TestName, readToken)==0)
            return test;		/* Match found ! */

        scanAt++;
    }

    if (strstr(TestName, "[") && strstr(TestName, "]") && !stringRepresentsInteger(getArrayContentsName(TestName))
            && Dictionary_isLegalEntry(Dictionary_FetchEntry(getArrayName(TestName))) && Dictionary_EntryType(Dictionary_FetchEntry(getArrayName(TestName)))==TYPE_VARIABLE)
    {
        if (Dictionary_isLegalEntry(Dictionary_FetchEntry(getArrayContentsName(TestName)))
                && Dictionary_EntryType(Dictionary_FetchEntry(getArrayContentsName(TestName)))==TYPE_VARIABLE)
        {
            if (DAE_FetchEntry(Dictionary_EntryValue(Dictionary_FetchEntry(getArrayName(TestName))),Dictionary_EntryValue(Dictionary_FetchEntry(getArrayContentsName(TestName)))))
            {
                return DAE_FetchEntry(Dictionary_EntryValue(Dictionary_FetchEntry(getArrayName(TestName))),Dictionary_EntryValue(Dictionary_FetchEntry(getArrayContentsName(TestName))));
            }
            else
            {
                /* Create DAE entry */
                DAE_CreateEntry(currentDAENumber, Dictionary_EntryValue(Dictionary_FetchEntry(getArrayName(TestName))), Dictionary_EntryValue(Dictionary_FetchEntry(getArrayContentsName(TestName))));
                return currentDAENumber--;
            }
        }
        else
        {
            printf("Error: variable '%s' does not exist\n", getArrayContentsName(TestName));
        }
    }
    return 0;
}


void Dictionary_CreateEntry(char* name, int value, int value_type)
{
    /* Increment entries counter, store data */
    definitions++;
    sprintf(TheStringTable,"%s %s %d ", TheStringTable, name, value);
}

/*
 * In interactive mode, the compiler symbol
 * dictionary is temporary copied to leave
 * room for the assembler's opcodes dictionary.
 * The next few functions take care of this.
 */

void SetDefinitionsCount(int defcount)
{
    definitions=defcount;
}

int getDefCount(void)
{
    return definitions;
}

void SetDictionaryContents(char* contents)
{
    strcpy(TheStringTable, contents);
}

void BackupStringTable(void)
{
    strcpy(TheStringTableBAK, TheStringTable);
}

void RetrieveBackedUpStringTable(void)
{
    strcpy(TheStringTable, TheStringTableBAK);
}

