/******************************************************************************/
/*                                                                            */
/* this works with gcc too and makes life easier                              */
/*                                                                            */
/******************************************************************************/

#define _USEOLDEXEC_

/******************************************************************************/
/*                                                                            */
/* *** FIRST *** function - prevents a crash when called from CLI!            */
/*                                                                            */
/******************************************************************************/

int safefail()
{
  return 0;
}

/******************************************************************************/
/*                                                                            */
/* global declarations (only libs global pointers)                            */
/*                                                                            */
/******************************************************************************/

struct Library *myLibPtr = NULL;
struct ExecBase *SysBase = NULL;
struct Library *LayersBase = NULL;
struct Library *MUIMasterBase = NULL;

/******************************************************************************/
/*                                                                            */
/* own library struct                                                         */
/*                                                                            */
/******************************************************************************/

typedef struct _Library {
  struct Library LibNode;
  APTR  SegList;
  struct SignalSemaphore LibSemaphore;
} _LIB;

/******************************************************************************/
/*                                                                            */
/* prototypes                                                                 */
/*                                                                            */
/******************************************************************************/

struct Library *LibInit(void);
struct Library *LibOpen(void);
APTR LibClose(void);
APTR LibExpunge(void);
APTR LibExtFunc(void);
ULONG LibMCC_Query(void);

int MUI_Mcc_Init(void);
void MUI_Mcc_Cleanup(void);
ULONG MUI_Mcc_Query(LONG which);

/******************************************************************************/
/*                                                                            */
/* resident structure                                                         */
/*                                                                            */
/******************************************************************************/

static const struct Resident RomTag = {
  RTC_MATCHWORD,
  (struct Resident *)&RomTag,
  (APTR)((&RomTag)+1),
  0,
  LIB_VERSION,
  NT_LIBRARY,
  0,
  (BYTE *) LibName,
  (BYTE *) LibIdString,
  (APTR) LibInit
};

/******************************************************************************/
/*                                                                            */
/* autoinit table for use with initial MakeLibrary()                          */
/*                                                                            */
/******************************************************************************/

static const APTR LibVectors[] =
{
  LibOpen,
  LibClose,
  LibExpunge,
  LibExtFunc,
  LibMCC_Query,
  (APTR)-1
};

/******************************************************************************/
/*                                                                            */
/* initialization function called by MakeLibrary()                            */
/*                                                                            */
/******************************************************************************/

struct Library *LibInit(void)
{
  register APTR a0 asm("a0");          /* Segment <-> SegList */
  APTR SegList = a0;
  _LIB *Library;

  SysBase = *((struct ExecBase **)4);
  if (Library = (_LIB *) MakeLibrary((APTR)LibVectors,NULL,NULL,sizeof(_LIB),NULL))
  {
    int result;
    Library->LibNode.lib_Node.ln_Type = NT_LIBRARY;
    Library->LibNode.lib_Node.ln_Name = (char *) LibName;
    Library->LibNode.lib_Flags        = LIBF_CHANGED | LIBF_SUMUSED;
    Library->LibNode.lib_Version      = (UWORD) LIB_VERSION;
    Library->LibNode.lib_Revision     = (UWORD) LIB_REVISION;
    Library->LibNode.lib_IdString     = (UBYTE *) LibIdString;
    Library->SegList  = SegList;

    myLibPtr = (struct Library *) Library;

    InitSemaphore(&Library->LibSemaphore);

    /********************* Open libraries here ************************/

    MUIMasterBase = NULL;
    LayersBase = NULL;
    if (MUIMasterBase = OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))
    {
      if (LayersBase = OpenLibrary("layers.library",37))
      {

        if (MUI_Mcc_Init())
        {
          AddLibrary((struct Library *) Library);
          return ((struct Library *) Library);
        }

      }
    }
    if (LayersBase)
      CloseLibrary(LayersBase);
    if (MUIMasterBase)
      CloseLibrary(MUIMasterBase);

    /******************************************************************/

    FreeMem((APTR)(((UBYTE *) Library) - Library->LibNode.lib_NegSize),
            (Library->LibNode.lib_NegSize+Library->LibNode.lib_PosSize));
  }
  return (NULL);
}

/******************************************************************************/
/*                                                                            */
/* LibOpen() will be called for every OpenLibrary()                           */
/*                                                                            */
/* !!! CAUTION: This function runs in a forbidden state !!!                   */
/*                                                                            */
/******************************************************************************/

struct Library *LibOpen(void)
{
  register struct Library *lib asm("a6");

  lib->lib_Flags &= ~LIBF_DELEXP;

  lib->lib_OpenCnt++;

  return lib;
}

/******************************************************************************/
/*                                                                            */
/* LibClose() will be called for every CloseLibrary()                         */
/*                                                                            */
/* !!! CAUTION: This function runs in a forbidden state !!!                   */
/*                                                                            */
/******************************************************************************/

APTR LibClose(void)
{
  register struct Library *lib asm("a6");
  APTR SegList=0;

  if (lib->lib_OpenCnt > 0)
    lib->lib_OpenCnt--;

  if ((lib->lib_OpenCnt==0)
#ifndef EXPUNGE_AT_LAST_CLOSE
       && (lib->lib_Flags & LIBF_DELEXP)
#endif
     )
    SegList = LibExpunge();

  return SegList;
}

/******************************************************************************/
/*                                                                            */
/* remove library from memory if possible                                     */
/*                                                                            */
/* !!! CAUTION: This function runs in a forbidden state !!!                   */
/*                                                                            */
/******************************************************************************/

APTR LibExpunge(void)
{
  register struct Library *lib asm("a6");
  _LIB *Library = (_LIB *)lib;
  APTR SegList=0;

  if (Library->LibNode.lib_OpenCnt == 0)
  {
    SegList = Library->SegList;
    Remove((struct Node *) Library);

    MUI_Mcc_Cleanup();

    /***************** Close opened libraries here ********************/

    if (LayersBase)
      CloseLibrary(LayersBase);
    if (MUIMasterBase)
      CloseLibrary(MUIMasterBase);

    /******************************************************************/

    FreeMem((APTR)(((UBYTE *) Library) - Library->LibNode.lib_NegSize),
            (Library->LibNode.lib_NegSize+Library->LibNode.lib_PosSize));
  }
  else
    Library->LibNode.lib_Flags |= LIBF_DELEXP;

  return SegList;
}

/******************************************************************************/
/*                                                                            */
/* a do nothing stub (required!)                                              */
/*                                                                            */
/******************************************************************************/

APTR LibExtFunc(void)
{
  return 0;
}

/******************************************************************************/
/*                                                                            */
/* MUI_Mcc_Query stub                                                         */
/*                                                                            */
/******************************************************************************/

ULONG LibMCC_Query(void)
{
  register LONG d0 asm("d0");
  LONG which = d0;
  return (MUI_Mcc_Query(which));
}

/******************************************************************************/
/*                                                                            */
/* end of libinit.c                                                           */
/*                                                                            */
/******************************************************************************/

