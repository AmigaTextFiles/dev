/* -*-C-*-
 *
 *
 * Filename : initcolour.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Sets a colour register.
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
 * $Log: initcolour.c,v $
 * Revision 1.4  1993/05/17  23:33:10  sie
 * Underscores added to names.
 * Changes for version 2.10
 *
 * Revision 1.3  1992/06/10  23:44:39  sie
 * Added serial support.
 *
 * Revision 1.2  91/09/28  18:33:17  sie
 * DEPTH instead on NPLANES.
 * 
 * Revision 1.1  91/09/07  11:43:26  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/initcolour.c,v 1.4 1993/05/17 23:33:10 sie Exp $";

#include <exec/types.h>
#include "acurses.h"


init_color(WORD n, UWORD r, UWORD g, UWORD b)
{
  if(n<0 || n>=(1<<DEPTH) || r>1000 || g>1000 || b>1000)
    return ERR;
  if(_CursesType == CUST_CURSES)
    SetRGB4(_VPort, n, r*15/1000, g*15/1000, b*15/1000);
  return OK;
}
