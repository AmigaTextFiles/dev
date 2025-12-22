/* Dice2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: Dice2Msg 1.01 (11.03.94)";

struct ErrorMsg {
  BOOL warn;
  LONG row,col;
  UBYTE fileName[256];
  UBYTE errStr[256];
};


void 
PrintMsg(struct ErrorMsg *msg)
{
  printf("<%s> %d %c <%s>\n",msg->fileName,msg->row,(msg->warn ? 'W' : 'E'),msg->errStr);
}


/*
DICE 2.07.54

DCPP: "test.c" L:5 C:0 Error:47 Can't open file asfasf.h
DAS: "test.c" L:12 Error:41 Unknown Directive: *ARGV[]
DC1: "test.c" L:22 Error:80 expected '{' or '}' for procedure def

DICE 2.06.40

DC1: Error Line 3 "test.c" 73:syntax error in declaration
DC1: Fatal-Error Line 3 "test.c" 23:syntax error in expression
Error file test.c line 3 : Unable to open asdasda.h
Error file test.c line 11 : Unexpected EOF (unterminated comment)
*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256];

  while (ReadLn(line,255)) {
    msg->warn = (strstr(line,"Warning") != NULL);
  
    if (sscanf(line,"%*s \"%[^\"]\" L:%d %[^\n]",msg->fileName,&msg->row,msg->errStr) == 3)
      return(TRUE);
    
    if (sscanf(line,"%*s \"%[^\"]\" L:%d C:%*d %[^\n]",msg->fileName,&msg->row,msg->errStr) == 3)
      return(TRUE);
  
    if (sscanf(line,"%*s %*s Line %d \"%[^\"]\" %[^\n]",&msg->row,msg->fileName,msg->errStr) == 3)
      return(TRUE);
  
    if (sscanf(line,"%*s file %s line %d : %[^\n]",msg->fileName,&msg->row,msg->errStr) == 3)
      return(TRUE);
  }
  return(FALSE);
}


int
main(int argc,UBYTE *argv[])
{
struct ErrorMsg errMsg;

  while (ConvertMsg(&errMsg))
    PrintMsg(&errMsg);

  return(0);
}

