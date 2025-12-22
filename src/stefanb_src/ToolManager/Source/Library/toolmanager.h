/*
 * toolmanager.h  V3.1
 *
 * Library main include file
 *
 * Copyright (C) 1990-98 Stefan Becker
 *
 * This source code is for educational purposes only. You may study it
 * and copy ideas or algorithms from it for your own projects. It is
 * not allowed to use any of the source codes (in full or in parts)
 * in other programs. Especially it is not allowed to create variants
 * of ToolManager or ToolManager-like programs from this source code.
 *
 */

/* OS include files */
#include <datatypes/datatypes.h>
#include <datatypes/pictureclass.h>
#include <datatypes/pictureclassext.h>
#include <dos/dos.h>
#include <dos/dostags.h>
#include <exec/libraries.h>
#include <exec/memory.h>
#include <exec/resident.h>
#include <hardware/blit.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <intuition/intuitionbase.h>
#include <libraries/dospath.h>
#include <libraries/gadtools.h>
#include <libraries/iffparse.h>
#include <libraries/locale.h>
#include <libraries/screennotify.h>
#include <libraries/toolmanager.h>
#include <libraries/wbstart.h>
#include <rexx/errors.h>
#include <workbench/startup.h>

/* Do some redefines to enable DICE register parameters */
#define CoerceMethodA  DummyCMA
#define DoMethodA      DummyDMA
#define DoSuperMethodA DummyDSMA
#include <clib/alib_protos.h>
#undef CoerceMethodA
#undef DoMethodA
#undef DoSuperMethodA
#if 1
/* Define these functions with DICE regargs */
ULONG CoerceMethodA(__A0 Class *, __A2 Object *, __A1 Msg);
ULONG DoSuperMethodA(__A0 Class *, __A2 Object *, __A1 Msg);
ULONG DoMethodA(__A2 Object *, __A1 Msg);
#else
__stkargs ULONG CoerceMethodA(Class *, Object *, Msg);
__stkargs ULONG DoSuperMethodA(Class *, Object *, Msg);
__stkargs ULONG DoMethodA(Object *, Msg);
#endif

/* OS function prototypes */
#include <clib/commodities_protos.h>
#include <clib/datatypes_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/dos_protos.h>
#include <clib/dospath_protos.h>
#include <clib/exec_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/icon_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/intuition_protos.h>
#include <clib/locale_protos.h>
#include <clib/rexxsyslib_protos.h>
#include <clib/screennotify_protos.h>
#include <clib/utility_protos.h>
#include <clib/wb_protos.h>
#include <clib/wbstart_protos.h>

/* OS function inline calls */
#include <pragmas/commodities_pragmas.h>
#include <pragmas/datatypes_pragmas.h>
#include <pragmas/diskfont_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/dospath_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/iffparse_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/rexxsyslib_pragmas.h>
#include <pragmas/screennotify_pragmas.h>
#include <pragmas/utility_pragmas.h>
#include <pragmas/wb_pragmas.h>
#include <pragmas/wbstart_pragmas.h>

/* ANSI C include files */
#include <stdlib.h>
#include <string.h>

/* Localization */
#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#include "/locale/toolmanager.h"

/* Debugging */
#ifdef DEBUG
/* Global data */
#define DEBUGFLAGENTRIES  1
#define DEBUGPRINTTAGLIST

