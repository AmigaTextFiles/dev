/* -*-C-*-
 *
 *
 * Filename : werase.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Empties the screen buffer.
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
 * $Log: werase.c,v $
 * Revision 1.4  1993/05/17  23:28:16  sie
 * Underscores added to names.
 *
 * Revision 1.3  1991/12/30  10:31:21  sie
 * Removed LRLine and LRATTRS.
 * The speed increase caused by them was too insignificant.
 *
 * Revision 1.2  91/12/28  14:01:21  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 * 
 * Revision 1.1  91/09/07  11:50:02  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/werase.c,v 1.4 1993/05/17 23:28:16 sie Exp $";

#include "acurses.h"


werase(WINDOW *WinPtr)
{
  int Line;
  
  if(!(_CursesFlags & CFLAG_INITSCR))  /* Haven't called initscr() */
    return ERR;
  
  /* Blank screen image */
  for(Line=0; Line<WinPtr->NLines; Line++) {
    memset(WinPtr->LnArry[Line].Line, ' ', WinPtr->_maxx + 1);
    memset(WinPtr->LnArry[Line].ATTRS, WinPtr->_attrs, WinPtr->_maxx+1);
    WinPtr->LnArry[Line].Touched = TRUE;
    WinPtr->LnArry[Line].StartCol = 0;
    WinPtr->LnArry[Line].EndCol = WinPtr->_maxx;
  }
  WinPtr->_curx = 0;
  WinPtr->_cury = 0;
  return OK;
}
