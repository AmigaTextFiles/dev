/*
 * umsrfc.c V1.0.00
 *
 * Library routines
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umsrfc.h"

/*
 * Object file dummy entry point
 */
static ULONG Dummy(void)
{
 return(0);
}

/* Library name and ID string */
static const char LibraryName[] = UMSRFC_LIBRARY_NAME;
static const char LibraryID[]   = "$VER: " UMSRFC_LIBRARY_NAME " "
                                  INTTOSTR(UMSRFC_LIBRARY_VERSION) "."
                                  INTTOSTR(UMSRFC_LIBRARY_REVISION) " ("
#ifdef _DCC
                                  __COMMODORE_DATE__
#elif __SASC
#error Current date not defined!
#else
#error Current date not defined!
#endif
                                  ")\r\n";

/* Standard library function prototypes */
__LIB_PREFIX static struct Library *LibraryInit(__LIB_ARG(A0) BPTR,
                                                __LIB_ARG(A6) struct Library *);
__LIB_PREFIX static struct Library *LibraryOpen(__LIB_ARG(A6) struct Library *);
__LIB_PREFIX static BPTR  LibraryClose(__LIB_ARG(A6) struct Library *);
__LIB_PREFIX static BPTR  LibraryExpunge(__LIB_ARG(A6) struct UMSRFCBase *);
             static ULONG LibraryReserved(void);

/* ROMTag structure */
static const struct Resident ROMTag = { RTC_MATCHWORD, &ROMTag, &ROMTag + 1, 0,
 UMSRFC_LIBRARY_VERSION, NT_LIBRARY, 0, LibraryName, LibraryID, LibraryInit
};

/* Library functions table */
static const APTR LibraryVectors[] = {
 /* Standard functions */
 (APTR) LibraryOpen,
 (APTR) LibraryClose,
 (APTR) LibraryExpunge,
 (APTR) LibraryReserved,

 /* Library specific functions */
 (APTR) LibraryReserved, /* reserved for ARexx entry point */
 (APTR) UMSRFCAllocData,
 (APTR) UMSRFCFreeData,
 (APTR) UMSRFCVLog,
 (APTR) UMSRFCFlushLog,
 (APTR) UMSRFCConvertUMSAddress,
 (APTR) UMSRFCConvertRFCAddress,
 (APTR) UMSRFCGetMessage,
 (APTR) UMSRFCFreeMessage,
 (APTR) UMSRFCWriteMessage,
 (APTR) UMSRFCReadMessage,
 (APTR) UMSRFCPutMailMessage,
 (APTR) UMSRFCPutNewsMessage,
 (APTR) UMSRFCPrintTime,
 (APTR) UMSRFCPrintCurrentTime,
 (APTR) UMSRFCGetTime,

 /* End of table */
 (APTR) -1
};

/* Library bases */
struct Library *SysBase = NULL;

/* Initialize library */
__LIB_PREFIX static struct Library *LibraryInit(__LIB_ARG(A0) BPTR Segment,
                                                __LIB_ARG(A6) struct Library *ExecBase)
{
 struct UMSRFCBase *urb;

 /* Initialize SysBase */
 SysBase = ExecBase;

 if (urb = (struct UMSRFCBase *) MakeLibrary(LibraryVectors, NULL, NULL,
                                             sizeof(struct UMSRFCBase),
                                             NULL)) {

  /* Initialize libray structure */
  urb->urb_Library.lib_Node.ln_Type = NT_LIBRARY;
  urb->urb_Library.lib_Node.ln_Name = LibraryName;
  urb->urb_Library.lib_Flags        = LIBF_CHANGED | LIBF_SUMUSED;
  urb->urb_Library.lib_Version      = UMSRFC_LIBRARY_VERSION;
  urb->urb_Library.lib_Revision     = UMSRFC_LIBRARY_REVISION;
  urb->urb_Library.lib_IdString     = (APTR) LibraryID;
  urb->urb_Segment                  = Segment;

  /* Add the library to the system */
  AddLibrary((struct Library *) urb);
 }

 /* Return new library pointer */
 return(urb);
}

/* Standard library function: Open */
__LIB_PREFIX static struct Library *LibraryOpen(__LIB_ARG(A6) struct Library *lib)
{
 /* Oh another user :-) */
 lib->lib_OpenCnt++;

 /* Reset delayed expunge flag */
 lib->lib_Flags &= ~LIBF_DELEXP;

 /* Return library pointer */
 return(lib);
}

/* Standard library function: Close */
__LIB_PREFIX static BPTR LibraryClose(__LIB_ARG(A6) struct Library *lib)
{
 /* Open count already zero or more than one user? */
 if ((lib->lib_OpenCnt == 0) || (--lib->lib_OpenCnt > 0))
  return(NULL);

 /* Is the delayed expunge bit set? Yes, try to remove the library */
 if (lib->lib_Flags & LIBF_DELEXP)
  return(LibraryExpunge((struct UMSRFCBase *) lib));

 /* No. Don't remove library now */
 return(NULL);
}

/* Standard library function: Expunge */
__LIB_PREFIX static BPTR LibraryExpunge(__LIB_ARG(A6) struct UMSRFCBase *urb)
{
 BPTR rc = NULL;

 /* Does anyone use library now? */
 if (urb->urb_Library.lib_OpenCnt > 0) {
  /* Yes, library still in use -> set delayed expunge flag */
  urb->urb_Library.lib_Flags |= LIBF_DELEXP;

 } else {
  /* No, remove library */
  Remove(&urb->urb_Library.lib_Node);

  /* Return library segment */
  rc = urb->urb_Segment;

  /* Free memory for library base */
  FreeMem((void *) ((ULONG) urb - urb->urb_Library.lib_NegSize),
           urb->urb_Library.lib_NegSize + urb->urb_Library.lib_PosSize);
 }

 return(rc);
}

/* Reserved function, returns NULL */
static ULONG LibraryReserved(void)
{
 return(NULL);
}
