/* -*-C-*-
 *
 *
 * Filename : SRC:lib/curses/src/setupterm.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.co.uk).
 *
 * Date     : Thu Jun 24 21:20:37 1993
 *
 * Desc     : Initialisation for terminfo support.
 *
 *
 * THIS CODE IS NOT PUBLIC DOMAIN
 * ==============================
 * 
 * This code is copyright Simon J Raybould 1993, all rights are reserved.
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
 * effectively.
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
 * $Log: setupterm.c,v $
 * Revision 1.1  1994/02/21  22:18:22  sie
 * Initial revision
 *
 *
 */

#ifndef lint
static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/setupterm.c,v 1.1 1994/02/21 22:18:22 sie Exp $";
#endif /* lint */

#include "acurses.h"


static char __sut_bp[1024], __sut_area[1024], *aptr = __sut_area;


void
setupterm(void)
{
  char *lterm;                  /* The terminal type */
  
  if(!(lterm = getenv("TERM"))) {
    fprintf(stderr, "Failed to get terminal type\n");
    return;                     /* don't know term type */
  }  
    
  tgetent(__sut_area, lterm);

  /* get clear capability string */
  _clstr = aptr;
  if(!tgetstr("cl", &aptr))
    fprintf(stderr, "Failed to get cl string\n");

  /* get cursor motion capability string */
  _cmstr = aptr;
  if(!tgetstr("cm", &aptr))
    fprintf(stderr, "Failed to get cm string\n");
}
