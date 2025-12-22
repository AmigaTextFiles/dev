#ifndef EXAMPLE_LIBINIT_C
#define EXAMPLE_LIBINIT_C

/* Programmheader

	Name:		libinit.c
	Main:		example
	Versionstring:	$VER: libinit.c 1.1 (21.09.2002)
	Author:		SDI
	Distribution:	Freeware
	Description:	all the library initialization stuff

 1.0   25.06.00 : first version
 1.1   21.09.02 : added 3rd function
*/

#include <exec/execbase.h>
#include <exec/resident.h>
#include <intuition/intuitionbase.h>
#include <proto/exec.h>
#include <proto/utility.h>
#include "libinfo.h"

#ifdef __MORPHOS__
#ifndef RTF_PPC
#define RTF_PPC (1<<3) /* rt_Init points to a PPC function */
#endif
#ifndef FUNCARRAY_32BIT_QUICK_NATIVE
#define FUNCARRAY_32BIT_QUICK_NATIVE 0xFFFBFFFB
#endif
/* To tell the loader that this is a new emulppc elf and not
 * one for the ppc.library. */
ULONG __amigappc__=1;
#endif

/************************************************************************/

/* First executable routine of this library; must return an error
   to the unsuspecting caller */
LONG ReturnError(void)
{
  return -1;
}

/************************************************************************/

/* natural aligned! */
struct LibInitData {
 UBYTE i_Type;     UBYTE o_Type;     UBYTE  d_Type;	UBYTE p_Type;
 UWORD i_Name;     UWORD o_Name;     STRPTR d_Name;
 UBYTE i_Flags;    UBYTE o_Flags;    UBYTE  d_Flags;	UBYTE p_Flags;
 UBYTE i_Version;  UBYTE o_Version;  UWORD  d_Version;
 UBYTE i_Revision; UBYTE o_Revision; UWORD  d_Revision;
 UWORD i_IdString; UWORD o_IdString; STRPTR d_IdString;
 ULONG endmark;
};

/************************************************************************/
extern const ULONG LibInitTable[4]; /* the prototype */

/* The library loader looks for this marker in the memory
   the library code and data will occupy. It is responsible
   setting up the Library base data structure. */
const struct Resident RomTag = {
  RTC_MATCHWORD,                   /* Marker value. */
  (struct Resident *)&RomTag,      /* This points back to itself. */
  (struct Resident *)LibInitTable, /* This points somewhere behind this marker. */
#ifdef __MORPHOS__
  RTF_PPC|
#endif
  RTF_AUTOINIT,                    /* The Library should be set up according to the given table. */
  VERSION,                         /* The version of this Library. */
  NT_LIBRARY,                      /* This defines this module as a Library. */
  0,                               /* Initialization priority of this Library; unused. */
  LIBNAME,                         /* Points to the name of the Library. */
  IDSTRING,                        /* The identification string of this Library. */
  (APTR)&LibInitTable              /* This table is for initializing the Library. */
};

/************************************************************************/

/* The mandatory reserved library function */
static ULONG LibReserved(void)
{
  return 0;
}

/* Open the library, as called via OpenLibrary() */
static ASM(struct Library *) LibOpen(REG(a6, struct ExampleBaseP * ExampleBase))
{
  /* Prevent delayed expunge and increment opencnt */
  ExampleBase->exb_LibNode.lib_Flags &= ~LIBF_DELEXP;
  ExampleBase->exb_LibNode.lib_OpenCnt++;

  return &ExampleBase->exb_LibNode;
}

#ifdef BASE_GLOBAL
struct ExecBase *      SysBase       = 0;
struct IntuitionBase * IntuitionBase = 0;
struct UtilityBase *   UtilityBase   = 0;
struct ExampleBase *   ExampleBase   = 0;

static void MakeGlobalLibs(struct ExampleBaseP *exampleBase)
{
  IntuitionBase = exampleBase->exb_IntuitionBase;
  UtilityBase =   exampleBase->exb_UtilityBase;
  ExampleBase   = (struct ExampleBase *) exampleBase;
}
static void MakeGlobalSys(struct ExampleBaseP *exampleBase)
{
  SysBase = exampleBase->exb_SysBase;
}
#endif

/* Closes all the libraries opened by LibInit() */
static void CloseLibraries(struct ExampleBaseP * ExampleBase)
{
#ifndef BASE_GLOBAL
  struct ExecBase *SysBase = ExampleBase->exb_SysBase;
#endif

  if(ExampleBase->exb_IntuitionBase)
    CloseLibrary((struct Library *) ExampleBase->exb_IntuitionBase);
  if(ExampleBase->exb_UtilityBase)
    CloseLibrary((struct Library *) ExampleBase->exb_UtilityBase);
}

