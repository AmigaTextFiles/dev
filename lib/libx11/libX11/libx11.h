/* Copyright (c) 1996 by Terje Pedersen.  All Rights Reserved   */
/*                                                              */
/* By using this code you will agree to these terms:            */
/*                                                              */
/* 1. You may not use this code for profit in any way or form   */
/*    unless an agreement with the author has been reached.     */
/*                                                              */
/* 2. The author is not responsible for any damages caused by   */
/*    the use of this code.                                     */
/*                                                              */
/* 3. All modifications are to be released to the public.       */
/*                                                              */
/* Thats it! Have fun!                                          */
/* TP                                                           */
/*                                                              */

/***
   NAME
     libX11
   PURPOSE
     common includes to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Dec 22, 1994: Created.
***/

#ifndef LIBX11
#define LIBX11

#ifdef _M68020
#define __USE_SYSBASE 1
#endif

#include <proto/exec.h>

#include <exec/types.h>
#include <exec/memory.h>

#ifdef _M68881
#include <math.h>
#include <m68881.h>
#else
#include <math.h>
#endif

#include <assert.h>

#include <X11/X.h>
#include <X11/Xlib.h>

typedef struct {
  int x,y;
  unsigned int width,height;
  unsigned long border,background;
  char deleted;
  int parent,id,mapped;
} X11winchild;

typedef struct {
  struct BitMap *pBitMap;
  int  width,height,depth;
  char bTileStipple;
} X11BitMap_t;
  
extern X11winchild *X11DrawablesChildren;

/*extern X11winchild children[];*/
/*extern X11userdata *Xuserdata;*/
extern int X11mapping;

extern void X11init_fonts(void);
extern void X11exit_fonts(void);
extern void X11init_cursors(void);
extern void X11exit_cursors(void);
extern void X11exit_resources(void);
extern void X11init_resources(void);
extern void X11initcmap(void);
extern void X11updatecmap(void);
extern void X11SetupVisual(void);
extern int X11findparent(int);
extern void X11delayfor(int,int);
extern void X11resource_exit(int);

extern void X11init_events(void);
extern void X11exit_events(void);
extern void X11testback(int,int,int);
extern int X11NewSubWindow(int);
extern int X11NewBitmap(struct BitMap *,int width,int height,int depth);
extern int X11NewWindow(struct Window *);
extern void X11exit_cmaps(void);
extern void X11init_cmaps(void);
extern void X11init_clipping(void);
extern void X11exit_clipping(void);
extern void X11init_drawing(void);
extern void X11exit_drawing(void);

extern void init_backfillrp(int,int);

int GetBackground(struct Window *);
void SetBackground(int);

typedef struct {
  struct TextFont *tfont;
  struct TextAttr *tattr;
} sFont;

typedef struct {
  UWORD *cdata;
  int size; /* had to add this to store size used in AllocMem -tp */
  unsigned char hotx,hoty;
} CursorData; /* ,*Cursor */

/* resource errors */

#define WINDOW1 1
#define WINDOW2 2
#define WINDOW3 3
#define WINDOW4 20
#define EVENTS1 4
#define EVENTS2 5
#define DISPLAY1 6
#define DISPLAY2 7
#define DISPLAY3 8
#define DISPLAY4 9
#define DISPLAY5 10
#define IMAGES1 100
#define IMAGES2 101
#define IMAGES3 102
#define IMAGES4 103
#define IMAGES5 104
#define IMAGES6 105
#define IMAGES7 106
#define IMAGES8 107
#define IMAGES9 108
#define IMAGES10 109
#define IMAGES11 110
#define IMAGES12 111
#define IMAGES13 112

#define DRAWING1 200
#define DRAWING2 201
#define DRAWING3 202

