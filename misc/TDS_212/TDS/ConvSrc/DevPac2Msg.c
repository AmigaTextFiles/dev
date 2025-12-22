/* DevPac2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: DevPac2Msg 1.00 (28.01.94)";

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
Devpac 2.14/3.00

Warning line malformed at line 3 in file test.c
Error instruction not recognized at line 8 in file test.c
*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256];
UBYTE *scan;

  while (ReadLn(line,255)) {
    if (scan = strstr(line,"at line")) {
      msg->warn = (strstr(line,"Warning") != NULL);
      *(scan-1) = '\0';
      strcpy(msg->errStr,line);
      if (sscanf(scan,"at line %d in file %s",&msg->row,msg->fileName) == 2)
        return(TRUE);
    }
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

