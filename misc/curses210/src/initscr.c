/* -*-C-*-
 *
 *
 * Filename : initscr.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Initialise curses.
 *
 *
 * THIS CODE IS NOT PUBLIC DOMAIN
 * ==============================
 * 
 * This code is copyright Simon J Raybould 1991, all rights are reserved.
 * All code, ideas, data structures and algorithms remain the property of the
 * author. Neither the whole nor sections of this code may be used as part
 * of other code without the authors consent. If you wish to use some of this
 * code then please email me at (sie@fulcrum.bt.co.uk).
 *
 * This source is not public domain, so you do not have any right to alter it
 * or sell it for personal gain. The source is provided purely for reference
 * purposes. You may re-compile the source with any compiler you choose.
 * You must not distribute altered copies without the authors consent. My
 * intention is that the source will help people isolate any bugs much more
 * effectivly.
 *
 * Disclaimer
 * ==========
 *
 * No implication is made as to this code being fit for any purpose at all.
 * I (the author) shall not be held responsible for any loss of data or damage 
 * to property that may result from its use or misuse.
 *
 *
 * Revision History
 * ================
 *
 * $Log: initscr.c,v $
 * Revision 1.8  1994/02/21  22:12:00  sie
 * added call to setupterm.
 * renamed BreakHandler as _BreakHandler
 *
 * Revision 1.7  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.6  1992/12/26  00:23:56  sie
 * Made more amendments to the LINES and COLS calculations.
 * Now sets them according to the system font and screen mode.
 * They are over-ridden if the env variables are set up.
 * In ANSI mode, they are just set to 24 and 80.
 *
 * Revision 1.5  92/07/14  20:45:27  sie
 * fixed screen size problems.
 * 
 * Revision 1.4  92/06/10  23:44:41  sie
 * Added serial support.
 * 
 * Revision 1.3  92/01/25  23:54:31  sie
 * Now uses fontheight and fontwidth.
 * Different algorithm for working out LINES and COLS.
 * 
 * Revision 1.2  91/12/30  10:31:03  sie
 * Removed LRLine and LRATTRS.
 * The speed increase caused by them was too insignificant.
 * 
 * Revision 1.1  91/09/07  11:43:35  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/initscr.c,v 1.8 1994/02/21 22:12:00 sie Exp $";

/* version strings */
#define VERSION      "Amiga curses by Simon J Raybould  V2.00+ 30.Jun.92"
static char *version = "$VER: Amiga curses (SJR) version 2.00+";


#include <signal.h>
#include "acurses.h"

extern struct Library *ConsoleDevice;

static struct NewScreen NewScreen = {
  0, 0, 0, 0, 4, 0, 1, HIRES, CUSTOMSCREEN, NULL, "Curses screen", NULL, NULL
};

static struct NewWindow NewWindow = {
  0, 0, 0, 0, -1, -1, RAWKEY, ACTIVATE | BORDERLESS,
  NULL, NULL, NULL, NULL, NULL, 0,0,0,0, CUSTOMSCREEN
};

/*
 *  Make version number appear when right mouse button is pressed.
 */
static struct Menu _CursesMenu = {
  NULL, 0, 0, 0, 0, 0, VERSION, NULL, 0, 0, 0, 0
};

static UWORD _ColourTable[] = {
  0x000, 0xfff, 0xff0, 0x00f, 0xf0f, 0x0ff, 0xf00, 0x0f0
};

static int
_BreakHandler(void)
{
  endwin();			/* tidy up */
  fprintf(stderr, "Amiga Curses exiting after receiving interrupt signal\n");
  _CleanExit(20);
  return 0;
}

