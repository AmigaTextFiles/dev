/* -*-C-*-
 *
 *
 * Filename : wdelch.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Deletes the char at the current location in the buffer.
 *            All chars to the right are slid left to fill the gap.
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
 * $Log: wdelch.c,v $
 * Revision 1.2  1991/12/28  14:01:16  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 *
 * Revision 1.1  91/09/07  11:49:51  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/wdelch.c,v 1.2 1991/12/28 14:01:16 sie Exp $";

#include "acurses.h"


wdelch(WINDOW *WinPtr)
{
  int i;
  
  /* shuffle line along to the left */
  for (i = WinPtr->_curx; i < WinPtr->_maxx; i++)
    WinPtr->LnArry[WinPtr->_cury].Line[i] = WinPtr->LnArry[WinPtr->_cury].Line[i+1];
  WinPtr->LnArry[WinPtr->_cury].Line[i] = ' ';  /* Blank last char */
  WinPtr->LnArry[WinPtr->_cury].StartCol = min(WinPtr->LnArry[WinPtr->_cury].StartCol, WinPtr->_curx);
  WinPtr->LnArry[WinPtr->_cury].EndCol = WinPtr->_maxx;
  WinPtr->LnArry[WinPtr->_cury].Touched = TRUE;
  
  return OK;
}
