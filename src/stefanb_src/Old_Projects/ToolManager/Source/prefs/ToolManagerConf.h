/*
 * ToolManagerConf.h  V2.1
 *
 * configuration program main include file
 *
 * (c) 1990-1993 Stefan Becker
 */

/* System include files */
#include <exec/types.h>
#include <exec/memory.h>
#include <dos/dos.h>
#include <envoy/envoy.h>
#include <graphics/gfxbase.h>
#include <intuition/gadgetclass.h>
#define ASL_V38_NAMES_ONLY
#include <libraries/asl.h>
#include <libraries/iffparse.h>
#include <libraries/locale.h>
#include <libraries/toolmanager.h>
#include <prefs/prefhdr.h>

/* System function prototypes */
#include <clib/alib_protos.h>
#include <clib/asl_protos.h>
#include <clib/diskfont_protos.h>
#include <clib/dos_protos.h>
#include <clib/envoy_protos.h>
#include <clib/exec_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/graphics_protos.h>
#include <clib/icon_protos.h>
#include <clib/iffparse_protos.h>
#include <clib/intuition_protos.h>
#include <clib/locale_protos.h>
#include <clib/wb_protos.h>

/* System function pragmas */
#include <pragmas/asl_pragmas.h>
#include <pragmas/diskfont_pragmas.h>
#include <pragmas/dos_pragmas.h>
#include <pragmas/envoy_pragmas.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/gadtools_pragmas.h>
#include <pragmas/graphics_pragmas.h>
#include <pragmas/icon_pragmas.h>
#include <pragmas/iffparse_pragmas.h>
#include <pragmas/intuition_pragmas.h>
#include <pragmas/locale_pragmas.h>
#include <pragmas/wb_pragmas.h>

/* ANSI C include files */
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* Compiler specific include files */
#include <lists.h>     /* GetHead() et al. */

/* Project specific include files */
#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#include "/locale/toolmanager.h"
#include "/ToolManagerPrefs.h"

/* Structures */
struct GadgetData {
                   char           *name;
                   ULONG           type;
                   ULONG           flags;
                   struct TagItem *tags;
                   UWORD           left;
                   UWORD           top;
                   UWORD           width;
                   UWORD           height;
                   struct Gadget  *gadget;
                  };

struct FileReqParms {
                     struct Window *frp_Window;
                     char          *frp_Title;
                     char          *frp_OKText;
                     ULONG          frp_Flags1;
                     ULONG          frp_Flags2;
                     char          *frp_OldFile;
                    };

struct ToolNode {
                 struct Node  tn_Node;
                 char        *tn_Image;
                 char        *tn_Sound;
                };

/* Internal function prototypes */
/* *window.c typedefs */
typedef void         (*UpdateWindowFuncPtr)(void *);
typedef BOOL         (*OpenWindowFuncPtr)(void *, struct Window *);
typedef void         (*HandleAppMsgFuncPtr)(struct AppMessage *);
typedef void        *(*HandleIDCMPFuncPtr)(struct IntuiMessage *);
typedef struct Node *(*CopyNodeFuncPtr)(struct Node *);
typedef void         (*FreeNodeFuncPtr)(struct Node *);
typedef struct Node *(*ReadNodeFuncPtr)(UBYTE *);
typedef BOOL         (*WriteNodeFuncPtr)(struct IFFHandle *, UBYTE *,
                                         struct Node *);

/* accesswindow.c */
void         InitAccessEditWindow(UWORD, UWORD);
BOOL         OpenAccessEditWindow(void *, struct Window *);
void         UpdateAccessEditWindow(void *);
void        *HandleAccessEditWindowIDCMP(struct IntuiMessage *);
struct Node *CopyAccessNode(struct Node *);
void         FreeAccessNode(struct Node *);
struct Node *ReadAccessNode(UBYTE *);
BOOL         WriteAccessNode(struct IFFHandle *, UBYTE *, struct Node *);

/* aslreqs.c */
char            *OpenFileRequester(struct Requester *);
struct TextAttr *OpenFontRequester(struct Window *, struct Requester *,
                                   struct TextAttr *);

