/* -*-C-*-
 *
 *
 * Filename : wrefresh.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Refresh a window, sending output to the screen.
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
 * $Log: wrefresh.c,v $
 * Revision 1.11  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.10  1992/12/25  23:39:56  sie
 * GNU C port.
 *
 * Revision 1.9  92/06/21  01:14:13  sie
 * Moved _clear=FALSE to after all lines have been refreshed.
 * 
 * Revision 1.8  92/06/11  00:22:05  sie
 * Now reflects cleared window to curscr.
 * 
 * Revision 1.7  92/06/10  23:45:04  sie
 * Added serial support.
 * 
 * Revision 1.6  92/01/25  23:56:18  sie
 * Now uses FontHeight and FontWidth.
 * 
 * Revision 1.5  91/12/30  10:31:13  sie
 * Removed LRLine and LRATTRS.
 * The speed increase caused by them was too insignificant.
 * 
 * Revision 1.4  91/12/28  22:46:01  sie
 * changed attrs to UBYTE from short + some tidying up.
 * 
 * Revision 1.3  91/12/28  14:01:40  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 * 
 * Revision 1.2  91/09/28  17:54:39  sie
 * Only need to optimise lines that have been written to.
 * 
 * Revision 1.1  91/09/07  11:52:07  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/wrefresh.c,v 1.11 1993/05/17 23:33:10 sie Exp $";

#include <exec/types.h>
#include "acurses.h"
#include <string.h>
#include <fcntl.h>


static void _optimise(WINDOW *winptr, int line)
{
  int i;
 
  if(!winptr->LnArry[line].Touched)
    return;

  for(i=winptr->LnArry[line].StartCol; i<=winptr->LnArry[line].EndCol; i++) {
    if((winptr->LnArry[line].Line[i] !=
	curscr->LnArry[line+winptr->_begy].Line[i+winptr->_begx]) ||
       (winptr->LnArry[line].ATTRS[i] !=
	curscr->LnArry[line+winptr->_begy].ATTRS[i+winptr->_begx]))
      break;
    winptr->LnArry[line].StartCol++;
    if(winptr->LnArry[line].StartCol > winptr->LnArry[line].EndCol)
      break;
  }
  for(i=winptr->LnArry[line].EndCol; i>=winptr->LnArry[line].StartCol; i--) {
    if((winptr->LnArry[line].Line[i] !=
	curscr->LnArry[line+winptr->_begy].Line[i+winptr->_begx]) ||
       (winptr->LnArry[line].ATTRS[i] !=
	curscr->LnArry[line+winptr->_begy].ATTRS[i+winptr->_begx]))
      break;
    winptr->LnArry[line].EndCol--;
    if(winptr->LnArry[line].StartCol > winptr->LnArry[line].EndCol)
      break;
  }
  if(winptr->LnArry[line].StartCol > winptr->LnArry[line].EndCol) {
    winptr->LnArry[line].StartCol = winptr->_maxx+1;
    winptr->LnArry[line].EndCol = 0;
    winptr->LnArry[line].Touched = FALSE;
  }
}

wrefresh(WINDOW *WinPtr)
{
  int i, j;
  unsigned long style;
  short Line;
  char Buffer[BUFSIZ];


  if(WinPtr == curscr)
    clearok(WinPtr, TRUE);
  _ZapCursor();
  /*
   *  It is possible for no printing since last refresh, but for
   *  a move to have been done...
   */
  if(WinPtr->_flags & CWF_MOVED) {
    WinPtr->_flags &= ~CWF_MOVED;
    _CursorLine = WinPtr->_cury + WinPtr->_begy;
    _CursorCol = WinPtr->_curx + WinPtr->_begx;
  }
  if(WinPtr->_clear) {
    if(_CursesType == CUST_CURSES) {
      SetAPen(_RPort, 0);
      SetDrMd(_RPort, JAM2);
      RectFill(_RPort, WinPtr->_begx * _FontWidth, WinPtr->_begy * _FontHeight,
	       ((WinPtr->_begx + WinPtr->_maxx) * _FontWidth) + (_FontWidth-1),
	       ((WinPtr->_begy + WinPtr->_maxy) * _FontHeight + (_FontHeight-1)));
    } else if(_CursesType == ANSI_CURSES) {
      _ANSIClearRect(WinPtr->_begy, WinPtr->_begx, WinPtr->_maxy+1, WinPtr->_maxx+1);
    }
    /* update curscr */
    for(i=0; i<=WinPtr->_maxy; i++) {
      memset(&(curscr->LnArry[i+WinPtr->_begy].Line[WinPtr->_begx]), ' ',
	     WinPtr->_maxx+1);
      memset(&(curscr->LnArry[i+WinPtr->_begy].ATTRS[WinPtr->_begx]), COLOR_WHITE,
	     WinPtr->_maxx+1);
    }
  }
  if(_CursesFlags & CFLAG_CURSOR) {
    _CursorLine = WinPtr->_cury + WinPtr->_begy;
    _CursorCol = WinPtr->_curx + WinPtr->_begx;
  }
  for(Line=0; Line<WinPtr->NLines; Line++) {
#ifdef LATTICE
    chkabort(); /* Check if INTR */
#endif
    /* if we have cleared the screen then must refresh everything */
    if(WinPtr->_clear) {
      WinPtr->LnArry[Line].Touched = TRUE;
      WinPtr->LnArry[Line].StartCol = 0;
      WinPtr->LnArry[Line].EndCol = WinPtr->_maxx;
    }
    _optimise(WinPtr, Line);	/* don't refresh stuff that's already done */
    if(WinPtr->LnArry[Line].Touched) {
      j = WinPtr->LnArry[Line].StartCol;
      for(i=j + 1; i<=WinPtr->LnArry[Line].EndCol; i++) {
	if(WinPtr->LnArry[Line].ATTRS[i] != WinPtr->LnArry[Line].ATTRS[j]) {
	  /* Print what we've got */
	  if(_CursesType == CUST_CURSES) {
	    SetAPen(_RPort, WinPtr->LnArry[Line].ATTRS[j] & A_CLRPART);
	    if(WinPtr->LnArry[Line].ATTRS[j] & (A_REVERSE | A_STANDOUT))
	      SetDrMd(_RPort, JAM2|INVERSVID);
	    else
	      SetDrMd(_RPort, JAM2);
	    style = FS_NORMAL;
	    if(WinPtr->LnArry[Line].ATTRS[j] & A_BOLD)
	      style |= FSF_BOLD;
	    if(WinPtr->LnArry[Line].ATTRS[j] & A_UNDERLINE)
	      style |= FSF_UNDERLINED;
	    SetSoftStyle(_RPort, style, ~0L);
	    Move(_RPort, (j+WinPtr->_begx) * _FontWidth,
		 _FontBase + (Line+WinPtr->_begy) * _FontHeight);
	    Text(_RPort, &WinPtr->LnArry[Line].Line[j], i-j);
	  } else if(_CursesType == ANSI_CURSES) {
	    _ANSIMove(Line+WinPtr->_begy, j+WinPtr->_begx);
	    if(WinPtr->LnArry[Line].ATTRS[j] & A_ATRPART) {
	      sprintf(Buffer, "\033[0;%d;40m", (WinPtr->LnArry[Line].ATTRS[j] & A_CLRPART)+30);
	      if(WinPtr->LnArry[Line].ATTRS[j] & A_BOLD)
		Buffer[2] = '1';
	      if(WinPtr->LnArry[Line].ATTRS[j] & A_UNDERLINE)
		Buffer[2] = '4';
	      if(WinPtr->LnArry[Line].ATTRS[j] & A_STANDOUT)
		Buffer[2] = '7';
	      write(1, Buffer, strlen(Buffer));
	    }
	    write(1, &WinPtr->LnArry[Line].Line[j], i-j);
	    if(WinPtr->LnArry[Line].ATTRS[j] & A_ATRPART)
	      write(1, "\033[0m", 4);
	  }
	  /*
	   *  Update the record of the current screen state.
	   */
	  if(WinPtr != curscr) {
	    memcpy(&(curscr->LnArry[Line+WinPtr->_begy].Line[j+WinPtr->_begx]),
		   &WinPtr->LnArry[Line].Line[j], i-j);
	    memcpy(&(curscr->LnArry[Line+WinPtr->_begy].ATTRS[j+WinPtr->_begx]),
		   &WinPtr->LnArry[Line].ATTRS[j], i-j);
	  }
	  j=i;
	}
      }
      if(j<i) {
	if(_CursesType == CUST_CURSES) {
	  SetAPen(_RPort, WinPtr->LnArry[Line].ATTRS[j] & A_CLRPART);
	  if(WinPtr->LnArry[Line].ATTRS[j] & (A_STANDOUT | A_REVERSE))
	    SetDrMd(_RPort, JAM2|INVERSVID);
	  else
	    SetDrMd(_RPort, JAM2);
	  style = FS_NORMAL;
	  if(WinPtr->LnArry[Line].ATTRS[j] & A_BOLD)
	    style |= FSF_BOLD;
	  if(WinPtr->LnArry[Line].ATTRS[j] & A_UNDERLINE)
	    style |= FSF_UNDERLINED;
	  SetSoftStyle(_RPort, style, ~0L);
	  Move(_RPort, (j+WinPtr->_begx) * _FontWidth,
	       _FontBase + (Line+WinPtr->_begy) * _FontHeight);
	  Text(_RPort, &(WinPtr->LnArry[Line].Line[j]), i-j);
	} else if(_CursesType == ANSI_CURSES) {
	  _ANSIMove(Line+WinPtr->_begy, j+WinPtr->_begx);
	  if(WinPtr->LnArry[Line].ATTRS[j] & A_ATRPART) {
	    sprintf(Buffer, "\033[0;%d;40m", (WinPtr->LnArry[Line].ATTRS[j] & A_CLRPART)+30);
	    if(WinPtr->LnArry[Line].ATTRS[j] & A_BOLD)
	      Buffer[2] = '1';
	    if(WinPtr->LnArry[Line].ATTRS[j] & A_UNDERLINE)
	      Buffer[2] = '4';
	    if(WinPtr->LnArry[Line].ATTRS[j] & A_STANDOUT)
	      Buffer[2] = '7';
	    write(1, Buffer, strlen(Buffer));
	  }
	  write(1, &WinPtr->LnArry[Line].Line[j], i-j);
	  if(WinPtr->LnArry[Line].ATTRS[j] & A_ATRPART)
	    write(1, "\033[0m", 4);
	}
	/*
	 *  Update the record of the current screen state.
	 */
	if(WinPtr != curscr) {
	  memcpy(&(curscr->LnArry[Line+WinPtr->_begy].Line[j+WinPtr->_begx]),
		 &WinPtr->LnArry[Line].Line[j], i-j);
	  memcpy(&(curscr->LnArry[Line+WinPtr->_begy].ATTRS[j+WinPtr->_begx]),
		 &WinPtr->LnArry[Line].ATTRS[j], i-j);
	}
      }
      WinPtr->LnArry[Line].Touched = FALSE;
      WinPtr->LnArry[Line].StartCol = WinPtr->_maxx+1;
      WinPtr->LnArry[Line].EndCol = 0;
    }
  }
  _DrawCursor();
  if(WinPtr->_clear)		/* Only on this refresh is it OK to clear */
    WinPtr->_clear = FALSE;
  return OK;
}
