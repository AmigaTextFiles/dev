/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     x11display
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 10, 1996: Created.
***/

#ifndef X11DISPLAY
#define X11DISPLAY

/********************************************************************************/
/* defines */
/********************************************************************************/

#include "defines.h"

enum {
  ARC=1,
  REC,
};

/********************************************************************************/
/* structs */
/********************************************************************************/

typedef struct {
  struct BitMap *pBitMap;
  int  width,height,depth;
  unsigned char bTileStipple;
  char vNumActive;
} X11BitMap_t;

typedef struct {
  void * win_rastptr; /* PLANEPTR */
  int AWidth,AHeight,max_coords;
  WORD *coor_buf;
  struct TmpRas win_tmpras /*,*oldtmpras*/;
  struct AreaInfo win_AIstruct;
  int background;

  struct AreaInfo *X11OldAreaInfo;
  struct TmpRas *X11OldTmpRas;
} X11userdata;

typedef struct {
  Display X11Display;
  Screen  X11Screen[2];
  GC      X11GC;
  XFontStruct *X11Font;
  Visual X11Visual[2];

  unsigned char nDisplayDepth;
  unsigned char nDisplayMaxDepth;
  unsigned short nDisplayWidth;
  unsigned short nDisplayHeight;
  unsigned short nDisplayMaxWidth;
  unsigned short nDisplayMaxHeight;
  unsigned short nDisplayColors;

  boolean bX11Open;
  boolean bLibsOpen;
  boolean bNeedBackRP;
  boolean bX11Cursors;
  boolean bWbSaved;
  boolean bUse30;
  boolean bClearMemList;

  int vWinX; /* current drawing window position */
  int vWinY;
  int vWinWidth; /* current drawing window size */
  int vWinHeight;

  Window vPrevWindow; /* previous window that was operated on */

  /* filling with pixmap background: */

  Pixmap X11FillSource;
  int X11FillX;
  int X11FillY;
  int X11FillWidth;
  int X11FillHeight;
  int X11FillDepth;
  int X11UnCached;
  
  int vLastFill;
  int vLastFillW;
  int vLastFillH;

  XPoint *X11PointBuffer;
  XPoint *aPoints;

  int vMaxPointBuffer;
  int vMaxEntries;

  int X11InternalFill; /* 1 if internal fill routines are to be used */

  int X11NumDrawables;
  int X11NumDrawablesWindows;
  int X11NumDrawablesBitmaps;
  int X11NumMUI;
  int X11NumGC;
  int X11NumCmaps;

  int X11AvailDrawables;
  int X11AvailWindows;
  int X11AvailBitmaps;
  int X11AvailMUI;
  int X11AvailGC;
  int X11AvailCmaps;

  int XAllocFailed;

  int vUseWB;
  int vWBapp;

  WORD *Xcurrent_tile;
  int Xtile_size;
  int amiga_id;
  int amiga_ham8;

  LONG X11ScreenID;
  int X11ScreenHAM8;

  struct Window *vWindow;
  struct Screen *Scr;
  struct Screen *wb;
  X11userdata *Xuserdata;

  struct RastPort X11BitmapRP;
  struct RastPort*  drp; /* current rastport beeing drawn into */
  struct BitMap *X11FillBitMap;
  int oldX11FillSource;
} DisplayGlobals_s;

extern GC vPrevGC; /* previous GC that was used */
extern GC vPrevDrawGC; /* previous GC that was used when only draw affected gc ops are set  */

extern DisplayGlobals_s DG;

/********************************************************************************/
/* prototypes */
/********************************************************************************/

#ifdef __cplusplus
extern "C" {
#endif

struct BitMap *
alloc_bitmap( int width,
	      int height,
	      int depth,
	      int flags,
	      struct BitMap *pFriend );

int free_bitmap( struct BitMap *bmp );

extern void CloseDownScreen(void);
extern int SetupScreen(int width,int height,int depth,ULONG id);
extern void CloseDownScreen(void);
extern Window AmigaCreateWindow(int,int,int,int,ULONG);
extern int OpenLibraries(void);
extern void CloseLibraries(void);
extern void report_display(void);
extern void force_exit(int);

extern void stackcheck(int);
extern char *getdisplayname(ULONG);

#if 0
extern void init_backrp( int width, int height, int depth );
#endif

int Display_FindParentX( int win, int x );
int Display_FindParentY( int win, int y );

extern struct RastPort *setup_win(Window win);
extern void setup_gc(GC gc);
extern void setup_drawgc( GC gc );

extern X11userdata* init_area(struct Window*,int,int,int);
extern void exit_area(struct Window*, X11userdata* );

void X11Fit_InternalFill( int w, int h, int invert, int xmin, int ymin );
void X11Setup_InternalFill(Pixmap pm);

extern struct Window *Agetwin(Window win);

extern Window X11NewMUI(Object *);

int X11FillCheck( int n,
		  int width,
		  int height );

#ifdef __cplusplus
}
#endif

/********************************************************************************/
/* globals */
/********************************************************************************/

extern struct Window **X11DrawablesWindows;
extern Object **X11DrawablesMUI;
extern X11BitMap_t *X11DrawablesBitmaps;

extern int X11FunctionMapping[];
extern UWORD X11LineMapping[];

extern char *X11Drawables,*X11DrawablesBackground;
extern GC *X11GC;
extern int *X11DrawablesMap,*X11DrawablesWindowsInvMap;
extern int X11NumDrawables,X11NumDrawablesWindows,X11NumDrawablesBitmaps;
extern int X11NumGC,X11AvailGC;
extern long *X11DrawablesMask;
extern int X11NumMUI;
extern Cursor *X11DrawablesMUICursor;

#ifdef DEBUGXEMUL_ENTRY
extern int bIgnoreDrawing; /* ignore outputting information about events */
extern int bSkipDrawing;
extern int bIgnoreEvents; /* ignore outputting information about events */
extern int bIgnoreColormaps; /* ignore outputting information about events */
extern int bIgnoreColormaps; /* ignore outputting information about events */
extern int bIgnoreDisplay; /* ignore outputting information about display */
extern int bIgnoreDisplayWarning; /* ignore outputting information about display warnings */
extern int bIgnoreWindows; /* ignore outputting information about windows */
extern int bIgnoreWindowWarnings; /* ignore outputting information about window warnings */
extern int bSkipFilling;

#endif

void setmouse( int x, int y );

void init_memlist( void );

void X11FreeGC( GC oldGC );
void X11FreeBitmap( int vPixmap );
void X11FreeWindow( int vWindow );

int GetNumMUI( void );
int GetNumDrawables( void );

#include "funcount.h"

#endif /* X11DISPLAY */
