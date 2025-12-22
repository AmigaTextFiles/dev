#include <exec/execbase.h>
#include <exec/memory.h>
#include <exec/semaphores.h>
#include <exec/devices.h>
#include <exec/io.h>
#include <dos/dos.h>
#include <amigem/utils.h>
#include <clib/_exec.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

FC1(1,struct Library *,Lib_Open,A6,ULONG version,D0)
;
FC0(2,BPTR,Lib_Close,A6)
;

FD1(66,void,AddLibrary,struct Library *lib,A1)
{
  lib->lib_Node.ln_Type=NT_LIBRARY;  
  lib->lib_Flags|=LIBF_CHANGED;
  SumLibrary(lib); /* build checksum for library vectors */

  Forbid();
    Enqueue(&SysBase->LibList,&lib->lib_Node);
  Permit();
}

FD1(67,void,RemLibrary,struct Library *lib,A1)
{
  Forbid();
    Remove(&lib->lib_Node);
  Permit();
}

FD3(15,ULONG,MakeFunctions,APTR bp,A0,APTR array,A1,APTR base,A2)
{
  UBYTE *tp=(UBYTE *)base;

  if(base!=NULL)
  {
    WORD *fp=(WORD *)array;
    while(*fp!=-1)
    {
      tp-=LIB_VECTSIZE;
      MINSETFUNCTION(tp,(char *)base+*fp);
      fp++;
    }
  }
  else
  {
    void **fp=(void **)array;
    while(*fp!=(void *)-1)
    {
      tp-=LIB_VECTSIZE;
      MINSETFUNCTION(tp,*fp);
      fp++;
    }
  }
  CacheClearE(tp,(UBYTE *)base-tp,CACRF_ClearI|CACRF_ClearD);
  return (UBYTE *)base-tp;
}

void InitStructNoClear(APTR is,APTR mem,ULONG size)
{
  UBYTE *st,*de;
  st=(UBYTE *)is;
  de=(UBYTE *)mem;

  while(*st!=0)
  {
    LONG cnt1,max2,cnt2;
    UBYTE t;

    cnt1=(*st&15)+1;
    t=*st>>6&3;
    max2=4>>(*st++>>4&3);
    if(max2!=1&&t!=2)
      st++;

    switch(t)
    {
      case 0:
        for(;cnt1;cnt1--)
          for(cnt2=max2;cnt2;cnt2--)
            *de++=*st++;
        break;
      case 1:
        for(;cnt1;cnt1--)
        {
          for(cnt2=max2;cnt2;cnt2--)
            *de++=*st++;
          st-=max2;
        }
        st+=max2;
        break;
      case 2:
        de=(UBYTE *)mem+*st++;
        for(;cnt1;cnt1--)
          for(cnt2=max2;cnt2;cnt2--)
            *de++=*st++;
        break;          
      case 3:
      {/* A 24 bit offset on a 32 bit machine is very nasty - this solution is even more */
        ULONG test_endian=0x18100800;
        UBYTE *et=(UBYTE *)&test_endian;
        if(*et==0x18)
          et++;
        de=(UBYTE *)mem+((st[0]<<et[0])+(st[1]<<et[1])+(st[2]<<et[2]));
        for(;cnt1;cnt1--)
          for(cnt2=max2;cnt2;cnt2--)
            *de++=*st++;
        break;          
      } 
    } 
  }
}

FD3(13,void,InitStruct,APTR is,A1,APTR mem,A2,ULONG size,D0)
{
  { /* Clear Memory area */
    UBYTE *b=mem;
    ULONG s2=size;
    while(s2--)
      *b++=0;
  }
  InitStructNoClear(is,mem,size);
}

FD5(14,struct Library *,MakeLibrary,APTR jmptabl,A0,APTR is,A1,ULONG (*initpc)(),A2,ULONG size,D0,ULONG seglist,D1)
{
  struct Library *ret;
  ULONG jtsize=0,possize,negsize;

  {/* Count jumpvectors */
    if(*(WORD *)jmptabl==-1)
    {
      WORD *fp=(WORD *)jmptabl+1;
      while(*fp++!=-1)
        jtsize+=LIB_VECTSIZE;
    }
    else
    {
      void **fp=(void **)jmptabl;
      while((long)*fp++!=-1)
        jtsize+=LIB_VECTSIZE;
    }
  }

  negsize=(jtsize+(sizeof(ULONG)-1))&~(sizeof(ULONG)-1);
  possize=(size+(sizeof(ULONG)-1))&~(sizeof(ULONG)-1);

  if((ret=(struct Library *)AllocMem(possize+negsize,MEMF_PUBLIC|MEMF_CLEAR))!=NULL)
  {
    ret=(struct Library *)((char *)ret+negsize);

    if(*(WORD *)jmptabl==-1)
      MakeFunctions(ret,(WORD *)jmptabl+1,(WORD *)jmptabl+1);
    else
      MakeFunctions(ret,jmptabl,NULL);

    ret->lib_NegSize=negsize;
    ret->lib_PosSize=possize;
    if(is!=NULL)
      InitStructNoClear(is,ret,size);
    if(initpc!=NULL)
      ret=(*(struct Library *(*)(struct Library *,BPTR,struct ExecBase *))
            initpc)(ret,seglist,SysBase);
  }
  return ret;
}

FD1(68,struct Library *,OldOpenLibrary,APTR libName,A1)
{
  return OpenLibrary(libName,0);
}

FD1(69,void,CloseLibrary,struct Library *library,A1)
{
  Forbid();
    if(library)
      Lib_Close(library);
  Permit();
}

FD3(70,APTR,SetFunction,struct Library *library,A1,LONG funcOffset,A0,APTR funcEntry,D0)
{
  APTR ret;
  library->lib_Flags|=LIBF_CHANGED;
  ret=MINGETFUNCTION((char *)library+funcOffset);
  MINSETFUNCTION((char *)library+funcOffset,funcEntry);
  CacheClearE((char *)library+funcOffset,LIB_VECTSIZE,CACRF_ClearI|CACRF_ClearD);
  SumLibrary(library);
  return ret;
}

FD1(71,void,SumLibrary,struct Library *library,A1)
{
}

FD2(92,struct Library *,OpenLibrary,STRPTR libName,A1,ULONG version,D0)
{
  struct Library *ret;
  Forbid();
    ret=(struct Library *)FindName(&SysBase->LibList,libName);
    if(ret->lib_Version<version)
      ret=NULL;
    if(ret)
      ret=Lib_Open(ret,version);
  Permit();
  return ret;
}