initscr(void)
{
  char *Ptr, *getenv(const char *);
  int Tmp;
  struct Screen WBScreen;
  
  /*
   *  It would be devestating if someone called initscr() twice
   *  so make subsequent calls just return OK.
   */
  if(_CursesFlags & CFLAG_INITSCR)
    return OK;
  
  _CursesFlags |= CFLAG_INITSCR;
  
  /* Work out which sort of curses is required */
  _CursesType = CUST_CURSES;
  if(Ptr = getenv("CURSESTYPE")) {
    if(!strcmp(Ptr, "ansi") || !strcmp(Ptr, "ANSI"))
      _CursesType = ANSI_CURSES;
  }
  if(_CursesType == CUST_CURSES) {
    if((IntuitionBase = (struct IntuitionBase *)
	OpenLibrary("intuition.library", 0)) == NULL) {
      fprintf(stderr, "Failed to open Intuition library");
      _CleanExit(10);
    }
    /* Open graphics library */
    if((GfxBase = (struct GfxBase *)
	OpenLibrary("graphics.library", 0))==NULL) {
      fprintf(stderr, "Failed to open Graphics library");
      _CleanExit(10);
    }
    /* Get WB screen height and Width */
    if(!GetScreenData((char *)&WBScreen, sizeof(struct Screen), WBENCHSCREEN, NULL)) {
      printf("Can't get screen size\n");
      exit(10);
    }
    NewScreen.Height = NewWindow.Height = WBScreen.Height;
    NewScreen.Width = NewWindow.Width = WBScreen.Width;
    NewScreen.Depth = DEPTH;
    /* Set interlace if height>=400 */
    if(NewScreen.Height>=400)
      NewScreen.ViewModes |= LACE;
    
    /*
     * must have the console.device opened to use RawKeyConvert()
     */
    if(OpenDevice("console.device", -1L, (struct IORequest *)&ioreq, 0L))
      _CleanExit(10);
    ConsoleDevice = (struct Library *)ioreq.io_Device;
    
    if((_CursesScreen = (struct Screen *)OpenScreen(&NewScreen)) == NULL) {
      fprintf(stderr, "Failed to open Screen");
      _CleanExit(10);
    }
    _RPort = &(_CursesScreen->RastPort);
    _VPort = &(_CursesScreen->ViewPort);

    LoadRGB4(_VPort, _ColourTable, (1<<DEPTH));
    SetDrMd(_RPort, JAM2);
    SetAPen(_RPort, 1);
    NewWindow.Screen = _CursesScreen;
    if((_CursesWindow=(struct Window *)OpenWindow(&NewWindow)) == NULL) {
      fprintf(stderr, "Failed to open Window\n");
      _CleanExit(10);
    }
    _CursesMsgPort = _CursesWindow->UserPort;
    SetMenuStrip(_CursesWindow, &_CursesMenu);

    /* Get font size */
    _FontHeight = _CursesWindow->IFont->tf_YSize;
    _FontWidth = _CursesWindow->IFont->tf_XSize;
    _FontBase = _CursesWindow->IFont->tf_Baseline;
    /* Alter the default LINES and COLS for custom curses */
    LINES = WBScreen.Height/_FontHeight;
    COLS = WBScreen.Width/_FontWidth;
  } else {                      /* ANSI only */
    /* if LINES and/or COLS set as environment variables then use them */
    if((Ptr = getenv("LINES"))) {
      Tmp = atoi(Ptr);
      if(Tmp>0 && Tmp<=MAXLINES)
        LINES = Tmp;
    }
    if((Ptr = getenv("COLS"))) {
      Tmp = atoi(Ptr);
      if(Tmp>0 && Tmp<=MAXCOLS)
        COLS = Tmp;
    }
  }
#ifdef DEBUG
  printf("FontHeight=%d, FontWidth=%d, FontBase=%d\n", _FontHeight, _FontWidth, _FontBase);
  printf("LINES=%d, COLS=%d\n", LINES, COLS);
#endif

  /* Create stdscr and curscr */
  stdscr = newwin(LINES, COLS, 0, 0);
  curscr = newwin(LINES, COLS, 0, 0);  /* used for redraws */
#ifdef LATTICE
  if(onbreak(_BreakHandler)) {
    fprintf(stderr, "Failed to set BREAK handler.\n");
    _CleanExit(10);
  }
#else /* LATTICE */
  if ((int)signal(SIGINT, _BreakHandler) == -1) {
    perror("Failed to set BREAK handler.");
    _CleanExit(10);
  }
#endif /* else LATTICE */

  if(_CursesType == ANSI_CURSES) {
    _ifh = Input();
    if(_CursesFlags & CFLAG_CBREAK)
      _RawMode(_ifh);
    setupterm();                /* get the capability strings ready */
  }
  return OK;
}
