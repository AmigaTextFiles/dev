/*
 * LibInit.c  V2.1.02
 *
 * shared library C stub
 *
 * (c) 1990-1995 Stefan Becker
 */

#include "ToolManagerLib.h"

/*
 * Object file dummy entry point
 */
static ULONG Dummy(void)
{
 return(0);
}

/* library name & id string */
#define INTTOSTR(a) #a
const char LibName[]=TMLIBNAME;
const char LibId[]="$VER: " TMLIBNAME " " INTTOSTR(TMLIBVERSION) "."
                   INTTOSTR(TMLIBREVISION) " (" __COMMODORE_DATE__ ")\r\n";

/* prototypes for library management functions */
__geta4 static struct Library *LibInit(__A0 BPTR, __A6 struct Library *);
__geta4 static struct Library *LibOpen(__A6 struct Library *);
__geta4 static BPTR            LibClose(__A6 struct Library *);
__geta4 static BPTR            LibExpunge(__A6 struct Library *);
        static ULONG           LibReserved(void);
__geta4 static void            QuitToolManager(void);
__geta4 struct TMHandle       *AllocTMHandle(void);
__geta4 static void            FreeTMHandle(__A0 struct TMHandle *);
__geta4 static BOOL            CreateTMObjectTagList(__A0 struct TMHandle *,
                                                     __A1 char *, __D0 ULONG,
                                                     __A2 struct TagItem *);
__geta4 static BOOL            DeleteTMObject(__A0 struct TMHandle *,
                                              __A1 char *);
__geta4 static BOOL            ChangeTMObjectTagList(__A0 struct TMHandle *,
                                                     __A1 char *,
                                                     __A2 struct TagItem *);

/* ROMTag structure */
static const struct Resident ROMTag = {
                                       RTC_MATCHWORD,
                                       &ROMTag,
                                       &ROMTag + 1,
                                       0,             /* Flags */
                                       TMLIBVERSION,
                                       NT_LIBRARY,
                                       0,             /* Priority */
                                       LibName,
                                       LibId,
                                       LibInit
                                      };

/* library functions table */
static const APTR LibVectors[]={
                                /* Standard functions */
                                (APTR) LibOpen,
                                (APTR) LibClose,
                                (APTR) LibExpunge,
                                (APTR) NULL,

                                /* Library specific functions */
                                (APTR) LibReserved, /* reserved for ARexx */
                                (APTR) QuitToolManager,
                                (APTR) AllocTMHandle,
                                (APTR) FreeTMHandle,
                                (APTR) CreateTMObjectTagList,
                                (APTR) DeleteTMObject,
                                (APTR) ChangeTMObjectTagList,

                                /* Table end */
                                (APTR) -1
                                };

/* misc. data */
static BPTR LibSegment=NULL;
static struct Library *PrivateDOSBase=NULL;
static struct Task *HandlerTask;
struct Library *SysBase=NULL;
struct Library *LibBase=NULL;
BOOL Closing=FALSE;
const char DosName[]="dos.library";

/* Prototype & pragma for local calls to CreateNewProc() */
struct Task *MyCreateNewProc(struct TagItem *tags);
#pragma libcall PrivateDOSBase MyCreateNewProc 1f2 101

/* library init routine */
__geta4 static struct Library *LibInit(__A0 BPTR LibSegList,
                                       __A6 struct Library *ExecBase)
{
 struct Library *MyLib;

 /* Initialize SysBase */
 SysBase = ExecBase;

 /* Open dos.library */
 if (!(PrivateDOSBase=OpenLibrary(DosName,37))) return(0);

 LibSegment=LibSegList;

 if (!(LibBase=MyLib=MakeLibrary(LibVectors, NULL, NULL,
                                 sizeof(struct Library), NULL))) {
  CloseLibrary(PrivateDOSBase);
  return(0);
 }

 MyLib->lib_Node.ln_Type=NT_LIBRARY;
 MyLib->lib_Node.ln_Name=LibName;
 MyLib->lib_Flags=LIBF_CHANGED|LIBF_SUMUSED;
 MyLib->lib_Version=TMLIBVERSION;
 MyLib->lib_Revision=TMLIBREVISION;
 MyLib->lib_IdString=(APTR) LibId;
 AddLibrary(MyLib);

 DEBUG_PRINTF("Init Lib: %08lx ",MyLib);
 DEBUG_PRINTF("Seg: %08lx\n",LibSegment);

 return(MyLib);
}

/* shared library open function */
__geta4 static struct Library *LibOpen(__A6 struct Library *lib)
{
 /* Handle special case: OpenCnt=0 & Handler is just closing down */
 if ((lib->lib_OpenCnt == 0) && Closing) return(NULL);

 /* Handler active? Try to start it... */
 if (!LibraryPort && !(HandlerTask=MyCreateNewProc(HandlerProcessTags)))
  return(NULL);

 /* Oh another user :-) */
 lib->lib_OpenCnt++;

 /* Reset delayed expunge flag */
 lib->lib_Flags&=~LIBF_DELEXP;

 /* Return library pointer */
 DEBUG_PRINTF("Open Lib: %ld\n",lib->lib_OpenCnt);
 return(lib);
}

