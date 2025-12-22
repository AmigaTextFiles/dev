/*
 * toolmanager.h  V3.1
 *
 * Preferences editor main include file
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
#include <dos/dos.h>
#include <exec/memory.h>
#include <libraries/asl.h>
#include <libraries/gadtools.h>
#include <libraries/mui.h>
#include <libraries/toolmanager.h>
#include <mui/listtree_mcc.h>
#include <mui/pophotkey_mcc.h>
#include <mui/popport_mcc.h>
#include <mui/popposition_mcc.h>
#include <utility/tagitem.h>
#include <workbench/startup.h>
#include <workbench/workbench.h>

/* Do some redefines to enable DICE register parameters */
#define CoerceMethodA  DummyCMA
#define DoMethodA      DummyDMA
#define DoSuperMethodA DummyDSMA
#include <clib/alib_protos.h>
#undef CoerceMethodA
#undef DoMethodA
#undef DoSuperMethodA
#if _DCC
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
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/icon_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/intuition_protos.h>
#include <clib/locale_protos.h>
#include <clib/muimaster_protos.h>
#include <clib/utility_protos.h>

/* OS function inline calls */
#include <pragmas/dos_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/iffparse_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/muimaster_pragmas.h>
#include <pragmas/utility_pragmas.h>

/* ANSI C include files */
#include <stdlib.h>
#include <string.h>

/* Localization */
#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#include "locale.h"

/* Global defines for string gadget max. content length */
#define LENGTH_STRING    80
#define LENGTH_HOTKEY    80
#define LENGTH_COMMAND  256
#define LENGTH_PATH     256
#define LENGTH_FILENAME 256

/* Private MUI Attributes */
#define MUIA_Popscreen_ShowCurrent   0x804238a7 /* V11 i.. BOOL */
#define MUIA_Popscreen_ShowDefault   0x804295ca /* V11 i.. BOOL */
#define MUIA_Popscreen_ShowFrontmost 0x804261a3 /* V11 i.. BOOL */
#define MUIA_Popscreen_ShowMUI       0x804298bf /* V11 i.. BOOL */

/* Object creation macros */
#define TMString(contents, maxlen, help)                                      \
                                        StringObject,                         \
                                         MUIA_String_Contents,    (contents), \
                                         MUIA_String_MaxLen,      (maxlen),   \
                                         MUIA_String_AdvanceOnCR, TRUE,       \
                                         MUIA_CycleChain,         TRUE,       \
                                         MUIA_ShortHelp,          (help),     \
                                         StringFrame,                         \
                                        End

#define TMInteger(contents, help) StringObject,                               \
                                   MUIA_String_Accept,      TextGlobalAccept, \
                                   MUIA_String_Integer,     (contents),       \
                                   MUIA_String_MaxLen,      11,               \
                                   MUIA_String_AdvanceOnCR, TRUE,             \
                                   MUIA_CycleChain,         TRUE,             \
                                   MUIA_ShortHelp,          (help),           \
                                   StringFrame,                               \
                                  End

