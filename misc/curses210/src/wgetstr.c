/* -*-C-*-
 *
 *
 * Filename : wgetstr.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Read a string from the keyboard, provide del facility.
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
 * $Log: wgetstr.c,v $
 * Revision 1.3  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.2  1992/06/10  23:45:00  sie
 * Added serial support.
 *
 * Revision 1.1  91/09/07  11:50:18  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/wgetstr.c,v 1.3 1993/05/17 23:33:10 sie Exp $";

#include "acurses.h"


wgetstr(WINDOW *WinPtr, char *ptr)
{
  char done = FALSE, *BuffStart;
  unsigned char CbreakSet;  /* Used to restore after */
  
  if(!(_CursesFlags & CFLAG_INITSCR))  /* Haven't called initscr() */
    return ERR;
  
  BuffStart = ptr;
  
  /* Will need to be in CBREAK mode for this */
  CbreakSet = _CursesFlags & CFLAG_CBREAK;
  cbreak();
  while(!done) {
    switch(*ptr = wgetch(WinPtr)) {
    case -1:  /* wgetch() returned ERROR */
      *ptr = '\0';
      if(!CbreakSet)		/* if wasn't set then unset cbreak */
	nocbreak();
      return -1;
    case '\n':
    case '\r':
      *ptr = '\0';
      done = TRUE;
      break;
    case '\b':
      if(--ptr < BuffStart)  /* Don't move before start */
	ptr = BuffStart;
      else if(_CursesFlags & CFLAG_ECHO) {
	/* Do BS SP BS processing */
	mvcur(_CursorLine, _CursorCol, _CursorLine, _CursorCol - 1);  /* BS */
	_DoEcho(WinPtr, ' ');          /* SP */
	mvcur(_CursorLine, _CursorCol, _CursorLine, _CursorCol - 1);  /* BS */
      }
      break;
    default:
      ptr++;
      break;
    }
  }
  if(!CbreakSet)		/* if wasn't set then unset cbreak */
    nocbreak();
  return 0;
}
