/* -*-C-*-
 *
 *
 * Filename : Workbench2.0:src/curses/tgetstr.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.co.uk).
 *
 * Date     : Sat Feb 06 22:52:41 1993
 *
 * Desc     : tgetstr()
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
 * $Log: tgetstr.c,v $
 * Revision 1.1  1993/05/17  23:33:10  sie
 * Initial revision
 *
 *
 */

#ifndef lint
static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/tgetstr.c,v 1.1 1993/05/17 23:33:10 sie Exp $";
#endif /* lint */

#include <string.h>
#include "acurses.h"

char *
tgetstr(char *cn, char **ptr)
{
  int i;
  char *cptr, *tptr;
  
  if(strlen(cn) != CAP_LEN)
    return (char *)0;
  
#ifdef FUTURE
  if(_CursesType == CUST_CURSES) {
    tptr = *ptr;
    strcpy(tptr, cn);
    *ptr+=strlen(cn)+1;
    return tptr;
  }
#endif

  /* find the capability string */
  for(i=0; i< __no_caps; i++) {
    if(!strncmp(cn, __capary[i], CAP_LEN)) { /* if it's this one */
      cptr = __capary[i] + CAP_LEN;
      if(*cptr++ == '=') {
        while(*cptr == ' ' || *cptr == '\t') /* ignore leading WS */
          cptr++;
        tptr = *ptr;
        strcpy(tptr, cptr);
        *ptr+=strlen(cptr)+1;
        return tptr;
      }
    }
  }
  return (char *)0;
}