#define TMPopFile(title, contents, maxlen, help)                              \
                  NewObject(PopASLClass->mcc_Class, NULL,                     \
                   MUIA_Popasl_Type,      ASL_FileRequest,                    \
                   MUIA_Popstring_String, TMString(contents, (maxlen), NULL), \
                   MUIA_Popstring_Button, PopButton(MUII_PopFile),            \
                   MUIA_ShortHelp,        (help),                             \
                   ASLFR_TitleText,       (title)

#define TMPopScreen(contents, help)                                           \
        MUI_NewObject(MUIC_Popscreen,                                         \
         MUIA_Popstring_String,      TMString(contents, LENGTH_STRING, NULL), \
         MUIA_Popstring_Button,      PopButton(MUII_PopUp),                   \
         MUIA_Popscreen_ShowMUI,     TRUE,                                    \
         MUIA_Popscreen_ShowDefault, TRUE,                                    \
         MUIA_ShortHelp,             (help)

#define TMPopHotKey(contents, help) PophotkeyObject,                          \
            MUIA_Popstring_String,   TMString(contents, LENGTH_HOTKEY, NULL), \
            MUIA_Pophotkey_Extended, TRUE,                                    \
            MUIA_ShortHelp,          (help)

#define TMPopPosition(x,y, help) PoppositionObject,                           \
                  MUIA_Popposition_XPos, (x),                                 \
                  MUIA_Popposition_YPos, (y),                                 \
                  MUIA_Popstring_String, TMString(NULL, LENGTH_STRING, NULL), \
                  MUIA_ShortHelp,        (help)

/* Debugging */
#ifdef DEBUG
/* Global data */
#define DEBUGFLAGENTRIES  1
#define DEBUGPRINTTAGLIST

/* Macros */                                   /* 87654321 */
#define STARTUP_LOG(x)     _LOG(0,  0, (x))    /*        1 */
#define MEMORY_LOG(x)      _LOG(0,  1, (x))    /*        2 */
#define LOCALE_LOG(x)      _LOG(0,  2, (x))    /*        4 */
#define MAINWINDOW_LOG(x)  _LOG(0,  3, (x))    /*        8 */
#define LISTPANEL_LOG(x)   _LOG(0,  4, (x))    /*       10 */
#define LISTTREE_LOG(x)    _LOG(0,  5, (x))    /*       20 */
#define BASE_LOG(x)        _LOG(0,  6, (x))    /*       40 */
#define EXEC_LOG(x)        _LOG(0,  7, (x))    /*       80 */
#define IMAGE_LOG(x)       _LOG(0,  8, (x))    /*      100 */
#define SOUND_LOG(x)       _LOG(0,  9, (x))    /*      200 */
#define MENU_LOG(x)        _LOG(0, 10, (x))    /*      400 */
#define ICON_LOG(x)        _LOG(0, 11, (x))    /*      800 */
#define DOCK_LOG(x)        _LOG(0, 12, (x))    /*     1000 */
#define ACCESS_LOG(x)      _LOG(0, 13, (x))    /*     2000 */
#define GROUP_LOG(x)       _LOG(0, 14, (x))    /*     4000 */
#define CONFIG_LOG(x)      _LOG(0, 15, (x))    /*     8000 */
#define GLOBAL_LOG(x)      _LOG(0, 16, (x))    /*    10000 */
#define POPASL_LOG(x)      _LOG(0, 17, (x))    /*    20000 */
#define DROPAREA_LOG(x)    _LOG(0, 18, (x))    /*    40000 */
#define ENTRYLIST_LOG(x)   _LOG(0, 19, (x))    /*    80000 */
#define ENTRIES_LOG(x)     _LOG(0, 20, (x))    /*   100000 */
#define MISC_LOG(x)        _LOG(0, 21, (x))    /*   200000 */
#define CLIPWINDOW_LOG(x)  _LOG(0, 22, (x))    /*   400000 */
#define CLIPLIST_LOG(x)    _LOG(0, 23, (x))    /*   800000 */
#else
#define STARTUP_LOG(x)
#define MEMORY_LOG(x)
#define LOCALE_LOG(x)
#define MAINWINDOW_LOG(x)
#define LISTPANEL_LOG(x)
#define LISTTREE_LOG(x)
#define BASE_LOG(x)
#define GROUP_LOG(x)
#define EXEC_LOG(x)
#define IMAGE_LOG(x)
#define SOUND_LOG(x)
#define MENU_LOG(x)
#define ICON_LOG(x)
#define DOCK_LOG(x)
#define ACCESS_LOG(x)
#define CONFIG_LOG(x)
#define GLOBAL_LOG(x)
#define POPASL_LOG(x)
#define DROPAREA_LOG(x)
#define ENTRYLIST_LOG(x)
#define ENTRIES_LOG(x)
#define MISC_LOG(x)
#define CLIPWINDOW_LOG(x)
#define CLIPLIST_LOG(x)
#endif

/* Globale ToolManager definitions */
#include "/global.h"

/* Global data */
extern struct Library         *DOSBase;
extern struct Library         *IconBase;
extern struct Library         *IFFParseBase;
extern struct Library         *IntuitionBase;
extern struct Library         *MUIMasterBase;
extern struct Library         *SysBase;
extern struct Library         *UtilityBase;
extern struct MUI_CustomClass *MainWindowClass;
extern struct MUI_CustomClass *GlobalClass;
extern struct MUI_CustomClass *ListPanelClass;
extern struct MUI_CustomClass *ListTreeClass;
extern struct MUI_CustomClass *PopASLClass;
extern struct MUI_CustomClass *DropAreaClass;
extern struct MUI_CustomClass *EntryListClass;
extern struct MUI_CustomClass *BaseClass;
extern struct MUI_CustomClass *GroupClass;
extern struct MUI_CustomClass *ObjectClasses[];
extern struct MUI_CustomClass *ClipWindowClass;
extern struct MUI_CustomClass *ClipListClass;
extern struct Hook             AppMessageHook;
extern char                   *ProgramName;
extern ULONG                   CreateIcons;
extern const char              ConfigSaveName[];
extern const char              ConfigUseName[];
extern const char             *TextGlobalTitle;
extern const char             *TextGlobalCommand;
extern const char             *TextGlobalSelectCmd;
extern const char             *TextGlobalDirectory;
extern const char             *TextGlobalSelectDir;
extern const char             *TextGlobalHotKey;
extern const char             *TextGlobalPublicScreen;
extern const char             *TextGlobalPosition;
extern const char             *TextGlobalExecObject;
extern const char             *TextGlobalImageObject;
extern const char             *TextGlobalSoundObject;
extern const char             *TextGlobalDock;
extern const char             *TextGlobalSelectFile;
extern const char             *TextGlobalDelete;
extern const char             *HelpGlobalDelete;
extern const char             *TextGlobalUse;
extern const char             *HelpGlobalUse;
extern const char             *TextGlobalCancel;
extern const char             *HelpGlobalCancel;
extern const char              TextGlobalAccept[];
extern const char              TextGlobalEmpty[];

/* Data structures */
struct AttachData {
 struct MinNode  ad_Node;
 Object         *ad_Object;
 Object         *ad_AttachedTo;
};

struct DockEntry {
 struct MinNode     de_Node;
 struct AttachData *de_Exec;
 struct AttachData *de_Image;
 struct AttachData *de_Sound;
};

/* Prototypes of internal functions */
struct MUI_CustomClass  *CreateMainWindowClass(void);
struct MUI_CustomClass  *CreateListPanelClass(void);
struct MUI_CustomClass  *CreateListTreeClass(void);
struct AttachData       *AttachObject(Object *, Object *, ULONG);
struct MUI_CustomClass  *CreatePopASLClass(void);
struct MUI_CustomClass  *CreateDropAreaClass(void);
struct MUI_CustomClass  *CreateEntryListClass(void);
struct MUI_CustomClass  *CreateBaseClass(void);
struct MUI_CustomClass  *CreateExecClass(void);
struct MUI_CustomClass  *CreateImageClass(void);
struct MUI_CustomClass  *CreateSoundClass(void);
struct MUI_CustomClass  *CreateMenuClass(void);
struct MUI_CustomClass  *CreateIconClass(void);
struct MUI_CustomClass  *CreateDockClass(void);
struct MUI_CustomClass  *CreateAccessClass(void);
struct MUI_CustomClass  *CreateGroupClass(void);
struct MUI_CustomClass  *CreateClipWindowClass(void);
struct MUI_CustomClass  *CreateClipListClass(void);
void                     ReadConfig(Object *, Object **, BOOL, const char *);
const char              *ReadConfigWithRequester(Object *, Object **, BOOL,
                                                 const char *);
BOOL                     WriteConfig(Object *, Object **, const char *, BOOL);
const char              *WriteConfigWithRequester(Object *, Object **,
                                                  const char *, BOOL);
char                    *ReadStringProperty(struct IFFHandle *, ULONG, ULONG);
BOOL                     WriteProperty(struct IFFHandle *, ULONG, void *,
                                       ULONG);
BOOL                     WriteStringProperty(struct IFFHandle *, ULONG,
                                             const char *);
BOOL                     ParseGlobalIFF(struct IFFHandle *);
BOOL                     WriteGlobalIFF(struct IFFHandle *);
void                     FreeGlobalData(void);
struct MUI_CustomClass  *CreateGlobalClass(void);
void                     OpenGlobalWindow(Object *);
BOOL                     CheckRequesters(Object *);
void                     ReadDockEntries(struct IFFHandle *, struct MinList *,
                                         Object *, Object **);
BOOL                     WriteDockEntries(struct IFFHandle *,
                                          struct MinList *);
void                     FreeDockEntry(struct DockEntry *);
void                     FreeDockEntries(struct MinList *);
struct DockEntry        *CopyDockEntry(struct DockEntry *, Object *);
BOOL                     RemoveDockEntryAttach(struct DockEntry *,
                                               struct AttachData *);
void                     InitLocale(void);
void                     DeleteLocale(void);
const char              *TranslateString(const char *, ULONG);
ULONG                    DoSuperNew(Class *, Object *, Tag tag1, ...);
char                    *DuplicateString(const char *);
char                    *GetStringContents(Object *, const char *);
ULONG                    GetCheckmarkState(Object *, ULONG);
ULONG                    GetCheckitState(Object *, ULONG);
struct AttachData       *GetAttachData(Object *, Object *,
                                       struct AttachData *);
void                     SetDisabledState(Object *, ULONG);
Object                  *MakeButton(const char *, const char *);
Object                  *MakeCheckmark(ULONG, const char *);

/* ToolManager class Methods */
#define TMM_Methods (TAG_USER + 0x00100000)
     /* Method name                                          Method ID       */
     /*                Method params    Return type                          */

     /* All classes                                                          */
#define TMM_Finish                                           (TMM_Methods +  1)
     /*                TMP_Finish       (void)                               */

     /* MainWindow class                                                     */
#define TMM_Load                                             (TMM_Methods +  2)
     /*                TMP_Load         (void)                               */
#define TMM_Menu                                             (TMM_Methods +  3)
     /*                TMP_Menu         (void)                               */
#define TMM_AppEvent                                         (TMM_Methods +  4)
     /*                TMP_AppEvent     (void)                               */

     /* ListTree class                                                       */
#define TMM_NewGroup                                         (TMM_Methods +  5)
     /*                Msg              ("Tree Node")                        */
#define TMM_NewObject                                        (TMM_Methods +  6)
     /*                Msg              ("Tree Node")                        */
#define TMM_Sort                                             (TMM_Methods +  7)
     /*                Msg              (void)                               */
#define TMM_Selected                                         (TMM_Methods +  8)
     /*                TMP_Selected     (void)                               */
#define TMM_Update                                           (TMM_Methods +  9)
     /*                TMP_Update       (void)                               */

     /* Classes derived from Base class                                      */
#define TMM_Attach                                           (TMM_Methods + 10)
     /*                TMP_Attach       (struct AttachData *)                */
#define TMM_Detach                                           (TMM_Methods + 11)
     /*                TMP_Detach       (void)                               */
#define TMM_Notify                                           (TMM_Methods + 12)
     /*                TMP_Notify       (void)                               */
#define TMM_Edit                                             (TMM_Methods + 13)
     /*                TMP_Edit         (void)                               */
#define TMM_Change                                           (TMM_Methods + 14)
     /*                Msg              (void)                               */
#define TMM_ParseIFF                                         (TMM_Methods + 15)
     /*                TMP_ParseIFF     (BOOL)                               */
#define TMM_WriteIFF                                         (TMM_Methods + 16)
     /*                TMP_WriteIFF     (BOOL)                               */

     /* Classes derived from Base class, ListPanel class, EntryList class    */
#define TMM_WBArg                                            (TMM_Methods + 17)
     /*                TMP_WBArg        (Object *)                           */

     /* ClipList, DropArea and Dock classes                                  */
#define TMM_DoubleClicked                                    (TMM_Methods + 18)
     /*                Msg              (void)                               */

     /* EntryList class                                                      */
#define TMM_Column                                           (TMM_Methods + 19)
     /*                TMP_Column       (void)                               */

/* Method parameters */
#define TMV_Finish_Cancel 0
#define TMV_Finish_Use    1
#define TMV_Finish_Test   2
#define TMV_Finish_Save   3
struct TMP_Finish {
 ULONG tmpf_MethodID;
 ULONG tmpf_Type;
};

struct TMP_AppEvent {
 ULONG              tmpae_MethodID;
 struct AppMessage *tmpae_Message;
 Object            *tmpae_Object;
};

struct TMP_Load {
 ULONG       tmpl_MethodID;
 const char *tmpl_File;
};

struct TMP_Menu {
 ULONG tmpm_MethodID;
 ULONG tmpm_UserData;
};

struct TMP_SetGroup {
 ULONG       tmpsg_MethodID;
 const char *tmpsg_Name;
};

struct TMP_Selected {
 ULONG                          tmps_MethodID;
 struct MUIS_Listtree_TreeNode *tmps_Entry;
};

struct TMP_Update {
 ULONG   tmpu_MethodID;
 Object *tmpu_Entry;
 ULONG   tmpu_Type;
};

struct TMP_Attach {
 ULONG   tmpa_MethodID;
 Object *tmpa_Object;
};

struct TMP_Detach {
 ULONG              tmpd_MethodID;
 struct AttachData *tmpd_Data;
};

struct TMP_Notify {
 ULONG              tmpn_MethodID;
 struct AttachData *tmpn_Data;
};

struct TMP_Edit {
 ULONG   tmpe_MethodID;
 Object *tmpe_Group;
};

struct TMP_ParseIFF {
 ULONG              tmppi_MethodID;
 struct IFFHandle  *tmppi_IFFHandle;
 Object           **tmppi_Lists;
};

struct TMP_WriteIFF {
 ULONG             tmpwi_MethodID;
 struct IFFHandle *tmpwi_IFFHandle;
};

struct TMP_WBArg {
 ULONG          tmpwa_MethodID;
 struct WBArg  *tmpwa_Argument;
 Object       **tmpwa_Lists;
};

struct TMP_Column {
 ULONG tmpc_MethodID;
 ULONG tmpc_Column;
};

/* Method attributes */
/* i = Can be supplied in OM_NEW    */
/* I = MUST be supplied in OM_NEW   */
/* s = Can be changed with OM_SET   */
/* g = Can be requested with OM_GET */
#define TMA_DUMMY     (TAG_USER + 0x00100000)  /* XXX (Type)                 */

/* ListTree attributes */
#define TMA_LISTTREE  (TMA_DUMMY     + 0x0000)
#define TMA_Class     (TMA_LISTTREE  +      1) /* I.. (MUI_CustomClass *)    */
#define TMA_Active    (TMA_LISTTREE  +      2) /* ..g (Object *)             */

/* Base attributes */
#define TMA_BASE      (TMA_DUMMY     + 0x1000)
#define TMA_Name      (TMA_BASE      +      1) /* Isg (const char *)         */
#define TMA_ID        (TMA_BASE      +      2) /* .sg (ULONG)                */
#define TMA_Type      (TMA_BASE      +      3) /* I.g (ULONG)                */
#define TMOBJTYPE_GROUP TMOBJTYPES             /* special value for groups   */
#define TMA_List      (TMA_BASE      +      4) /* I.. (Object *)             */

/* DropArea attributes */
#define TMA_DROPAREA  (TMA_DUMMY     + 0x2000)
#define TMA_Attach    (TMA_DROPAREA  +      1) /* I.g (struct AttachData *)  */
#define TMA_Object    (TMA_DROPAREA  +      2) /* .s. (struct Object *)      */

/* EntryList attributes */
#define TMA_ENTRYLIST (TMA_DUMMY     + 0x3000)
#define TMA_Entries   (TMA_ENTRYLIST +      1) /* I.g (struct MinList *)     */

/* PopASL attributes */
#define TMA_POPASL    (TMA_DUMMY     + 0x4000)
#define TMA_ButtonDisabled (TMA_POPASL +    1) /* .s. (BOOL)                 */
