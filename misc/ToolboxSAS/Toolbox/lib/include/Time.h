#ifndef yyTime
#define yyTime


int StepTime(void);
/* Returns the sum of user time and system time */
/* since the last call to 'StepTime' in milli-  */
/* seconds.                                     */

void WriteStepTime(char *string);
/* Writes a line consisting of the string      */
/* 'string' and the value obtained from a call */
/* to 'StepTime' on standard output.           */

#endif