/* shared library close function */
__geta4 static BPTR LibClose(__A6 struct Library *lib)
{
 /* Open count already zero or more than one user? */
 if ((lib->lib_OpenCnt == 0) || (--lib->lib_OpenCnt > 0)) return(NULL);

 /* Is handler active? Yes, send him a signal if he should shut down */
 if (LibraryPort && Closing) Signal(HandlerTask,SIGBREAKF_CTRL_F);

 /* Is the delayed expunge bit set?  Yes, try to remove the library */
 if (lib->lib_Flags & LIBF_DELEXP) return(LibExpunge(lib));

 /* No. Don't remove library now */
 return(NULL);
}

/* shared library expunge function */
__geta4 static BPTR LibExpunge(__A6 struct Library *lib)
{
 DEBUG_PRINTF("Expunge Lib: %08lx ",lib);
 DEBUG_PRINTF("Seg: %08lx\n",LibSegment);

 /* Does no-one use library now or is handler active/closing down?? */
 if ((lib->lib_OpenCnt > 0) || LibraryPort || Closing) {
  /* No, library still in use -> set delayed expunge flag */
  lib->lib_Flags|=LIBF_DELEXP;
  return(NULL);
 }

 /* Yes, remove library and free resources */
 Remove(&lib->lib_Node);
 FreeMem((void *) ((ULONG) lib-lib->lib_NegSize),
         lib->lib_NegSize+lib->lib_PosSize);
 if (PrivateDOSBase) {
  CloseLibrary(PrivateDOSBase);
  PrivateDOSBase=NULL;
 }

 /* return BPTR to our seglist */
 DEBUG_PUTSTR("Removing library...\n");
 return(LibSegment);
}

/* Reserved function, returns NULL */
static ULONG LibReserved(void)
{
 return(NULL);
}

/* Set quit flag for handler process */
__geta4 static void QuitToolManager(void)
{
 /* Set flag */
 if (LibraryPort && !Closing) Closing=TRUE;
}

/* Send IPC message */
static BOOL SendIPC(struct TMHandle *handle)
{
 /* Handler ready? */
 if (LibraryPort) {
  /* Yep, send message */
  PutMsg(LibraryPort,(struct Message *) handle);

  /* Wait on reply */
  WaitPort(handle->tmh_Msg.mn_ReplyPort);

  /* Get reply */
  GetMsg(handle->tmh_Msg.mn_ReplyPort);

  /* get return code */
  return(handle->tmh_Command);
 }

 /* Oops nobody listening :-( */
 return(FALSE);
}

/* Allocate a TMHandle */
__geta4 void *AllocTMHandle(void)
{
 struct TMHandle *handle;

 DEBUG_PRINTF("AllocTMHandle() called.\n");

 /* Allocate memory for handle structure */
 if (handle=AllocMem(sizeof(struct TMHandle),MEMF_PUBLIC)) {
  struct MsgPort *rp;

  /* Create IPC Port */
  if (rp=CreateMsgPort()) {
   /* Init message */
   handle->tmh_Msg.mn_ReplyPort=rp;
   handle->tmh_Msg.mn_Length=sizeof(struct TMHandle);

   /* Send command to handler */
   handle->tmh_Command=TMIPC_AllocTMHandle;
   if (SendIPC(handle)) return(handle); /* All OK. */

   /* Something went wrong */
   DeleteMsgPort(handle->tmh_Msg.mn_ReplyPort);
  }
  FreeMem(handle,sizeof(struct TMHandle));
 }

 /* call failed */
 DEBUG_PRINTF("AllocTMHandle() failed.\n");
 return(NULL);
}

__geta4 static void FreeTMHandle(__A0 struct TMHandle *handle)
{
 /* Send command to handler */
 handle->tmh_Command=TMIPC_FreeTMHandle;
 SendIPC(handle);

 /* Free handle */
 DeleteMsgPort(handle->tmh_Msg.mn_ReplyPort);
 FreeMem(handle,sizeof(struct TMHandle));
}

__geta4 BOOL CreateTMObjectTagList(__A0 struct TMHandle *handle,
                                   __A1 char *object,
                                   __D0 ULONG type,
                                   __A2 struct TagItem *tags)
{
 /* Sanity checks */
 if ((handle==NULL) || (object==NULL) || (type>=TMOBJTYPES))
  return(FALSE); /* Bad arguments! */

 /* Build IPC command */
 handle->tmh_Command=TMIPC_CreateTMObject;
 handle->tmh_Type=type;
 handle->tmh_Object=object;
 handle->tmh_Tags=tags;

 /* Send command to handler */
 return(SendIPC(handle));
}

/* Delete a TMObject (shared library version) */
__geta4 BOOL DeleteTMObject(__A0 struct TMHandle *handle, __A1 char *object)
{
 /* Sanity checks */
 if ((handle==NULL) || (object==NULL)) return(FALSE); /* Bad arguments! */

 /* Build IPC command */
 handle->tmh_Command=TMIPC_DeleteTMObject;
 handle->tmh_Object=object;

 /* Send command to handler */
 return(SendIPC(handle));
}

/* Change a TMObject (shared library version) */
__geta4 BOOL ChangeTMObjectTagList(__A0 struct TMHandle *handle,
                                   __A1 char *object,
                                   __A2 struct TagItem *tags)
{
 /* Sanity checks */
 if ((handle==NULL) || (object==NULL)) return(FALSE); /* Bad arguments! */

 /* Build IPC command */
 handle->tmh_Command=TMIPC_ChangeTMObject;
 handle->tmh_Object=object;
 handle->tmh_Tags=tags;

 /* Send command to handler */
 return(SendIPC(handle));
}

