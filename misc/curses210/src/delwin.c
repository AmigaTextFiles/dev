/* -*-C-*-
 *
 *
 * Filename : delwin.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Frees up memory used by a window.
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
 * $Log: delwin.c,v $
 * Revision 1.6  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.5  1992/06/10  23:44:34  sie
 * Added serial support.
 *
 * Revision 1.4  91/12/30  10:30:55  sie
 * Removed LRLine and LRATTRS.
 * The speed increase caused by them was too insignificant.
 * 
 * Revision 1.3  91/12/28  13:57:24  sie
 * Removed WinStat.
 * Renamed LineElement as lnel.
 * 
 * Revision 1.2  91/12/26  14:39:45  sie
 * removed use of Next and Prev in WinStat as linked list is no longer
 * relevant.
 * 
 * Revision 1.1  91/09/07  11:40:51  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/delwin.c,v 1.6 1993/05/17 23:33:10 sie Exp $";

#include <stdlib.h>
#include "acurses.h"


delwin(WINDOW *WinPtr)
{
  int LineNo;
  
  if(!(_CursesFlags & CFLAG_INITSCR))
    return ERR;
  
  if(!WinPtr->ParentWin) {
    /* If it's a real window, free up Line, ATTRS */
    for(LineNo=0; LineNo<WinPtr->NLines; LineNo++) {
      free(WinPtr->LnArry[LineNo].Line);
      free(WinPtr->LnArry[LineNo].ATTRS);
    }
  }
  /* Free up LnArry[] */
  free(WinPtr->LnArry);
  /* Free the WinPtr */
  free(WinPtr);
  return OK;
}
