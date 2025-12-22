Needed defines (do a search and replace in your editor):

XXX           Library base name, e.g. screennotify

XXX_NAME      Library base name with ".library" appended
              Defined in <libraries/XXX.h>, e.g.

                  #define SCREENNOTIFY_NAME "screennotify.library"

XXX_VERSION   Library version
              Defined in <libraries/XXX.h>, e.g.

                  #define SCREENNOTIFY_VERSION 1

XXX_REVISION  Library revision
              Defined in "XXX.h", e.g.

                  #define SCREENNOTIFY_VERSION 1

XXXBase       Library base data structure
              Defined in "XXX.h", e.g.

                  struct ScreenNotifyBase {
                   struct Library snb_Library;
                   UWORD          snb_Pad;
                   BPTR           snb_Segment;
                   /* Other private library global data */
                  },

xxxb          Pointer to library base in functions, e.g. snb
              (Abbreviation of library base data structure name)


Include files:

"XXX.h"                  Local include file for library source.
                         Contains all private library declarations.

<clib/XXX_protos.h>      Library function prototypes

<libraries/XXX.h>        Public library include file.
                         Contains all public library declarations.

<pragmas/XXX_pragmas.h>  Library function inline call declarations


Other files:

FD/XXX_lib.fd            Library function offsets & register deklaration file

/*
 * XXX.c V0.0.00
 *
 * Library routines
 *
 * (c) 1995-96 Stefan Becker
 */

#include "XXX.h"

/*
 * Object file dummy entry point
 */
static ULONG Dummy(void)
{
 return(0);
}

/* Library name and ID string */
#define INTTOSTR(a) #a
static const char LibraryName[] = XXX_NAME;
static const char LibraryID[]   = "$VER: " XXX_NAME " "
                                  INTTOSTR(XXX_VERSION) "."
                                  INTTOSTR(XXX_REVISION)
                                  " (" __COMMODORE_DATE__ ")\r\n";

/* Standard library function prototypes */
__geta4 static struct Library *LibraryInit(__A0 BPTR, __A6 struct Library *);
__geta4 static struct Library *LibraryOpen(__A6 struct XXXBase *);
__geta4 static BPTR            LibraryClose(__A6 struct XXXBase *);
__geta4 static BPTR            LibraryExpunge(__A6 struct XXXBase *);
        static ULONG           LibraryReserved(void);

/* Library specific function prototypes */
<...>

/* ROMTag structure */
static const struct Resident ROMTag = { RTC_MATCHWORD, &ROMTag, &ROMTag + 1, 0,
 XXX_VERSION, NT_LIBRARY, 0, LibraryName, LibraryID, LibraryInit
};

/* Library functions table */
static const APTR LibraryVectors[] = {
 /* Standard functions */
 (APTR) LibraryOpen,
 (APTR) LibraryClose,
 (APTR) LibraryExpunge,
 (APTR) LibraryReserved,

 /* Library specific functions */
 (APTR) <1st library specific function> /* Reserve this one for ARexx! */
 (APTR) <2nd library specific function>
 ....

 /* End of table */
 (APTR) -1
};

/* Global library bases */
struct Library *SysBase;
struct XXXBase *XXXBase;

/* Initialize library */
__geta4 static struct Library *LibraryInit(__A0 BPTR Segment,
                                           __A6 struct Library *ExecBase)
{
 struct XXXBase *xxxb = NULL;

 /* Initialize SysBase */
 SysBase = ExecBase;

 if (xxxb = (struct XXXBase *) MakeLibrary(LibraryVectors, NULL, NULL,
                                            sizeof(struct XXXBase), NULL)) {
  /* Initialize libray structure */
  xxxb->xxxb_Library.lib_Node.ln_Type = NT_LIBRARY;
  xxxb->xxxb_Library.lib_Node.ln_Name = LibraryName;
  xxxb->xxxb_Library.lib_Flags        = LIBF_CHANGED | LIBF_SUMUSED;
  xxxb->xxxb_Library.lib_Version      = XXX_VERSION;
  xxxb->xxxb_Library.lib_Revision     = XXX_REVISION;
  xxxb->xxxb_Library.lib_IdString     = (APTR) LibraryID;
  xxxb->xxxb_Segment                  = Segment;

  <.... get other resources for the library ...>

  /* Add the library to the system */
  AddLibrary((struct Library *) wbsb);

  /* Set global library base pointer */
  XXXBase = xxxb;
 }

 /* Return new library pointer */
 return((struct Library *) xxxb);
}

/* Standard library function: Open. Called in Forbid() state */
__geta4 static struct Library *LibraryOpen(__A6 struct XXXBase *xxxb)
{
 /* Oh another user :-) */
 xxxb->xxxb_Library.lib_OpenCnt++;

 /* Reset delayed expunge flag */
 xxxb->xxxb_Library.lib_Flags &= ~LIBF_DELEXP;

 /* Return library pointer */
 return(&xxxb->xxxb_Library);
}

/* Standard library function: Close. Called in Forbid() state */
__geta4 static BPTR LibraryClose(__A6 struct XXXBase *xxxb)
{
 BPTR rc = NULL;

 /* Open count greater zero, only one user and delayed expunge bit set? */
 if ((xxxb->xxxb_Library.lib_OpenCnt > 0) &&
     (--xxxb->xxxb_Library.lib_OpenCnt == 0) &&
     (xxxb->xxxb_Library.lib_Flags & LIBF_DELEXP))

  /* Yes, try to remove the library */
  rc = LibraryExpunge(xxxb);

 /* Return library segment if expunge was successful */
 return(rc);
}

/* Standard library function: Expunge. Called in Forbid() state */
__geta4 static BPTR LibraryExpunge(__A6 struct XXXBase *xxxb)
{
 BPTR rc = NULL;

 /* Does anybody use library now? */
 if (xxxb->xxxb_Library.lib_OpenCnt > 0)

  /* No, library still in use -> set delayed expunge flag */
  xxxb->xxxb_Library.lib_Flags |= LIBF_DELEXP;

 else {
  /* Yes, remove library */
  Remove(&xxxb->xxxb_Library.lib_Node);

  <... Free other library resources ...>

  /* Return library segment */
  rc = xxxb->xxxb_Segment;

  /* Free memory for library base */
  FreeMem((void *) ((ULONG) xxxb - xxxb->xxxb_Library.lib_NegSize),
          xxxb->xxxb_Library.lib_NegSize + xxxb->xxxb_Library.lib_PosSize);
 }

 /* Return library segment if expunge was successful */
 return(rc);
}

/* Reserved function, returns NULL */
static ULONG LibraryReserved(void)
{
 return(0);
}