/* Macros */                                   /* 87654321 */
#define INTERFACE_LOG(x)   _LOG(0,  0, (x))    /*        1 */
#define MEMORY_LOG(x)      _LOG(0,  1, (x))    /*        2 */
#define HANDLER_LOG(x)     _LOG(0,  2, (x))    /*        4 */
#define TMHANDLE_LOG(x)    _LOG(0,  3, (x))    /*        8 */
#define COMMANDS_LOG(x)    _LOG(0,  4, (x))    /*       10 */
#define BASECLASS_LOG(x)   _LOG(0,  5, (x))    /*       20 */
#define EXECCLASS_LOG(x)   _LOG(0,  6, (x))    /*       40 */
#define IMAGECLASS_LOG(x)  _LOG(0,  7, (x))    /*       80 */
#define SOUNDCLASS_LOG(x)  _LOG(0,  8, (x))    /*      100 */
#define MENUCLASS_LOG(x)   _LOG(0,  9, (x))    /*      200 */
#define ICONCLASS_LOG(x)   _LOG(0, 10, (x))    /*      400 */
#define DOCKCLASS_LOG(x)   _LOG(0, 11, (x))    /*      800 */
#define CONFIG_LOG(x)      _LOG(0, 12, (x))    /*     1000 */
#define GLOBAL_LOG(x)      _LOG(0, 13, (x))    /*     2000 */
#define IDCMP_LOG(x)       _LOG(0, 14, (x))    /*     4000 */
#define COMMODITIES_LOG(x) _LOG(0, 15, (x))    /*     8000 */
#define APPMSGS_LOG(x)     _LOG(0, 16, (x))    /*    10000 */
#define NETWORK_LOG(x)     _LOG(0, 17, (x))    /*    20000 */
#define SCREEN_LOG(x)      _LOG(0, 18, (x))    /*    40000 */
#define CLISTART_LOG(x)    _LOG(0, 19, (x))    /*    80000 */
#define WBSTART_LOG(x)     _LOG(0, 20, (x))    /*   100000 */
#define AREXX_LOG(x)       _LOG(0, 21, (x))    /*   200000 */
#define CMDLINE_LOG(x)     _LOG(0, 22, (x))    /*   400000 */
#define GROUPCLASS_LOG(x)  _LOG(0, 23, (x))    /*   800000 */
#define BUTTONCLASS_LOG(x) _LOG(0, 24, (x))    /*  1000000 */
#define ENTRYCLASS_LOG(x)  _LOG(0, 25, (x))    /*  2000000 */
#define LOCALE_LOG(x)      _LOG(0, 26, (x))    /*  4000000 */
#else
#define INTERFACE_LOG(x)
#define MEMORY_LOG(x)
#define HANDLER_LOG(x)
#define TMHANDLE_LOG(x)
#define COMMANDS_LOG(x)
#define BASECLASS_LOG(x)
#define EXECCLASS_LOG(x)
#define IMAGECLASS_LOG(x)
#define SOUNDCLASS_LOG(x)
#define MENUCLASS_LOG(x)
#define ICONCLASS_LOG(x)
#define DOCKCLASS_LOG(x)
#define CONFIG_LOG(x)
#define GLOBAL_LOG(x)
#define IDCMP_LOG(x)
#define COMMODITIES_LOG(x)
#define APPMSGS_LOG(x)
#define NETWORK_LOG(x)
#define SCREEN_LOG(x)
#define CLISTART_LOG(x)
#define WBSTART_LOG(x)
#define AREXX_LOG(x)
#define CMDLINE_LOG(x)
#define GROUPCLASS_LOG(x)
#define BUTTONCLASS_LOG(x)
#define ENTRYCLASS_LOG(x)
#define LOCALE_LOG(x)
#endif

/* Globale ToolManager definitions */
#include "/global.h"

/* Revision number */
#define TMLIBREVISION 12

/* Library <-> Handler IPC commands */
#define TMIPC_AllocTMHandle  0
#define TMIPC_FreeTMHandle   1
#define TMIPC_CreateTMObject 2
#define TMIPC_DeleteTMObject 3
#define TMIPC_ChangeTMObject 4

/* Handler states */
#define TMHANDLER_INACTIVE 0  /* Handler not running.  Set by handler */
#define TMHANDLER_STARTING 1  /* Handler starting.     Set by library */
#define TMHANDLER_RUNNING  2  /* Handler is active.    Set by handler */
#define TMHANDLER_CLOSING  3  /* Handler should leave. Set by library */
#define TMHANDLER_LEAVING  4  /* Handler is leaving.   Set by library */

