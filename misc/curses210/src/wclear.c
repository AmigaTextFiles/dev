/* -*-C-*-
 *
 *
 * Filename : wclear.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Clears the display.
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
 * $Log: wclear.c,v $
 * Revision 1.5  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.4  1991/12/30  10:31:18  sie
 * Removed LRLine and LRATTRS.
 * The speed increase caused by them was too insignificant.
 *
 * Revision 1.3  91/12/28  22:45:35  sie
 * changed attrs to UBYTE from short + some tidying up.
 * 
 * Revision 1.2  91/12/28  14:01:10  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 * 
 * Revision 1.1  91/09/07  11:49:29  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/wclear.c,v 1.5 1993/05/17 23:33:10 sie Exp $";

#include "acurses.h"


wclear(WINDOW *WinPtr)
{
  int Line;
  
  if(!(_CursesFlags & CFLAG_INITSCR))  /* Haven't called initscr() */
    return ERR;
  
  for(Line=0; Line<WinPtr->NLines; Line++) {
    memset(WinPtr->LnArry[Line].Line, ' ', WinPtr->_maxx + 1);
    memset(WinPtr->LnArry[Line].ATTRS, WinPtr->_attrs, WinPtr->_maxx+1);
    WinPtr->LnArry[Line].Touched = FALSE;
    WinPtr->LnArry[Line].StartCol = WinPtr->_maxx+1;
    WinPtr->LnArry[Line].EndCol = 0;
  }
  WinPtr->_curx = 0;
  WinPtr->_cury = 0;
  WinPtr->_clear = TRUE;
  return OK;
}