/* button.c */
BOOL CalcReqButtonImage(void);
void FreeReqButtonImage(void);
void InitReqButtonGadget(struct Gadget *);

/* config.c */
BOOL  ReadConfigFile(char *);
BOOL  WriteConfigFile(char *);
char *GetConfigStr(UBYTE **);
BOOL  PutConfigStr(char *, UBYTE **);

/* dockwindow.c */
void         InitDockEditWindow(UWORD, UWORD);
BOOL         OpenDockEditWindow(void *, struct Window *);
void         UpdateDockEditWindow(void *);
void        *HandleDockEditWindowIDCMP(struct IntuiMessage *);
struct Node *CopyDockNode(struct Node *);
void         FreeDockNode(struct Node *);
struct Node *ReadDockNode(UBYTE *);
BOOL         WriteDockNode(struct IFFHandle *, UBYTE *, struct Node *);

/* docklistwindow.c */
void         InitDockListEditWindow(UWORD, UWORD);
BOOL         OpenDockListEditWindow(void *, struct Window *);
void         UpdateDockListEditWindow(void *);
void        *HandleDockListEditWindowIDCMP(struct IntuiMessage *);
struct List *CopyToolsList(struct List *);
void         FreeToolsList(struct List *toollist);

/* execwindow.c */
void         InitExecEditWindow(UWORD, UWORD);
BOOL         OpenExecEditWindow(void *, struct Window *);
void         UpdateExecEditWindow(void *);
void         HandleExecEditWindowAppMsg(struct AppMessage *);
void        *HandleExecEditWindowIDCMP(struct IntuiMessage *);
struct Node *CreateExecNode(char *, struct WBArg *);
struct Node *CopyExecNode(struct Node *);
void         FreeExecNode(struct Node *);
struct Node *ReadExecNode(UBYTE *);
BOOL         WriteExecNode(struct IFFHandle *, UBYTE *, struct Node *);

/* gadget.c */
struct Gadget *CreateGadgetList(struct GadgetData *, ULONG);
void           DisableGadget(struct Gadget *, struct Window *, BOOL);
char          *DuplicateBuffer(struct Gadget *);
char           FindVanillaKey(char *);
ULONG          MatchVanillaKey(unsigned char, char *);

/* iconwindow.c */
void         InitIconEditWindow(UWORD, UWORD);
BOOL         OpenIconEditWindow(void *, struct Window *);
void         UpdateIconEditWindow(void *);
void        *HandleIconEditWindowIDCMP(struct IntuiMessage *);
struct Node *CreateIconNode(char *);
struct Node *CopyIconNode(struct Node *);
void         FreeIconNode(struct Node *);
struct Node *ReadIconNode(UBYTE *);
BOOL         WriteIconNode(struct IFFHandle *, UBYTE *, struct Node *);

/* imagewindow.c */
void         InitImageEditWindow(UWORD, UWORD);
BOOL         OpenImageEditWindow(void *, struct Window *);
void         HandleImageEditWindowAppMsg(struct AppMessage *);
void        *HandleImageEditWindowIDCMP(struct IntuiMessage *);
struct Node *CreateImageNode(char *, struct WBArg *);
struct Node *CopyImageNode(struct Node *);
void         FreeImageNode(struct Node *);
struct Node *ReadImageNode(UBYTE *);
BOOL         WriteImageNode(struct IFFHandle *, UBYTE *, struct Node *);

/* listreq.c */
void  InitListRequester(UWORD, UWORD);
BOOL  OpenListRequester(ULONG, struct Window *);
void *HandleListRequesterIDCMP(struct IntuiMessage *);

/* locale.c */
void GetLocale(void);
void FreeLocale(void);

/* main.c */
void FreeAllObjects(void);
BOOL CopyFile(char *, char *);

/* mainwindow.c */
void   InitMainWindow(UWORD, UWORD);
ULONG  OpenMainWindow(UWORD, UWORD);
void   CloseMainWindow(void);
void   UpdateMainWindow(void *);
void   HandleMainWindowAppMsg(struct AppMessage *);
void  *HandleMainWindowIDCMP(struct IntuiMessage *);
void   UpdateAppMainWindow(void *);

