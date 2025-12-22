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
     display
   PURPOSE
     add display handling to libX11
   NOTES
     
   HISTORY
     Terje Pedersen - Oct 23, 1994: Created.
***/

#include <time.h>

#include <intuition/intuition.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/gadtools.h>

#include <graphics/gfxbase.h>
#include <graphics/gfxmacros.h>

#include <libraries/asl.h>
#include <proto/asl.h>

#include <dos.h>
#include <signal.h>
#include <stdlib.h>
#include <stdio.h>

#include "libX11.h"
#define XLIB_ILLEGAL_ACCESS 1

#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
/*
#include <X11/IntrinsicP.h>
#include <X11/CoreP.h>

#include <X11/Xlibint.h>
*/

#include <libraries/mui.h>
#include <proto/muimaster.h>

#include "amigax_proto.h"
#include "amiga_x.h"

ListNode_t *pMemoryList=NULL;

#ifdef XMUIAPP
struct Library *MUIMasterBase=NULL;
#endif

/*******************************************************************************************/
/* globals */
/*******************************************************************************************/

int amiga_id=-1,amiga_ham8=0;
int Xdash;
UWORD *XOrigPattern;
byte XOrigPatternSize;
WORD *Xcurrent_tile=NULL;

Display amigaX_display;
Screen  amiga_screen[2];
extern Visual X11AmigaVisual[2];
/*Screen  screens[10];*/
GC      amiga_gc;

Window prevwin=NULL;
GC prevgc=NULL;
struct RastPort *drp;


#define MAX_COORD 400 /* 100 vertices, 5 bytes each = 500 bytes. */ 

X11userdata *Xuserdata=NULL;
X11userdata *XBackUserData=NULL;
struct AreaInfo *_Xoldarea;
struct TmpRas *_Xoldtmpras;

void X11free_userdata(X11userdata *ud);

/* internal tile based filling */

int X11FillFree=0;
Pixmap X11FillSource=0;
int X11InternalFill=0;
struct BitMap *X11FillBitMap;
 
/******/

int userdata_width(void) {
  if (Xuserdata) return Xuserdata->AWidth;
  return 0;
}

int userdata_height(void) {
  if (Xuserdata) return Xuserdata->AHeight;
  return 0;
}


/*******************************************************************************************/
/* externals */
/*******************************************************************************************/
/*struct Library	*IconBase = NULL;*/
#define NEEDINTUITIONBASE
#define NEEDGFXBASE

#ifdef NEEDINTUITIONBASE
extern struct IntuitionBase *IntuitionBase;
#endif
#ifdef NEEDGFXBASE
extern struct GfxBase *GfxBase;
#endif
extern struct Library *AslBase;
extern struct Library *GadToolsBase;
extern struct Library *DiskfontBase;
extern struct Library *LayersBase;
extern struct Library *KeymapBase;

/*
extern struct Library *CxBase;
extern struct Library *UtilityBase;
*/
extern struct DosLibrary *DOSBase;

struct Screen *Scr=NULL,*wb=NULL;
struct RastPort temprp,backrp,backfillrp,backfillrp2;
extern int prevcm;

char *LIBversion="$VER: libX11 1.00 (03.24.94)";

char *LibX11Info="This program is using libX11 by Terje Pedersen!";

struct Layer_Info *X11layerinfo;

struct Window *rootwin=NULL;

/*******************************************************************************************/
/* defines */
/*******************************************************************************************/
#define SCALE8TO32(x) ((x)|((x)<<8)|((x)<<16)|((x)<<24))

#define SCREENOPENFAIL 10L
#define SCREENVISUALFAIL 11L
#define SCRWINOPENFAIL 12L
#define ACWFAIL 20L
#define XCSFAIL 30L

/*******************************************************************************************/
/* global  data */
/*******************************************************************************************/

DisplayGlobals_s DG = { 0 };

char vendor[]="Amiga",*X11cwd=NULL;
int borderadj=0,adjx,adjy;
int newpic=1; /* remove it..*/

/*
int new_id=0;
int maxwidth=720,maxheight=560;
int df=0;
*/
int usewb=1,/*Adisplay=0,*/wbapp=0;
int X_relx,X_rely,X_bottom,X_right,X_width,X_height;
int debugxemul=0,gfxcard=0,askmode=0;

/*struct TextAttr topaz8 = {(STRPTR)"topaz.font",8,0x00,0x01};*/
UWORD DriPens[] = { 65535 };
APTR VisualInfo = NULL;
ULONG wbmode=DEFAULT_MONITOR_ID;

struct RastPort drawrp;

/*X11winchild children[CHILDRENAVAIL];*/
/*long amigamask[CHILDRENAVAIL];*/

struct NameInfo dbuffer;
char pbuffer[MAXPUBSCREENNAME]="";

int X11NumDrawables,X11NumDrawablesWindows,X11NumDrawablesBitmaps;
int X11NumDrawablesSubWindows,X11NumMUI;

int X11AvailDrawables,X11AvailWindows,X11AvailBitmaps;
int X11AvailSubWindows,X11AvailMUI,X11AvailGC,X11NumGC;
GC *X11GC;

char *X11Drawables,*X11DrawablesBackground;
int *X11DrawablesMap,*X11DrawablesWindowsInvMap;
long *X11DrawablesMask;
struct Window **X11DrawablesWindows;
X11BitMap_t *X11DrawablesBitmaps;
Object **X11DrawablesMUI;
Cursor *X11DrawablesMUICursor;
_ActualWindow *X11ActualWindows;
int *X11DrawablesSubWindows;
X11winchild *X11DrawablesChildren;

/*******************************************************************************************/

void X11resource_exit(int n){
  printf("Unable to allocate internal resources! (%d)\n",n);
  exit(-1);
}

/*
typedef struct {
  int entries,maxentries,entrysize;
  char *data;
} DMap;

NewDMap(DMap *pm){
  char *new=malloc(pm->entrysize*(pm->entries+5));
  if(!new) X11resource_exit(-1);
  if(pm->data!=NULL){
    memcpy(new,pm->date,pm->entries*pm->entrysize);
    free(pm->data);
  }
  pm->maxentries=pm->entries+5;
  pm->data=new;
}

XID NewCmapsEntry(struct ColorMap *cmap){
  X11Cmaps[X11NumCmaps++]=cmap;
  if(X11NumCmaps==X11AvailCmaps){
    X11Cmaps=NewPointerMap(X11AvailCmaps+10,X11Cmaps,X11AvailCmaps);
    X11AvailCmaps+=10;
  }
  return(X11NumCmaps-1);
}
*/

void X11init_drawables(void){
  X11NumDrawables=1; X11AvailDrawables=2;
  X11NumDrawablesWindows=0;
  X11NumDrawablesBitmaps=0;
  X11NumDrawablesSubWindows=0;
  X11NumMUI=0;
  X11AvailWindows=2;
  X11AvailBitmaps=2;
  X11AvailSubWindows=2;
  X11AvailMUI=2;
  X11AvailGC=2;
  X11NumGC=0;

  X11Drawables=(char*)calloc(X11AvailDrawables,1);
  X11DrawablesBackground=(char*)calloc(X11AvailDrawables,1);
  X11DrawablesMap=(int*)calloc(X11AvailDrawables*sizeof(int),1);
  X11DrawablesWindowsInvMap=(int*)malloc(X11AvailWindows*sizeof(int));
  X11DrawablesMask=(long*)malloc(X11AvailDrawables*sizeof(long));
  X11ActualWindows=(_ActualWindow*)calloc(1,X11AvailWindows*sizeof(_ActualWindow));
  X11DrawablesWindows=(struct Window**)calloc(X11AvailWindows*sizeof(struct Window*),1);
  X11DrawablesBitmaps=(X11BitMap_t*)malloc(X11AvailBitmaps*sizeof(X11BitMap_t));
  X11DrawablesMUI=(Object**)malloc(X11AvailMUI*sizeof(Object*));
  X11DrawablesMUICursor=(Cursor*)malloc(X11AvailMUI*sizeof(Cursor));
  X11DrawablesSubWindows=(int*)malloc(X11AvailSubWindows*sizeof(int));
  X11DrawablesChildren=(X11winchild*)calloc(X11AvailSubWindows*sizeof(X11winchild),1);
  X11GC=(GC*)malloc(X11AvailGC*sizeof(int *));
  if(!X11Drawables||!X11DrawablesMap||!X11DrawablesWindows||!X11DrawablesBitmaps||
     !X11DrawablesSubWindows||!X11DrawablesWindowsInvMap||!X11DrawablesMask||
     !X11DrawablesMUI||!X11DrawablesChildren||!X11DrawablesMUICursor||!X11GC)
    X11resource_exit(DISPLAY1);
  X11Drawables[0]=X11ROOT;
}

