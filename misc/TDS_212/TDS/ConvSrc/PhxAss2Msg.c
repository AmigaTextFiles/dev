/* PhxAss2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <clib/dos_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: PhxAss2Msg 1.00 (03.02.94)";

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
PhxAss MC680x0/68851/6888x Macro Assembler V3.30

        cippo   #100,d0
23 Unknown directive
 in line 2 (= line 2 of test.asm)

Pass 2
        cippo   #100,d0
23 Unknown directive
 in line 2 (= line 2 of test.asm)

*/

BOOL
ConvertMsg(struct ErrorMsg *msg)
{
UBYTE line[256],*scan;

  msg->errStr[0] = 0;
  while (ReadLn(line,255)) {
    if (scan = strstr(line,"(= line")) {
      if (sscanf(scan,"(= line %d of %[^)])",&msg->row,msg->fileName) == 2) {
        msg->warn = FALSE;
        msg->col = 0;
        return(TRUE);
      }
    }
    else {
      UBYTE *src,*dest;
      
      src = line;
      dest = msg->errStr;
      while (*src != '\n') {
        if (*src >= ' ')
          *dest++ = *src;
        src++;
      }
      *dest = 0;
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

