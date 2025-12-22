/* Oberon2Msg.c */

#include <exec/types.h>
#include <dos/stdio.h>
#include <dos/dostags.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>

#include <stdio.h>
#include <string.h>

static UBYTE version[] = "$VER: Oberon2Msg 1.00 (28.01.94)";

/* Oberon 3.0
  -------

  6:   i: INTEER;
                ^
       25: Bezeichner nicht definiert
       38: Typ erwartet

  -------

  9:   FOR i:= TO 10 DO
          ^
      183: Bezeichner nach FOR muß Integer-Variable sein
              ^
       67: Faktor erwartet
*/


void
OberonMsg(BPTR fh,UBYTE *filename)
{
UBYTE buffer[256];
UBYTE errstr[256];
LONG errnum,row;

  while (FGets(fh,buffer,255)) {
    if (strspn(buffer," ") > 2) {  	/* error message */
      if (sscanf(buffer," %ld: %[^\n]",&errnum,errstr) == 2)
        Printf("<%s> %ld E <%ld: %s>\n",filename,row,errnum,errstr);
    }
    else				/* row number */
      sscanf(buffer," %ld:",&row);
  }
}


/* Usage: Oberon2Msg source-file */

int
main(int argc,UBYTE *argv[])
{
BPTR fh;
UBYTE errfile[32];
UBYTE cmdstr[256];
LONG exitcode;
BOOL done = FALSE;

  if (argc > 1) {
    sprintf(errfile,"T:Oberon2Msg%0lx",FindTask(NULL));
    fh = Open(errfile,MODE_NEWFILE);
    if (fh) {
      sprintf(cmdstr,"OBERON:OErr %s\n",argv[1]);
      exitcode = SystemTags(cmdstr,SYS_Input,NULL,SYS_Output,fh,TAG_DONE);
      Close(fh);
      
      if (exitcode == 0) {
        fh = Open(errfile,MODE_OLDFILE);
        if (fh) {
          OberonMsg(fh,argv[1]);
          Close(fh);
          DeleteFile(errfile);
          done = TRUE;
        }
      }
    }
  }
  return(done ? 0 : 20);
}