void X11exit_drawables(void){
  free(X11DrawablesChildren);
  free(X11Drawables);
  free(X11DrawablesBackground);
  free(X11DrawablesMap);
  free(X11DrawablesMask);
  free(X11ActualWindows);
  free(X11DrawablesWindowsInvMap);
  free(X11DrawablesWindows);
  free(X11DrawablesBitmaps);
  free(X11DrawablesSubWindows);
  free(X11DrawablesMUI);
  free(X11DrawablesMUICursor);
  free(X11GC);
}

void X11expand_drawables(void){
  char *old=X11Drawables;
  char *oldback=X11DrawablesBackground;
  int *oldmap=X11DrawablesMap;
  long *oldmask=X11DrawablesMask;
  X11Drawables=(char*)malloc(X11AvailDrawables+10);
  X11DrawablesBackground=(char*)calloc(X11AvailDrawables+10,1);
  X11DrawablesMap=(int*)malloc((X11AvailDrawables+10)*sizeof(int));
  X11DrawablesMask=(long*)malloc((X11AvailDrawables+10)*sizeof(long));

  if(!X11Drawables||!X11DrawablesMap||!X11DrawablesMask) X11resource_exit(DISPLAY2);
  memcpy(X11Drawables,old,X11AvailDrawables);
  memcpy(X11DrawablesBackground,oldback,X11AvailDrawables);
  memcpy(X11DrawablesMap,oldmap,X11AvailDrawables*sizeof(int));
  memcpy(X11DrawablesMask,oldmask,X11AvailDrawables*sizeof(long));
  X11AvailDrawables+=10;
  free(old);
  free(oldback);
  free(oldmap);
  free(oldmask);
}

void X11expand_windows(void){
  struct Window **old=X11DrawablesWindows;
  int *oldwin=X11DrawablesWindowsInvMap;
  _ActualWindow *oldactual=X11ActualWindows;
  X11DrawablesWindows=(struct Window**)calloc((X11AvailWindows+10)*sizeof(struct Window*),1);
  X11DrawablesWindowsInvMap=(int*)calloc((X11AvailWindows+10)*sizeof(int),1);
  X11ActualWindows=(_ActualWindow*)calloc((X11AvailWindows+10)*sizeof(_ActualWindow),1);
  memcpy(X11DrawablesWindows,old,X11AvailWindows*sizeof(struct Window*));
  memcpy(X11DrawablesWindowsInvMap,oldwin,X11AvailWindows*sizeof(int));
  memcpy(X11ActualWindows,oldactual,X11AvailWindows*sizeof(_ActualWindow));
  if(!X11DrawablesWindows||!X11DrawablesWindowsInvMap||!X11ActualWindows) X11resource_exit(DISPLAY3);
  X11AvailWindows+=10;
  free(old);
  free(oldwin);
  free(oldactual);
}

void X11expand_bitmaps(void){
  X11BitMap_t *old=X11DrawablesBitmaps;
  X11DrawablesBitmaps=(X11BitMap_t*)calloc((X11AvailBitmaps+10)*sizeof(X11BitMap_t),1);
  if(!X11DrawablesBitmaps) X11resource_exit(DISPLAY4);
  memcpy(X11DrawablesBitmaps,old,X11AvailBitmaps*sizeof(X11BitMap_t));
  X11AvailBitmaps+=10;
  free(old);
}

void X11expand_MUI(void){
  Object **old=X11DrawablesMUI;
  Cursor *oldc=X11DrawablesMUICursor;
  X11DrawablesMUI=(Object**)malloc((X11AvailMUI+10)*sizeof(Object *));
  X11DrawablesMUICursor=(Cursor*)malloc((X11AvailMUI+10)*sizeof(Cursor));
  if(!X11DrawablesMUI||!X11DrawablesMUICursor) X11resource_exit(DISPLAY4);
  memcpy(X11DrawablesMUI,old,X11AvailMUI*sizeof(Object*));
  memcpy(X11DrawablesMUICursor,oldc,X11AvailMUI*sizeof(Cursor));
  X11AvailMUI+=10;
  free(old);
  free(oldc);
}

void X11expand_subwindows(void){
  int *old=X11DrawablesSubWindows;
  X11winchild *oldchild=X11DrawablesChildren;
  X11DrawablesSubWindows=(int*)calloc((X11AvailSubWindows+10)*sizeof(int),1);
  X11DrawablesChildren=(X11winchild*)calloc((X11AvailSubWindows+10)*sizeof(X11winchild),1);
  if(!X11DrawablesSubWindows||!X11DrawablesChildren) X11resource_exit(DISPLAY5);
  memcpy(X11DrawablesSubWindows,old,X11AvailSubWindows*sizeof(int));
  memcpy(X11DrawablesChildren,oldchild,X11AvailSubWindows*sizeof(X11winchild));
  X11AvailSubWindows+=10;
  free(old);
  free(oldchild);
}

void X11expand_GC(void){
  GC *old=X11GC;
  X11GC=(GC*)malloc((X11AvailGC+10)*sizeof(int*));
  if(!X11GC) X11resource_exit(DISPLAY5);
  memcpy(X11GC,old,X11AvailGC*sizeof(int*));
  X11AvailGC+=10;
  free(old);
}

X11NewWindow(struct Window *win){
  X11Drawables[X11NumDrawables]=X11WINDOW;
  X11DrawablesMap[X11NumDrawables]=X11NumDrawablesWindows;
  X11DrawablesWindowsInvMap[X11NumDrawablesWindows]=X11NumDrawables++;
  X11DrawablesWindows[X11NumDrawablesWindows++]=win;
  if(X11NumDrawables==X11AvailDrawables) X11expand_drawables();
  if(X11NumDrawablesWindows==X11AvailWindows) X11expand_windows();
  return(X11NumDrawables-1);
}

int X11NewGC(GC newGC){
  X11GC[X11NumGC++]=newGC;
  if(X11NumGC==X11AvailGC) X11expand_GC();
  return(X11NumGC-1);
}

X11NewBitmap( struct BitMap *bmp, int width, int height, int depth ){
  X11Drawables[X11NumDrawables]=X11BITMAP;
  X11DrawablesMap[X11NumDrawables++]=X11NumDrawablesBitmaps;
  X11DrawablesBitmaps[X11NumDrawablesBitmaps].width=width;
  X11DrawablesBitmaps[X11NumDrawablesBitmaps].height=height;
  X11DrawablesBitmaps[X11NumDrawablesBitmaps].depth=depth;
  X11DrawablesBitmaps[X11NumDrawablesBitmaps].bTileStipple=0;
  X11DrawablesBitmaps[X11NumDrawablesBitmaps++].pBitMap=bmp;
  if(X11NumDrawables==X11AvailDrawables) X11expand_drawables();
  if(X11NumDrawablesBitmaps==X11AvailBitmaps) X11expand_bitmaps();
  return(X11NumDrawables-1);
}

Window X11NewMUI(Object *obj){
  X11Drawables[X11NumDrawables]=X11MUI;
  X11DrawablesMap[X11NumDrawables++]=X11NumMUI;
  X11DrawablesMUI[X11NumMUI++]=obj;
  if(X11NumDrawables==X11AvailDrawables) X11expand_drawables();
  if(X11NumMUI==X11AvailMUI) X11expand_MUI();
  return((Window)(X11NumDrawables-1));
}

X11SetMui(XID window, Object* obj){
  X11DrawablesMUI[X11DrawablesMap[window]]=obj;
}

X11NewSubWindow(int win){
  X11Drawables[X11NumDrawables]=X11SUBWINDOW;
  X11DrawablesMap[X11NumDrawables++]=X11NumDrawablesSubWindows;
  X11DrawablesSubWindows[X11NumDrawablesSubWindows++]=win;
  if(X11NumDrawables==X11AvailDrawables) X11expand_drawables();
  if(X11NumDrawablesSubWindows==X11AvailSubWindows) X11expand_subwindows();
  return(X11NumDrawables-1);
}