/* menuwindow.c */
void         InitMenuEditWindow(UWORD, UWORD);
BOOL         OpenMenuEditWindow(void *, struct Window *);
void         UpdateMenuEditWindow(void *);
void        *HandleMenuEditWindowIDCMP(struct IntuiMessage *);
struct Node *CreateMenuNode(char *);
struct Node *CopyMenuNode(struct Node *);
void         FreeMenuNode(struct Node *);
struct Node *ReadMenuNode(UBYTE *);
BOOL         WriteMenuNode(struct IFFHandle *, UBYTE *, struct Node *);

/* movewindow.c */
void  InitMoveWindow(UWORD, UWORD);
void  OpenMoveWindow(struct Window *, struct Gadget *, struct Gadget *);
void  CloseMoveWindow(void);
void *HandleMoveWindowIDCMP(struct IntuiMessage *);

/* selectwindow.c */
void  InitSelectWindow(UWORD, UWORD);
BOOL  OpenSelectWindow(void *, struct Window *);
void *HandleSelectWindowIDCMP(struct IntuiMessage *);

/* soundwindow.c */
void         InitSoundEditWindow(UWORD, UWORD);
BOOL         OpenSoundEditWindow(void *, struct Window *);
void        *HandleSoundEditWindowIDCMP(struct IntuiMessage *);
struct Node *CopySoundNode(struct Node *);
void         FreeSoundNode(struct Node *);
struct Node *ReadSoundNode(UBYTE *);
BOOL         WriteSoundNode(struct IFFHandle *iff, UBYTE *, struct Node *);

/* window.c */
void CloseWindowSafely(struct Window *);
void DisableWindow(struct Window *, struct Requester *);
void EnableWindow(struct Window *, struct Requester *, ULONG);

/* System library base pointers */
extern struct Library *AslBase;
extern struct Library *DiskfontBase;
extern struct Library *DOSBase;
extern struct Library *GadToolsBase;
extern struct GfxBase *GfxBase;
extern struct Library *IconBase;
extern struct Library *IFFParseBase;
extern struct Library *IntuitionBase;
extern struct Library *SysBase;
extern struct Library *WorkbenchBase;

/* Global data */
extern char                 *ProgramName;
extern UpdateWindowFuncPtr   UpdateWindow;
extern HandleAppMsgFuncPtr   HandleAppMsg;
extern struct Window        *CurrentWindow;
extern FreeNodeFuncPtr       FreeNodeFunctions[];
extern char                 *AppStrings[];
extern struct List           ObjectLists[];
extern struct List           PubScreenList;
extern struct RastPort       TmpRastPort;
extern struct NewGadget      NewGadget;
extern struct FileReqParms   FileReqParms;
extern struct Screen        *PublicScreen;
extern void                 *ScreenVI;
extern struct TextAttr       ScreenTextAttr;
extern struct TextFont      *ScreenFont;
extern struct MsgPort       *IDCMPPort;
extern struct MsgPort       *AppMsgPort;
extern struct Window        *MoveWindowPtr;
extern ULONG                 MoveWindowOffX,MoveWindowOffY;
extern BOOL                  OSV39;
extern BOOL                  WBScreen;
extern BOOL                  CreateIcons;
extern UWORD                 WindowTop;
extern UWORD                 ListViewColumns;
extern UWORD                 ListViewRows;
extern UWORD                 WBXOffset;
extern UWORD                 WBYOffset;
extern const struct TagItem  DisabledTags[];
extern const char            PrefsFileName[];
extern const char            SavePrefsFileName[];

/* Global defines */
#define TMVERSION  "2"
#define TMREVISION "1"
#define TMCRYEAR   "1990-93"

#define REQBUTTONWIDTH 20
#define SGBUFLEN 256

#define LISTREQ_EXEC  0
#define LISTREQ_IMAGE 1
#define LISTREQ_SOUND 2
#define LISTREQ_DOCK  3
#define LISTREQ_PUBSC 4
#define LREQRET_CANCEL   ((void *) -1)
#define LREQRET_NOSELECT ((void *) -2)

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
