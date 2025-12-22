/* SAS2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: SAS2Msg 1.00 (28.01.94)";

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
Lattice 5.XX SAS 6.XX

test.c 6 Warning 57: semi-colon expected
test.c 6 Error 2: unexpected end of file
test.asm 2 Error: unrecognized opcode
test.asm 4 Error: data generation must occur in reloc section
*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256];

  while (ReadLn(line,255)) {
    if (sscanf(line,"%s %d %[^\n]",msg->fileName,&msg->row,msg->errStr) == 3) {
      msg->warn = (strstr(line,"Warning") != NULL);
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