X11OldSubWindow(int win){
  int i;
  for( i=0; i>X11NumDrawables; i++ )
    if( X11Drawables[i]==X11SUBWINDOW && X11DrawablesSubWindows[X11DrawablesMap[i]]==win ){
      return i;
    }
  return 0;
}

/*******************************************************************************************/

/* PTINRECT returns '1' if x,y is in rect (inclusive) */
#define PTINRECT(x,y,rx,ry,rw,rh) \
           ((x)>=(rx) && (y)>=(ry) && (x)<=(rx)+(rw) && (y)<=(ry)+(rh))

int check_inside_subwindows(struct Window *win,int x,int y){
  int i;
  for(i=DG.nNumChildren;i>0;i--){
    if(PTINRECT(x,y,X11DrawablesChildren[i].x,X11DrawablesChildren[i].y,X11DrawablesChildren[i].width,X11DrawablesChildren[i].height)&&
       !X11DrawablesChildren[i].deleted&&X11DrawablesChildren[i].mapped&&
       X11DrawablesChildren[i].parent==EG.nEventDrawable){
      X_relx=win->BorderLeft+X11DrawablesChildren[i].x;
      X_rely=win->BorderTop+X11DrawablesChildren[i].y;
/*      printf("inside subwindow %d\n",i);*/
      return(i);
    }
  }
/*
  X_relx=0;
  X_rely=0;
*/

  return(0);
}

int X11findparent(int win){
  int pos;
  if(X11Drawables[win]==X11WINDOW) return(win);
  pos=X11DrawablesChildren[X11DrawablesSubWindows[X11DrawablesMap[win]]].parent;
  if(X11Drawables[pos]!=X11SUBWINDOW){
/*    printf("findparent: %d is a parent of %d\n",pos,win);*/
    return(pos);
  } else return(X11findparent(pos));
}

void clear_subwin(Window win,int border,int background){
  struct Window *w;
  int child=X11DrawablesSubWindows[X11DrawablesMap[win]];
  int parent=X11findparent(win);
  if(win!=prevwin) if(!(drp=setup_win(win))) return;
  w=Agetwin(win);
  prevwin=-1;
  prevgc=(GC)-1;
  if(!w) return;
  if(!X11ActualWindows[X11DrawablesMap[parent]].mapped) return;

  SetDrMd(drp,JAM1);
  SetAPen(drp,X11DrawablesBackground[win]);
  RectFill(drp,
	   w->BorderLeft+X11DrawablesChildren[child].x+border,
	   w->BorderTop+X11DrawablesChildren[child].y+border,
	   w->BorderLeft+X11DrawablesChildren[child].x+X11DrawablesChildren[child].width-border,
	   w->BorderTop+X11DrawablesChildren[child].y+X11DrawablesChildren[child].height-border);
}

/*******************************************************************************************/

void force_exit(n){
/*  printf("forced exit!\n");*/
  signal(SIGINT,SIG_DFL); 
  signal(SIGABRT,SIG_DFL);
  XFlush(&amigaX_display);
  rootwin=NULL;
  XCloseDisplay(&amigaX_display);
  exit(-1);
}

/*******************************************************************************************/

void report_display(void){
  if(debugxemul){
    printf("dosbase lib version %d\n",DOSBase->dl_lib.lib_Version);
    if(!DG.bUse30) printf("not ");
    printf("using os3.0 funcs.\n");
/*
#ifdef _M68040
    printf("using 68040 code\n");
#elif defined(_M68030)
    printf("using 68030 code\n");
#elif defined(_M68020)
    printf("using 68020 code\n");
#elif defined(_M68000)
    printf("using 68000 code\n");
#endif

#ifdef _M68881
    printf("and 68881 math!\n");
#endif
*/
  }
}

cantopen(char *lib){
  printf("unable to open %s\n",lib);
}

/*struct IOStdReq ioreq;*/

int OpenLibraries(void){
  if(DG.bLibsOpen)return(1);
  KeymapBase = OpenLibrary("keymap.library", 37);
  if (KeymapBase == NULL) return FALSE;
#ifdef NEEDGFXBASE
  if (!(GfxBase = (struct GfxBase*)OpenLibrary( "graphics.library", 39L ))){
    if (!(GfxBase = (struct GfxBase*)OpenLibrary( "graphics.library", 37L ))){
      cantopen("graphics.library v39");
      return FALSE;
    }
  }
#endif
#ifdef NEEDINTUITIONBASE
  if (!(IntuitionBase = (struct IntuitionBase*)OpenLibrary( "intuition.library", 39L ))){
    if (!(IntuitionBase = (struct IntuitionBase*)OpenLibrary( "intuition.library", 37L ))){
      cantopen("Intuition.library v37 or v39");
      return FALSE;
    }
    DG.bUse30=0;
  }else DG.bUse30=1;
#endif
  if (!(LayersBase = OpenLibrary( "layers.library", 39L ))){
    if (!(LayersBase = OpenLibrary( "layers.library", 37L ))){
      cantopen("layers.library v37");
      return FALSE;
    }
  }
/*
  if (!(CxBase = OpenLibrary( "commodities.library", 37l ))) return FALSE;
  if (!(IconBase = OpenLibrary( "icon.library", 37l ))) return FALSE;
  if (!(UtilityBase = OpenLibrary( "utility.library", 37l ))) return FALSE;
*/
  if (!(AslBase = OpenLibrary( "asl.library", 37L ))){
    cantopen("asl.library v37");
    return FALSE;
  }
  if (!(DiskfontBase = OpenLibrary( "diskfont.library", 36L ))){
    cantopen("asl.library v36");
    return FALSE;
  }
  if (!(GadToolsBase = OpenLibrary( "gadtools.library", 39L ))){
    if (!(GadToolsBase = OpenLibrary( "gadtools.library", 37L ))){
      cantopen("gadtools.library");
      return FALSE;
    }
  }
#ifdef XMUIAPP
  if(!(MUIMasterBase=OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))) exit(20);
#endif
  DG.bLibsOpen=1;
  return TRUE;
}

void CloseLibraries(void){
  if(GadToolsBase)CloseLibrary(GadToolsBase);
  if(DiskfontBase)CloseLibrary(DiskfontBase);
  if(AslBase)CloseLibrary(AslBase);
/*
  if(UtilityBase)CloseLibrary(UtilityBase);
  if(IconBase)CloseLibrary(IconBase);
  if(CxBase)CloseLibrary(CxBase);
*/
  if(LayersBase)CloseLibrary((struct Library*)LayersBase);
#ifdef NEEDGFXBASE
  if(GfxBase)CloseLibrary((struct Library*)GfxBase);
#endif
#ifdef NEEDINTUITIONBASE
  if(IntuitionBase)CloseLibrary((struct Library*)IntuitionBase);
#endif
  CloseLibrary(KeymapBase);

#ifdef XMUIAPP
  if(MUIMasterBase)CloseLibrary(MUIMasterBase);
#endif
}

/*******************************************************************************************/
/* 2.04 friendly alloc of bitmap */
/* BMF_CLEAR|BMF_DISPLAYABLE */
struct BitMap *alloc_bitmap(int width,int height,int depth,int flags){
  int i;
  struct BitMap *bmp;
/*  printf("Allocating <%d,%d> depth %d\n",width,height,depth); */
  if(!DG.bUse30){
    bmp=calloc(sizeof(struct BitMap),1);
    if(!bmp) return(0);
    InitBitMap(bmp,depth,width,height);
    for(i=0;i<depth;i++){
      bmp->Planes[i]=(PLANEPTR)AllocRaster(width,height);
      if(!bmp->Planes[i]) X11resource_exit(DISPLAY6);
      memset(bmp->Planes[i],0,RASSIZE(width,height));
    }
/*    bmp->Rows=height;*/
  }else{
    if(!usewb)
      bmp = AllocBitMap((UWORD)(width), (UWORD)height, (UWORD)depth, (UWORD)BMF_CLEAR, NULL);
    else
      bmp = AllocBitMap((UWORD)(width), (UWORD)height, (UWORD)depth, (UWORD)(flags), NULL);
  }
  if(!bmp){
    printf("alloc bitmap %d %d %d failed!\n",width,height,bmp);
    XCloseDisplay(NULL);
    exit(-1);
  }
  for( i=depth; i<8; i++ )
    bmp->Planes[i]=NULL;
  return(bmp);
}

