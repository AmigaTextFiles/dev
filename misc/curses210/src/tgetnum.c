/* -*-C-*-
 *
 *
 * Filename : Workbench2.0:src/curses/tgetnum.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.co.uk).
 *
 * Date     : Thu Feb 25 21:28:42 1993
 *
 * Desc     : Gets a numeric value of capability id.
 *
 *
 * THIS CODE IS NOT PUBLIC DOMAIN
 * ==============================
 * 
 * This code is copyright Simon J Raybould 1992, all rights are reserved.
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
 * $Log: tgetnum.c,v $
 * Revision 1.1  1993/05/17  23:33:10  sie
 * Initial revision
 *
 *
 */

#ifndef lint
static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/tgetnum.c,v 1.1 1993/05/17 23:33:10 sie Exp $";
#endif /* lint */


#include "acurses.h"


tgetnum(char *id)
{
  int i;
  
  if(strlen(id) != CAP_LEN)
    return -1;
  
#ifdef FUTURE                   /* These are the starts of future enhancements */
                                /* or is it a Leonard Cohen album ? */
  if(_CursesType == CUST_CURSES) {
    switch(*((short *)id)) {
    case 0x6c69:                /* li */
      return LINES;
      break;
    case 0x636f:                /* co */
      return COLS;
      break;
    }
  } else {
#endif
  /* find the capability string */
  for(i=0; i< __no_caps; i++) {
    if(!strncmp(id, __capary[i], CAP_LEN)) { /* if it's this one */
      if(__capary[i][2] != '#') /* if it's not a number capability */
        return -1;
      return atoi(&__capary[i][3]);
    }
  }
#ifdef FUTURE
  }
#endif
  return -1;                    /* not found */
}
