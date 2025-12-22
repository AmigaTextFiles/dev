/*
 * dospath.c  V1.0
 *
 * Library routines
 *
 * (c) 1996 Stefan Becker
 */

#include "dospath.h"

/*
 * Object file dummy entry point
 */
static ULONG Dummy(void)
{
 return(0);
}

/* Library name, ID string and other constant strings */
#define INTTOSTR(a) #a
static const char LibraryName[] = DOSPATH_NAME;
static const char LibraryID[]   = "$VER: " DOSPATH_NAME " "
                                   INTTOSTR(DOSPATH_VERSION) "."
                                   INTTOSTR(DOSPATH_REVISION)
                                   " (" __COMMODORE_DATE__ ")\r\n";

/* Standard library function prototypes */
__geta4 static struct Library *LibraryInit(__A0 BPTR, __A6 struct Library *);
__geta4 static struct Library *LibraryOpen(__A6 struct DOSPathBase *);
__geta4 static BPTR            LibraryClose(__A6 struct DOSPathBase *);
__geta4 static BPTR            LibraryExpunge(__A6 struct Library *);
        static ULONG           LibraryReserved(void);

/* ROMTag structure */
static const struct Resident ROMTag = { RTC_MATCHWORD, &ROMTag, &ROMTag + 1, 0,
 DOSPATH_VERSION, NT_LIBRARY, 0, LibraryName, LibraryID, LibraryInit
};

/* Library functions table */
static const APTR LibraryVectors[] = {
 /* Standard functions */
 (APTR) LibraryOpen,
 (APTR) LibraryClose,
 (APTR) LibraryExpunge,
 (APTR) LibraryReserved,

 /* Library specific functions */
 (APTR) LibraryReserved, /* reserved for ARexx */
 (APTR) FreePathList,
 (APTR) CopyPathList,
 (APTR) BuildPathListTagList,
 (APTR) FindFileInPathList,
 (APTR) RemoveFromPathList,
 (APTR) GetProcessPathList,
 (APTR) SetProcessPathList,
 (APTR) CopyWorkbenchPathList,

 /* End of table */
 (APTR) -1
};

/* Local data */
static struct DOSPathBase *DOSPathBase    = NULL; /* DCC: Don't remove! */
static BPTR                DOSPathSegment;

/* Global library bases */
struct Library *SysBase;

/* Generate a DOSPath library base */
static struct DOSPathBase *CreateLibraryBase(void)
{
 struct DOSPathBase *dpb;

 if (dpb = (struct DOSPathBase *) MakeLibrary(LibraryVectors, NULL, NULL,
                                              sizeof(struct DOSPathBase),
                                              NULL)) {

  /* Initialize libray structure */
  dpb->dpb_Library.lib_Node.ln_Type = NT_LIBRARY;
  dpb->dpb_Library.lib_Node.ln_Name = LibraryName;
  dpb->dpb_Library.lib_Flags        = LIBF_CHANGED | LIBF_SUMUSED;
  dpb->dpb_Library.lib_Version      = DOSPATH_VERSION;
  dpb->dpb_Library.lib_Revision     = DOSPATH_REVISION;
  dpb->dpb_Library.lib_IdString     = (APTR) LibraryID;
 }

 /* Return pointer to new library base */
 return(dpb);
}

/* Free library base */
static void FreeLibraryBase(struct DOSPathBase *dpb)
{
 FreeMem((void *) ((ULONG) dpb - dpb->dpb_Library.lib_NegSize),
         dpb->dpb_Library.lib_NegSize + dpb->dpb_Library.lib_PosSize);
}

/* Initialize library */
__geta4 static struct Library *LibraryInit(__A0 BPTR Segment,
                                           __A6 struct Library *ExecBase)
{
 struct Library *lib = NULL;

 /* Check OS version, must be OS 2.x or better */
 if (ExecBase->lib_Version >= 37) {

  /* Initialize SysBase */
  SysBase = ExecBase;

  /* Create global library base */
  if (lib = (struct Library *) CreateLibraryBase()) {

   /* Add the library to the system */
   AddLibrary(lib);

   /* Set global pointers */
   DOSPathBase    = (struct DOSPathBase *) lib;
   DOSPathSegment = Segment;

   DEBUGLOG(kprintf("Init Lib: %08lx Seg 0x%08lx\n", lib, Segment);)
  }
 }

 /* Return new library pointer */
 return(lib);
}