int free_bitmap(struct BitMap *bmp){
  int i;
  if(!bmp) return;
  if(!DG.bUse30){
    for(i=0;i<bmp->Depth;i++){
      if(bmp->Planes[i])
	FreeRaster(bmp->Planes[i],(bmp->BytesPerRow)*8,bmp->Rows);
    }
    free(bmp);
  }else FreeBitMap(bmp);
}

/*******************************************************************************************/

char *getdisplayname(ULONG id){
  int res=GetDisplayInfoData(FindDisplayInfo(id),(UBYTE*)&dbuffer,sizeof(dbuffer),DTAG_NAME,NULL);
  if(res) return((char*)dbuffer.Name);
  return(NULL);
}

/*******************************************************************************************/
/*
char X11home[128]="";
*/

void X11gethome(void);

void X11gethome(void){
  X11cwd=getcwd(NULL,128);
/*
  strcpy(X11home,X11cwd);
  {
    h=getenv("X11HOME");
    if(h!=NULL){
      strcpy(X11home,h);
      free(h);
    }
  }
*/
}

void stackcheck(int n){
  if(stacksize()+stackused()<n){
    printf("set stack to >=%d! current %ld used %ld\n",n,stacksize(),stackused());
    CloseLibraries();
    exit(-1);
  }
}

void init_memlist(void) {
  pMemoryList=List_MakeNull();
}

void cleanup_memlist(void) {
  List_FreeList(pMemoryList);
  MWReport("At end of main()", MWR_FULL);  /* Generate a memory usage report */
}

void init_backfill( int w, int h ){
  init_area(NULL,200,w,h);
  XBackUserData=Xuserdata;
  Xuserdata=NULL;
}

void exit_backfill(void){
  X11free_userdata(XBackUserData);
}

Display *XOpenDisplay(char * display_name){
  XrmValue value;
  XrmDatabase db;
  struct DimensionInfo dinfo;
/*  struct DisplayInfo buffer;*/
/*  struct MonitorInfo minfo;*/
  DisplayInfoHandle handle;
  char dispname[80]="";
  if(DG.bX11Open) return(&amigaX_display);

  memset(&DG,0,sizeof(DisplayGlobals_s));

  DG.bX11Cursors=1;
  DG.bX11Open=1;
  DG.nDisplayDepth=8;
  DG.bClearMemList=True;

  if(!pMemoryList)
    init_memlist();
  else DG.bClearMemList=False;

#ifdef DEBUGXEMUL_ENTRY
  printf("(display)XOpenDisplay [");
  if(display_name) printf("%s]\n",display_name);
  else printf("NULL]\n");
#endif
  if(!OpenLibraries()) X11resource_exit(DISPLAY7);
  fprintf(stderr,LibX11Info);
  fprintf(stderr,"\n");
  stackcheck(20000);
  if(display_name){
    strcpy(dispname,display_name);
    usewb=1;
  }
  XrmInitialize();
  db=XtDatabase(&amigaX_display);
  if(XrmGetResource(db,"Amiga.debug",NULL,NULL,&value))
    debugxemul=1;
  if(XrmGetResource(db,"Amiga.nochunkytoplanar",NULL,NULL,&value))
    gfxcard=1;
  if(XrmGetResource(db,"Amiga.askmode",NULL,NULL,&value))
    askmode=1;
  if(XrmGetResource(db,"Amiga.cursors",NULL,NULL,&value))
    sscanf(value.addr,"%d",&DG.bX11Cursors);
  if(XrmGetResource(db,"Amiga.usepubscreen",NULL,NULL,&value)){
    strcpy(dispname,value.addr);
  }
  if(strlen(dispname)==0) GetDefaultPubScreen(pbuffer);
  else {
    strcpy(pbuffer,dispname);
    if(stricmp(dispname,"Workbench")==0)usewb=1;
  }
  if(strlen(pbuffer)>0){
    if(debugxemul) printf("locking defpub '%s'\n",pbuffer);
    wb=LockPubScreen(pbuffer);
  }
  if(!wb) wb=LockPubScreen(NULL);

/*  if(IntuitionBase->lib_Version>=39) DG.bUse30=1; else DG.bUse30=0;*/ /*DOSBase*/
  handle=FindDisplayInfo(HIRES_KEY);
  GetDisplayInfoData(handle,(UBYTE*)&dinfo,sizeof(dinfo),DTAG_DIMS,NULL);
  if(debugxemul)
    printf("display_info max [%d,%d] depth %d.\n",
	   dinfo.MaxRasterWidth,dinfo.MaxRasterHeight,dinfo.MaxDepth);

  if(dinfo.MaxDepth>8){
    DG.nDisplayDepth=8;
    DG.nDisplayMaxDepth=8;
  }else{
    DG.nDisplayDepth=dinfo.MaxDepth;
    DG.nDisplayMaxDepth=dinfo.MaxDepth;
  }

  DG.nDisplayWidth=wb->Width/*dinfo.MaxRasterWidth*/-32;
  DG.nDisplayHeight=wb->Height /*dinfo.MaxRasterHeight*/-16;
  DG.nDisplayMaxWidth=dinfo.MaxRasterWidth;
  DG.nDisplayMaxHeight=dinfo.MaxRasterHeight;
  if(DG.nDisplayMaxWidth>2048) DG.nDisplayMaxWidth=2048;
  if(DG.nDisplayMaxHeight>2048) DG.nDisplayMaxHeight=2048;

  X11init_drawables();

  amiga_screen[0].cmap=(Colormap)wb->ViewPort.ColorMap;
/*  amiga_screen[1].cmap=XCreateColormap(NULL,NULL,0,256);*/
  DG.nDisplayColors=(1<<(wb->RastPort.BitMap->Depth));
  DG.nDisplayDepth=wb->RastPort.BitMap->Depth;
  if(usewb||wbapp){
    Scr=wb; 
    DG.nDisplayDepth=(wb->RastPort.BitMap->Depth);
    DG.nDisplayMaxDepth=(wb->RastPort.BitMap->Depth);
    DG.nDisplayWidth=wb->Width;
    DG.nDisplayHeight=wb->Height;
    DG.nDisplayMaxWidth=DG.nDisplayWidth;
    DG.nDisplayMaxHeight=DG.nDisplayHeight; 
    X11init_cmaps();
    if(!DG.bWbSaved) savewbcm();
  } else X11init_cmaps();

  init_backfill(wb->Width,wb->Height);

  if(XrmGetResource(XtDatabase(&amigaX_display),"Amiga.displaydepth",NULL,NULL,&value)){
    sscanf(value.addr,"%d",&DG.nDisplayDepth);
    DG.nDisplayMaxDepth=DG.nDisplayDepth;
  }
  report_display();

  amigaX_display.screens=amiga_screen;
  amigaX_display.bitmap_bit_order=1;
  amigaX_display.bitmap_unit=16;
  amiga_screen[0].display=&amigaX_display;
  amiga_screen[1].display=&amigaX_display;
  amigaX_display.vendor=vendor;
  amigaX_display.release=001;
  amigaX_display.display_name=vendor;
  amigaX_display.default_screen=0;
  amiga_screen[0].root_visual=&X11AmigaVisual[0];
  amiga_screen[1].root_visual=&X11AmigaVisual[1];
  {
    XGCValues xgc;
    xgc.foreground=1;
    xgc.background=0;
    amiga_screen[0].default_gc=XCreateGC(&amigaX_display,NULL,GCForeground|GCBackground,&xgc);
  }
  amiga_screen[0].root=ROOTID;
  amiga_screen[0].root_depth=DG.nDisplayDepth;
  amiga_screen[0].width=DG.nDisplayWidth;
  amiga_screen[0].height=DG.nDisplayHeight;
  amiga_screen[0].mwidth=(int)((DG.nDisplayWidth/72)*25.4);
  amiga_screen[0].mheight=(int)((DG.nDisplayHeight/72)*25.4);
  amiga_screen[0].white_pixel=2;
  amiga_screen[0].black_pixel=1;
  amiga_screen[1].max_maps=2;
  X11SetupVisual();
/*
  amiga_visual.map_entries=1<<DG.nDisplayDepth;
  amiga_visual.red_mask=0x800;
  amiga_visual.class=PseudoColor;
  amiga_visual.green_mask=0x080;
  amiga_visual.blue_mask=0x008;
  amiga_visual.bits_per_rgb=8;
*/
  signal(SIGINT,force_exit); 
  signal(SIGABRT,SIG_IGN);
/*
  for(i=0;i<CHILDRENAVAIL;i++){
    X11DrawablesChildren[i].x=0;
    X11DrawablesChildren[i].y=0;
    X11DrawablesChildren[i].deleted=0;
    X11DrawablesChildren[i].mapped=0;
  }*/
  open_timer();
  backrp.BitMap=NULL;
  temprp.BitMap=NULL;


  InitRastPort(&drawrp);
/*
  X11layerinfo=NewLayerInfo();
  {
    struct Screen *oldscr=Scr;
    Scr=wb;
    init_backrp();
    Scr=oldscr;
  }
  drawrp.Layer=CreateUpfrontLayer(X11layerinfo,backrp.BitMap,0,0,wb->Width,wb->Height,LAYERSIMPLE);*/
  amiga_gc=amiga_screen[0].default_gc;
  amiga_gc->values.font=(unsigned long)wb->RastPort.Font;
  if(X11cwd==NULL) X11gethome();
  X11init_fonts();
  X11init_drawing();
/*  for(i=0;i<CHILDRENAVAIL;i++) amigamask[i]=0xFFFF;*/
  chdir(X11cwd);
  X11init_clipping();
  X11init_resources();
  X11init_cursors();
  X11init_events();
  return(&amigaX_display);
}

