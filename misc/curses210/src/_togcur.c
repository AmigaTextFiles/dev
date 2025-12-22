/* -*-C-*-
 *
 *
 * Filename : _togcur.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Friday 23rd August 1991.
 *
 * Desc     : Toggle the cursor on/off.
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
 * $Log: _togcur.c,v $
 * Revision 1.4  1993/05/17  23:30:32  sie
 * Underscores added to names.
 *
 * Revision 1.3  1992/06/10  23:45:17  sie
 * Added serial support.
 *
 * Revision 1.2  92/01/25  23:57:26  sie
 * Now uses FontHeight and FontWidth.
 * 
 * Revision 1.1  91/09/07  11:53:30  sie
 * Initial revision
 * 
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/_togcur.c,v 1.4 1993/05/17 23:30:32 sie Exp $";

#include "acurses.h"


void
_ToggleCursor(int Line, int Col)
{
  if(_CursesType == CUST_CURSES) {
    SetDrMd(_RPort, JAM2 | INVERSVID | COMPLEMENT);
    Move(_RPort, Col*_FontWidth, _FontBase+Line*_FontHeight);
    Text(_RPort, " ", 1);
  }
}