/* Standard library function: Open. Called in Forbid() state */
__geta4 static struct Library *LibraryOpen(__A6 struct DOSPathBase *gdb)
{
 struct DOSPathBase *dpb;

 /* Create new library base */
 if (dpb = CreateLibraryBase()) {

  DEBUGLOG(kprintf("Open Lib: Lib 0x%08lx\n", dpb);)

  /* Open dos.library */
  if (dpb->dpb_DOSBase = OpenLibrary("dos.library", 37)) {

   DEBUGLOG(kprintf("Open Lib: DOSBase 0x%08lx\n", dpb->dpb_DOSBase);)

   /* Open utility.library */
   if (dpb->dpb_UtilityBase = OpenLibrary("utility.library", 37)) {

    /* Calculate library checksum */
    SumLibrary((struct Library *) dpb);

    /* Oh another user :-) */
    gdb->dpb_Library.lib_OpenCnt++;
    dpb->dpb_Library.lib_OpenCnt = 1;

    /* Reset delayed expunge flag */
    gdb->dpb_Library.lib_Flags &= ~LIBF_DELEXP;

    DEBUGLOG(kprintf("Open Lib: Open count %ld\n",
             gdb->dpb_Library.lib_OpenCnt);)

   } else {

    /* Couldn't open utility.library */
    CloseLibrary(dpb->dpb_DOSBase);
    FreeLibraryBase(dpb);
    dpb = NULL;
   }
  } else {

   /* Couldn't open dos.library */
   FreeLibraryBase(dpb);
   dpb = NULL;
  }
 }

 /* Return library pointer */
 return((struct Library *) dpb);
}

/* Standard library function: Close. Called in Forbid() state */
__geta4 static BPTR LibraryClose(__A6 struct DOSPathBase *dpb)
{
 BPTR rc = NULL;

 DEBUGLOG(kprintf("Close Lib: Lib 0x%08lx\n", dpb);)

 /* Close Libraries */
 CloseLibrary(dpb->dpb_UtilityBase);
 CloseLibrary(dpb->dpb_DOSBase);

 /* Free library base */
 FreeLibraryBase(dpb);

 /* Open count greater zero, only one user and delayed expunge bit set? */
 if ((DOSPathBase->dpb_Library.lib_OpenCnt > 0) &&
     (--DOSPathBase->dpb_Library.lib_OpenCnt == 0) &&
     (DOSPathBase->dpb_Library.lib_Flags & LIBF_DELEXP))

  /* Yes, try to remove the library */
  rc = LibraryExpunge((struct Library *) DOSPathBase);

 DEBUGLOG(kprintf("Close Lib: Open Count %ld Segment 0x%08lx\n",
                  DOSPathBase->dpb_Library.lib_OpenCnt, rc);)

 /* Return library segment if expunge was successful */
 return(rc);
}

/* Standard library function: Expunge. Called in Forbid() state */
__geta4 static BPTR LibraryExpunge(__A6 struct Library *lib)
{
 BPTR rc = NULL;

 DEBUGLOG(kprintf("Expunge Lib: %08lx Seg: 0x%08lx\n", lib, DOSPathSegment);)

 /* Does anybody use library now? */
 if (lib->lib_OpenCnt > 0)

  /* Yes, library still in use -> set delayed expunge flag */
  lib->lib_Flags |= LIBF_DELEXP;

 else {

  /* No, remove library */
  Remove(&lib->lib_Node);

  /* Return library segment */
  rc = DOSPathSegment;

  /* Free memory for library base */
  FreeLibraryBase((struct DOSPathBase *) lib);

  DEBUGLOG(kprintf("Removing library...\n");)
 }

 /* Return library segment if expunge was successful */
 return(rc);
}

/* Reserved function, returns NULL */
static ULONG LibraryReserved(void)
{
 return(0);
}