void XSetPlanes(int d){
  amiga_screen[0].root_depth=d;
  DG.nDisplayDepth=d;
/*  amiga_visual.map_entries=1<<DG.nDisplayDepth;*/
}

/*******************************************************************************************/

/* int num_windows=0;Window windows[10];*/

XCloseDisplay(Display * display){
  int i;
#ifdef DEBUGXEMUL_ENTRY
  printf("(display)XCloseDisplay\n");
#endif
  if(!DG.bX11Open) return;
  for(i=0;i<X11NumDrawablesWindows;i++)
    if(X11ActualWindows[i].mapped){
      /* nasty, still not closed */
      XUnmapWindow(NULL,X11ActualWindows[i].win);
    }
  for(i=0;i<X11NumGC;i++)
    if(X11GC[i]!=NULL) XFreeGC(NULL,X11GC[i]);
  for(i=0;i<X11NumDrawablesBitmaps;i++)
    if(X11DrawablesBitmaps[X11DrawablesMap[i]].pBitMap!=NULL) XFreePixmap(NULL,i);
  DG.bX11Open=0;
  if(strlen(pbuffer)>0){
    if(debugxemul) printf("unlocking defpub '%s'\n",pbuffer);
    if(strcmp(pbuffer,"Workbench")!=0)UnlockPubScreen(pbuffer,NULL);
  }
  UnlockPubScreen("Workbench",NULL);
  CloseDownScreen();
/*
  if(drawrp.Layer){
    unclipWindow(drawrp.Layer);
    DeleteLayer(drawrp.Layer);
    DisposeLayerInfo(X11layerinfo);
  }*/
/*  XFreeColormap(NULL,amiga_screen[1].cmap);*/
  {
    extern char *_Xresources;
    if(_Xresources!=NULL) XrmDestroyDatabase((XrmDatabase)_Xresources);
  }
/*
  {
    extern Cursor prevdefined;
    if(prevdefined!=NULL) XFreeCursor(NULL,prevdefined);
  }
*/
  signal(SIGINT,SIG_IGN); 
  signal(SIGABRT,SIG_IGN);

/*
  for(i=1;i<num_windows;i++)
    if(windows[i]){
      exit_area(windows[i]);
      CloseWindow(windows[i]);
      windows[i]=NULL;
    }
*/
  if(Xuserdata)
    X11free_userdata(Xuserdata);

  if(DG.bNeedBackRP) free_bitmap(backrp.BitMap);
  if(temprp.BitMap) free_bitmap(temprp.BitMap);
  X11exit_fonts();
  X11exit_drawing();
  chdir(X11cwd);
  free(X11cwd);
  X11cwd=NULL;

  unlink("t:rgb.txt");
  close_timer();
  for(i=0;i<X11NumDrawablesBitmaps;i++){
    if(X11DrawablesBitmaps[i].pBitMap!=NULL) free_bitmap(X11DrawablesBitmaps[i].pBitMap);
  }
  X11exit_clipping();
  X11exit_resources();
  X11exit_drawables();
  X11exit_cursors();
  X11exit_events();
  X11exit_cmaps();
  exit_backfill();
  if(X11FillFree) free_bitmap(X11FillBitMap);
  CloseLibraries();
  if(DG.bClearMemList)
    cleanup_memlist();
}

/*******************************************************************************************/

void setup_bitmap(Window win){
    X_relx=0;X_rely=0;
    drawrp.BitMap=X11DrawablesBitmaps[X11DrawablesMap[win]].pBitMap;
    X_width=X11DrawablesBitmaps[X11DrawablesMap[win]].width;
    X_height=X11DrawablesBitmaps[X11DrawablesMap[win]].height;
    if(Xuserdata!=0){
      drawrp.TmpRas=&(Xuserdata->win_tmpras);
      drawrp.AreaInfo=&(Xuserdata->win_AIstruct);
    } else {
      printf("no tmpras info\n");
    }
    drp=&drawrp;
}

void setup_tempwin(Window win){
  int child=X11DrawablesSubWindows[X11DrawablesMap[win]];
  setup_bitmap(X11ActualWindows[X11DrawablesMap[X11findparent(win)]].pixmap);
  X_relx=X11DrawablesChildren[child].x; /* relative drawing position */
  X_rely=X11DrawablesChildren[child].y;
  X_right=X_relx+X11DrawablesChildren[child].width;
  X_bottom=X_rely+X11DrawablesChildren[child].height;
}

struct Window *Agetwin(Window win){
  struct Window *w;
  XRectangle r;
  if(X11Drawables[win]==X11SUBWINDOW){ /* this is a child */
    int parent;
    int child=X11DrawablesSubWindows[X11DrawablesMap[win]];
    parent=X11findparent(win);
    w=X11DrawablesWindows[X11DrawablesMap[parent]];
    if(!w) {
#if 0
      return NULL;
#else
      XMapWindow(NULL,parent);
      w=X11DrawablesWindows[X11DrawablesMap[parent]];
#endif
/*      setup_tempwin(win);*/
    }
/*
    amiga_screen[0].root=parent;
*/
    X11DrawablesChildren[0].id=amiga_screen[0].root;
    X_relx=w->BorderLeft+X11DrawablesChildren[child].x; /* relative drawing position */
    X_rely=w->BorderTop+X11DrawablesChildren[child].y;
    X_right=X_relx+X11DrawablesChildren[child].width;
    X_bottom=X_rely+X11DrawablesChildren[child].height;
    X_width=X11DrawablesChildren[child].width;
    X_height=X11DrawablesChildren[child].height;
/*
    r.x=X_relx-1;r.y=X_rely-1;r.width=X11DrawablesChildren[child].width+2;r.height=X11DrawablesChildren[child].height+2;
*/
    r.x=0;r.y=0;r.width=X11DrawablesChildren[child].width;r.height=X11DrawablesChildren[child].height;
    if(r.x<0) r.x=0;
    if(r.y<0) r.y=0;
    amiga_screen[0].root=parent;
    XSetClipRectangles(&amigaX_display,NULL,0,0,&r,1,0);
    amiga_screen[0].root=amiga_screen[0].root;
    prevwin=win;
    return(w);
  }else if(X11Drawables[win]==X11BITMAP) {
    setup_bitmap(win);
  } else {
    w=X11DrawablesWindows[X11DrawablesMap[win]];
    if(!w){
#if 0
      return NULL;
#else
      XMapWindow(NULL,win);
      w=X11DrawablesWindows[X11DrawablesMap[win]];
      if(!w){
	printf("where is %d\n",win);
	XCloseDisplay(NULL);
	exit(-1);
      }
#endif
    }
    X11DrawablesChildren[0].id=amiga_screen[0].root;
    X_relx=w->BorderLeft;
    X_rely=w->BorderTop;
    X_right=w->Width;
    X_bottom=w->Height;
    X_width=w->Width;
    X_height=w->Height;
/*
    r.x=X_relx;r.y=X_rely;
*/
    r.x=0;r.y=0;
    r.width=w->Width-w->BorderRight-w->BorderLeft;
    r.height=w->Height-w->BorderTop-w->BorderBottom;
    amiga_screen[0].root=win;
    XSetClipRectangles(&amigaX_display,NULL,0,0,&r,1,0);
    amiga_screen[0].root=amiga_screen[0].root;
    prevwin=win;
    return(w);
  }
}

