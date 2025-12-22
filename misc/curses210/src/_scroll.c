/* -*-C-*-
 *
 *
 * Filename : _scroll.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : scrolls any region of lines up or down by one line.
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
 * $Log: _scroll.c,v $
 * Revision 1.9  1993/05/17  23:29:43  sie
 * Underscores added to names.
 *
 * Revision 1.8  1992/12/25  23:42:17  sie
 * Set x coord to 0 after a scroll operation.
 *
 * Revision 1.7  92/08/13  23:08:06  sie
 * Fixed bug that corrupted colours when screen scrolled.
 * 
 * Revision 1.6  92/06/21  01:14:47  sie
 * Now marks scroll lines as requiring refreshing.
 * 
 * Revision 1.5  92/06/10  23:45:15  sie
 * Added serial support.
 * 
 * Revision 1.4  91/12/30  10:31:10  sie
 * Removed LRLine and LRATTRS.
 * The speed increase caused by them was too insignificant.
 * 
 * Revision 1.3  91/12/28  22:46:25  sie
 * changed attrs to UBYTE from short + some tidying up.
 * 
 * Revision 1.2  91/12/28  14:02:06  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 * 
 * Revision 1.1  91/09/07  11:53:21  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/_scroll.c,v 1.9 1993/05/17 23:29:43 sie Exp $";

#include <string.h>
#include "acurses.h"


_Scroll(WINDOW *WinPtr, int Top, int Bottom, int Direction)
{
  int Step, SLine, DLine;
  char *TLine;
  UBYTE *TATTRS;
  
  /* Store pointers to line that will be lost */
  if(Direction == SCROLL_UP) {
    Step = +1;
    DLine = Top;
    SLine = Top + Step;
  } else {
    Step = -1;
    DLine = Bottom;
    SLine = Bottom + Step;
  }
  TLine = WinPtr->LnArry[DLine].Line;
  TATTRS = WinPtr->LnArry[DLine].ATTRS;
  /* Move the lines */
  for(;;) {
    /* This line now needs refreshing */
    WinPtr->LnArry[DLine].Touched = TRUE;
    WinPtr->LnArry[DLine].StartCol = 0;
    WinPtr->LnArry[DLine].EndCol = WinPtr->_maxx;
    /* check if we've finished */
    if((Direction == SCROLL_UP) && (DLine >= Bottom))
      break;  /* Done */
    if((Direction == SCROLL_DOWN) && (DLine <= Top))
      break;  /* Done */
    /* move the lines and attrs */
    WinPtr->LnArry[DLine].Line = WinPtr->LnArry[SLine].Line;
    WinPtr->LnArry[DLine].ATTRS = WinPtr->LnArry[SLine].ATTRS;
    /* next line */
    SLine += Step;
    DLine += Step;
  }
  /* Blank the Temp line */
  memset(TLine, ' ', WinPtr->_maxx+1);
  memset(TATTRS, WinPtr->_attrs, WinPtr->_maxx+1);
  /* move in temp line */
  WinPtr->LnArry[DLine].Line = TLine;
  WinPtr->LnArry[DLine].ATTRS = TATTRS;
  WinPtr->_curx = 0;            /* back to left margin */
  
  return OK;
}
