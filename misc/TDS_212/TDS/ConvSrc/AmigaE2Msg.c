/* AmigaE2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: AmigaE2Msg 1.00 (28.01.94)";

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
Amiga E v2.1

ERROR: unknown identifier
LINE 9: largest_chip:=_AvailMem($20002)
*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256];
UBYTE *scan;
BOOL found;

  found = FALSE;
  while (ReadLn(line,255)) {
    if (scan = strstr(line,"ERROR:")) {
      if (sscanf(scan,"ERROR: %[^\n]",msg->errStr) == 1)
        found = TRUE;
    }
    else if (found && (scan = strstr(line,"LINE"))) {
      if (sscanf(scan,"LINE %d:",&msg->row) == 1)
        return(TRUE);
    }
  }
  return(FALSE);
}


int
main(int argc,UBYTE *argv[])
{
struct ErrorMsg errMsg;
int ret = 0;

  if (argc > 1) {
    strcpy(errMsg.fileName,argv[1]);
    while (ConvertMsg(&errMsg))
      PrintMsg(&errMsg);
  }
  else
    ret = 20;

  return(ret);
}

