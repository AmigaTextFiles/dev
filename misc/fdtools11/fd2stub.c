/* fd2stub.c - generate .a file with stub routines */

#include "fdparse.h"

char REG[16][3] = { "D0","D1","D2","D3","D4","D5","D6","D7",
                    "A0","A1","A2","A3","A4","A5","A6","A7" };

char rbuff[100];

long offset;

void dobuff(char *rbuff,UWORD regs)

{
  int i,j;
  int flag = 0;

  rbuff[0] = 0;

  i = 0;
  while(i < 8) {
    if(regs & (1 << i)) {
      if(flag) strcat(rbuff,"/");
      else flag = !0;
      j = i+1;
      while(j < 8 && (regs & (1 << j))) j++;
      if(--j > i+1) {
        strcat(rbuff,REG[i]);
        strcat(rbuff,"-");
        strcat(rbuff,REG[j]);
        i = j+1;
      }
      else {
        strcat(rbuff,REG[i]);
        i++;
      }
    }
    else i++;
  } 
  while(i < 15) {
    if(regs & (1 << i)) {
      if(flag) strcat(rbuff,"/");
      else flag = !0;
      j = i+1;
      while(j < 15 && (regs & (1 << j))) j++;
      if(--j > i+1) {
        strcat(rbuff,REG[i]);
        strcat(rbuff,"-");
        strcat(rbuff,REG[j]);
        i = j+1;
      }
      else {
        strcat(rbuff,REG[i]);
        i++;
      }
    }
    else i++;
  } 
}

void movemstr(struct fd *fd)

{
  UWORD regs = 0;
  int i;

  offset = 4;

  for(i = 0;i < fd->fd_NumParams;i++) 
    regs |= (1 << fd->fd_Parameter[i]);

  regs |= (1 << 14);       /* +A6 */
  regs &= ~(3 + (3 << 8)); /* -D0/D1/A0/A1 */

  for(i = 0;i < 16;i++)
    if(regs & (1 << i)) offset += 4;
 
  dobuff(rbuff,regs);
}

#define BUFFLEN 256

extern void addext(STRPTR buff,LONG len,STRPTR orig,STRPTR xt);

long __oslibversion = 37;

UBYTE verstag[] = "$VER: fd2stub 1.1 " __AMIGADATE__ ;

UBYTE template[] = "FDFILE/A,STUBFILE/A";

LONG args[2] = { 0, 0};

int main(int argc,char **argv)

