/* PCQ2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: PCQ2Msg 1.00 (28.01.94)";

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


/* PCQ 1.2b using -q option
"foo.p" At 7,6 : Unknown ID
"foo.p" At 11,2 : Unknown ID
*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256];

  while (ReadLn(line,255)) {
    if (sscanf(line,"\"%[^\"]\" At %d,%d : %[^\n]",msg->fileName,
        &msg->row,&msg->col,msg->errStr) == 4) {
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

