/*
 * ToolManagerLib.h  V2.1.07
 *
 * shared library main include file
 *
 * (c) 1990-1996 Stefan Becker
 */

/* System include files */
#include <exec/types.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <exec/resident.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#include <devices/timer.h>
#include <envoy/nipc.h>
#include <envoy/errors.h>
#include <graphics/gfxmacros.h>
#include <intuition/intuitionbase.h>
#include <libraries/iffparse.h>
#include <libraries/locale.h>
#include <libraries/screennotify.h>
#include <libraries/toolmanager.h>
#include <libraries/wbstart.h>
#include <prefs/prefhdr.h>
#include <rexx/errors.h>
#include <workbench/workbench.h>
#include <workbench/startup.h>

/* System function prototypes */
#include <clib/alib_protos.h>
#include <clib/commodities_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/icon_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/intuition_protos.h>
#include <clib/locale_protos.h>
#include <clib/nipc_protos.h>
#include <clib/rexxsyslib_protos.h>
#include <clib/screennotify_protos.h>
#include <clib/utility_protos.h>
#include <clib/wb_protos.h>
#include <clib/wbstart_protos.h>

/* System function pragmas */
#include <pragmas/commodities_pragmas.h>
#include <pragmas/diskfont_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/iffparse_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/nipc_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>
#include <pragmas/screennotify_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/wb_pragmas.h>
#include <pragmas/wbstart_pragmas.h>

/* ANSI C include files */
#include <stdlib.h>
#include <string.h>

/* Compiler specific include files */
#include <lists.h>     /* GetHead() et al. */

/* Project specific include files */
#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#include "/locale/toolmanager.h"
#include "/ToolManagerPrefs.h"

/* Library <-> Handler IPC commands */
#define TMIPC_AllocTMHandle  0
#define TMIPC_FreeTMHandle   1
#define TMIPC_CreateTMObject 2
#define TMIPC_DeleteTMObject 3
#define TMIPC_ChangeTMObject 4

/* Image object activation commands */
#define IOC_DEACTIVE 1
#define IOC_ACTIVE   2
#define IOC_FULLANIM 3
#define IOC_CONTANIM 4

/* Menu IDs */
#define MENU_CLOSE 0
#define MENU_QUIT  1

/* Hook function prototype */
typedef ULONG (*HookFuncPtr)(__A0 struct Hook *, __A1 void *, __A2 void *);

/* Data structures */
struct TMHandle {
                 struct Message  tmh_Msg;      /* Library <-> Handler IPC */
                 UBYTE           tmh_Command;  /* Library <-> Handler IPC */
                 UBYTE           tmh_Type;     /* object type */
                 char           *tmh_Object;   /* object name */
                 struct TagItem *tmh_Tags;     /* object parameters */
                 struct List     tmh_ObjectLists[TMOBJTYPES];
                };

struct TMObject {
                 struct MinNode  tmo_Node;
                 struct List     tmo_Links;
                 char           *tmo_Name;
                 UBYTE           tmo_Type;
                 UBYTE           tmo_Pad;
                 /* will be extended different for each object type */
                };

struct TMLink {
               struct MinNode   tml_Node;
               ULONG            tml_Size;     /* size of structure */
               struct TMObject *tml_Linked;   /* linked object */
               struct TMObject *tml_LinkedTo; /* obj. is linked to this obj. */
               void            *tml_Active;   /* linked object is active */
               /* will be extended different for each object type */
              };

struct TMLinkImage { /* a link to an Image object */
                    struct TMLink    tmli_Link;
                    struct RastPort *tmli_RastPort; /* Draw images here */
                    UWORD            tmli_LeftEdge; /* (x,y) in RastPort */
                    UWORD            tmli_TopEdge;
                    UWORD            tmli_Width;    /* Image size */
                    UWORD            tmli_Height;
                    struct Image    *tmli_Normal;
                    struct Image    *tmli_Selected;
                   };

struct TMTimerReq {
                   struct timerequest  tmtr_Request;
                   struct TMLink      *tmtr_Link;
                  };

/* Library internal function prototypes */
/* config.c */
void ReadConfig(void);
void FreeConfig(void);

