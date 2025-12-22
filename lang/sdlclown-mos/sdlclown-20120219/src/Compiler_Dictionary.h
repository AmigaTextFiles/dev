/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _HEADER_5
#define _HEADER_5

extern int Dictionary_EntryValue(int DefinitionReference);
extern void SetDefinitionsCount(int defcount);
extern int Dictionary_EntryType(int EntityReference);
extern int Dictionary_isLegalEntry(int EntityReference);
extern void Dictionary_CreateEntry(char* name, int value, int value_type);
extern int Dictionary_FetchEntry(char* TestName);
extern int Dictionary_Init(void);
extern int getDefCount(void);
extern void BackupStringTable(void);
extern void RetrieveBackedUpStringTable(void);
extern char* getDictionaryToken(void);
extern void SetDictionaryContents(char* contents);

#endif


