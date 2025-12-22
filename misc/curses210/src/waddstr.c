/* -*-C-*-
 *
 *
 * Filename : waddstr.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Adds a string to the display buffer.
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
 * $Log: waddstr.c,v $
 * Revision 1.7  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.6  1992/06/21  01:12:54  sie
 * Indentation.
 *
 * Revision 1.5  92/06/10  23:44:49  sie
 * Added serial support.
 * 
 * Revision 1.4  92/01/25  23:55:34  sie
 * Used define for TABSIZE rather than a hard coded 8.
 * 
 * Revision 1.3  91/12/28  22:45:23  sie
 * changed attrs to UBYTE from short + some tidying up.
 * 
 * Revision 1.2  91/12/28  14:01:00  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 * 
 * Revision 1.1  91/09/28  18:09:36  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/waddstr.c,v 1.7 1993/05/17 23:33:10 sie Exp $";

#include "acurses.h"


waddstr(WINDOW *WinPtr, char *Str)
{
  if(!*Str)
    return OK;
  
  WinPtr->LnArry[WinPtr->_cury].Touched = TRUE;
  WinPtr->LnArry[WinPtr->_cury].StartCol = min(WinPtr->LnArry[WinPtr->_cury].StartCol, WinPtr->_curx);
  if(WinPtr->ParentWin) {
    WinPtr->ParentWin->LnArry[WinPtr->_cury + WinPtr->_begy].Touched = TRUE;
    WinPtr->ParentWin->LnArry[WinPtr->_cury + WinPtr->_begy].StartCol = min(WinPtr->ParentWin->LnArry[WinPtr->_cury + WinPtr->_begy].StartCol, WinPtr->_curx + WinPtr->_begx);
  }
  while(*Str) {
    switch(*Str) {
    case '\t':
      do {
	WinPtr->LnArry[WinPtr->_cury].Line[WinPtr->_curx] = ' ';
	WinPtr->LnArry[WinPtr->_cury].ATTRS[WinPtr->_curx++] = WinPtr->_attrs;
      } while(WinPtr->_curx % TABSIZE);
      break;
    case '\n':
      WinPtr->LnArry[WinPtr->_cury].EndCol = max(WinPtr->LnArry[WinPtr->_cury].EndCol, WinPtr->_curx - 1);
      wclrtoeol(WinPtr);
      if(WinPtr->ParentWin)
	WinPtr->ParentWin->LnArry[WinPtr->_cury+WinPtr->_begy].EndCol=max(WinPtr->ParentWin->LnArry[WinPtr->_cury+WinPtr->_begy].EndCol,WinPtr->_curx+WinPtr->_begx-1);
      WinPtr->_curx=0;
      WinPtr->_cury++;
      if(WinPtr->_cury > WinPtr->ScrollBot) {
	if(WinPtr->_scroll)
	  scroll(WinPtr);
	WinPtr->_cury = WinPtr->ScrollBot;
      }
      if(*(Str + 1)) {  /* If there is more then touch this line too */
	WinPtr->LnArry[WinPtr->_cury].Touched = TRUE;
	WinPtr->LnArry[WinPtr->_cury].StartCol = min(WinPtr->LnArry[WinPtr->_cury].StartCol, WinPtr->_curx);
	if(WinPtr->ParentWin) {
	  WinPtr->ParentWin->LnArry[WinPtr->_cury+WinPtr->_begy].Touched = TRUE;
	  WinPtr->ParentWin->LnArry[WinPtr->_cury+WinPtr->_begy].StartCol = min(WinPtr->ParentWin->LnArry[WinPtr->_cury+WinPtr->_begy].StartCol, WinPtr->_curx+WinPtr->_begx);
	}
      }
      break;
    default:
      WinPtr->LnArry[WinPtr->_cury].Line[WinPtr->_curx] = *Str;
      WinPtr->LnArry[WinPtr->_cury].ATTRS[WinPtr->_curx] = WinPtr->_attrs;
      WinPtr->_curx++;
      break;
    } /* switch */
    if(WinPtr->_curx > WinPtr->_maxx) {	/* If gone off end of line */
      WinPtr->LnArry[WinPtr->_cury].EndCol = WinPtr->_maxx;
      WinPtr->_curx = 0;
      WinPtr->_cury++;
      if(WinPtr->_scroll) {
	if(WinPtr->_cury > WinPtr->ScrollBot) {
	  scroll(WinPtr);
	  WinPtr->_cury = WinPtr->ScrollBot;
	}
      }
      if(WinPtr->_cury > WinPtr->_maxy)
	WinPtr->_cury = WinPtr->_maxy;
      if(*(Str + 1)) {  /* If there is more then touch this line too */
	WinPtr->LnArry[WinPtr->_cury].Touched = TRUE;
	WinPtr->LnArry[WinPtr->_cury].StartCol = WinPtr->_begx;
	if(WinPtr->ParentWin) {
	  WinPtr->ParentWin->LnArry[WinPtr->_cury+WinPtr->_begy].Touched=TRUE;
	  WinPtr->ParentWin->LnArry[WinPtr->_cury+WinPtr->_begy].StartCol=
	    min(WinPtr->ParentWin->LnArry[WinPtr->_cury + WinPtr->_begy].StartCol, WinPtr->_begx);
	}
      }
    } /* if gone off end of line */
    Str++;
  } /* while (*Str) */
  WinPtr->LnArry[WinPtr->_cury].EndCol = max(WinPtr->LnArry[WinPtr->_cury].EndCol, WinPtr->_curx - 1);
  if(WinPtr->ParentWin)
    WinPtr->ParentWin->LnArry[WinPtr->_cury+WinPtr->_begy].EndCol = max(WinPtr->ParentWin->LnArry[WinPtr->_cury+WinPtr->_begy].EndCol, WinPtr->_curx+WinPtr->_begx-1);
  return OK;
}