/* Library base */
struct ToolManagerBase {
 struct Library  tmb_Library;
 UWORD           tmb_State;
 BPTR            tmb_Segment;
 struct Process *tmb_Process;
 struct MsgPort *tmb_Port;
};

/* Global data */
extern struct Library         *DOSBase;
extern struct Library         *GfxBase;
extern struct Library         *IFFParseBase;
extern struct Library         *IntuitionBase;
extern struct Library         *SysBase;
extern struct Library         *UtilityBase;
extern struct ToolManagerBase *ToolManagerBase;
extern const Class            *ToolManagerClasses[TMOBJTYPES];
extern const Class            *ToolManagerGroupClass;
extern const Class            *ToolManagerButtonClass;
extern const Class            *ToolManagerEntryClass;
extern const char              DefaultOutput[];
extern const char              DefaultDirectory[];
extern const char              DosName[];
extern const char              ToolManagerName[];

/* Data structures */
struct TMMessage {
 struct Message  tmm_Msg;     /* Library <-> Handler IPC */
 UBYTE           tmm_Command; /* Library <-> Handler IPC */
 UBYTE           tmm_Type;    /* Object type             */
 char           *tmm_Object;  /* Object name             */
 struct TagItem *tmm_Tags;    /* Object parameters       */
};

struct TMHandle {
 struct TMMessage tmh_Message;
 struct MinNode   tmh_Node;                    /* Node for handle list    */
 ULONG            tmh_IDCounter;               /* Counter for IDs         */
 struct MinList   tmh_ObjectLists[TMOBJTYPES]; /* Object lists            */
};
#define TMHANDLE(n) ((struct TMHandle *) \
                      ((char *) (n) - sizeof(struct TMMessage)))

struct TMMemberData {
 struct MinNode  tmmd_Node;   /* For member list management       */
 Object         *tmmd_Object; /* Object of which we are member of */
 Object         *tmmd_Member; /* The member itself                */
};

struct TMImageData {
 struct TMMemberData  tmid_MemberData; /* This is a derived structure       */
 ULONG                tmid_Type;       /* Imaga data type                   */
 void                *tmid_ImageData;  /* Image data (DiskObject or BitMap) */
 UWORD                tmid_Width;      /* Image width in pixels             */
 UWORD                tmid_Height;     /* Image height in pixels            */
};

/* Prototypes of library internal functions */
void            KillToolManager(void);
void            ToolManagerHandler(void);
void            InitHandles(void);
struct MinList *GetHandleList(void);
BOOL            InitToolManagerHandle(struct TMHandle *);
void            DeleteToolManagerHandle(struct TMHandle *);
Object         *CreateToolManagerObject(struct TMHandle *, ULONG);
Object         *FindTypedNamedTMObject(struct TMHandle *, const char *, ULONG);
Object         *FindNamedTMObject(struct TMHandle *, const char *);
Object         *FindTypedIDTMObject(struct TMHandle *, ULONG, ULONG);
LONG            StartConfigChangeNotify(void);
void            StopConfigChangeNotify(void);
BOOL            HandleConfigChange(void);
BOOL            NextConfigParseStep(struct TMHandle *);
void           *DuplicateProperty(struct IFFHandle *, ULONG, ULONG);
BOOL            ParseGlobalIFF(struct IFFHandle *);
void            FreeGlobalParameters(void);
char           *GetGlobalDefaultDirectory(void);
void            StartPreferences(void);
LONG            StartLowMemoryWarning(void);
void            StopLowMemoryWarning(void);
void            HandleLowMemory(void);
LONG            StartIDCMP(void);
void            StopIDCMP(void);
void            HandleIDCMP(void);
BOOL            AttachIDCMP(Object *, struct Window *, ULONG);
void            SafeCloseWindow(struct Window *);
LONG            StartCommodities(void);
void            StopCommodities(void);
void            HandleCommodities(void);
CxObj          *CreateHotKey(const char *, Object *);
void            SafeDeleteCxObjAll(struct CxObj *, Object *);
BOOL            SendInputEvent(const char *);
LONG            StartAppMessages(void);
void            StopAppMessages(void);
void            HandleAppMessages(void);
void           *CreateAppMenuItem(Object *);
void            DeleteAppMenuItem(void *, Object *);
void           *CreateAppIcon(Object *, struct DiskObject *, BOOL);
void            DeleteAppIcon(void *, Object *);
void           *CreateAppWindow(Object *, struct Window *);
void            DeleteAppWindow(void *, Object *);
LONG            StartNetwork(void);
void            StopNetwork(void);
void            EnableNetwork(void);
void            DisableNetwork(void);
void            HandleNetwork(void);
LONG            StartScreenNotify(void);
void            StopScreenNotify(void);
void            LockScreenNotify(void);
void            ReleaseScreenNotify(void);
void            HandleScreenNotify(void);
LONG            StartIPC(void);
void            StopIPC(void);
struct MsgPort *GetIPCPort(void);
void            HandleIPC(void);
Class          *CreateBaseClass(void);
Class          *CreateExecClass(Class *);
Class          *CreateImageClass(Class *);
void            EnableRemap(BOOL, ULONG);
Class          *CreateSoundClass(Class *);
Class          *CreateMenuClass(Class *);
Class          *CreateIconClass(Class *);
Class          *CreateDockClass(Class *);
Class          *CreateGroupClass(void);
Class          *CreateButtonClass(void);
Class          *CreateEntryClass(void);
BOOL            StartCLIProgram(const char *, const char *, const char **,
                                const char *, ULONG, WORD,
                                struct AppMessage *);
