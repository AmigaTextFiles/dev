/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _HEADER_15
#define _HEADER_15

clown_float_t programFile_readFloat(void);
clown_int_t programFile_readInt(void);
int LoadProgramFileToMemory(char* cTheProgramFile);
clown_int_t readFromProgramFile(void);
void setCursor(clown_int_t theCursor);
clown_int_t getCursor(void);
void freeProgram(void);
void writeToProgramFile(clown_float_t input);
void writeToProgramFile_int(int input);
void SetUpBytecodeStorage(void);

#endif


