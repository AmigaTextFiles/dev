#include <exec/execbase.h>
#include <dos/dos.h>
#include <amigem/machine.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

#define CBUFSIZE (sizeof(ULONG)*BITSPERBYTE*301/1000)

/* Two functions from machine.c */
struct dm10
{
  ULONG q;
  ULONG r;
};

APTR stuffChar(void (*PutChProc)(),ULONG character,APTR PutChData);
struct dm10 DivMod10(ULONG value);

FD4(87,APTR,RawDoFmt,STRPTR FormatString,A0,APTR DataStream,A1,void (*PutChProc)(),A2,APTR PutChData,A3)
{
  while(*FormatString)
  {
    if(*FormatString=='%')
    {
      int left=0,fill=' ',larg=0,minus=0;
      ULONG i,width=0,minwidth=0,maxwidth=~0;
      UBYTE cbuf[CBUFSIZE];
      UBYTE *buf;
      
      FormatString++;

      if(*FormatString=='-')
        left=*FormatString++;
      if(*FormatString=='0')
        fill=*FormatString++;

      while(*FormatString>='0'&&*FormatString<='9')
        minwidth=minwidth*10+(*FormatString++-'0');

      if(*FormatString=='.')
        FormatString++;

      if(*FormatString>='0'&&*FormatString<='9')
      {
        maxwidth=0;
        do
          maxwidth=maxwidth*10+(*FormatString++-'0');
        while(*FormatString>='0'&&*FormatString<='9');
      }

      if(*FormatString=='l')
        larg=*FormatString++;
      
      switch(*FormatString++)
      {
        case 'b':
          {
            UBYTE *buffer;
            buf=buffer=(UBYTE *)BSTR2C(*(*(BPTR **)&DataStream)++);
            while(*buffer++)
              width++;
            if(width>maxwidth)
              width=maxwidth;
	  }
          break;
        case 'd':
          {
            LONG n;
            if(larg)
              n=*(*(ULONG **)&DataStream)++;
            else
              n=*(*(UWORD **)&DataStream)++;
            if(n<0)
            {
              minus=1;
              n=-n;
              width++;
	    }
            buf=&cbuf[CBUFSIZE];
            do
            {
              struct dm10 r;
              r=DivMod10(n);
              *--buf=r.r+'0';
              n=r.q;
              width++;
	    }while(n);
	  }
          break;
        case 'u':
          {
            ULONG n;
            if(larg)
              n=*(*(ULONG **)&DataStream)++;
            else
              n=*(*(UWORD **)&DataStream)++;
            buf=&cbuf[CBUFSIZE];
            do
            {
              struct dm10 r;
              r=DivMod10(n);
              *--buf=r.r+'0';
              n=r.q;
              width++;
	    }while(n);
          }
          break;
        case 'x':
          {
            ULONG n;
            if(larg)
              n=*(*(ULONG **)&DataStream)++;
            else
              n=*(*(UWORD **)&DataStream)++;
            buf=&cbuf[CBUFSIZE];
            do
            {
              *--buf="0123456789abcdef"[n&15];
              n>>=4;
              width++;
	    }while(n);
          }
          break;
        case 's':
          {
            UBYTE *buffer;
            buf=buffer=*(*(UBYTE ***)&DataStream)++;
            while(*buffer++)
              width++;
            if(width>maxwidth)
              width=maxwidth;
	  }
          break;
        case 'c':
          {
            buf=cbuf;
            width++;
            if(larg)
              *buf=*(*(ULONG **)&DataStream)++;
            else
              *buf=*(*(UWORD **)&DataStream)++;
	  }
          break;
        case '\0':
          FormatString--;
          buf=NULL;
          break;
        default: /* case '%': */
          buf=FormatString-1;
          width++;
          break;
      }
      if(minus&&fill==' ')	/* Print sign */
        PutChData=stuffChar(PutChProc,'-',PutChData);
      if(!left)			/* Pad left */
        for(i=width+minus;i<minwidth;i++)
          PutChData=stuffChar(PutChProc,fill,PutChData);
      if(minus&&fill!=' ')	/* Print sign */
        PutChData=stuffChar(PutChProc,'-',PutChData);
      for(i=0;i<width;i++)	/* Print body */
        PutChData=stuffChar(PutChProc,*buf++,PutChData);
      if(left)			/* Pad right */
        for(i=width+minus;i<minwidth;i++)
          PutChData=stuffChar(PutChProc,' ',PutChData);
    }else
      PutChData=stuffChar(PutChProc,*FormatString++,PutChData);
  }
  PutChData=stuffChar(PutChProc,0,PutChData);
  return DataStream;
}
