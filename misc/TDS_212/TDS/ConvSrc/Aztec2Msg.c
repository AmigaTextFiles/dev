/* Aztec2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: Aztec2Msg 1.00 (28.01.94)";

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
Manx Aztec 3.6

test.c:6: ERROR 46: missing closing brace: 
test.c:8: WARNING 124: invalid ptr/ptr assignment: 
File test.asm; Line 1 # Need opcode, directive or macro name here.
*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256];

  while (ReadLn(line,255)) {
    if (sscanf(line,"%[^:]:%d: %[^\n]",msg->fileName,&msg->row,msg->errStr) == 3) {
      msg->warn = (strstr(line,"WARNING") != NULL);
      return(TRUE);
    }
    if (sscanf(line,"File %[^;]; Line %d %[^\n]",msg->fileName,&msg->row,msg->errStr) == 3) {
      msg->warn = FALSE;
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

