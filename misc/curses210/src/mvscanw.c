/* -*-C-*-
 *
 *
 * Filename : mvscanw.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Move and scan.
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
 * $Log: mvscanw.c,v $
 * Revision 1.2  1992/12/25  23:35:18  sie
 * Fixed the bug with scanw().
 * There is no svscanf() function!
 *
 * Revision 1.1  91/09/07  11:44:21  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/mvscanw.c,v 1.2 1992/12/25 23:35:18 sie Exp $";

#include "curses.h"
#include <stdarg.h>


mvscanw(short int Line, short int Col, char *fmt,
        char *ptr1, char *ptr2, char *ptr3, char *ptr4, char *ptr5,
        char *ptr6, char *ptr7, char *ptr8, char *ptr9, char *ptr10)
{
  char buffer[BUFSIZ];
  
  move(Line, Col);
  getstr(buffer);
  return sscanf(buffer, fmt, ptr1, ptr2, ptr3, ptr4, ptr5, ptr6, ptr7, ptr8, ptr9, ptr10);
}
