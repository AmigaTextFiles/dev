/****h *AmigaTalk/SysLists.h ******************************************
**
** NAME
**    SysLists.h
**
***********************************************************************
*/

#ifndef  SYSLISTS_H
# define SYSLISTS_H 1

# ifdef ALLOCATE_VARS

struct IntuitionBase *IntuitionBase;
struct GfxBase       *GfxBase;
struct Library       *GadToolsBase;

PUBLIC UBYTE  ScrTitle[] = "System Info";

PUBLIC UBYTE  emg[256], *ErrMsg = &emg[0];

PUBLIC struct Screen       *Scr           = NULL;
PUBLIC UBYTE               *PubScreenName = "Workbench";
PUBLIC APTR                 VisualInfo    = NULL;
PUBLIC struct Window       *Wnd           = NULL;
PUBLIC struct Gadget       *GList         = NULL;
PUBLIC struct IntuiMessage  IMsg;

PUBLIC UWORD WLeft   = 0;
PUBLIC UWORD WTop    = 16;
PUBLIC UWORD WWidth  = 632;
PUBLIC UWORD WHeight = 250;

PUBLIC struct TextAttr *Font, Attr;
PUBLIC struct TextFont *TFont = NULL;

PUBLIC struct CompFont  CFont;

# else

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct GfxBase       *GfxBase;
IMPORT struct Library       *GadToolsBase;

IMPORT UBYTE  ScrTitle[];
IMPORT UBYTE  *ErrMsg;

IMPORT struct Screen       *Scr;
IMPORT UBYTE               *PubScreenName;
IMPORT APTR                 VisualInfo;
IMPORT struct Window       *Wnd;
IMPORT struct Gadget       *GList;
IMPORT struct IntuiMessage  IMsg;

IMPORT UWORD WLeft;
IMPORT UWORD WTop;
IMPORT UWORD WWidth;
IMPORT UWORD WHeight;

IMPORT struct TextAttr *Font;
IMPORT struct TextFont *TFont;

IMPORT struct CompFont  CFont;

# endif

// For SysScreens.c file:

#define ScrLV        0
#define ScrUpdate    1
#define ScrMore      2
#define ScrClose     3
#define ScrCancel    4
#define ScrSelection 5

#define SCR_CNT      6

// For SysTasks.c file:

#define TaskLV     0
#define TUpdate    1
#define TMore      2
#define TCancel    3
#define TFreeze    4
#define TRemove    5
#define TSignal    6
#define TBreak     7
#define TPriority  8
#define TSelection 9

#define T_CNT     10

// -------- Function protos for SysCommon.c file: --------------------

PUBLIC int  SetupSystemList( int (*OpenWindowFunc)( void ) );
PUBLIC void ShutdownSystemList();

#endif

/* ----------------------- END of SysLists.h file! ------------------- */