#define DISPLAY6 21
#define DISPLAY7 22
#define DISPLAY8 23
#define XMDRAWING1 30
#define COLORMAPS1 31
#define COLORMAPS2 32
#define COLORMAPS3 33
#define FONTS1 40
#define FONTS2 41
#define FONTS3 42
#define FONTS4 43
#define FONTS5 44
#define FONTS6 45
#define FONTS7 46
#define FONTS8 47
#define FONTS9 48
#define FONTS10 49

#define RESOURCE1 50
#define RESOURCE2 51
#define RESOURCE3 52
#define RESOURCE4 53
#define RESOURCE5 54

#define XTMUI1 300
#define XTMUI2 301
#define XTMUI3 302
#define XTMUI4 303

extern char *X11cwd,X11home[];

typedef enum {
  X11_BUTTON=1,
  X11_TOGGLEBUTTON,
  X11_MENUSTRIP,
  X11_POPUPMENU,
  X11_SCROLLBAR,
  X11_ROWCOLUMN,
  X11_PULLDOWNMENU,
  X11_LABEL,
  X11_SEPARATOR,
  X11_FORM,
  X11_FILESELECTIONBOX,
  X11_PROMPTDIALOG,
  X11_FORMDIALOG,
  X11_FILESELECTIONDIALOG,
  X11_TEXTFIELD,
  X11_CASCADEBUTTON,
  X11_DRAWINGAREA,
  X11_TEXT,
  X11_SCALE,
} X11_Class;


#include "lists.h"

extern ListNode_t *pMemoryList;

typedef char boolean;

typedef struct {
  unsigned char nDisplayDepth;
  unsigned char nDisplayMaxDepth;
  unsigned short nDisplayWidth;
  unsigned short nDisplayHeight;
  unsigned short nDisplayMaxWidth;
  unsigned short nDisplayMaxHeight;
  unsigned short nDisplayColors;

  boolean bX11Open;
  boolean bLibsOpen;
  boolean bSubWins;
  boolean bNeedBackRP;
  boolean bX11Cursors;
  boolean bWbSaved;
  boolean bUse30;
  boolean bClearMemList;
  int nNumChildren;
} DisplayGlobals_s;

extern DisplayGlobals_s DG;

typedef struct {
  struct BitMap *pClipBM;
  struct Layer *pPreviousLayer;
  struct Region *pClipRegion;
  int nXClipOrigin;
  int nYClipOrigin;
  boolean bNeedClip;
} ClippingGlobals_s;


extern ClippingGlobals_s CG;

typedef struct internalevent {
  XEvent *xev;
  struct internalevent *next;
  int size;
} _InternalXEvent;

typedef struct {
  ULONG fwindowsig;
  struct Window *X11eventwin;
  _InternalXEvent *X11InternalEvents,*X11InternalEventsLast;
  unsigned long GrabMask;
  int GrabWin;
  unsigned int nButtonMask;
  int nPrevInside;
  int nPeeked;
  int nMouseX;
  int nMouseY;
  int nBorderX;
  int nBorderY;
  short nEventDrawable;
  ULONG nClass;
  UWORD nCode;
  UWORD nQual;
  boolean bHaveWinMsg;
  boolean bDontWait;
  boolean bButtonSwitch;
  boolean bSkipInternal;
  unsigned long nTime;
  boolean bX11SkippedClient;
  boolean bX11ReleaseAll;
} EventGlobals_s;

extern EventGlobals_s EG;

#include <X11/Xlib.h>

extern Window prevwin;
extern GC prevgc;
extern struct BitMap *X11FillBitMap;
extern int X11InternalFill;
extern struct RastPort backfillrp,backfillrp2;

/* #define DEBUGXEMUL 1 */
/* #define DEBUGXEMUL0 1 */
/* #define DEBUGXEMUL_ENTRY 1*/

#define NORMAL_FILL (1<<31)
#define INTERNAL_FILL (1<<30)

#define ROOTID 0xffff

extern int X11NewGC(GC newGC);
extern int X11OldSubWindow(int win);

#endif /* LIBX11 */
