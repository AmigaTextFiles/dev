/* -*-C-*-
 *
 *
 * Filename : endwin.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Finished with curses, close everything and return.
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
 * $Log: endwin.c,v $
 * Revision 1.4  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.3  1992/06/10  23:44:36  sie
 * Added serial support.
 *
 * Revision 1.2  91/12/26  14:40:27  sie
 * removed use of Next and Prev in WinStat as linked list is no longer
 * relevant.
 * 
 * Revision 1.1  91/09/07  11:41:32  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/endwin.c,v 1.4 1993/05/17 23:33:10 sie Exp $";

#include "acurses.h"


/*
 *  Close the screen and libraries.
 */

endwin(void)                  /* called from main prior to exit. */
{
  if(!(_CursesFlags & CFLAG_INITSCR)) {  /* haven't called initscr() */
    return ERR;
  }
  _CleanUp();
  _CursesFlags &= ~CFLAG_INITSCR;  /* Mark that we have called endwin() */
  if(_CursesType == ANSI_CURSES)
    _ANSIMove(LINES-1, 0);
  if(_CursesFlags & CFLAG_CBREAK)
    nocbreak();
  return OK;
}
