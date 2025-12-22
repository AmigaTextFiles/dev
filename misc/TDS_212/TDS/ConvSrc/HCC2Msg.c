/* HCC2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: HCC2Msg 1.00 (28.01.94)";

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


/* HCC 1.1
fatal error in src/display.c on line 3: Cant open  defs.h
error in foo.c on line 16: expect )
warning in foo.c on line 33: assume }
*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256];
UBYTE *scan;

  while (ReadLn(line,255)) {
    if (scan = strstr(line,"in")) {
      if (sscanf(scan,"in %s on line %d: %[^\n]",msg->fileName,&msg->row,msg->errStr) == 3) {
        msg->warn = (strstr(line,"warning") != NULL);
        return(TRUE);
      }
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

