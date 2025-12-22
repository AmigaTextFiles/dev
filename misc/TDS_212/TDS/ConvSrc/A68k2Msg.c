/* A68k2Msg.c */

#include <exec/types.h>
#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: A68k2Msg 1.00 (28.01.94)";

void 
PrintMsg(UBYTE *fileName,LONG row,BOOL warn,UBYTE *errStr)
{
  printf("<%s> %d %c <%s>\n",fileName,row,(warn ? 'W' : 'E'),errStr);
}

/* A68k 2.61
foo.asm line 4
    4           moveq   #300,d9
                             ^ Undefined Symbol.
                             ^ Addressing mode not allowed here.
*/


int
main(int argc,UBYTE *argv[])
{
UBYTE buffer[256];
UBYTE fileName[256],lastName[256];
UBYTE errStr[256];
LONG row,lastRow;
BOOL warn = FALSE;

  lastName[0] = 0;
  while (fgets(buffer,255,stdin)) {
    if (sscanf(buffer,"%s line %ld",fileName,&row) == 2) {
      strcpy(lastName,fileName);
      lastRow = row;
    }
    else if (lastName[0] != 0 && sscanf(buffer," ^ %[^\n]",errStr) == 1) {
      PrintMsg(lastName,lastRow,warn,errStr);
    }
  }
  return(0);
}


