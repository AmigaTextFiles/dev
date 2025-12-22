/* -*-C-*-
 *
 *
 * Filename : winsch.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Inserts a character into the screen buffer.
 *            All char to the right are slid along to make room.
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
 * $Log: winsch.c,v $
 * Revision 1.2  1991/12/28  14:01:31  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 *
 * Revision 1.1  91/09/07  11:50:31  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/winsch.c,v 1.2 1991/12/28 14:01:31 sie Exp $";

#include "acurses.h"


winsch(WINDOW *WinPtr, char c)
{
  int i;
  
  /* shuffle line along to the right */
  for (i = WinPtr->_maxx; i > WinPtr->_curx; i--)
    WinPtr->LnArry[WinPtr->_cury].Line[i] = WinPtr->LnArry[WinPtr->_cury].Line[i-1];
  WinPtr->LnArry[WinPtr->_cury].Line[i] = c;
  WinPtr->LnArry[WinPtr->_cury].StartCol = min(WinPtr->LnArry[WinPtr->_cury].StartCol, WinPtr->_curx);
  WinPtr->LnArry[WinPtr->_cury].EndCol = WinPtr->_maxx;
  WinPtr->LnArry[WinPtr->_cury].Touched = TRUE;
  
  return OK;
}
