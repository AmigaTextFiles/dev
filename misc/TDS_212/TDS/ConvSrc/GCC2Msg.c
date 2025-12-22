/* GCC2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: GCC2Msg 1.00 (28.01.94)";

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
GCC 2.3.3
test.c:12: error message
*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256];

  while (ReadLn(line,255)) {
    if (sscanf(line,"%[^:]:%d: %[^\n]",msg->fileName,&msg->row,msg->errStr) == 3) {
      msg->warn = (strstr(line,"warning") != NULL);
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

