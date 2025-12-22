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
     amigax_proto
   PURPOSE
     prototypes for amigaX specific functions
   NOTES
     
   HISTORY
     Terje Pedersen - Feb 17, 1995: Created.
***/

#ifndef AMIGAX_PROTO
#define AMIGAX_PROTO

#ifdef __cplusplus
extern "C" {
#endif

extern struct RastPort *setup_win(Window win);
extern void setup_gc(GC gc);
extern void initfonts(void);
extern void swapwbcm(int,ULONG *);
extern void savewbcm(void);
extern void Xfreecursors(void);

extern void clear_subwin(Window,int,int);
extern void clip_begin(int,int,int,int);
extern void clip_exclude(int,int,int,int);

extern int defaultfontwidth(void);
extern int defaultfontheight(void);

extern void CloseDownScreen(void);
extern int SetupScreen(int width,int height,int depth,ULONG id);
extern void CloseDownScreen(void);
extern void CloseBackdropWindow(void);
extern int OpenBackdropWindow(int,int,int,int);
extern Window AmigaCreateWindow(int,int,int,int,ULONG);
extern int OpenLibraries(void);
extern void CloseLibraries(void);
extern void report_display(void);
extern void force_exit(int);
extern int open_timer(void);
extern void close_timer(void);
extern void init_backrp(void);

extern struct BitMap *alloc_bitmap(int width,int height,int depth,int flags);
extern int free_bitmap(struct BitMap *bmp);

#define CHILDRENAVAIL 100

#ifndef         S_ISDIR         /* missing POSIX-type macros */
#define       S_ISDIR(mode)   (((mode)&S_IFMT) == S_IFDIR)
#define       S_ISBLK(mode)   (((mode)&S_IFMT) == S_IFBLK)
#define       S_ISCHR(mode)   (((mode)&S_IFMT) == S_IFCHR)
#define       S_ISREG(mode)   (((mode)&S_IFMT) == S_IFREG)
#endif
#ifndef         S_ISFIFO
#  ifdef        S_IFIFO
#    define     S_ISFIFO(mode)  (((mode)&S_IFMT) == S_IFIFO)
#  else
#    define     S_ISFIFO(mode)  0
#  endif
#endif
#ifndef         S_ISLINK
#  ifdef        S_IFLNK
#    define     S_ISLINK(mode)  (((mode)&S_IFMT) == S_IFLNK)
#  else
#    define     S_ISLINK(mode)  0
#  endif
#endif
#ifndef         S_ISSOCK
#  ifdef        S_IFSOCK
#    define     S_ISSOCK(mode)  (((mode)&S_IFMT) == S_IFSOCK)
#  else
#    define     S_ISSOCK(mode)  0
#  endif
#endif

#include <stdio.h>
#include <memwatch.h> /* To enable memlib, you must #define MWDEBUG to 1 */

#define X11WINDOW 1
#define X11BITMAP 2
#define X11SUBWINDOW 3
#define X11MUI 4
#define X11ROOT 5

extern char *X11Drawables,*X11DrawablesBackground;
extern int *X11DrawablesSubWindows;
extern GC *X11GC;
extern int *X11DrawablesMap,*X11DrawablesWindowsInvMap;
extern int X11NumDrawables,X11NumDrawablesWindows,X11NumDrawablesBitmaps;
extern int X11NumDrawablesSubWindows,X11NumGC,X11AvailGC;
extern long *X11DrawablesMask;
extern int X11NumMUI;
extern Cursor *X11DrawablesMUICursor;

typedef struct {
  int x,y,width,height;
  int depth;
  int parent;
  char background;
  char mapped;
  Cursor cursor;
  Window win;
  char *name;
  Pixmap pixmap;
} _ActualWindow;

extern _ActualWindow *X11ActualWindows;

extern void X11AddInternal(Window,int,int);
extern void X11AddInternalEvent(Window,int,int);
extern void stackcheck(int);
extern char *getdisplayname(ULONG);
extern int get_intuievent(XEvent *event);
void X11ScanFile(FILE *fp);
#ifdef __cplusplus
}
#endif

#endif /* AMIGAX_PROTO */
