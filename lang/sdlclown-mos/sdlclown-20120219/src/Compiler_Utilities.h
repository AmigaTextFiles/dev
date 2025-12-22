/*
   Clown Script Interpreter
      v0.2.5 - Public
    Written by Bl0ckeduser
*/

#ifndef _HEADER_10
#define _HEADER_10

extern void CopyFile(char* pathIn, char* pathOut);
extern int stringRepresentsInteger(char* theString);
extern int stringRepresentsNumeral(char* theString);
extern int char2int(char* fChar);
extern char* int2char(int theInteger);
extern char* getArrayContentsName(char* arrayString);
extern char* getArrayName(char* arrayString);
extern int countCharInString(char theChar, char* theString);
extern int power10(int pwr);
extern float char2float(char* fChar);
extern void neat_print(char* buf);

#endif


