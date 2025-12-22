/* CatComp2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: CatComp2Msg 1.00 (28.01.94)";

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


/* CatComp 39.5
ERROR: '/' expected
       file 'foo.ct' line 1 column 17
WARNING: original string for token <name>
       file 'foo.ct' line 10 column 27
*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256];
BOOL found;

  found = FALSE;
  while (ReadLn(line,255)) {
    if (!found && sscanf(line,"ERROR: %[^\n]",msg->errStr) == 1)
      found = TRUE;
    else if (!found && sscanf(line,"WARNING: %[^\n]",msg->errStr) == 1) {
      msg->warn = TRUE;
      found = TRUE;
    }
    else if (found && sscanf(line," file '%[^']' line %d column %d",
             msg->fileName,&msg->row,&msg->col) == 3) {
      return(TRUE);
    }
    else if (found && sscanf(line," file '%[^']' line %d",msg->fileName,&msg->row) == 2) {
      return(TRUE);
    }
    else if (found && sscanf(line," file '%[^']'",msg->fileName) == 1) {
      msg->row = 1;
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