int SetupScreen(  int wide,int high,int depth, ULONG id){
  struct DimensionInfo di;
  int overscan,xpos,ypos;
  if(usewb) {
    usewb=0;
    wbapp=0;
/*
    if(Adisplay==19||Adisplay==21) DG.nDisplayMaxDepth=8;
    else DG.nDisplayMaxDepth=5;*/
  }
  else if(depth>DG.nDisplayMaxDepth)depth=DG.nDisplayMaxDepth;
  if (GetDisplayInfoData(NULL,(UBYTE *)&di,sizeof(di),DTAG_DIMS,id)){
    int maxwidth= di.VideoOScan.MaxX - di.VideoOScan.MinX + 1;
    int maxheight= di.VideoOScan.MaxY - di.VideoOScan.MinY + 1;
  
    int stdwidth= di.TxtOScan.MaxX - di.TxtOScan.MinX + 1;
    int stdheight= di.TxtOScan.MaxY - di.TxtOScan.MinY + 1;
    if (wide > maxwidth||high > maxheight+16){
      overscan= OSCAN_VIDEO;
      xpos= (maxwidth  - wide)/ 2;
      ypos= (maxheight - high)/ 2;
    }else{
      overscan= OSCAN_TEXT;
      xpos= (stdwidth  - wide)/ 2;
      ypos= (stdheight - high)/ 2;
    }
  }

  if(xpos<0)xpos=0;if(ypos<0)ypos=0;
  if(debugxemul)
    printf("opening screen w %d h %d d %d id %x overscan %d\n",wide,high,depth,id,overscan);
  if(!(Scr=OpenScreenTags(NULL,SA_Left,xpos,
			  SA_Top,0, /*ypos,*/
			  SA_Overscan,  overscan,
			  SA_Width,	wide,
			  SA_Height,	high,
			  SA_Depth,	depth,
			  SA_AutoScroll,1,
/*			  SA_Interleaved, TRUE,*/
			  SA_ShowTitle, FALSE,
/*			  SA_Font,	&topaz8,*/
			  SA_Type,	SCREENQUIET,
					SA_DisplayID,	id,
			  SA_Pens,	&DriPens[0],
			  SA_Title,	LibX11Info,
			  TAG_DONE )))
    return( SCREENOPENFAIL );
  
  if ( ! ( VisualInfo = GetVisualInfo( Scr, TAG_DONE ))) X11resource_exit(DISPLAY8);
  
/*  rast=&(Scr->RastPort);*/
/*
  ret=OpenBackdropWindow(xpos,ypos,wide,high);
  if(ret!=0) return(SCRWINOPENFAIL);
*/
  DG.nDisplayWidth=wide;
  DG.nDisplayHeight=high;
  DG.nDisplayDepth=depth;
  amiga_id=id;
  amiga_screen[0].cmap=(Colormap)Scr->ViewPort.ColorMap;
/*
  {
    int n;
    n=ObtainPen(amiga_screen[0].cmap,-1,SCALE8TO32(10),SCALE8TO32(10),SCALE8TO32(10),0);
    if(n==-1) printf("didn't work!\n");
    else ReleasePen(amiga_screen[0].cmap,n);
  }
*/
  if(temprp.BitMap) free_bitmap(temprp.BitMap);
  else InitRastPort(&temprp);
  temprp.BitMap=alloc_bitmap(DG.nDisplayWidth+16,1,DG.nDisplayDepth,BMF_CLEAR);
  temprp.Layer=NULL;

  X11updatecmap();
  return(NULL);
}

void CloseDownScreen( void ){
  if(!Scr) return;
/*  CloseBackdropWindow();*/
  if ( VisualInfo ) {
    FreeVisualInfo( VisualInfo );
    VisualInfo = NULL;
  }
  if ( Scr && Scr!=wb /*!usewb&&!wbapp*/ ) {
    CloseScreen( Scr );
    Scr = NULL;
  }
}

/*
int OpenBackdropWindow( left,top,width,height ){
  if (!(rootwin = 
	OpenWindowTags( NULL,
		       WA_Left,0,WA_Top,0,
		       WA_Width,width,WA_Height,height,
		       WA_IDCMP,IDCMP_INACTIVEWINDOW|IDCMP_ACTIVEWINDOW|IDCMP_NEWSIZE|
		       IDCMP_MOUSEMOVE|IDCMP_MOUSEBUTTONS|IDCMP_CLOSEWINDOW|
		       IDCMP_REFRESHWINDOW|IDCMP_RAWKEY,
		       WA_Flags,WFLG_NOCAREREFRESH|WFLG_SMART_REFRESH|WFLG_BACKDROP|
		       WFLG_REPORTMOUSE|WFLG_BORDERLESS|WFLG_RMBTRAP,
		       WA_ScreenTitle,	"TP was here..",
		       WA_CustomScreen,	Scr,
		       TAG_DONE ))) return( 4L );
  
  GT_RefreshWindow( rootwin, NULL );
  init_area(rootwin,MAX_COORD,rootwin->Width,rootwin->Height);
  return( 0L );
}


void CloseBackdropWindow(void){
  if (rootwin) {
    unclipWindow(rootwin->WLayer);
    CG.pPreviousLayer=NULL;
    exit_area(rootwin);
    XFlush(NULL);
/*    if(usewb) XDestroyWindow(&amigaX_display,rootwin);
    else*/ 
    CloseWindow(rootwin);
    rootwin = NULL;
  }
}
*/
void init_backrp(width,height,depth){
  if(DG.bNeedBackRP){
    if(backrp.BitMap) free_bitmap(backrp.BitMap);
    else InitRastPort(&backrp);
    backrp.BitMap=alloc_bitmap(width,height,depth,BMF_CLEAR);
    backrp.Layer=NULL;
    if(backrp.BitMap) SetRast(&backrp,(UBYTE)0);
  }
}

Window AmigaCreateWindow(int wide,int high,int depth,int flag,ULONG id){
/*  int posx,posy;*/
#ifdef DEBUGXEMUL_ENTRY
  printf("AmigaCreateWindow %d %d %d (%d %d)\n",wide,high,depth,DG.nDisplayWidth,DG.nDisplayHeight);
#endif
  if(debugxemul)
    printf("createwindow w %d h %d d %d flag %d id %x\n",wide,high,depth,flag,id);
  if(usewb&&flag&&wb->RastPort.BitMap->Depth<=8){
  }
/*
  if(usewb){
    Window newwin;
  if(wide<=Scr->Width&&high<=Scr->Height&&depth<=Scr->RastPort.BitMap->Depth){
      posx=0; posy=0;
      if(rootwin){
	if(wide==DG.nDisplayWidth&&high==DG.nDisplayHeight) return(0);
	posx=rootwin->LeftEdge;
	posy=rootwin->TopEdge;
	unclipWindow(rootwin->WLayer);
	exit_area(rootwin);
	CG.pPreviousLayer=NULL;
	XFlush(NULL);
	CloseWindow(rootwin);
      }
      newwin=XCreateSimpleWindow(&amigaX_display,NULL,posx,posy,wide,high,0,0,0);
      if(!newwin) {return(ACWFAIL);}
      XMapWindow(NULL,newwin);
      rootwin=X11DrawablesWindows[X11DrawablesMap[newwin]];
      EG.fwindowsig=1<<rootwin->UserPort->mp_SigBit;
/*
      amiga_screen[0].root=newwin;
*/
      DG.nDisplayWidth=wide;
      DG.nDisplayHeight=high;
      DG.nDisplayDepth=depth;
      adjx=rootwin->BorderLeft+rootwin->BorderRight;
      adjy=rootwin->BorderTop+rootwin->BorderBottom;
      if(borderadj==0)borderadj=1;
      amiga_id=GetVPModeID(&(wb->ViewPort));
      return(newwin);
    }
    prevcm=-1;
    usewb=0;
    wbapp=0;
   } 
