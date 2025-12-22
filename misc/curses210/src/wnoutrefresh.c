/* -*-C-*-
 *
 *
 * Filename : wnoutrefresh.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Refresh without output.
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
 * $Log: wnoutrefresh.c,v $
 * Revision 1.3  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.2  1992/06/10  23:45:03  sie
 * Added serial support.
 *
 * Revision 1.1  91/09/07  11:51:53  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/wnoutrefresh.c,v 1.3 1993/05/17 23:33:10 sie Exp $";

#include <stdlib.h>
#include "acurses.h"

wnoutrefresh(WINDOW *WinPtr)
{
  struct RefreshElement *NewRefEl;
  
  if(!(_CursesFlags & CFLAG_INITSCR))
    return ERR;
  
  if(!(NewRefEl = (struct RefreshElement *)
       malloc(sizeof(struct RefreshElement))))
    return ERR;
  
  /* Fill the new element in */
  NewRefEl->Next = (struct RefreshElement *)NULL;
  NewRefEl->WinPtr = WinPtr;
  
  /* Add to start of refresh list */
  if(_HeadRefreshList)
    NewRefEl->Next = _HeadRefreshList;
  _HeadRefreshList = NewRefEl;
}
