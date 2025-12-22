/* fd2i.c - generate .i file with _LVOs from .fd file */

#include "fdparse.h"
#include <proto/utility.h>

#define BUFFLEN 256

extern void addext(STRPTR buff,LONG len,STRPTR orig,STRPTR xt);

long __oslibversion = 37;

UBYTE verstag[] = "$VER: fd2i 1.1 " __AMIGADATE__ ;

UBYTE template[] = "FDFILE/A,IFILE/A";

LONG args[2] = { 0, 0};

struct Library *UtilityBase;

int main(int argc,char **argv)

{
  int i;
  int retval = 0;
  struct RDArgs *rda;
  UBYTE buff[BUFFLEN];
  BPTR infile = 0,outfile = 0;
  struct fd fd;

  if(argc == 0) return(20); /* we do not run from WB */

  UtilityBase = OpenLibrary("utility.library",37);
  if(UtilityBase == 0) return(20);

  rda = ReadArgs(template,args,0);
  if(rda) {
    addext(buff,BUFFLEN,(STRPTR)args[0],".fd");
    infile = Open(buff,MODE_OLDFILE);
    if(!infile) {
      Printf("Could not open .fd file !\n");
      retval = 10;
    }

    addext(buff,BUFFLEN,(STRPTR)args[1],".i");
    outfile = Open(buff,MODE_NEWFILE);
    if(!outfile) {
      Printf("Could not open .i file !\n");
      retval = 10;
    }

    FreeArgs(rda);
  }
  else retval = 10;

  if(!retval) {
    FPrintf(outfile,"* %s\n\n",buff);
  
    FPrintf(outfile,"\tIFND\t");

    for(i = 0;buff[i];i++) {
      if(buff[i] == '.' || buff[i] == '/') FPutC(outfile,'_');
      else FPutC(outfile,ToUpper(buff[i]));
    }

    FPutC(outfile,'\n');

    for(i = 0;buff[i];i++) {
      if(buff[i] == '.' || buff[i] == '/') FPutC(outfile,'_');
      else FPutC(outfile,ToUpper(buff[i]));
    }

    FPrintf(outfile,"\tSET\t1\n\n");

    InitFD(infile,&fd);

    do {
      switch(ParseFD(&fd)) {
        case FD_KEYWORD:
          break;
        case FD_FUNCTION:
          if(fd.fd_State & FD_PRIVATE) 
            FPrintf(outfile,"* _LVO%s\tEQU\t%ld\n",
                    fd.fd_Function,fd.fd_Offset);
          else
            FPrintf(outfile,"_LVO%s\tEQU\t%ld\n",
                    fd.fd_Function,fd.fd_Offset);
          break;
        case FD_ERROR:
          Printf("%s\n",fd.fd_Function);
          retval = 10;
          goto error;
        case FD_COMMENT:
          FPrintf(outfile,"%s\n",fd.fd_Function);
          break;
      }
    } while(!(fd.fd_State & FD_READY));

    FPrintf(outfile,"\n\tENDC\n");
  }

error:
  if(outfile) Close(outfile);
  if(infile) Close(infile);

  CloseLibrary(UtilityBase);

  return(retval);
}