BOOL            GetWorkbenchPath(void);
void            FreeWorkbenchPath(void);
BOOL            StartWBProgram(const char *, const char *, ULONG, WORD,
                               struct AppMessage *);
BOOL            SendARexxCommand(const char *, ULONG);
BOOL            StartARexxProgram(const char *, const char *,
                                  struct AppMessage *);
char           *BuildCommandLine(const char *, struct AppMessage *, BPTR,
                                 ULONG *);
void            SafeDeleteMsgPort(struct MsgPort *);
void            StartLocale(void);
void            StopLocale(void);
const char     *TranslateString(const char *, ULONG);

/* ToolManager class Methods */
#define TMM_Methods                                          (0x80000000)
     /* Method name                                          Method ID       */
     /*                Method params    Return type                          */

     /* All classes                                                          */
#define TMM_Attach                                           (TMM_Methods +  1)
     /*                 TMP_Attach      (struct TMMemberData *)              */
#define TMM_Detach                                           (TMM_Methods +  2)
     /*                 TMP_Detach      (void)                               */

     /* Classes derived from Base class */
#define TMM_Release                                          (TMM_Methods +  3)
     /*                 TMP_Detach      (void)                               */
#define TMM_ParseIFF                                         (TMM_Methods +  4)
     /*                 TMP_ParseIFF    (BOOL)                               */
#define TMM_ParseTags                                        (TMM_Methods +  5)
     /*                 TMP_ParseTags   (BOOL)                               */

     /* Exec, Sound, Menu, Icon, Dock classes */
#define TMM_Activate                                         (TMM_Methods +  6)
     /*                 TMP_Activate    (void)                               */

     /* Icon, Entry classes */
#define TMM_Notify                                           (TMM_Methods +  7)
     /*                 TMP_Detach      (void)                               */

     /* Image class */
#define TMM_GetImage                                         (TMM_Methods +  8)
     /*                 TMP_GetImage    (struct TMImageData *)               */
#define TMM_PurgeCache                                       (TMM_Methods +  9)
     /*                 Msg             (void)                               */

     /* Dock class */
#define TMM_IDCMPEvent                                       (TMM_Methods + 10)
     /*                 TMP_IDCMPEvent  (void)                               */
#define TMM_ScreenOpen                                       (TMM_Methods + 11)
     /*                 TMP_ScreenOpen  (void)                               */

     /* Image and Dock classes */
