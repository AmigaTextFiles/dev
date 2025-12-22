/* -*-C-*-
 *
 *
 * Filename : wclrtoeol.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Clear to end of line.
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
 * $Log: wclrtoeol.c,v $
 * Revision 1.4  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.3  1992/06/23  22:14:06  sie
 * Changed from a for loop to memset(), should be quicker.
 *
 * Revision 1.2  92/06/21  01:13:20  sie
 * Now writes directly to the screen structure rather than
 * using waddstr and wmove.
 * 
 * Revision 1.1  91/09/07  11:49:45  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/wclrtoeol.c,v 1.4 1993/05/17 23:33:10 sie Exp $";

#include "acurses.h"


wclrtoeol(WINDOW *WinPtr)
{
  if(!(_CursesFlags & CFLAG_INITSCR)) /* Haven't called initscr() */
    return ERR;

  memset(&(WinPtr->LnArry[WinPtr->_cury].Line[WinPtr->_curx]),
	 ' ', WinPtr->_maxx-WinPtr->_curx+1);
  memset(&(WinPtr->LnArry[WinPtr->_cury].ATTRS[WinPtr->_curx]),
	 WinPtr->_attrs, WinPtr->_maxx-WinPtr->_curx+1);

  WinPtr->LnArry[WinPtr->_cury].StartCol =
    min(WinPtr->_curx, WinPtr->LnArry[WinPtr->_cury].StartCol);
  WinPtr->LnArry[WinPtr->_cury].EndCol = WinPtr->_maxx;
  WinPtr->LnArry[WinPtr->_cury].Touched = TRUE;
  return OK;
}
