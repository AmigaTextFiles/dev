/* -*-C-*-
 *
 *
 * Filename : box.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Draw a box around window.
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
 * $Log: box.c,v $
 * Revision 1.1  1991/09/07  11:40:10  sie
 * Initial revision
 *
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/box.c,v 1.1 1991/09/07 11:40:10 sie Exp $";

#include "acurses.h"


box(WINDOW *WinPtr, char vert, char hor)
{
  int i;
  short CurY, CurX;
  
  CurY = WinPtr->_cury;
  CurX = WinPtr->_curx;
  
  if(vert < 32 || vert > 126)
    vert = '|';
  if(hor < 32 || hor > 126)
    hor = '-';
  
  for(i=0; i<=WinPtr->_maxx; i++) {
    mvwaddch(WinPtr, 0, i, hor);  /* Top horizontal */
    mvwaddch(WinPtr, WinPtr->_maxy, i, hor);  /* Bottom horizontal */
  }
  for(i=1; i<WinPtr->_maxy; i++) {
    mvwaddch(WinPtr, i, 0, vert);  /* Left vertical */
    mvwaddch(WinPtr, i, WinPtr->_maxx, vert);  /* Right vertical */
  }
  WinPtr -> _cury = CurY;
  WinPtr -> _curx = CurX;
  return OK;
}
