/******************************************************************************/
/*                                                                            */
/* this works with gcc too and makes life easier                              */
/*                                                                            */
/******************************************************************************/

#define __USE_SYSBASE

/******************************************************************************/
/*                                                                            */
/* includes                                                                   */
/*                                                                            */
/******************************************************************************/

#include <exec/types.h>
#include <exec/resident.h>
#include <proto/exec.h>
#define EXTENDED /* multibase library */
#include "libinit.h"
#include <headers/stabs.h>

/******************************************************************************/
/*                                                                            */
/* *** VERY *** nessecary for relocation!                                     */
/*                                                                            */
/******************************************************************************/

int *reloc=(int *)&reloc;

/******************************************************************************/
/*                                                                            */
/* *** FIRST *** function - prevents a crash when called from CLI!            */
/*                                                                            */
/******************************************************************************/

int safefail()
{
  return -1;
}

/******************************************************************************/
/*                                                                            */
/* defines                                                                    */
/*                                                                            */
/******************************************************************************/

#define SETA4(x) asm volatile ("movel a4,sp@-; movel %0,a4" :/* */: "g" (x))
#define RESA4(x) asm volatile ("movel sp@+,a4;")

/******************************************************************************/
/*                                                                            */
/* imports                                                                    */
/*                                                                            */
/******************************************************************************/

extern const UWORD LibVersion;
extern const UWORD LibRevision;

extern const BYTE LibName[];
extern const BYTE LibIdString[];

extern APTR  __LibTable__[];
extern APTR  __FuncTable__[];

extern const int __datadata_relocs[];

extern int   __UserLibInit(_LIB *);
extern void  __UserLibCleanUp();

/******************************************************************************/
/*                                                                            */
/* resident structure                                                         */
/*                                                                            */
/******************************************************************************/

const APTR InitTab[4];

static const struct Resident RomTag = {
  RTC_MATCHWORD,
  (struct Resident *)&RomTag,
  (APTR)((&RomTag)+1),
  RTF_AUTOINIT,
  0,
  NT_LIBRARY,
  0,
  (BYTE *)LibName,
  (BYTE *)LibIdString,
  (APTR)&InitTab
};

/******************************************************************************/
/*                                                                            */
/* autoinit table for use with initial MakeLibrary()                          */
/*                                                                            */
/******************************************************************************/

const APTR InitTab[4] = {
  (APTR)sizeof(_LIB),
  (APTR)&__LibTable__[1],
  0,
  (APTR)LibInit
};

/******************************************************************************/
/*                                                                            */
/* support function(s) to be inlined                                          */
/*                                                                            */
/******************************************************************************/

static inline APTR __GetDataSeg()
{
  APTR res;
  asm ("lea ___a4_init-0x7ffe,%0" : "=a" (res));
  return res;
}

static inline ULONG __GetDBSize()
{
  ULONG res;
  asm ("movel #___data_size,%0; addl #___bss_size,%0" : "=d" (res));
  return res;
}

static inline ULONG __DSize()
{
  ULONG res;
  asm ("movel #___data_size,%0" : "=d" (res));
  return res;
}

/******************************************************************************/
/*                                                                            */
/* initialization function called by MakeLibrary()                            */
/*                                                                            */
/******************************************************************************/

struct Library *LibInit()
{
  register APTR SegList asm("a0");
  register struct Library *lib asm("d0");
  _LIB *Library = (_LIB *)lib;

  /* init global library base */

  Library->LibNode.lib_Node.ln_Type = NT_LIBRARY;
  Library->LibNode.lib_Node.ln_Name = (UBYTE *)LibName;
  Library->LibNode.lib_Flags        = LIBF_CHANGED | LIBF_SUMUSED;
  Library->LibNode.lib_Version      = (UWORD)LibVersion;
  Library->LibNode.lib_Revision     = (UWORD)LibRevision;
  Library->LibNode.lib_IdString     = (UBYTE *)LibIdString;
  Library->SegList                  = SegList;
  Library->DataSeg                  = __GetDataSeg();
  Library->DataSize                 = __GetDBSize();
  Library->Parent                   = Library;

  /* this will be added to SysBase->LibList */

  return (struct Library *)Library;
}

/******************************************************************************/
/*                                                                            */
/* LibOpen() will be called for every OpenLibrary()                           */
/*                                                                            */
/* !!! CAUTION: This function runs in a forbidden state !!!                   */
/*                                                                            */
/******************************************************************************/

/* forced to be placed in the code section (required!) */

const ULONG *const FuncTable=(ULONG *)&__FuncTable__[0];

struct Library *LibOpen()
{
  register struct Library *lib asm("a6");
  _LIB *Library = (_LIB *)lib, *NewLibrary;
  long *relocs,numrel;

  /* any memory allocation can cause a call of THIS library expunge vector.
     if OpenCnt is zero the library might go away ... So fake a user :-) */

  Library->LibNode.lib_OpenCnt++;

  /* create new library base */

