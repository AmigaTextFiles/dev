
#include "amiga.h"
#include <assert.h>
#include <time.h>
#include <proto/gadtools.h>
#include <libraries/asl.h>
#include <proto/asl.h>
#include <dos.h>
#include <signal.h>
#include "libX11.h"
#define XLIB_ILLEGAL_ACCESS 1
#include <X11/Xutil.h>
#include <X11/Intrinsic.h>
#include "x11display.h"
#include "x11windows.h"
#include "x11events.h"
#include "x11colormaps.h"
#include "images.h"
#include "x11resources.h"
#include "timing.h"
#include "filling.h"
#include "visuals.h"
#include "debug.h"
#include "funcount.h"
#include "memorytrack.h"
#ifdef XMUI
#define MUIMASTER_NAME    "muimaster.library"
#define MUIMASTER_VMIN    11
struct Library *MUIMasterBase = NULL;
//#include <libraries/mui.h>
//#include <proto/muimaster.h>
#endif
void X11expand_colormaps (void);
GC vPrevGC;
#if 0
GC vPrevDrawGC;
#endif
int bNoFlicker = 0;
int X11LoresWidth = 0;
int X11LoresHeight = 0;
int X11BorderLess = 0;
#if (MEMORYTRACKING!=0)
ListNode_t *pMemoryList = NULL;
#endif
#if(DEBUG!=0)
ListNode_t *pBitmapList = NULL;
#endif
#define MAX_COORD 400
void X11free_userdata (X11userdata * ud);
#ifdef DEBUGXEMUL_ENTRY
int bInformDisplay = 0;
int bInformGC = 0;
int bInformWindows = 0;
int bIgnoreWindowWarnings = 0;
int bInformEvents = 0;
int bInformImages = 0;
int bSkipImageWrite = 0;
int bInformFilling = 0;
int bSkipFilling = 0;
int bInformColormaps = 0;
int bInformDrawing = 0;
int bSkipDrawing = 0;
int bInformFonts = 0;
#endif
int
userdata_width (void)
{
  if (DG.Xuserdata)
    return DG.Xuserdata->AWidth;
  return 0;
}
int
userdata_height (void)
{
  if (DG.Xuserdata)
    return DG.Xuserdata->AHeight;
  return 0;
}
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
extern struct DosLibrary *DOSBase;
struct RastPort backrp;
extern int prevcm;
char *LIBversion = "$VER: libX11 1.00 (03.24.94)";
char *LibX11Info = "This program is using libX11 by Terje Pedersen!";
struct Layer_Info *X11layerinfo;
#if (DEBUG!=0)
struct Screen *pRealWB;
#endif
#define InRange(x,a,b) (((x)>=(a) && (x)<=(b)) ? 1 : 0)
#define SCALE8TO32(x) ((x)|((x)<<8)|((x)<<16)|((x)<<24))
#define SCREENOPENFAIL 10L
#define SCREENVISUALFAIL 11L
#define SCRWINOPENFAIL 12L
#define ACWFAIL 20L
#define XCSFAIL 30L
DisplayGlobals_s DG =
{0};
char vendor[] = "Amiga", *X11cwd = NULL;
int newpic = 1;
int debugxemul = 0, gfxcard = 0, askmode = 0;
UWORD DriPens[] =
{65535};
APTR VisualInfo = NULL;
ULONG wbmode = DEFAULT_MONITOR_ID;
struct NameInfo dbuffer;
char pbuffer[MAXPUBSCREENNAME] = "";
GC *X11GC = NULL;
struct ColorMap **X11Cmaps = NULL;
char *X11Drawables = NULL;
char *X11DrawablesBackground = NULL;
int *X11DrawablesMap = NULL;
int *X11DrawablesWindowsInvMap = NULL;
long *X11DrawablesMask = NULL;
struct Window **X11DrawablesWindows = NULL;
X11BitMap_t *X11DrawablesBitmaps = NULL;
Object **X11DrawablesMUI = NULL;
Cursor *X11DrawablesMUICursor = NULL;
X11Window *X11Windows = NULL;
void StopMe (void);
void
StopMe (void)
{
  getchar ();
}
void
X11SetupFont (void)
{
}
void
X11resource_exit (int n)
{
  fprintf (stderr, "Unable to allocate internal resources! (%d)\n", n);
  fprintf (stderr, "Drawables: %d\n", DG.X11NumDrawables);
  fprintf (stderr, "Windows: %d\n", DG.X11NumDrawablesWindows);
  fprintf (stderr, "Bitmaps: %d\n", DG.X11NumDrawablesBitmaps);
  fprintf (stderr, "GC: %d\n", DG.X11NumGC);
  fprintf (stderr, "Color maps: %d\n", DG.X11NumCmaps);
  exit (-1);
}
/*
NewDMap (DMap * pm)
{
  char *new = malloc (pm->entrysize * (pm->entries + 5));
  if (!new)
    X11resource_exit (-1);
  if (pm->data != NULL)
    {
      memcpy (new, pm->date, pm->entries * pm->entrysize);
      free (pm->data);
    }
  pm->maxentries = pm->entries + 5;
  pm->data = new;
}
*/
XID X11NewCmap (struct ColorMap *cmap)
{
  X11Cmaps[DG.X11NumCmaps++] = cmap;
  if (DG.X11NumCmaps == DG.X11AvailCmaps)
    X11expand_colormaps ();
  return ((XID) (DG.X11NumCmaps - 1));
}
void
X11init_drawables (void)
{
  DG.X11NumDrawables = 2;
  DG.X11AvailDrawables = 4;
  DG.X11NumDrawablesWindows = 2;
  DG.X11NumDrawablesBitmaps = 0;
  DG.X11NumMUI = 0;
  DG.X11AvailWindows = 4;
  DG.X11AvailBitmaps = 2;
  DG.X11AvailMUI = 2;
  DG.X11AvailGC = 2;
  DG.X11NumGC = 0;
  DG.X11AvailCmaps = 4;
  DG.X11NumCmaps = 0;
  X11Drawables = (char *) calloc (DG.X11AvailDrawables, 1);
  X11DrawablesBackground = (char *) calloc (DG.X11AvailDrawables, 1);
  X11DrawablesMap = (int *) calloc (DG.X11AvailDrawables * sizeof (int), 1);
  X11DrawablesWindowsInvMap = (int *) malloc (DG.X11AvailWindows * sizeof (int));
  X11DrawablesMask = (long *) malloc (DG.X11AvailDrawables * sizeof (long));
  X11Windows = (X11Window *) calloc (1, DG.X11AvailWindows * sizeof (X11Window));
  X11DrawablesWindows = (struct Window **) calloc (DG.X11AvailWindows * sizeof (struct Window *), 1);
  X11DrawablesBitmaps = (X11BitMap_t *) malloc (DG.X11AvailBitmaps * sizeof (X11BitMap_t));
  X11DrawablesMUI = (Object **) malloc (DG.X11AvailMUI * sizeof (Object *));
  X11DrawablesMUICursor = (Cursor *) malloc (DG.X11AvailMUI * sizeof (Cursor));
  X11GC = (GC *) malloc (DG.X11AvailGC * sizeof (int *));
  X11Cmaps = (struct ColorMap **) malloc (DG.X11AvailCmaps * sizeof (XID));
  if (!X11Drawables || !X11DrawablesMap || !X11DrawablesWindows || !X11DrawablesBitmaps ||
      !X11DrawablesWindowsInvMap || !X11DrawablesMask ||
      !X11DrawablesMUI || !X11DrawablesMUICursor || !X11GC || !X11Cmaps)
    X11resource_exit (DISPLAY1);
  X11Drawables[0] = X11ROOT;
}
void
X11exit_drawables (void)
{
  free (X11Drawables);
  free (X11DrawablesBackground);
  free (X11DrawablesMap);
  free (X11DrawablesMask);
  free (X11Windows);
  free (X11DrawablesWindowsInvMap);
  free (X11DrawablesWindows);
  free (X11DrawablesBitmaps);
  free (X11DrawablesMUI);
  free (X11DrawablesMUICursor);
  free (X11GC);
}
void
X11expand_drawables (void)
{
  char *old = X11Drawables;
  char *oldback = X11DrawablesBackground;
  int *oldmap = X11DrawablesMap;
  long *oldmask = X11DrawablesMask;
  X11Drawables = (char *) malloc (DG.X11AvailDrawables + 10);
  X11DrawablesBackground = (char *) calloc (DG.X11AvailDrawables + 10, 1);
  X11DrawablesMap = (int *) malloc ((DG.X11AvailDrawables + 10) * sizeof (int));
  X11DrawablesMask = (long *) malloc ((DG.X11AvailDrawables + 10) * sizeof (long));
  if (!X11Drawables || !X11DrawablesMap || !X11DrawablesMask)
    X11resource_exit (DISPLAY2);
  memcpy (X11Drawables, old, DG.X11AvailDrawables);
  memcpy (X11DrawablesBackground, oldback, DG.X11AvailDrawables);
  memcpy (X11DrawablesMap, oldmap, DG.X11AvailDrawables * sizeof (int));
  memcpy (X11DrawablesMask, oldmask, DG.X11AvailDrawables * sizeof (long));
  DG.X11AvailDrawables += 10;
  free (old);
  free (oldback);
  free (oldmap);
  free (oldmask);
}
void
X11expand_colormaps (void)
{
  struct ColorMap **old = X11Cmaps;
  X11Cmaps = (struct ColorMap **) malloc ((DG.X11AvailCmaps + 5) * sizeof (XID));
  if (!X11Cmaps)
    X11resource_exit (DISPLAY3);
  memcpy (X11Cmaps, old, DG.X11AvailCmaps * sizeof (struct ColorMap *));
  free (old);
  DG.X11AvailCmaps += 5;
}
void
X11expand_windows (void)
{
  struct Window **old = X11DrawablesWindows;
  int *oldwin = X11DrawablesWindowsInvMap;
  X11Window *oldactual = X11Windows;
  X11DrawablesWindows = (struct Window **) calloc ((DG.X11AvailWindows + 10) * sizeof (struct Window *), 1);
  X11DrawablesWindowsInvMap = (int *) calloc ((DG.X11AvailWindows + 10) * sizeof (int), 1);
  X11Windows = (X11Window *) calloc ((DG.X11AvailWindows + 10) * sizeof (X11Window), 1);
  memcpy (X11DrawablesWindows, old, DG.X11AvailWindows * sizeof (struct Window *));
  memcpy (X11DrawablesWindowsInvMap, oldwin, DG.X11AvailWindows * sizeof (int));
  memcpy (X11Windows, oldactual, DG.X11AvailWindows * sizeof (X11Window));
  if (!X11DrawablesWindows
      || !X11DrawablesWindowsInvMap
      || !X11Windows)
    X11resource_exit (DISPLAY3);
  DG.X11AvailWindows += 10;
  free (old);
  free (oldwin);
  free (oldactual);
}
void
X11expand_bitmaps (void)
{
  X11BitMap_t *old = X11DrawablesBitmaps;
  X11DrawablesBitmaps = (X11BitMap_t *) calloc ((DG.X11AvailBitmaps + 10) * sizeof (X11BitMap_t), 1);
  if (!X11DrawablesBitmaps)
    X11resource_exit (DISPLAY4);
  memcpy (X11DrawablesBitmaps, old, DG.X11AvailBitmaps * sizeof (X11BitMap_t));
  DG.X11AvailBitmaps += 10;
  free (old);
}
void
X11expand_MUI (void)
{
  Object **old = X11DrawablesMUI;
  Cursor *oldc = X11DrawablesMUICursor;
  X11DrawablesMUI = (Object **) malloc ((DG.X11AvailMUI + 10) * sizeof (int *));
  X11DrawablesMUICursor = (Cursor *) malloc ((DG.X11AvailMUI + 10) * sizeof (Cursor));
  if (!X11DrawablesMUI || !X11DrawablesMUICursor)
    X11resource_exit (DISPLAY4);
  memcpy (X11DrawablesMUI, old, DG.X11AvailMUI * sizeof (int *));
  memcpy (X11DrawablesMUICursor, oldc, DG.X11AvailMUI * sizeof (Cursor));
  DG.X11AvailMUI += 10;
  free (old);
  free (oldc);
}
void
X11expand_GC (void)
{
  GC *old = X11GC;
  X11GC = (GC *) malloc ((DG.X11AvailGC + 10) * sizeof (int *));
  if (!X11GC)
    X11resource_exit (DISPLAY5);
  memcpy (X11GC, old, DG.X11AvailGC * sizeof (int *));
  DG.X11AvailGC += 10;
  free (old);
}
boolean bGotFreeWindow = FALSE;
X11NewWindow (struct Window *win)
{
  int vUse = DG.X11NumDrawables;
  int vUseWindow = DG.X11NumDrawablesWindows;
  int i;
  if (bGotFreeWindow)
    {
      bGotFreeWindow = FALSE;
      for (i = 0; i < DG.X11NumDrawables; i++)
	{
	  if (X11Drawables[i] == X11NONEWINDOW)
	    {
	      vUse = i;
	      vUseWindow = X11DrawablesMap[i];
	      bGotFreeWindow = TRUE;
	      break;
	    }
	}
    }
  X11Drawables[vUse] = X11WINDOW;
  X11DrawablesMap[vUse] = vUseWindow;
  if (vUse == DG.X11NumDrawables)
    DG.X11NumDrawables++;
  X11DrawablesMap[vUse] = vUseWindow;
  X11DrawablesWindowsInvMap[vUseWindow] = vUse;
  X11DrawablesWindows[vUseWindow] = win;
  if (vUseWindow == DG.X11NumDrawablesWindows)
    DG.X11NumDrawablesWindows++;
  if (DG.X11NumDrawables == DG.X11AvailDrawables)
    X11expand_drawables ();
  if (DG.X11NumDrawablesWindows == DG.X11AvailWindows)
    X11expand_windows ();
  return (vUse);
}
void
X11FreeWindow (int vWindow)
{
  assert (vWindow < DG.X11NumDrawables);
  assert (X11Drawables[vWindow] == X11WINDOW);
  bGotFreeWindow = TRUE;
  X11Drawables[vWindow] = X11NONEWINDOW;
}
boolean bGotFreeGC = FALSE;
int
X11NewGC (GC newGC)
{
  if (bGotFreeGC)
    {
      register int i;
      for (i = 0; i < DG.X11NumGC; i++)
	{
	  if (!X11GC[i])
	    {
	      X11GC[i] = newGC;
	      return i;
	    }
	}
      bGotFreeGC = FALSE;
    }
  X11GC[DG.X11NumGC++] = newGC;
  if (DG.X11NumGC == DG.X11AvailGC)
    X11expand_GC ();
  return (DG.X11NumGC - 1);
}
void
X11FreeGC (GC oldGC)
{
  register int i;
  for (i = 0; i < DG.X11NumGC; i++)
    {
      if (X11GC[i] == oldGC)
	{
	  X11GC[i] = NULL;
	  bGotFreeGC = TRUE;
	  return;
	}
    }
}
boolean bGotFreeBitmap = FALSE;
X11NewBitmap (struct BitMap * bmp, int width, int height, int depth)
{
  int vUse = DG.X11NumDrawables;
  int vUseBitmap = DG.X11NumDrawablesBitmaps;
  int i;
  if (bGotFreeBitmap)
    {
      bGotFreeBitmap = FALSE;
      for (i = 0; i < DG.X11NumDrawables; i++)
	{
	  if (X11Drawables[i] == X11NONE)
	    {
	      vUse = i;
	      vUseBitmap = X11DrawablesMap[i];
	      bGotFreeBitmap = TRUE;
	      break;
	    }
	}
    }
  X11Drawables[vUse] = X11BITMAP;
  X11DrawablesMap[vUse] = vUseBitmap;
  if (vUse == DG.X11NumDrawables)
    DG.X11NumDrawables++;
  X11DrawablesBitmaps[vUseBitmap].width = width;
  X11DrawablesBitmaps[vUseBitmap].height = height;
  X11DrawablesBitmaps[vUseBitmap].depth = depth;
  X11DrawablesBitmaps[vUseBitmap].bTileStipple = 0;
  X11DrawablesBitmaps[vUseBitmap].vNumActive = 0;
  X11DrawablesBitmaps[vUseBitmap].pBitMap = bmp;
  if (vUseBitmap == DG.X11NumDrawablesBitmaps)
    DG.X11NumDrawablesBitmaps++;
  if (DG.X11NumDrawables == DG.X11AvailDrawables)
    X11expand_drawables ();
  if (DG.X11NumDrawablesBitmaps == DG.X11AvailBitmaps)
    X11expand_bitmaps ();
  return (vUse);
}
void
X11FreeBitmap (int vPixmap)
{
  bGotFreeBitmap = TRUE;
  X11Drawables[vPixmap] = X11NONE;
}
Window
X11NewMUI (Object * obj)
{
  X11Drawables[DG.X11NumDrawables] = X11MUI;
  X11DrawablesMap[DG.X11NumDrawables++] = DG.X11NumMUI;
  X11DrawablesMUI[DG.X11NumMUI++] = obj;
  if (DG.X11NumDrawables == DG.X11AvailDrawables)
    X11expand_drawables ();
  if (DG.X11NumMUI == DG.X11AvailMUI)
    X11expand_MUI ();
  return ((Window) (DG.X11NumDrawables - 1));
}
int
X11FillCheck (int n,
	      int width,
	      int height)
{
  int vNewSize;
  assert (DG.Xuserdata);
#if 0
  if (!DG.vWindow)
    return 0;
#endif
  if (n > DG.Xuserdata->max_coords)
    vNewSize = n + 50;
  else
    vNewSize = DG.Xuserdata->max_coords;
  if (width >= DG.Xuserdata->AWidth
      || height >= DG.Xuserdata->AHeight
      || DG.Xuserdata->max_coords != vNewSize)
    {
      exit_area (DG.vWindow, DG.Xuserdata);
      DG.Xuserdata = init_area (DG.vWindow, vNewSize, width, height);
      return 1;
    }
  return 0;
}
void
force_exit (int n)
{
  signal (SIGINT, SIG_DFL);
  signal (SIGABRT, SIG_DFL);
  XFlush (&DG.X11Display);
  XCloseDisplay (&DG.X11Display);
  exit (-1);
}
void
report_display (void)
{
  if (debugxemul)
    {
      printf ("dosbase lib version %d\n", DOSBase->dl_lib.lib_Version);
      if (!DG.bUse30)
	printf ("not ");
      printf ("using os3.0 funcs.\n");
    }
}
cantopen (char *lib)
{
  printf ("unable to open %s\n", lib);
}
int
OpenLibraries (void)
{
  if (DG.bLibsOpen)
    return (1);
  KeymapBase = OpenLibrary ("keymap.library", 37);
  if (!KeymapBase)
    return FALSE;
#ifdef NEEDGFXBASE
  if (!(GfxBase = (struct GfxBase *) OpenLibrary ("graphics.library", 39L)))
    {
      if (!(GfxBase = (struct GfxBase *) OpenLibrary ("graphics.library", 37L)))
	{
	  cantopen ("graphics.library v39");
	  return FALSE;
	}
    }
#endif
#ifdef NEEDINTUITIONBASE
  if (!(IntuitionBase = (struct IntuitionBase *) OpenLibrary ("intuition.library", 39L)))
    {
      if (!(IntuitionBase = (struct IntuitionBase *) OpenLibrary ("intuition.library", 37L)))
	{
	  cantopen ("Intuition.library v37 or v39");
	  return FALSE;
	}
      DG.bUse30 = 0;
    }
  else
    DG.bUse30 = 1;
#endif
  if (!(LayersBase = OpenLibrary ("layers.library", 39L)))
    {
      if (!(LayersBase = OpenLibrary ("layers.library", 37L)))
	{
	  cantopen ("layers.library v37");
	  return FALSE;
	}
    }
  if (!(AslBase = OpenLibrary ("asl.library", 37L)))
    {
      cantopen ("asl.library v37");
      return FALSE;
    }
  if (!(DiskfontBase = OpenLibrary ("diskfont.library", 0L)))
    {
      cantopen ("diskfont.library v36");
      return FALSE;
    }
  if (!(GadToolsBase = OpenLibrary ("gadtools.library", 39L)))
    {
      if (!(GadToolsBase = OpenLibrary ("gadtools.library", 37L)))
	{
	  cantopen ("gadtools.library");
	  return FALSE;
	}
    }
#ifdef XMUI
  if (!(MUIMasterBase = OpenLibrary (MUIMASTER_NAME, MUIMASTER_VMIN)))
    exit (20);
#endif
  DG.bLibsOpen = 1;
  return TRUE;
}
void
CloseLibraries (void)
{
  if (GadToolsBase)
    CloseLibrary (GadToolsBase);
  if (DiskfontBase)
    CloseLibrary (DiskfontBase);
  if (AslBase)
    CloseLibrary (AslBase);
  if (LayersBase)
    CloseLibrary ((struct Library *) LayersBase);
#ifdef NEEDGFXBASE
  if (GfxBase)
    CloseLibrary ((struct Library *) GfxBase);
#endif
#ifdef NEEDINTUITIONBASE
  if (IntuitionBase)
    CloseLibrary ((struct Library *) IntuitionBase);
#endif
  CloseLibrary (KeymapBase);
#ifdef XMUI
  if (MUIMasterBase)
    CloseLibrary (MUIMasterBase);
#endif
}
struct BitMap *
alloc_bitmap (int width,
	      int height,
	      int depth,
	      int flags,
	      struct BitMap *pFriend)
{
  int i;
  struct BitMap *bmp;
  if (width < 0 || height < 0)
    {
      printf ("alloc bitmap %dx%dx%d failed!\n", width, height, depth);
      StopMe ();
      return 0;
    }
  if (!DG.bUse30)
    {
      bmp = calloc (sizeof (struct BitMap), 1);
      if (!bmp)
	return (0);
      InitBitMap (bmp, depth, width, height);
      for (i = 0; i < depth; i++)
	{
	  bmp->Planes[i] = (PLANEPTR) AllocRaster (width, height);
	  if (!bmp->Planes[i])
	    X11resource_exit (DISPLAY6);
	  memset (bmp->Planes[i], 0, RASSIZE (width, height));
	}
    }
  else
    {
      bmp = AllocBitMap ((UWORD) (width), (UWORD) height, (UWORD) depth, (UWORD) (flags), pFriend);
    }
  if (!bmp)
    {
      printf ("alloc bitmap %dx%dx%d failed!\n", width, height, depth);
      printf ("Press return to contunue. Crash it not unlikely..\n");
      StopMe ();
      DG.XAllocFailed = 1;
      return 0;
    }
  for (i = depth; i < 8; i++)
    bmp->Planes[i] = NULL;
#if(DEBUG!=0)
  List_AddEntry (pBitmapList, (void *) bmp);
#endif
  return (bmp);
}
int
free_bitmap (struct BitMap *bmp)
{
  int i;
#if(DEBUG!=0)
  List_RemoveNode (pBitmapList, (void *) bmp);
#endif
  WaitBlit ();
  if (!bmp)
    return;
  if (!DG.bUse30)
    {
      for (i = 0; i < bmp->Depth; i++)
	{
	  if (bmp->Planes[i])
	    FreeRaster (bmp->Planes[i], (bmp->BytesPerRow) * 8, bmp->Rows);
	}
      free (bmp);
    }
  else
    {
      FreeBitMap (bmp);
#if 0
      (DEBUG != 0)
	memset (bmp, 0, sizeof (struct BitMap));
#endif
    }
}
char *
getdisplayname (ULONG id)
{
  int res = GetDisplayInfoData (FindDisplayInfo (id), (UBYTE *) & dbuffer, sizeof (dbuffer), DTAG_NAME, NULL);
  if (res)
    return ((char *) dbuffer.Name);
  return (NULL);
}
void X11gethome (void);
void
X11gethome (void)
{
  X11cwd = getcwd (NULL, 128);
}
/*
void
stackcheck (int n)
{
  if (stacksize () + stackused () < n)
    {
      printf ("set stack to >=%d! current %ld used %ld\n", n, stacksize (), stackused ());
      CloseLibraries ();
      exit (-1);
    }
}
*/
void
init_memlist (void)
{
#if (MEMORYTRACKING!=0)
  if (!pMemoryList)
    pMemoryList = List_MakeNull ();
#endif
#if(DEBUG!=0)
  if (!pBitmapList)
    pBitmapList = List_MakeNull ();
#endif
}
void
cleanup_memlist (void)
{
#if (MEMORYTRACKING!=0)
  {
#if (DEBUG!=0)
    int n = List_CountEntries (pMemoryList);
    printf ("Some memory not cleared..: %d\n", n);
#endif
  }
#endif
#if (MEMORYTRACKING!=0)
  List_FreeList (pMemoryList);
#endif
#if(DEBUG!=0)
  {
    struct BitMap *bmp;
    int n = List_CountEntries (pBitmapList);
    if (n > 1)
      {
	ListNode_t **pIter;
	printf ("Unfreed bitmaps! (%d)\n", n);
	pIter = ListIter_GetFirst (pBitmapList);
	while (!ListIter_IsEmpty (pIter))
	  {
	    bmp = (struct BitMap *) (*pIter)->pData;
	    printf ("BitMap %d\n", bmp);
	    pIter = ListIter_GetNext (pIter);
	  }
      }
  }
  List_FreeList (pBitmapList);
#endif
 // MWReport ("At end of main()", MWR_FULL);
}
Display *
XOpenDisplay (char *display_name)
{
  XrmValue value;
  XrmDatabase db;
  struct DimensionInfo dinfo;
  DisplayInfoHandle handle;
  char dispname[80] = "";
  if (DG.bX11Open == 1)
    return (&DG.X11Display);
  memset (&DG, 0, sizeof (DisplayGlobals_s));
  DG.bX11Cursors = 1;
  DG.bX11Open = 1;
  DG.nDisplayDepth = 8;
  DG.bClearMemList = True;
  DG.vPrevWindow = (Window) - 1;
  vPrevGC = (GC) - 1;
  DG.Xcurrent_tile = NULL;
  DG.Xtile_size = 0;
  DG.vUseWB = 1;
  DG.vWBapp = 1;
  DG.X11ScreenID = -1;
  DG.X11ScreenHAM8 = 0;
  DG.Xuserdata = NULL;
  DG.X11Font = NULL;
  init_memlist ();
  X11Visuals_init ();
  X11Windows_Init ();
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Init ();
#endif
#ifdef DEBUGXEMUL_ENTRY
  printf ("(display)XOpenDisplay [");
  if (display_name)
    printf ("%s]\n", display_name);
  else
    printf ("NULL]\n");
#endif
  if (!OpenLibraries ())
    X11resource_exit (DISPLAY7);
  fprintf (stderr, LibX11Info);
  fprintf (stderr, "\n");
/*
  stackcheck (20000);
*/
  if (display_name)
    {
      strcpy (dispname, display_name);
      DG.vUseWB = 1;
    }
  if (!DG.bNeedBackRP)
    backrp.BitMap = NULL;
  XrmInitialize ();
  db = XtDatabase (&DG.X11Display);
  if (XrmGetResource (db, "Amiga.debug", NULL, NULL, &value))
    debugxemul = 1;
  if (XrmGetResource (db, "Amiga.nochunkytoplanar", NULL, NULL, &value))
    gfxcard = 1;
  if (XrmGetResource (db, "Amiga.noflicker", NULL, NULL, &value))
    bNoFlicker = 1;
  if (XrmGetResource (db, "Amiga.askmode", NULL, NULL, &value))
    askmode = 1;
  if (XrmGetResource (db, "Amiga.borderless", NULL, NULL, &value))
    X11BorderLess = 1;
#if (DEBUG!=0)
  if (XrmGetResource (db, "Amiga.skipfillrectangle", NULL, NULL, &value))
    {
      extern int bSkipFillRectangle;
      bSkipFillRectangle = 1;
    }
  if (XrmGetResource (db, "Amiga.skipdrawsegments", NULL, NULL, &value))
    {
      extern int bSkipDrawSegments;
      bSkipDrawSegments = 1;
    }
  if (XrmGetResource (db, "Amiga.skipdrawline", NULL, NULL, &value))
    {
      extern int bSkipDrawLine;
      bSkipDrawLine = 1;
    }
  if (XrmGetResource (db, "Amiga.skipdrawrectangle", NULL, NULL, &value))
    {
      extern int bSkipDrawRectangle;
      bSkipDrawRectangle = 1;
    }
#endif
  if (XrmGetResource (db, "Amiga.cursors", NULL, NULL, &value))
    {
      int vValue;
      sscanf (value.addr, "%d", &vValue);
      DG.bX11Cursors = vValue;
    }
  if (XrmGetResource (db, "Amiga.ImageCache", NULL, NULL, &value))
    {
      int vValue;
      extern int vMaxCacheMemorySize;
      sscanf (value.addr, "%d", &vValue);
      vMaxCacheMemorySize = vValue * 1024;
    }
  if (XrmGetResource (db, "Amiga.usepubscreen", NULL, NULL, &value))
    {
      strcpy (dispname, value.addr);
    }
  if (!strlen (dispname))
    GetDefaultPubScreen (pbuffer);
  else
    {
      strcpy (pbuffer, dispname);
      if (!stricmp (pbuffer, "Workbench"))
	DG.vUseWB = 1;
    }
  if (strlen (pbuffer) > 0)
    {
      if (debugxemul)
	printf ("locking defpub '%s'\n", pbuffer);
      DG.wb = LockPubScreen (pbuffer);
#if (DEBUG!=0)
      if (strcmp (pbuffer, "Workbench"))
	pRealWB = LockPubScreen ("Workbench");
      else
	pRealWB = DG.wb;
#endif
    }
  if (!DG.wb)
    DG.wb = LockPubScreen (NULL);
  handle = FindDisplayInfo (DBLPALLORES_KEY);
  if (!handle)
    handle = FindDisplayInfo (LORES_KEY);
  GetDisplayInfoData (handle, (UBYTE *) & dinfo, sizeof (dinfo), DTAG_DIMS, NULL);
  X11LoresWidth = dinfo.VideoOScan.MaxX - dinfo.VideoOScan.MinX + 1;
  X11LoresHeight = dinfo.VideoOScan.MaxY - dinfo.VideoOScan.MinY + 1;
  handle = FindDisplayInfo (HIRES_KEY);
  GetDisplayInfoData (handle, (UBYTE *) & dinfo, sizeof (dinfo), DTAG_DIMS, NULL);
  if (debugxemul)
    printf ("display_info max [%d,%d] depth %d.\n",
	    dinfo.MaxRasterWidth, dinfo.MaxRasterHeight, dinfo.MaxDepth);
  if (dinfo.MaxDepth > 8)
    {
      DG.nDisplayDepth = 8;
      DG.nDisplayMaxDepth = 8;
    }
  else
    {
      DG.nDisplayDepth = dinfo.MaxDepth;
      DG.nDisplayMaxDepth = dinfo.MaxDepth;
    }
  DG.nDisplayWidth = DG.wb->Width - 32;
  DG.nDisplayHeight = DG.wb->Height - 16;
  DG.nDisplayMaxWidth = dinfo.MaxRasterWidth;
  DG.nDisplayMaxHeight = dinfo.MaxRasterHeight;
  if (DG.nDisplayMaxWidth > 2048)
    DG.nDisplayMaxWidth = 2048;
  if (DG.nDisplayMaxHeight > 2048)
    DG.nDisplayMaxHeight = 2048;
  X11init_drawables ();
#if 0
  DG.X11Screen[0].cmap = (Colormap) wb->ViewPort.ColorMap;
#else
  DG.X11Screen[0].cmap = X11NewCmap (DG.wb->ViewPort.ColorMap);
#endif
  DG.nDisplayColors = (1 << (DG.wb->RastPort.BitMap->Depth));
  DG.nDisplayDepth = DG.wb->RastPort.BitMap->Depth;
  if (DG.vUseWB)
    {
      DG.Scr = DG.wb;
      DG.nDisplayDepth = (DG.wb->RastPort.BitMap->Depth);
      DG.nDisplayMaxDepth = (DG.wb->RastPort.BitMap->Depth);
      DG.nDisplayWidth = DG.wb->Width;
      DG.nDisplayHeight = DG.wb->Height;
      DG.nDisplayMaxWidth = DG.nDisplayWidth;
      DG.nDisplayMaxHeight = DG.nDisplayHeight;
      X11init_cmaps ();
      if (!DG.bWbSaved)
	savewbcm ();
    }
  else
    X11init_cmaps ();
#if 0
  init_backfill (DG.wb->Width, DG.wb->Height);
#endif
  if (XrmGetResource (XtDatabase (&DG.X11Display), "Amiga.displaydepth", NULL, NULL, &value))
    {
      int vDepth;
      sscanf (value.addr, "%d", &vDepth);
      DG.nDisplayDepth = vDepth;
      DG.nDisplayMaxDepth = vDepth;
    }
  report_display ();
  DG.X11Display.screens = DG.X11Screen;
  DG.X11Display.bitmap_bit_order = 1;
  DG.X11Display.bitmap_unit = 16;
  DG.X11Screen[0].display = &DG.X11Display;
  DG.X11Screen[1].display = &DG.X11Display;
  DG.X11Display.vendor = vendor;
  DG.X11Display.release = 001;
  DG.X11Display.display_name = vendor;
  DG.X11Display.default_screen = 0;
  DG.X11Screen[0].root_visual = &DG.X11Visual[0];
  DG.X11Screen[1].root_visual = &DG.X11Visual[1];
  {
    XGCValues xgc;
    xgc.foreground = 1;
    xgc.background = 0;
    DG.X11Screen[0].default_gc = XCreateGC (&DG.X11Display, NULL, GCForeground | GCBackground, &xgc);
  }
  DG.X11Screen[0].root = ROOTID;
  DG.X11Screen[0].root_depth = DG.nDisplayDepth;
  DG.X11Screen[0].width = DG.nDisplayWidth;
  DG.X11Screen[0].height = DG.nDisplayHeight;
  DG.X11Screen[0].mwidth = (int) ((DG.nDisplayWidth / 72) * 25.4);
  DG.X11Screen[0].mheight = (int) ((DG.nDisplayHeight / 72) * 25.4);
  memset (&X11Windows[0], 0, sizeof (X11Window));
  memset (&X11Windows[ROOTID], 0, sizeof (X11Window));
  X11Windows[ROOTID].width = DG.nDisplayWidth;
  X11Windows[ROOTID].height = DG.nDisplayHeight;
  X11Windows[ROOTID].rwidth = DG.nDisplayWidth;
  X11Windows[ROOTID].rheight = DG.nDisplayHeight;
  SetWinFlagD (ROOTID, WIN_MAPPED);
  X11Windows[ROOTID].mChildren = Map_Init (10);
  X11Windows[ROOTID].mMappedChildren = Map_Init (10);
  X11Windows[0].mChildren = Map_Init (2);
  X11Windows[0].mMappedChildren = Map_Init (2);
  X11DrawablesWindows[ROOTID] = NULL;
  X11DrawablesWindowsInvMap[0] = 0;
  X11DrawablesWindowsInvMap[ROOTID] = ROOTID;
  X11DrawablesMap[ROOTID] = 1;
  X11Drawables[ROOTID] = X11WINDOW;
  if (DG.nDisplayDepth > 1)
    {
      DG.X11Screen[0].white_pixel = 2;
      DG.X11Screen[0].black_pixel = 1;
    }
  else
    {
      DG.X11Screen[0].white_pixel = 1;
      DG.X11Screen[0].black_pixel = 0;
    }
  DG.X11Screen[1].max_maps = 2;
  X11SetupVisual ();
  signal (SIGINT, force_exit);
  signal (SIGABRT, SIG_IGN);
  open_timer ();
  InitRastPort (&DG.X11BitmapRP);
  DG.X11GC = DG.X11Screen[0].default_gc;
  if (!X11cwd)
    X11gethome ();
  X11init_fonts ();
  X11init_drawing ();
  chdir (X11cwd);
  X11init_clipping ();
  X11init_resources ();
  X11init_cursors ();
  X11init_images ();
  X11Filling_Init ();
  Events_Init ();
  DG.X11GC->values.font = DG.X11Font->fid;
  return (&DG.X11Display);
}
void
XSetPlanes (int d)
{
  DG.X11Screen[0].root_depth = d;
  DG.nDisplayDepth = d;
}
XCloseDisplay (Display * display)
{
  int i;
#if 0
  printf ("(display)XCloseDisplay\n");
#endif
  if (!DG.bX11Open)
    return;
  XFreeFont (NULL, DG.X11Font);
  for (i = 0; i < DG.X11NumDrawablesWindows; i++)
    if (X11Windows[i].flags & WIN_MAPPED)
      {
	XUnmapWindow (NULL, X11Windows[i].win);
      }
  for (i = 0; i < DG.X11NumGC; i++)
    if (X11GC[i])
      XFreeGC (NULL, X11GC[i]);
  X11Filling_Exit ();
  for (i = 0; i < DG.X11NumDrawablesBitmaps; i++)
    if (X11DrawablesBitmaps[X11DrawablesMap[i]].pBitMap)
      {
	X11DrawablesBitmaps[X11DrawablesMap[i]].bTileStipple = 0;
	XFreePixmap (NULL, i);
      }
  DG.bX11Open = 0;
  if (strlen (pbuffer) > 0)
    {
      if (debugxemul)
	printf ("unlocking defpub '%s'\n", pbuffer);
      if (strcmp (pbuffer, "Workbench"))
	UnlockPubScreen (pbuffer, NULL);
    }
  UnlockPubScreen ("Workbench", NULL);
  CloseDownScreen ();
  {
    extern char *_Xresources;
    if (_Xresources)
      XrmDestroyDatabase ((XrmDatabase) _Xresources);
  }
  signal (SIGINT, SIG_IGN);
  signal (SIGABRT, SIG_IGN);
  if (DG.Xuserdata)
    X11free_userdata (DG.Xuserdata);
  if (DG.bNeedBackRP && backrp.BitMap)
    free_bitmap (backrp.BitMap);
  X11exit_fonts ();
  X11exit_drawing ();
  chdir (X11cwd);
  free (X11cwd);
  X11cwd = NULL;
  unlink ("t:rgb.txt");
  close_timer ();
  for (i = 0; i < DG.X11NumDrawablesBitmaps; i++)
    {
      if (X11DrawablesBitmaps[i].pBitMap)
	free_bitmap (X11DrawablesBitmaps[i].pBitMap);
    }
  X11exit_clipping ();
  X11exit_resources ();
  X11exit_drawables ();
  X11exit_cursors ();
  X11exit_images ();
  Events_Exit ();
  X11exit_cmaps ();
  X11Windows_Exit ();
  X11Visuals_exit ();
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Exit ();
#endif
#if 0
  exit_backfill ();
#endif
  CloseLibraries ();
  if (DG.bClearMemList)
    cleanup_memlist ();
}
int
SetupScreen (int wide, int high, int depth, ULONG id)
{
  struct DimensionInfo di;
  int overscan = 0, xpos = 0, ypos = 0;
  if (DG.vUseWB)
    {
      DG.vUseWB = 0;
      DG.vWBapp = 0;
    }
  else if (depth > DG.nDisplayMaxDepth)
    depth = DG.nDisplayMaxDepth;
  if (GetDisplayInfoData (NULL, (UBYTE *) & di, sizeof (di), DTAG_DIMS, id))
    {
      int maxwidth = di.VideoOScan.MaxX - di.VideoOScan.MinX + 1;
      int maxheight = di.VideoOScan.MaxY - di.VideoOScan.MinY + 1;
      int stdwidth = di.TxtOScan.MaxX - di.TxtOScan.MinX + 1;
      int stdheight = di.TxtOScan.MaxY - di.TxtOScan.MinY + 1;
      if (wide > maxwidth || high > maxheight + 16)
	{
	  overscan = OSCAN_VIDEO;
	  xpos = (maxwidth - wide) / 2;
	  ypos = (maxheight - high) / 2;
	}
      else
	{
	  overscan = OSCAN_TEXT;
	  xpos = (stdwidth - wide) / 2;
	  ypos = (stdheight - high) / 2;
	}
    }
  if (xpos < 0)
    xpos = 0;
  if (ypos < 0)
    ypos = 0;
  if (debugxemul)
    printf ("opening screen w %d h %d d %d id %x overscan %d\n", wide, high, depth, id, overscan);
  if (!(DG.Scr = OpenScreenTags (NULL, SA_Left, xpos,
				 SA_Top, 0,
				 SA_Overscan, overscan,
				 SA_Width, wide,
				 SA_Height, high,
				 SA_Depth, depth,
				 SA_AutoScroll, 1,
				 SA_ShowTitle, FALSE,
				 SA_Type, CUSTOMSCREEN,
				 SA_DisplayID, id,
				 SA_Pens, &DriPens[0],
				 SA_Title, LibX11Info,
				 TAG_DONE)))
    return (SCREENOPENFAIL);
  if (!(VisualInfo = GetVisualInfo (DG.Scr, TAG_DONE)))
    X11resource_exit (DISPLAY8);
  DG.nDisplayWidth = wide;
  DG.nDisplayHeight = high;
  DG.nDisplayDepth = depth;
  DG.X11ScreenID = id;
#if 0
  DG.X11Screen[0].cmap = (Colormap) Scr->ViewPort.ColorMap;
#else
  X11Cmaps[0] = DG.Scr->ViewPort.ColorMap;
#endif
  X11updatecmap ();
  return (NULL);
}
void
CloseDownScreen (void)
{
  if (!DG.Scr)
    return;
  if (VisualInfo)
    {
      FreeVisualInfo (VisualInfo);
      VisualInfo = NULL;
    }
  if (DG.Scr && DG.Scr != DG.wb)
    {
      CloseScreen (DG.Scr);
      DG.Scr = NULL;
    }
}
#if 0
void
init_backrp (int width, int height, int depth)
{
  extern int backrp_Width, backrp_Height, backrp_Depth;
  if (DG.bNeedBackRP)
    {
      if (backrp.BitMap)
	free_bitmap (backrp.BitMap);
      else
	InitRastPort (&backrp);
      backrp.BitMap = alloc_bitmap (width, height, depth, BMF_CLEAR, DG.wb->RastPort.BitMap);
      backrp_Width = width;
      backrp_Height = height;
      backrp_Depth = depth;
      backrp.Layer = NULL;
      if (DG.XAllocFailed)
	return;
      if (backrp.BitMap)
	SetRast (&backrp, (UBYTE) 0);
    }
}
#endif
Window
AmigaCreateWindow (int wide, int high, int depth, int flag, ULONG id)
{
  if (!X11BorderLess)
    {
      wide += 32;
      high += 32;
    }
  if (debugxemul)
    printf ("createwindow w %d h %d d %d flag %d id %x\n", wide, high, depth, flag, id);
  if (DG.vUseWB && flag && DG.wb->RastPort.BitMap->Depth <= 8)
    {
    }
  if (DG.wb)
    {
      wbmode = GetVPModeID (&(DG.wb->ViewPort));
      wbmode = wbmode & MONITOR_ID_MASK;
    }
  if (!id)
    {
      if (DG.bUse30)
	{
	  id = BestModeID (BIDTAG_NominalWidth, (UWORD) wide,
			   BIDTAG_NominalHeight, (UWORD) high,
			   BIDTAG_MonitorID, wbmode,
			   flag ? BIDTAG_DIPFMustHave : TAG_IGNORE, flag,
			   BIDTAG_Depth, (UBYTE) depth,
			   TAG_END);
	  if (debugxemul)
	    printf ("BestModeID to <%d,%d> is %x\n", wide, high, id);
	  if (wide <= X11LoresWidth)
	    {
	      id = id & (0xFFFFFFFF - HIRES_KEY);
	    }
	}
      else
	{
	  id = 0;
	  if (depth <= 4)
	    if (wide > 400)
	      id |= HIRES_KEY;
	  if (high > X11LoresHeight)
	    id |= LORESLACE_KEY;
	}
    }
#if 0
  if ((newpic
       && id == DG.DG.X11ScreenID
       || !newpic)
      && wide <= DG.nDisplayWidth
      && high <= DG.nDisplayHeight
      && DG.Scr
      && (DG.X11ScreenHAM8
	  && flag
	  || !flag
	  && !DG.X11ScreenHAM8))
    {
      return (NULL);
    }
#endif
  if (DG.Scr != DG.wb && DG.Scr)
    CloseDownScreen ();
  return ((Window) SetupScreen (wide, high, depth, id));
}
XNoOp (Display * display)
{
#ifdef DEBUGXEMUL
#endif
  return (0);
}
XBell (Display * d, int n)
{
  printf ("%c", 7);
}
int
XDisplayHeight (Display * display, int screen_number)
{
#if 0
  FunCount_Enter (, bInformDisplay);
#endif
  return (DG.wb->Height);
}
int
XDisplayWidth (Display * display, int screen_number)
{
  return (DG.wb->Width);
}
int
XDisplayCells (Display * display, int screen_number)
{
  return (DG.wb->BitMap.Depth);
}
Colormap
XDefaultColormap (Display * d, int n)
{
#if 0
  return ((Colormap) DG.Scr->ViewPort.ColorMap);
#else
  return 0;
#endif
}
Screen *
XDefaultScreenOfDisplay (Display * d)
{
  Screen *scr = d->screens;
  return (&scr[0]);
}
int
XDefaultDepth (Display * dpy,
	       int scr)
{
  return (DefaultDepth (dpy, scr));
}
int
XDefaultScreen (Display * dpy)
{
  return (DefaultScreen (dpy));
}
extern GC
XDefaultGC (Display * dpy, int scr)
{
  return (DefaultGC (dpy, scr));
}
char *
XDisplayString (Display * dpy)
{
  return (DisplayString (dpy));
}
unsigned long
XBlackPixel (Display * display, int screen_number)
{
  return (BlackPixel (display, screen_number));
}
unsigned long
XWhitePixel (Display * display, int screen_number)
{
  return (WhitePixel (display, screen_number));
}
Window
XRootWindow (Display * display, int screen_number)
{
  return (RootWindow (display, screen_number));
}
Window
XRootWindowOfScreen (Screen * screen)
{
  return (screen->root);
}
unsigned long
XBlackPixelOfScreen (Screen * screen)
{
  return (screen->black_pixel);
}
X11userdata *
init_area (struct Window * win, int size, int w, int h)
{
  X11userdata *ud;
  int vOldW = w;
  int vOldH = h;
#if (DEBUG!=0)
  printf ("init_area [%x] %d x %d size %d\n", win, w, h, size);
#endif
  ud = malloc (sizeof (X11userdata));
  if (!ud)
    X11resource_exit (WINDOW3);
  if (w < DG.vWinWidth)
    w = DG.vWinWidth;
  if (h < DG.vWinHeight)
    h = DG.vWinHeight;
  ud->AWidth = w + 16;
  ud->AHeight = h + 16;
  ud->win_rastptr = (PLANEPTR) AllocRaster (ud->AWidth, ud->AHeight);
  if (!ud->win_rastptr)
    {
      w = vOldW;
      h = vOldH;
      ud->AWidth = w + 16;
      ud->AHeight = h + 16;
      ud->win_rastptr = (PLANEPTR) AllocRaster (ud->AWidth, ud->AHeight);
      if (!ud->win_rastptr)
	X11resource_exit (WINDOW1);
    }
  InitTmpRas (&(ud->win_tmpras), ud->win_rastptr, ((ud->AWidth + 15) / 16) * ud->AHeight);
  memset (&(ud->win_AIstruct), 0, sizeof (struct AreaInfo));
  ud->coor_buf = malloc (size * 5 * sizeof (WORD));
  if (!ud->coor_buf)
    X11resource_exit (WINDOW2);
  ud->max_coords = size;
  InitArea (&(ud->win_AIstruct), ud->coor_buf, size);
  assert (ud);
  if (win)
    {
      ud->X11OldAreaInfo = (win->RPort)->AreaInfo;
      ud->X11OldTmpRas = (win->RPort)->TmpRas;
      (win->RPort)->TmpRas = &(ud->win_tmpras);
      (win->RPort)->AreaInfo = &(ud->win_AIstruct);
      win->UserData = (UBYTE *) ud;
    }
  return ud;
}
void
X11free_userdata (X11userdata * ud)
{
  assert (ud);
  assert (ud->win_rastptr);
  assert (ud->AWidth);
  assert (ud->AHeight);
#if (DEBUG!=0)
  if (bInformDisplay)
    printf ("free_userdata %d %d\n", ud->AWidth, ud->AHeight);
#endif
  FreeRaster (ud->win_rastptr, ud->AWidth, ud->AHeight);
  if (ud->coor_buf)
    free (ud->coor_buf);
  memset (ud, 0, sizeof (X11userdata));
  free (ud);
}
void
exit_area (struct Window *win, X11userdata * ud)
{
  assert (ud);
  assert (ud->AWidth);
  assert (ud->AHeight);
#if (DEBUG!=0)
  printf ("exit_area [%x]\n", win, ud->AWidth, ud->AHeight);
#endif
  if (!ud)
    return;
  if (win)
    {
      (win->RPort)->TmpRas = ud->X11OldTmpRas;
      (win->RPort)->AreaInfo = ud->X11OldAreaInfo;
      win->UserData = NULL;
    }
  X11free_userdata (ud);
}
void
SetBackground (int n)
{
  assert (DG.Xuserdata);
  DG.Xuserdata->background = n;
}
GetBackground (struct Window *w)
{
  X11userdata *Xud;
  Xud = (X11userdata *) (w->UserData);
  return (Xud->background);
}
XSetWindowBackground (Display * display,
		      Window w,
		      unsigned long background_pixel)
{
  X11DrawablesBackground[w] = (char) background_pixel;
  return (0);
}
X11Internal_Error (int n)
{
  printf ("Internal error %d\n", n);
  switch (n)
    {
    case 0:
      printf ("xx 0\n");
      break;
    case 1:
      printf ("xx 1\n");
      break;
    case 2:
      printf ("xx 2\n");
      break;
    }
}
int
XDisplayHeightMM (Display * display, int screen_number)
{
  return (DG.X11Screen[0].mheight);
}
int
XDisplayWidthMM (Display * display, int screen_number)
{
  return (DG.X11Screen[0].mwidth);
}
int
XScreenNumberOfScreen (Screen * screen)
{
  return 0;
}
void
XResetDrawing (void)
{
  DG.vPrevWindow = -1;
  vPrevGC = (GC) - 1;
}
void
Amiga_UseWb (void)
{
  DG.vUseWB = 1;
}
#if (DEBUG!=0)
#define map(v) X11DrawablesMap[(v)]
int
GetWinX (int v)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winx access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid winx access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  return X11Windows[map (v)].x;
}
int
GetWinY (int v)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winy access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid winy access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  return X11Windows[map (v)].y;
}
int
GetWinBorder (int v)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winborder access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid winborder access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  return (int) X11Windows[map (v)].border;
}
int
GetWinWidth (int v)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winwidth access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid winwidth access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  return (int) X11Windows[map (v)].width;
}
int
GetWinHeight (int v)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winheight access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid winheight access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  return (int) X11Windows[map (v)].height;
}
int
GetWinRWidth (int v)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winrwidth access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid winrwidth access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  return (int) X11Windows[map (v)].rwidth;
}
int
GetWinRHeight (int v)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winrheight access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid winrheight access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  return (int) X11Windows[map (v)].rheight;
}
int
GetWinIndex (int v)
{
  return (int) map (v);
}
int
GetWinParent (int v)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winparent access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid winparent access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  return X11Windows[map (v)].parent;
}
int
SetWinFlag (int v, int flag)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winflag access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid winflag access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  (X11Windows[map (v)].flags |= (flag));
  return 1;
}
int
GetWinFlag (int v, int flag)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid getwinflag access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid Getwinflag access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  return (X11Windows[map (v)].flags & (flag));
}
int
ClearWinFlag (int v, int flag)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid clearwinflag access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (map (v) > DG.X11NumDrawablesWindows)
    {
      printf ("invalid clearwinflag access! %d mapped %d of %d\n", v, map (v), DG.X11NumDrawablesWindows);
      StopMe ();
    }
  (X11Windows[map (v)].flags &= (~(flag)));
  return 1;
}
int
GetWinFlagD (int v, int flag)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid winflagd access! %d of %d\n", v, DG.X11NumDrawablesWindows);
      StopMe ();
    }
  if (v > DG.X11NumDrawablesWindows)
    {
      printf ("invalid Winflagd map access! %d\n", v);
      StopMe ();
    }
  return (X11Windows[v].flags & (flag));
}
int
SetWinFlagD (int v, int flag)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid Winflagd access! %d\n", v);
      StopMe ();
    }
  if (v > DG.X11NumDrawablesWindows)
    {
      printf ("invalid Winflagd map access! %d\n", v);
      StopMe ();
    }
  (X11Windows[v].flags |= (flag));
  return 1;
}
int
ClearWinFlagD (int v, int flag)
{
  if (v < 0 || v > DG.X11NumDrawables)
    {
      printf ("invalid clearWinflagd access! %d\n", v);
      StopMe ();
    }
  if (v > DG.X11NumDrawablesWindows)
    {
      printf ("invalid clearwinflagd access! %d\n", v);
      StopMe ();
    }
  (X11Windows[v].flags &= (~(flag)));
  return 1;
}
#endif
XmuGetHostname (char *name, int length)
{
  char *tmpstr = getenv ("hostname");
#if 0
  printf ("XmuGetHostname\n");
#endif
  if (tmpstr)
    {
      strncpy (name, tmpstr, length);
      free (tmpstr);
    }
  else
    strcpy (name, "Unknown");
  return (0);
}
void
XSetWMNormalHints (
		    Display * display,
		    Window w,
		    XSizeHints * hints
)
{
#if (DEBUGXEMUL_ENTRY) || (DEBUGXEMUL_WARNING)
  if (!bIgnoreWindowWarnings)
    printf ("WARNING: SetWMNormalHints\n");
#endif
  XSetWMProperties (display, w, NULL, NULL, NULL, 0, hints, NULL, NULL);
}
void
  XSetWMProperties (Display * display,
		    Window w,
		    XTextProperty * window_name,
		    XTextProperty * icon_name,
		    char **argv,
		    int argc,
		    XSizeHints * normal_hints,
		    XWMHints * wm_hints,
		    XClassHint * class_hints);