*/

  if(wb){
    wbmode=GetVPModeID(&(wb->ViewPort));
    wbmode=wbmode & MONITOR_ID_MASK;
  }
  if(!id){
    if(DG.bUse30){
      id= BestModeID(BIDTAG_NominalWidth, (UWORD)wide,
		     BIDTAG_NominalHeight,(UWORD)high,
		     BIDTAG_MonitorID , wbmode,
		     flag ? BIDTAG_DIPFMustHave : TAG_IGNORE, flag,
		     BIDTAG_Depth, (UBYTE)depth,
		     TAG_END);
      if(debugxemul) printf("BestModeID to <%d,%d> is %x\n",wide,high,id);
      if(wide<=320){
/*	if(debugxemul) printf("setting lores\n");*/
	id=id&(0xFFFFFFFF-HIRES_KEY);
      }
    }else{
      id=0;
      if(depth<=4) if(wide>400)id|=HIRES_KEY;
      if(high>320) id|=LORESLACE_KEY;
    }
  }
  if((newpic&&id==amiga_id||!newpic)&&wide<=DG.nDisplayWidth&&high<=DG.nDisplayHeight&&Scr&&(amiga_ham8&&flag||!flag&&!amiga_ham8)){
    return(NULL);
  }
  if(Scr!=wb&&Scr) CloseDownScreen();
  return((Window)SetupScreen(wide,high,depth,id));
}

int gettimeofday(struct timeval *tp,struct timezone *tzp){
/*  long t;*/
  unsigned int clock[2];
  int x=timer(clock);
/*  if(!TimerBase)open_timer();
  GetSysTime(tp);*/
/*
  time(&t);
  tp->tv_sec=t;
  tp->tv_usec=0;
*/
  if(!x){
    tp->tv_sec=(ULONG)clock[0];
    tp->tv_usec=(ULONG)clock[1];
  }else{
    tp->tv_sec=0;
    tp->tv_usec=0;
  }
  return(0);
}

/** mui part */

/* amigaspecific */

XNoOp(display)
     Display *display;
{/*                   File 'class4.o'*/
#ifdef DEBUGXEMUL
/*  printf("XNoOp\n");*/
#endif
  return(0);
}

XBell(Display *d,int n){
/*  printf("XBell..\n");*/
  printf("%c",7);
}

int XDisplayHeight(display, screen_number)
     Display *display;
     int screen_number;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XDisplayHeight\n");
#endif
  return(wb->Height);
}

int XDisplayWidth(display, screen_number)
     Display *display;
     int screen_number;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XDisplayWidth\n");
#endif
  return(wb->Width);
}

int XDisplayCells(display, screen_number)
     Display *display;
     int screen_number;
{
#ifdef DEBUGXEMUL_ENTRY
  printf("XDisplayCells\n");
#endif
  return(wb->BitMap.Depth);
}

int bReadDefaultsFile=0;

char *XGetDefault(display, program, option)
     Display *display;
     char *program;
     char *option;
{
  FILE *fp;
  XrmValue xv;
#if DEBUGXEMUL_ENTRY
  printf("XGetDefault\n");
#endif
  if(!bReadDefaultsFile){
    fp=fopen(".XDefaults","r");
    if(fp){
      X11ScanFile(fp);
      fclose(fp);
      XrmGetResource(XtDatabase(NULL),option,program,NULL,&xv);
      return((char*)xv.addr);
    }
    fclose(fp);
  } else {
    XrmGetResource(XtDatabase(NULL),option,program,NULL,&xv);
    return((char*)xv.addr);
  }
  return(NULL);
}

Status XQueryBestCursor(display, d, width, height,
			width_return, height_return)
     Display *display;
     Drawable d;
     unsigned int width, height;
     unsigned int *width_return, *height_return;
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  printf("WARNING: XQueryBestCursor\n");
#endif
}

Colormap XDefaultColormap(Display *d,int n){/*        File 'xast.o'*/
#ifdef DEBUGXEMUL_ENTRY
  printf("XDefaultColormap\n");
#endif
  assert(Scr);

  return((Colormap)Scr->ViewPort.ColorMap/*amiga_screen[n].cmap*/);
}

int X11check_size(Window,int,int);

int X11check_size(Window win,int width,int height){
  struct Window *w=NULL;
  if(X11Drawables[win]==X11SUBWINDOW){ /* this is a child */
    int parent=X11findparent(win);
    w=X11DrawablesWindows[X11DrawablesMap[parent]];
  } else if(X11Drawables[win]==X11WINDOW){
    w=X11DrawablesWindows[X11DrawablesMap[win]];
  } else if(X11Drawables[win]==X11MUI) {
    w=_window(X11DrawablesMUI[X11DrawablesMap[win]]);
  }
  if(!w) return 0;
  Xuserdata=(X11userdata *)w->UserData;
  if(width>Xuserdata->AWidth||height>Xuserdata->AHeight){
/*
    int max=Xuserdata->max_coords;
    exit_area(w);
    init_area(w,max,width,height);*/
    return 1;
  }
  return 0;
}

void _Xfillfit(Window,int);

void _Xfillfit(Window win,int n){
  struct Window *w=NULL;
  if(X11Drawables[win]==X11SUBWINDOW){ /* this is a child */
    int parent=X11findparent(win);
    w=X11DrawablesWindows[X11DrawablesMap[parent]];
  } else if(X11Drawables[win]==X11WINDOW){
    w=X11DrawablesWindows[X11DrawablesMap[win]];
  } else if(X11Drawables[win]==X11MUI) {
    w=_window(X11DrawablesMUI[X11DrawablesMap[win]]);
  } else if(X11Drawables[win]==X11BITMAP){
  }
  if(!w) return;
#if 0
  Xuserdata=(X11userdata *)w->UserData;
#endif
  if(n>Xuserdata->max_coords){
    exit_area(w);
    init_area(w,n+50,w->Width,w->Height);
    prevwin=-1;
  }
}

int oldX11FillSource,oldw,oldh;

void X11Setup_InternalFill(Pixmap pm){
  if(X11FillFree) free_bitmap(X11FillBitMap);
  X11FillSource=pm;
  X11FillBitMap=X11DrawablesBitmaps[X11DrawablesMap[pm]].pBitMap;
  X11FillFree=False;
  oldX11FillSource=0;
}

void X11Fit_InternalFill( int w, int h ){
  int x,y,nItemsX,nItemsY;
  int width;
  int height;
  struct BitMap *Source;

  if(oldX11FillSource==X11FillSource && oldw==w && oldh==h)
    return;
  oldX11FillSource=X11FillSource;
  oldw=w;
  oldh=h;

  width=X11DrawablesBitmaps[X11DrawablesMap[X11FillSource]].width;
  height=X11DrawablesBitmaps[X11DrawablesMap[X11FillSource]].height;
  Source=X11DrawablesBitmaps[X11DrawablesMap[X11FillSource]].pBitMap;

  nItemsX=(int)((w+width-1)/width);
  nItemsY=(int)((h+height-1)/height);

  if(width==w && height==h){
    init_backfillrp(width,height);
    return;
  } 

  init_backfillrp((nItemsX+1)*width,(nItemsY+1)*height);
  /* need to expand the source pattern */

  if(X11FillFree) free_bitmap(X11FillBitMap);
  X11FillFree=True;
  X11FillBitMap=alloc_bitmap((nItemsX+1)*width,(nItemsY+1)*height,1,BMF_CLEAR);
  for(x=1;x<8;x++){
    Source->Planes[x]=0;
    backfillrp.BitMap->Planes[x]=0;
  }
  for(y=0;y<nItemsY;y++)
    for(x=0;x<nItemsX;x++)
      BltBitMap(Source,0,0,X11FillBitMap,x*width,y*height,width,height,0xc0 /*(ABC|ABNC|ANBC)*/,0xff,NULL);
}

