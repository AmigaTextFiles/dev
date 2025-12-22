/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _HEADER_11
#define _HEADER_11

#define MAX_LINE_COUNT 5000

extern int WeighLines(char* filePath);
extern void WL_SetUp(void);
extern void WL_CleanUp(void);
extern int getLineWeight(int theLineNumber);
extern int MapLineWeights(char* filePath, char* filePath2);

#endif