{
  int i;
  int flag = 0;
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

    addext(buff,BUFFLEN,(STRPTR)args[1],".a");
    outfile = Open(buff,MODE_NEWFILE);
    if(!outfile) {
      Printf("Could not open stub file !\n");
      retval = 10;
    }

    FreeArgs(rda);
  }
  else retval = 10;

  if(!retval) {
    FPrintf(outfile,"* %s\n\n",argv[2]);
    FPrintf(outfile,"\tSECTION\tTEXT,CODE\n\n"); 
 
    InitFD(infile,&fd);

    do {
      switch(ParseFD(&fd)) {
        case FD_KEYWORD:
          if(!flag && fd.fd_BaseName[0]) {
            FPrintf(outfile,"\tXREF\t%s\n\n",fd.fd_BaseName);
            flag = !0;
          }
          break;
        case FD_FUNCTION:
          movemstr(&fd);
          if(fd.fd_State & FD_PRIVATE) {
            FPrintf(outfile,"* _LVO%s\tEQU\t%ld\n*\n*\tXDEF\t_LVO%s\n",
                            fd.fd_Function,fd.fd_Offset,fd.fd_Function);
            FPrintf(outfile,"*\tXDEF\t_%s\n",fd.fd_Function);
            FPrintf(outfile,"*\n* _%s:\n",fd.fd_Function);
            if(LibCallAlias(&fd)) {
              FPrintf(outfile,"*\n*\tXDEF\t_%s\n",fd.fd_Function);
              FPrintf(outfile,"*\n* _%s:\n",fd.fd_Function);
            }
            if(offset > 8)
              FPrintf(outfile,"*\tmovem.l\t%s,-(SP)\n",rbuff);
            else
              FPrintf(outfile,"*\tmove.l\t%s,-(SP)\n",rbuff);
            FPrintf(outfile,"*\tmove.l\t%s,A6\n",fd.fd_BaseName);
            for(i = 0;i < fd.fd_NumParams;i++) 
              FPrintf(outfile,"*\tmove.l\t%ld(SP),%s\n",offset+4*i,
                              REG[fd.fd_Parameter[i]]);
            FPrintf(outfile,"*\tjsr\t%ld(A6)\n",fd.fd_Offset);
            if(offset > 8)
              FPrintf(outfile,"*\tmovem.l\t(SP)+,%s\n",rbuff);
            else
              FPrintf(outfile,"*\tmove.l\t(SP)+,%s\n",rbuff);
            FPrintf(outfile,"*\trts\n\n");
            if(TagCallName(&fd)) {
              FPrintf(outfile,"*\n*\tXDEF\t_%s\n",fd.fd_Function);
              FPrintf(outfile,"*\n* _%s:\n",fd.fd_Function);
              if(offset > 8)
                FPrintf(outfile,"*\tmovem.l\t%s,-(SP)\n",rbuff);
              else
                FPrintf(outfile,"*\tmove.l\t%s,-(SP)\n",rbuff);
              FPrintf(outfile,"*\tmove.l\t%s,A6\n",fd.fd_BaseName);
              i = fd.fd_NumParams - 1;
              if(fd.fd_Parameter[i] < 8) {
                FPrintf(outfile,"*\tlea\t%ld(SP),A0\n*\tmove.l\tA0,%s\n",
                                offset+4*i,REG[fd.fd_Parameter[i]]);
              }
              for(i = 0;i < fd.fd_NumParams - 1;i++) 
                FPrintf(outfile,"*\tmove.l\t%ld(SP),%s\n",offset+4*i,
                                REG[fd.fd_Parameter[i]]);
              if(fd.fd_Parameter[i] > 7) {
                FPrintf(outfile,"*\tlea\t%ld(SP),%s\n",offset+4*i,
                                REG[fd.fd_Parameter[i]]);
              }
              FPrintf(outfile,"*\tjsr\t%ld(A6)\n",fd.fd_Offset);
              if(offset > 8)
                FPrintf(outfile,"*\tmovem.l\t(SP)+,%s\n",rbuff);
              else
                FPrintf(outfile,"*\tmove.l\t(SP)+,%s\n",rbuff);
              FPrintf(outfile,"*\trts\n\n");
            }
          }
          else {
            FPrintf(outfile,"_LVO%s\tEQU\t%ld\n\n\tXDEF\t_LVO%s\n",
                            fd.fd_Function,fd.fd_Offset,fd.fd_Function);
            FPrintf(outfile,"\tXDEF\t_%s\n",fd.fd_Function);
            FPrintf(outfile,"\n_%s:\n",fd.fd_Function);
            if(LibCallAlias(&fd)) {
              FPrintf(outfile,"\n\tXDEF\t_%s\n",fd.fd_Function);
              FPrintf(outfile,"\n_%s:\n",fd.fd_Function);
            }
            if(offset > 8) 
              FPrintf(outfile,"\tmovem.l\t%s,-(SP)\n",rbuff);
            else
              FPrintf(outfile,"\tmove.l\t%s,-(SP)\n",rbuff);
            FPrintf(outfile,"\tmove.l\t%s,A6\n",fd.fd_BaseName);
            for(i = 0;i < fd.fd_NumParams;i++) 
              FPrintf(outfile,"\tmove.l\t%ld(SP),%s\n",offset+4*i,
                              REG[fd.fd_Parameter[i]]);
            FPrintf(outfile,"\tjsr\t%ld(A6)\n",fd.fd_Offset);
            if(offset > 8) 
              FPrintf(outfile,"\tmovem.l\t(SP)+,%s\n",rbuff);
            else
              FPrintf(outfile,"\tmove.l\t(SP)+,%s\n",rbuff);
            FPrintf(outfile,"\trts\n\n");
            if(TagCallName(&fd)) {
              FPrintf(outfile,"\n\tXDEF\t_%s\n",fd.fd_Function);
              FPrintf(outfile,"\n_%s:\n",fd.fd_Function);
              if(offset > 8) 
                FPrintf(outfile,"\tmovem.l\t%s,-(SP)\n",rbuff);
              else
                FPrintf(outfile,"\tmove.l\t%s,-(SP)\n",rbuff);
              FPrintf(outfile,"\tmove.l\t%s,A6\n",fd.fd_BaseName);
              i = fd.fd_NumParams - 1;
              if(fd.fd_Parameter[i] < 8) {
                FPrintf(outfile,"\tlea\t%ld(SP),A0\n\tmove.l\tA0,%s\n",
                                offset+4*i,REG[fd.fd_Parameter[i]]);
              }
              for(i = 0;i < fd.fd_NumParams - 1;i++) 
                FPrintf(outfile,"\tmove.l\t%ld(SP),%s\n",offset+4*i,
                                REG[fd.fd_Parameter[i]]);
              if(fd.fd_Parameter[i] > 7) {
                FPrintf(outfile,"\tlea\t%ld(SP),%s\n",offset+4*i,
                                REG[fd.fd_Parameter[i]]);
              }
              FPrintf(outfile,"\tjsr\t%ld(A6)\n",fd.fd_Offset);
              if(offset > 8) 
                FPrintf(outfile,"\tmovem.l\t(SP)+,%s\n",rbuff);
              else
                FPrintf(outfile,"\tmove.l\t(SP)+,%s\n",rbuff);
              FPrintf(outfile,"\trts\n\n");
            }
          }
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
  
    FPrintf(outfile,"\n\tEND\n");
  }
  
error:
  if(outfile) Close(outfile);
  if(infile) Close(infile);
  
  return(retval);
}
