/* -*-C-*-
 *
 *
 * Filename : _doecho.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Echos one character.
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
 * $Log: _doecho.c,v $
 * Revision 1.6  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.5  1992/12/25  21:37:27  sie
 * Fixed font calculations.
 * Was previously hard coded for topaz 8.
 *
 * Revision 1.4  92/06/10  23:45:10  sie
 * Added serial support.
 * 
 * Revision 1.3  91/12/30  10:31:24  sie
 * Removed LRLine and LRATTRS.
 * The speed increase caused by them was too insignificant.
 * 
 * Revision 1.2  91/12/28  14:02:00  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 * 
 * Revision 1.1  91/09/07  11:52:57  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/_doecho.c,v 1.6 1993/05/17 23:33:10 sie Exp $";

#include "acurses.h"


void _DoEcho(WINDOW *WinPtr, char c)
{
  short x, y;
  char Buffer[ANSIBUFSIZ];
  
  if(c == BS || c == CR)        /* Don't echo Backspace or Return */
    return;

  if(_CursesType == CUST_CURSES) {
    x = _CursorCol * _FontWidth;
    y = _FontBase + _CursorLine * _FontHeight;
    _ZapCursor();
    SetDrMd(_RPort, JAM2);
    SetAPen(_RPort, WinPtr->_attrs & A_CLRPART);
    Move(_RPort, x, y);
    Text(_RPort, &c, 1);
    _DrawCursor();
  } else {
    _ANSIMove(_CursorLine, _CursorCol);
    if(WinPtr->LnArry[_CursorLine].ATTRS[_CursorCol] & A_ATRPART) {
      sprintf(Buffer, "\033[0;%d;40m", WinPtr->LnArry[_CursorLine].ATTRS[_CursorCol] & A_CLRPART+30);
      if(WinPtr->LnArry[_CursorLine].ATTRS[_CursorCol] & A_BOLD)
	Buffer[2] = '1';
      if(WinPtr->LnArry[_CursorLine].ATTRS[_CursorCol] & A_UNDERLINE)
	Buffer[2] = '4';
      if(WinPtr->LnArry[_CursorLine].ATTRS[_CursorCol] & A_STANDOUT)
	Buffer[2] = '7';
      write(1, Buffer, strlen(Buffer));
    }
    fputc(c, stdout);
    if(WinPtr->LnArry[_CursorLine].ATTRS[_CursorCol] & A_ATRPART)
      write(1, "\033[0m", 4);
  }
  /* Update curscr */
  if(WinPtr != curscr) {
    wmove(curscr, _CursorLine, _CursorCol);
    waddch(curscr, c);
  }
  /* Update Line structure */
  WinPtr->LnArry[_CursorLine-WinPtr->_begy].Line[_CursorCol-WinPtr->_begx] = c;
  WinPtr->LnArry[_CursorLine-WinPtr->_begy].ATTRS[_CursorCol-WinPtr->_begx] = WinPtr->_attrs;
  /* Move current position one to the right */
  if(++WinPtr->_curx > WinPtr->_maxx)
    WinPtr->_curx = WinPtr->_maxx;
  mvcur(_CursorLine, _CursorCol, _CursorLine, _CursorCol + 1);
}