void init_backfillrp(width,height){
  if(backfillrp.BitMap){
    if(backfillrp.BitMap->BytesPerRow*8==width && backfillrp.BitMap->Rows==height){
      SetRast(&backfillrp,(UBYTE)0);
      return;
    }
    free_bitmap(backfillrp.BitMap);
    free_bitmap(backfillrp2.BitMap);
  }
  else {
    InitRastPort(&backfillrp);
    InitRastPort(&backfillrp2);
  }
  backfillrp.BitMap=alloc_bitmap(width,height,1,BMF_CLEAR);
  backfillrp2.BitMap=alloc_bitmap(width,height,1,BMF_CLEAR);
  backfillrp.Layer=NULL;
  backfillrp2.Layer=NULL;
  backfillrp.TmpRas=&(Xuserdata /*XBackUserData*/->win_tmpras);
  backfillrp.AreaInfo=&(Xuserdata /*XBackUserData*/->win_AIstruct);
  if(backfillrp.BitMap) SetRast(&backfillrp,(UBYTE)0);
  if(backfillrp2.BitMap) SetRast(&backfillrp,(UBYTE)0);
}

void setup_gc(GC gc){
  extern WORD *Xcurrent_tile;
  extern int Xtile_size,Xhas_tile;
  int   FillStyle=gc->values.fill_style&0xff;
  int   FillOp=gc->values.fill_style &0xff00;
  assert(drp);
  if(gc->values.function==GXinvert||gc->values.function==GXxor)
    SetDrMd(drp,COMPLEMENT);
  else/* if(gc->values.function==GXclear)*/
    SetDrMd(drp,JAM1);

  if(FillStyle==FillTiled||FillStyle==FillStippled||FillStyle==FillOpaqueStippled){
    SetDrMd(drp,JAM1);
    if(FillOp==NORMAL_FILL){
      X11Setup_Tile(gc,gc->values.tile);
      XSetTile(NULL,gc,gc->values.tile);
      SetAfPt(drp,Xcurrent_tile,Xtile_size);
      X11InternalFill=0;
    } else {
      SetAfPt(drp,0,0);
      X11Setup_InternalFill(gc->values.tile);
      X11InternalFill=1;
    }
  } else{
    SetAfPt(drp,0,0);
    X11InternalFill=0;
  }
/*  if(gc->values.line_width!=0){
    printf("linewidth %d\n",gc->values.line_width);
    w->RPort->PenWidth=gc->values.line_width;
    w->RPort->PenHeight=gc->values.line_width;
  }
  rpfill=drp;*/
  if(gc->values.line_style==LineSolid){
    SetDrPt(drp,0xFFFF);
  } else if(gc->values.line_style==LineOnOffDash ||
	    gc->values.line_style==LineDoubleDash){
    SetDrPt(drp,Xdash); /* we're faking dashing.. */
  }
  SetAPen(drp,gc->values.foreground);
  SetBPen(drp,gc->values.background);

  prevgc=gc;
}

struct RastPort *setup_win(Window win){
  struct Window *w;
  if( win==ROOTID ){ /* oops drawing to root! */
    drp=&wb->RastPort;
    X_width=DG.nDisplayWidth;
    X_height=DG.nDisplayHeight;
    X_relx=0;
    X_rely=0;
  } else if(X11Drawables[win]==X11SUBWINDOW||X11Drawables[win]==X11WINDOW){
    w=Agetwin(win);
    prevwin=-1;
    if(!w){
      prevwin=-1;
      return 0;
    }
    drp=w->RPort;
/*
    X_width=w->Width;
    X_height=w->Height;
*/
  } else if(X11Drawables[win]==X11BITMAP) {
#if 0
    w=Agetwin(1);
#endif
    setup_bitmap(win);
  } else { /* a mui object */
    Object *mwin=X11DrawablesMUI[X11DrawablesMap[win]];
    drp=_rp(mwin);
    X_relx=_left(mwin);
    X_rely=_top(mwin);
    X_width=_mwidth(mwin);
    X_height=_mheight(mwin);
  }

  prevwin=win;
  return(drp);
}

Screen *XDefaultScreenOfDisplay(Display *d){/* File 'image_f_io.o'*/
  Screen *scr=d->screens;
#ifdef DEBUGXEMUL_ENTRY
  printf("XDefaultScreenOfDisplay\n");
#endif
  return(&scr[0]);
}

int XDefaultDepth(
    Display *dpy  		/* display */,
    int	scr		/* screen_number */
)
{
  return(DefaultDepth(dpy,scr));
}

int XDefaultScreen(
    Display *dpy  		/* display */
)
{
  return(DefaultScreen(dpy));
}

extern GC XDefaultGC(
    Display *dpy  		/* display */,
    int	scr		/* screen_number */
)
{
  return(DefaultGC(dpy,scr));
}

char *XDisplayString(
    Display *dpy		/* display */
)
{
  return(DisplayString(dpy));
}

XAutoRepeatOn(display)
     Display *display;
{}

unsigned long XBlackPixel(display, screen_number)
     Display *display;
     int screen_number;
{/*             File 'magick/libMagick.lib' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XBlackPixel\n");
#endif
  return(BlackPixel(display,screen_number));
}

unsigned long XWhitePixel(display, screen_number)
     Display *display;
     int screen_number;
{/*             File 'magick/libMagick.lib' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XWhitePixel\n");
#endif
  return(WhitePixel(display,screen_number));
}

Window XRootWindow(display, screen_number)
     Display *display;
     int screen_number;
{/*             File 'magick/libMagick.lib' */
#ifdef DEBUGXEMUL_ENTRY
  printf("XRootWindow\n");
#endif
  return(RootWindow(display,screen_number));
}

Window XRootWindowOfScreen(Screen *screen)
{
  return(screen->root);
}

unsigned long XBlackPixelOfScreen(screen)
     Screen *screen;
{
  return(screen->black_pixel);
}

void init_area(struct Window *win,int size,int w,int h){
  X11userdata *ud;

#ifdef DEBUGXEMUL
  printf("init_area %d\n",win);
#endif

  if( !Xuserdata ){
    ud=malloc(sizeof(X11userdata));
    if(!ud)  X11resource_exit(WINDOW3);

    ud->AWidth=w;
    ud->AHeight=h;
    
    ud->win_rastptr = (PLANEPTR)AllocRaster( ud->AWidth, ud->AHeight );
    if(!ud->win_rastptr) X11resource_exit(WINDOW1);
    
    InitTmpRas( &(ud->win_tmpras), ud->win_rastptr,((ud->AWidth+15)/16)*ud->AHeight );
    
    memset(&(ud->win_AIstruct),0,sizeof(struct AreaInfo));
    
    ud->coor_buf=malloc(size*5*sizeof(WORD));
    if(!ud->coor_buf)  X11resource_exit(WINDOW2);
    ud->max_coords=size;
    InitArea( &(ud->win_AIstruct), ud->coor_buf,size);
    Xuserdata=ud;
  } else 
    ud=Xuserdata;

  if(win){
    _Xoldarea=(win->RPort)->AreaInfo;
    _Xoldtmpras=(win->RPort)->TmpRas;
    (win->RPort)->TmpRas=&(ud->win_tmpras);
    (win->RPort)->AreaInfo = &(ud->win_AIstruct);
    win->UserData=(UBYTE*)ud;
  }
}

void X11free_userdata(X11userdata *ud){
  FreeRaster( ud->win_rastptr, ud->AWidth,ud->AHeight);
  if(ud->coor_buf)free(ud->coor_buf);
  free(ud);
}

void exit_area(struct Window *win){ 
  X11userdata *ud;
#ifdef DEBUGXEMUL_ENTRY
  printf("exit_area [%d]\n",win);
#endif
  ud=(X11userdata*)win->UserData;
  if(!ud) return;
#if 0
  Xuserdata=NULL;
#endif

  (win->RPort)->TmpRas=_Xoldtmpras;
  (win->RPort)->AreaInfo=_Xoldarea;

#if 0
  X11free_userdata(ud);
#endif
  win->UserData=NULL;
}

void SetBackground(int n){
  Xuserdata->background=n; 
}

GetBackground(struct Window *w){
  X11userdata *Xud;
  Xud=(X11userdata*)(w->UserData);
  return(Xud->background);
}

XSetWindowBackground(display, w, background_pixel)
     Display *display;
     Window w;
     unsigned long background_pixel;
{/*    File 'xvctrl.o' */
#if DEBUGXEMUL_ENTRY
  printf("XSetWindowBackground\n");
#endif
  X11DrawablesBackground[w]=(char)background_pixel;
  return(0);
}