/* Expunge the library, remove it from memory */
static ASM(SEGLISTPTR) LibExpunge(REG(a6, struct ExampleBaseP * ExampleBase))
{
#ifndef BASE_GLOBAL
  struct ExecBase *SysBase = ExampleBase->exb_SysBase;
#endif

  if(!ExampleBase->exb_LibNode.lib_OpenCnt)
  {
    SEGLISTPTR seglist;

    seglist = ExampleBase->exb_SegList;

    CloseLibraries(ExampleBase);

    /* Remove the library from the public list */
    Remove((struct Node *) ExampleBase);

    /* Free the vector table and the library data */
    FreeMem((STRPTR) ExampleBase - ExampleBase->exb_LibNode.lib_NegSize,
    ExampleBase->exb_LibNode.lib_NegSize +
    ExampleBase->exb_LibNode.lib_PosSize);

    return seglist;
  }
  else
    ExampleBase->exb_LibNode.lib_Flags |= LIBF_DELEXP;

  /* Return the segment pointer, if any */
  return 0;
}

/* Close the library, as called by CloseLibrary() */
static ASM(SEGLISTPTR) LibClose(REG(a6, struct ExampleBaseP * ExampleBase))
{
  if(!(--ExampleBase->exb_LibNode.lib_OpenCnt))
  {
    if(ExampleBase->exb_LibNode.lib_Flags & LIBF_DELEXP)
      return LibExpunge(ExampleBase);
  }
  return 0;
}

/* Initialize library */
#ifdef __MORPHOS__
static struct Library * LibInit(struct ExampleBaseP * ExampleBase,
SEGLISTPTR seglist, struct ExecBase *SysBase)
#else
static ASM(struct Library *) LibInit(REG(a0, SEGLISTPTR seglist),
REG(d0, struct ExampleBaseP * ExampleBase), REG(a6, struct ExecBase *SysBase))
#endif
{
#ifdef _M68060
  if(!(SysBase->AttnFlags & AFF_68060))
    return 0;
#elif defined (_M68040)
  if(!(SysBase->AttnFlags & AFF_68040))
    return 0;
#elif defined (_M68030)
  if(!(SysBase->AttnFlags & AFF_68030))
    return 0;
#elif defined (_M68020)
  if(!(SysBase->AttnFlags & AFF_68020))
    return 0;
#endif

  /* Remember stuff */
  ExampleBase->exb_SegList = seglist;
  ExampleBase->exb_SysBase = SysBase;

#ifdef BASE_GLOBAL
  MakeGlobalSys(ExampleBase);
#endif

  if((ExampleBase->exb_IntuitionBase = (struct IntuitionBase *) OpenLibrary("intuition.library", 37)))
  {
    if((ExampleBase->exb_UtilityBase = (struct UtilityBase *) OpenLibrary("utility.library", 37)))
    {
#ifdef BASE_GLOBAL
      MakeGlobalLibs(ExampleBase);
#endif
      return &ExampleBase->exb_LibNode;
    }
    CloseLibraries(ExampleBase);
  }

  /* Free the vector table and the library data */
  FreeMem((STRPTR) ExampleBase - ExampleBase->exb_LibNode.lib_NegSize,
  ExampleBase->exb_LibNode.lib_NegSize +
  ExampleBase->exb_LibNode.lib_PosSize);

  return 0;
}

/************************************************************************/

/* This is the table of functions that make up the library. The first
   four are mandatory, everything following it are user callable
   routines. The table is terminated by the value -1. */

static const APTR LibVectors[] = {
#ifdef __MORPHOS__
  (APTR) FUNCARRAY_32BIT_QUICK_NATIVE,
#endif
  (APTR) LibOpen,
  (APTR) LibClose,
  (APTR) LibExpunge,
  (APTR) LibReserved,
  (APTR) LIBex_TestRequest,
  (APTR) LIBex_TestRequest2A,
  (APTR) LIBex_TestRequest3,
  (APTR) -1
};

static const struct LibInitData LibInitData = {
 0xA0,   (UBYTE) OFFSET(Node,    ln_Type),      NT_LIBRARY,                0,
 0xC000, (UBYTE) OFFSET(Node,    ln_Name),      LIBNAME,
 0xA0,   (UBYTE) OFFSET(Library, lib_Flags),    LIBF_SUMUSED|LIBF_CHANGED, 0,
 0x90,   (UBYTE) OFFSET(Library, lib_Version),  VERSION,
 0x90,   (UBYTE) OFFSET(Library, lib_Revision), REVISION,
 0xC000, (UBYTE) OFFSET(Library, lib_IdString), IDSTRING,
 0
};

/* The following data structures and data are responsible for
   setting up the Library base data structure and the library
   function vector.
*/
const ULONG LibInitTable[4] = {
  (ULONG)sizeof(struct ExampleBaseP), /* Size of the base data structure */
  (ULONG)LibVectors,             /* Points to the function vector */
  (ULONG)&LibInitData,           /* Library base data structure setup table */
  (ULONG)LibInit                 /* The address of the routine to do the setup */
};

#endif /* EXAMPLE_LIBINIT_C */
