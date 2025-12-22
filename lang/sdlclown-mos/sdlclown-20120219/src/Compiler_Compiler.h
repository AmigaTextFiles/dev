/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _HEADER_3
#define _HEADER_3

extern void CleanUpLogicEngine(void);
extern int SetUpLogicEngine(void);
extern int getLogicObjectScopeWeight(int theObjectID);
extern int ClownCompiler_main(char* input_filename);
extern int ValidateVariableName(char* theVariableName);
extern int AllocateMoreProgramMemory(void);
extern int subExp(FILE* input, FILE* phase_output, char* name);

#define ERROR_LIMIT 	0	/* Maximum number of errors ! */

#endif