#define TMM_ScreenClose                                      (TMM_Methods + 12)
     /*                 TMP_ScreenClose (void)                               */

     /* Group class */
#define TMM_Layout                                           (TMM_Methods + 13)
     /*                 TMP_Layout      (void)                               */
#define TMM_GadgetUp                                         (TMM_Methods + 14)
     /*                 TMP_GadgetUp    (void)                               */
#define TMM_AppEvent                                         (TMM_Methods + 15)
     /*                 TMP_AppEvent    (void)                               */

/* Method parameters */
struct TMP_Activate {
 ULONG  tmpa_MethodID;
 void  *tmpa_Data;
};

#define TMV_Attach_Normal sizeof(struct TMMemberData)
struct TMP_Attach {
 ULONG   tmpa_MethodID;
 Object *tmpa_Object;
 ULONG   tmpa_Size;
};

struct TMP_Detach {
 ULONG                tmpd_MethodID;
 struct TMMemberData *tmpd_MemberData;
};

struct TMP_ParseIFF {
 ULONG             tmppi_MethodID;
 struct IFFHandle *tmppi_IFFHandle;
};

struct TMP_ParseTags {
 ULONG           tmppt_MethodID;
 struct TagItem *tmppt_Tags;
};

struct TMP_GetImage {
 ULONG          tmpgi_MethodID;
 Object        *tmpgi_Object;
 struct Screen *tmpgi_Screen;
};

struct TMP_IDCMPEvent {
 ULONG                tmpie_MethodID;
 struct IntuiMessage *tmpie_Message;
};

struct TMP_ScreenOpen {
 ULONG       tmpso_MethodID;
 const char *tmpso_Name;
};

struct TMP_ScreenClose {
 ULONG          tmpsc_MethodID;
 struct Screen *tmpsc_Screen;
};

struct TMP_Layout {
 ULONG tmpl_MethodID;
 ULONG tmpl_Columns;
};

struct TMP_GadgetUp {
 ULONG tmpgu_MethodID;
 ULONG tmpgu_GadgetID;
};

struct TMP_AppEvent {
 ULONG              tmpae_MethodID;
 struct AppMessage *tmpae_Message;
};

/* Method attributes */
/* i = Can be supplied in OM_NEW    */
/* I = MUST be supplied in OM_NEW   */
/* s = Can be changed with OM_SET   */
/* g = Can be requested with OM_GET */

#define TMA_BASE (TAG_USER + 0x10000)

/* Global attributes */                      /* XXX (Type)                   */
#define TMA_GLOBAL     (TMA_BASE   + 0x0000)
#define TMA_TMHandle   (TMA_GLOBAL +      1) /* I.g (struct TMHandle *)      */
#define TMA_ObjectType (TMA_GLOBAL +      2) /* I.. (ULONG)                  */
#define TMA_ObjectName (TMA_GLOBAL +      3) /* .sg (const char *)           */
#define TMA_ObjectID   (TMA_GLOBAL +      4) /* ..g (ULONG)                  */

/* Group class attributes */
#define TMA_GROUP      (TMA_BASE   + 0x1000)

/* Button class attributes */
#define TMA_BUTTON     (TMA_BASE   + 0x2000)
#define TMA_Entry      (TMA_BUTTON +      1) /* I.. (struct DockEntryChunk *)*/
#define TMA_Screen     (TMA_BUTTON +      2) /* I.. (struct Screen *)        */
#define TMA_Font       (TMA_BUTTON +      3) /* i.. (struct TextFont *)      */
#define TMA_Images     (TMA_BUTTON +      4) /* i.. (BOOL)                   */
#define TMA_Text       (TMA_BUTTON +      5) /* i.. (BOOL)                   */

/* Entry class attributes */
#define TMA_ENTRY      (TMA_BASE   + 0x4000)
#define TMA_String     (TMA_ENTRY  +      1) /* i.. (const char *)           */
#define TMA_Image      (TMA_ENTRY  +      2) /* i.. (Object *)               */