void
XSetWMProperties (Display * display,
		  Window w,
		  XTextProperty * window_name,
		  XTextProperty * icon_name,
		  char **argv,
		  int argc,
		  XSizeHints * normal_hints,
		  XWMHints * wm_hints,
		  XClassHint * class_hints)
{
  struct Window *win;
#if 0
  if (!bIgnoreWindows)
    printf ("XSetWMProperties [%d,%d]\n", normal_hints->width, normal_hints->height);
#endif
  if (window_name)
    {
      X11Windows[X11DrawablesMap[w]].name = window_name->value;
      if (GetWinFlag (w, WIN_MAPPED))
	{
	  int root = X11Windows[X11DrawablesMap[w]].root;
	  win = X11DrawablesWindows[X11DrawablesMap[root]];
	  SetWindowTitles (win, X11Windows[X11DrawablesMap[w]].name, window_name->value);
	}
    }
  if (normal_hints->flags & USPosition)
    {
      if (normal_hints->x < DG.X11Screen[0].width &&
	  normal_hints->y < DG.X11Screen[0].height)
	{
	  X11Windows[X11DrawablesMap[w]].x = normal_hints->x;
	  X11Windows[X11DrawablesMap[w]].y = normal_hints->y;
	}
    }
  return;
}
XSetNormalHints (Display * display,
		 Window w,
		 XSizeHints * hints)
{
#ifdef DEBUGXEMUL_ENTRY
  FunCount_Enter (XSETNORMALHINTS, bInformDisplay);
#endif
  if (GetWinFlag (w, WIN_MAPPED))
    {
      XWindowChanges values;
      values.x = hints->x;
      values.y = hints->y;
      values.width = hints->width;
      values.height = hints->height;
      XConfigureWindow (display, w, CWX | CWY | CWWidth | CWHeight, &values);
    }
  return (0);
}
XWMHints *
XAllocWMHints ()
{
  XWMHints *xwmh = malloc (sizeof (XWMHints));
#if 0
  if (!bIgnoreWindows)
    printf ("XAllocWMHints\n");
#endif
#if (MEMORYTRACKING!=0)
  List_AddEntry (pMemoryList, (void *) xwmh);
#endif
  if (!xwmh)
    X11resource_exit (WINDOW4);
  return (xwmh);
}
int
GetNumMUI (void)
{
  return DG.X11NumMUI;
}
int
GetNumDrawables (void)
{
  return DG.X11NumDrawables;
}
