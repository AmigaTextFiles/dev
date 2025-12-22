/* fd2pragma.c - generate .h file with #pragma (lib|tag)calls */

#include "fdparse.h"
#include <string.h>
#include <proto/dos.h>

#define BUFFLEN 256

extern void addext(STRPTR buff,LONG len,STRPTR orig,STRPTR xt);

void fprintfd(BPTR outfile,struct fd *fd,STRPTR pragtype)

{
  int i;

  if(fd->fd_State & FD_PRIVATE) FPrintf(outfile,"/*");
  FPrintf(outfile,"#pragma %scall %s %s %lx ",pragtype,
                                              fd->fd_BaseName+1,
                                              fd->fd_Function,
                                              -fd->fd_Offset);
  for(i = fd->fd_NumParams-1;i >= 0;i--)  
    FPrintf(outfile,"%lx",fd->fd_Parameter[i]);
  FPrintf(outfile,"0%lx",fd->fd_NumParams);
  if(fd->fd_State & FD_PRIVATE) FPrintf(outfile,"*/");
  FPrintf(outfile,"\n");
}

long __oslibversion = 37;

UBYTE verstag[] = "$VER: fd2pragma 1.1 " __AMIGADATE__ ;

UBYTE template[] = "FDFILE/A,INCFILE/A";

LONG args[2] = { 0, 0};

int main(int argc,char **argv)

{
  int retval = 0;
  struct RDArgs *rda;
  UBYTE buff[BUFFLEN];
  BPTR infile = 0,outfile = 0;
  struct fd fd;

  if(argc == 0) return(20); /* we do not run from WB */

  rda = ReadArgs(template,args,0);
  if(rda) {
    addext(buff,BUFFLEN,(STRPTR)args[0],".fd");
    infile = Open(buff,MODE_OLDFILE);
    if(!infile) {
      Printf("Could not open .fd file !\n");
      retval = 10;
    }

    addext(buff,BUFFLEN,(STRPTR)args[1],".h");
    outfile = Open(buff,MODE_NEWFILE);
    if(!outfile) {
      Printf("Could not open include file !\n");
      retval = 10;
    }

    FreeArgs(rda);
  }
  else retval = 10;

  if(!retval) {
    InitFD(infile,&fd);

    do {
      switch(ParseFD(&fd)) {
        case FD_KEYWORD:
          break;
        case FD_FUNCTION:
          fprintfd(outfile,&fd,"lib");
          if(LibCallAlias(&fd)) fprintfd(outfile,&fd,"lib");
          if(TagCallName(&fd)) {
            FPrintf(outfile,"#ifdef __SASC_60\n");
            fprintfd(outfile,&fd,"tag");
            FPrintf(outfile,"#endif\n");
          }
          break;
        case FD_ERROR:
          Printf("%s\n",fd.fd_Function);
          retval = 10;
          goto error;
        case FD_COMMENT:
          FPrintf(outfile,"/%s*/\n",fd.fd_Function);
          break;
      }
    } while(!(fd.fd_State & FD_READY));
  }
  
error:
  if(outfile) Close(outfile);
  if(infile) Close(infile);
  
  return(retval);
}
