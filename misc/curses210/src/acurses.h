/*
 *
 * Module      : acurses.h
 *
 * Description : Header file for AMIGA CURSES package.
 *
 * Author      : Simon Raybould  (sie@fulcrum.bt.co.uk)
 *
 * Date        : 16th February 1990
 *
 *
 *
 * THIS CODE IS COPYRIGHT S.J.R 1991, ALL RIGHTS ARE RESERVED.
 *
 * THIS SOURCE IS NOT PUBLIC DOMAIN, BUT IS FREELY DISTRIBUTABLE AS
 *                LONG AS IT REMAINS UNALTERED.
 *
 * NO IMPLICATION IS MADE AS TO IT BEING FIT FOR ANY PURPOSE AT ALL
 * I SHALL NOT BE HELD RESPONSIBLE FOR ANY LOSS OF PROPERTY OR DAMAGE
 * THAT MAY RESULT FROM ITS USE.
 *
 *
 * $Log: acurses.h,v $
 * Revision 1.10  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.9  1992/12/25  22:16:55  sie
 * GNU port.
 *
 * Revision 1.8  92/06/10  23:43:32  sie
 * Added serial support.
 * 
 * Revision 1.7  92/01/25  23:51:51  sie
 * Define for TABSIZE.
 * 
 * Revision 1.6  91/12/28  22:43:00  sie
 * changed attrs to UBYTE from short + some tidying up.
 * 
 * Revision 1.5  91/12/28  14:02:45  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 * 
 * Revision 1.4  91/12/26  14:52:31  sie
 * Removed Next & Prev from WinStat as a list is no longer required.
 * 
 * Revision 1.3  91/09/07  11:54:19  sie
 * V2.00 curses.
 * 
 * Revision 1.2  91/08/23  21:38:47  sie
 * Port to GNU C.
 * 
 * Revision 1.1  91/02/05  21:19:43  sie
 * Initial revision
 * 
 *
 */

#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <libraries/dos.h>
#include <sys/types.h>
#include <exec/types.h>
#include <exec/io.h>
#include <exec/memory.h>
#include <devices/audio.h>

#ifdef LATTICE
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <dos.h>
#include <proto/console.h>
#include <proto/dos.h>
#endif /* LATTICE */

#include <stdlib.h>
#include <string.h>
#include "curses.h"

/* min() and max() are not part of c.lib */
#ifndef min
#define min(a,b) ((a)<(b)?(a):(b))
#endif
#ifndef max
#define max(a,b) ((a)>(b)?(a):(b))
#endif

/*
 * Genral stuff.
 */
#define MAXTEXTLEN     80	/* Max text to an output call */
#define SOUNDLENGTH     2	/* Number of bytes in the sound wave */
#define CAPSMASK     0x07	/* leftshift | rightshift | capslock */
#define SHIFTMASK    0x03	/* leftshift | rightshift */
#define MAXLINES       64	/* Maximum number of lines (PAL LACE) */
#define MAXCOLS        80	/* No overscan yet */
#define TABSIZE         8	/* distance between tab stops */
#define ANSIBUFSIZ     32	/* buffers for building ANSI sequences */
#define CAP_LEN         2       /* length of capability name strings */

/*
 * Type of curses
 */
#define CUST_CURSES    0	/* Use custom screen (default) */
#define ANSI_CURSES    1	/* Use ANSI codes to work on serial lines */

/*
 *    characters
 */
#define BS            0x08	/* Backspace */
#define CR            0x0d	/* Carriage return */
#define ESC           0x1b	/* Escape */
  
/*
 *    My Flags. These are global to all windows, not window specific.
 */
#define CFLAG_CURSOR    0001	/* T=Cursor on, F=Cursor off. */
#define CFLAG_CBREAK    0002	/* T=cbreak mode, F=nocbreak mode */
#define CFLAG_NLCR      0004	/* T=nl to cr mapping, F=no mapping */
#define CFLAG_ECHO      0010	/* T=Echo enabled, F=no echo */
#define CFLAG_INITSCR   0020	/* T=initscr has been called */
#define CFLAG_KEYPAD    0040	/* T=translate ANSI codes to special ints */

/*
 *    WINDOW flags, these are specific to each window.
 */
#define CWF_MOVED    0001	/* move() has been done on this window */

/*
 *    Buffer size for raw key events.
 */
#define RAWBUFSIZ    32

/*
 *    Scroll directions
 */
#define SCROLL_UP    1
#define SCROLL_DOWN  2

/*
 * Termcap stuff
 */
#define DFLT_TERMCAP "s:termcap"
#define LINE_LEN     1024       /* max line length in termcap file */
#define MAX_CAPS      128       /* maximum number of capabilities */

#define BELL         0x07
#define BS           0x08
#define TAB          0x09
#define NL           0x0a
#define FF           0x0c
#define CR           0x0d
#define ESC          0x1b


/*
 *    Simple implementation of wnoutrefresh() and doupdate()
 */

struct RefreshElement {
  WINDOW *WinPtr;
  struct RefreshElement *Next;
};


/*
 * Externals in _data.c
 */
extern unsigned char _CursesFlags;
extern int _CursesType;
extern unsigned char _GetchNChars, _GetchBufPos;
extern short _CursorCol, _CursorLine, _LCursorLine, _LCursorCol;
extern struct RefreshElement *_HeadRefreshList;
extern struct RastPort *_RPort;
extern struct ViewPort *_VPort;
extern struct IntuitionBase *IntuitionBase;
extern struct GfxBase *GfxBase;
extern struct IOStdReq ioreq;
extern struct Screen *_CursesScreen;
extern struct Window *_CursesWindow;
extern struct MsgPort *_CursesMsgPort;
extern int _FontHeight, _FontWidth, _FontBase;
extern BPTR _ifh;
extern char *__area;
extern char *__capary[];
extern int __no_caps;

extern char *_clstr;
extern char *_cmstr;


/*
 * Prototypes.
 */
void _DoEcho(WINDOW *, char);
int _Scroll(WINDOW *, int, int, int);
void _CleanExit(int);
void _ZapCursor(void);
void _DrawCursor(void);
void _ToggleCursor(int, int);
void _CleanUp(void);
/* Prototypes for functions defined in _ansi.c */
void _ANSIInit(void);
void _ANSIClear(void);
void _ANSIMove(int line,
              int col);
void _ANSIFlash(void);
void _ANSIClearRect(int line,
                   int col,
                   int height,
                   int width);
long _RawMode(BPTR afh);
long _CanonMode(BPTR afh);
WINDOW *_CreatWindow(int NLines, int NCols, int StartLine, int StartCol, WINDOW *Orig);

