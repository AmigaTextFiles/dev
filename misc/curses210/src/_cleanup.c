/* -*-C-*-
 *
 *
 * Filename : _cleanup.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.bt.co.uk).
 *
 * Date     : Saturday 24th August 1991.
 *
 * Desc     : Free resources.
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
 * $Log: _cleanup.c,v $
 * Revision 1.2  1993/05/17  23:29:20  sie
 * Underscores added to names.
 *
 * Revision 1.1  1991/09/07  11:52:37  sie
 * Initial revision
 *
 *
 */

static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/_cleanup.c,v 1.2 1993/05/17 23:29:20 sie Exp $";

#include "acurses.h"


void
_CleanUp(void)
{
  if(_CursesWindow) {
    CloseWindow(_CursesWindow);
    _CursesWindow = NULL;
  }
  if(_CursesScreen) {
    CloseScreen(_CursesScreen);
    _CursesScreen = NULL;
  }
  if(GfxBase) {
    CloseLibrary((struct Library *)GfxBase);
    GfxBase = NULL;
  }
  if(IntuitionBase) {
    CloseLibrary((struct Library *)IntuitionBase);
    IntuitionBase = NULL;
  }
}
