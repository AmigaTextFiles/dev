/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _HEADER_2
#define _HEADER_2

#define tDefinition 1

extern int SetUpBinaryOutput();
extern int getOperationBinSize(char* theOp);
extern int getOperationCode(char* theOp);
extern int GenerateBin(FILE* srcFile);
extern int GenerateBin_int(FILE* srcFile);

#endif


