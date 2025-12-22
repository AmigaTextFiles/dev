/*
 * data.c  V2.1
 *
 * configuration program global data
 *
 * (c) 1990-1993 Stefan Becker
 */

#include "ToolManagerConf.h"

struct Library *WorkbenchBase=NULL;
char *ProgramName;
UpdateWindowFuncPtr UpdateWindow=NULL;
HandleAppMsgFuncPtr HandleAppMsg=NULL;
struct Window *CurrentWindow;
FreeNodeFuncPtr FreeNodeFunctions[TMOBJTYPES]={FreeExecNode,
                                               FreeImageNode,
                                               FreeSoundNode,
                                               FreeMenuNode,
                                               FreeIconNode,
                                               FreeDockNode,
                                               FreeAccessNode};
struct List ObjectLists[TMOBJTYPES];
struct List PubScreenList;
struct RastPort TmpRastPort;
struct NewGadget NewGadget;
struct FileReqParms FileReqParms;
struct TextAttr ScreenTextAttr;
struct Screen *PublicScreen;
void *ScreenVI;
struct TextFont *ScreenFont;
struct MsgPort *IDCMPPort;
struct MsgPort *AppMsgPort=NULL;
BOOL OSV39=FALSE;
BOOL WBScreen;
BOOL CreateIcons=TRUE;
UWORD WindowTop;
UWORD ListViewColumns=20;
UWORD ListViewRows=8;
UWORD WBXOffset=0;
UWORD WBYOffset=0;

/* Global gadget tags */
const struct TagItem DisabledTags[]={GA_Disabled, TRUE,
                                     TAG_DONE};

/* Preferences file names */
const char PrefsFileName[]=TMPREFSUSE;
const char SavePrefsFileName[]=TMPREFSSAVE;