/* dockobj.c */
void ScreenCloseRequest(struct TMObject *, struct Screen *);
void ScreenOpenRequest(struct TMObject *, char *);
void HandleIDCMPEvents(void);

/* execobj.c */
BOOL CopyPathList(struct PathList **pla, struct PathList **plc,
                  struct PathList *oldpl);
void FreePathList(struct PathList *pla);

/* handler.c */
__geta4 void HandlerEntry(void);

/* locale.c */
void GetLocale(void);
void FreeLocale(void);

/* objects.c */
BOOL InternalCreateTMObject(struct TMHandle *handle, char *object, ULONG type,
                            struct TagItem *tags);
BOOL CallDeleteTMObject(struct TMObject *tmobj);
BOOL InternalDeleteTMObject(struct TMHandle *handle, char *object);
BOOL InternalChangeTMObject(struct TMHandle *handle, char *object,
                            struct TagItem *tags);
struct TMObject *AllocateTMObject(ULONG size);
struct TMLink *AddLinkTMObject(struct TMHandle *handle, char *object,
                               ULONG type, struct TMObject *linkedto);
void RemLinkTMObject(struct TMLink *tml);
void DeleteAllLinksTMObject(struct TMObject *tmobj);
void CallActivateTMObject(struct TMLink *tml, void *args);

/* readiff.c */
struct TMImageData *ReadIFFData(char *name);
void FreeIFFData(struct TMImageData *tmid);

/* rexx.c */
BOOL SendARexxCommand(char *command, ULONG len);

/* safety.c */
void SafeDeleteCxObjAll(struct CxObj *cxobj, struct TMLink *tml);
void SafeRemoveAppMenuItem(void *appmenu, struct TMLink *tml);
void SafeRemoveAppIcon(void *appicon, struct TMLink *tml);
void SafeRemoveAppWindow(void *appwin, struct TMLink *tml);

/* tmhandle.c */
BOOL InternalAllocTMHandle(struct TMHandle *handle);
BOOL InternalFreeTMHandle(struct TMHandle *handle);

/* workbench.c */
BOOL GetWorkbench(void);
void FreeWorkbench(void);

/* System library base pointers */
extern struct Library *CxBase;
extern struct Library *DOSBase;
extern struct Library *GadToolsBase;
extern struct Library *GfxBase;
extern struct Library *IFFParseBase;
extern struct IntuitionBase *IntuitionBase;
extern struct Library *NIPCBase;
extern struct Library *ScreenNotifyBase;
extern struct Library *SysBase;
extern struct Library *UtilityBase;
extern struct Library *WorkbenchBase;
extern struct Library *WBStartBase;

/* Global data */
extern const struct TagItem HandlerProcessTags[];
extern struct MsgPort *LibraryPort;
extern struct MsgPort *DummyPort;
extern struct MsgPort *IDCMPPort;
extern struct MsgPort *TimerPort;
extern struct MsgPort *AppMsgPort;
extern struct MsgPort *BrokerPort;
extern struct MsgPort *ScreenNotifyPort;
extern struct Entity  *LocalEntity;
extern struct timerequest *deftimereq;
extern struct TMHandle *PrivateTMHandle;
extern CxObj *Broker;
extern struct PathList *GlobalPath;
extern BOOL Closing;
extern struct NewBroker BrokerData;
extern struct NewMenu DockMenu[];
extern char ToolManagerName[];
extern char PrefsFileName[];
extern char DefaultNoName[];
extern char DefaultDirName[];
extern char DefaultOutput[];
extern char DefaultPortName[];

/* Global defines */
#define TMVERSION     "2.1b"
#define TMLIBREVISION 2
#define TMCRYEAR      "1990-96"

#ifdef DEBUG
__stkargs void kputs(char *);
__stkargs char kgetc(void);
__stkargs void kprintf(char *,...);

#define DEBUG_PUTSTR(a) kputs(a);
#define DEBUG_GETCHR    kgetc();
#define DEBUG_PRINTF(a,b)  kprintf(a,b);
#else
#define DEBUG_PUTSTR(a)
#define DEBUG_GETCHR
#define DEBUG_PRINTF(a,b)
#endif