  if ((NewLibrary=(_LIB *)MakeLibrary((APTR)&FuncTable[1],NULL,(APTR)&LibInit,sizeof(_LIB)+Library->DataSize,0)) != NULL)
  {
    int result;

    /* one user */

    NewLibrary->LibNode.lib_OpenCnt++;

    /* copy dataseg */

    CopyMem(NewLibrary->DataSeg,(UBYTE *)NewLibrary+sizeof(_LIB),__DSize());

    /* relocate */

    relocs=(long *)&__datadata_relocs[0];
    if ((numrel=*relocs++))
    {
      int origmem=(int)NewLibrary->DataSeg, mem=(int)((UBYTE *)NewLibrary+sizeof(_LIB));

      do
       { 
         *(long *)(mem + *relocs++) -= origmem - mem;
       }
      while(--numrel);
    }
    NewLibrary->DataSeg = (APTR)((UBYTE *)NewLibrary+sizeof(_LIB)+0x7ffe);

    /* our 'real' parent */

    NewLibrary->Parent  = Library;

    /* assume user-init won't fail */

    Library->LibNode.lib_Flags &= LIBF_DELEXP;
    Library->LibNode.lib_OpenCnt++;

    /* now call user-init */

    SETA4(NewLibrary->DataSeg);
    result=__UserLibInit(NewLibrary);
    RESA4(0);

    /* all ok? */

    if (result!=0)
    {
      ULONG NegSize;

      --Library->LibNode.lib_OpenCnt;
      NegSize = Library->LibNode.lib_NegSize;
      FreeMem((APTR)((UBYTE *)NewLibrary-(UBYTE *)NegSize),NegSize+NewLibrary->LibNode.lib_PosSize);
      NewLibrary = NULL;
    }
  }

  /* end of expunge protection */

  --Library->LibNode.lib_OpenCnt;

  return (struct Library *)NewLibrary;
}

/******************************************************************************/
/*                                                                            */
/* CloseLibrary() entry for the private library bases                         */
/*                                                                            */
/* !!! CAUTION: This function runs in a forbidden state !!!                   */
/*                                                                            */
/******************************************************************************/

APTR LibClose()
{
  register struct Library *lib asm("a6");
  _LIB *Library = (_LIB *)lib;
  APTR SegList=0;
  ULONG NegSize;

  if (--Library->Parent->LibNode.lib_OpenCnt==0 && (Library->LibNode.lib_Flags&LIBF_DELEXP))
    SegList=LibExpunge();

  /* call user-exit */

  SETA4(Library->DataSeg);
  __UserLibCleanUp();
  RESA4(0);

  /* free library */

  NegSize = Library->LibNode.lib_NegSize;
  FreeMem((APTR)((UBYTE *)Library-(UBYTE *)NegSize),NegSize+Library->LibNode.lib_PosSize);

  /* SegList or NULL (still in use) */

  return SegList;
}

/******************************************************************************/
/*                                                                            */
/* remove library from memory if possible                                     */
/*                                                                            */
/* !!! CAUTION: This function runs in a forbidden state !!!                   */
/*                                                                            */
/******************************************************************************/

APTR LibExpunge()
{
  register struct Library *lib asm("a6");
  _LIB *Library = ((_LIB *)lib)->Parent;
  APTR SegList=0;

  /* set delayed expunge flag */

  Library->LibNode.lib_Flags |= LIBF_DELEXP;

  /* still in use? */

  if (Library->LibNode.lib_OpenCnt == 0)
  {
    ULONG NegSize;

    /* return the seglist for UnLoadSeg() */

    SegList = Library->SegList;

    /* remove library from SysBase->LibList */

    Remove((struct Node *)Library);

    /* free library */

    NegSize = Library->LibNode.lib_NegSize;
    FreeMem((APTR)((UBYTE *)Library-(UBYTE *)NegSize),NegSize+Library->LibNode.lib_PosSize);
  }
  return SegList;
}

/******************************************************************************/
/*                                                                            */
/* a do nothing stub (required!)                                              */
/*                                                                            */
/******************************************************************************/

APTR LibExtFunc()
{
  return 0;
}

/******************************************************************************/
/*                                                                            */
/* add these functions to 'liblist'                                           */
/*                                                                            */
/******************************************************************************/

ADD2LIST(LibOpen,   __LibTable__,22);
ADD2LIST(LibExtFunc,__LibTable__,22);
ADD2LIST(LibExpunge,__LibTable__,22);
ADD2LIST(LibExtFunc,__LibTable__,22);
asm(".stabs \"___LibTable__\",20,0,0,-1");

/******************************************************************************/
/*                                                                            */
/* add these functions to 'funclist'                                          */
/*                                                                            */
/******************************************************************************/

ADD2LIST(LibExtFunc,__FuncTable__,22);
ADD2LIST(LibClose,  __FuncTable__,22);
ADD2LIST(LibExpunge,__FuncTable__,22);
ADD2LIST(LibExtFunc,__FuncTable__,22);

/******************************************************************************/
/*                                                                            */
/* end of libinitr.c                                                          */
/*                                                                            */
/******************************************************************************/
