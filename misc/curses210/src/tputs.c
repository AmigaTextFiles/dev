/* -*-C-*-
 *
 *
 * Filename : Workbench2.0:src/curses/tputs.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.co.uk).
 *
 * Date     : Tue Feb 09 21:40:34 1993
 *
 * Desc     : tputs(3)
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
 * $Log: tputs.c,v $
 * Revision 1.1  1993/05/17  23:33:10  sie
 * Initial revision
 *
 *
 */

#ifndef lint
static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/tputs.c,v 1.1 1993/05/17 23:33:10 sie Exp $";
#endif /* lint */

#include "acurses.h"


tputs(char *cp, int affcnt, int(*outc)(char))
{
  int delay = 0;
  
#ifdef FUTURE
  if(_CursesType == CUST_CURSES) {
    switch(*((short *)cp)) {
    case 0x636c:                /* cl */
      /* SetRast(); */
      break;
    }
  } else {
#endif
  while(isdigit(*cp)) {
    delay *= 10;
    delay += (*cp - '0');
    cp++;
  }
  if(*cp == '*') {              /* is it a delay per line affected ? */
    delay *= affcnt;
    cp++;
  }
  while(*cp) {
    switch(*cp) {
      case '\\':
      if(isdigit(*++cp))
        /* This must be a 3 digit octal number */
        outc((64*(*cp++ - '0') + 8*(*cp++ - '0') + (*cp - '0')) & 0x7f);
      else {
        switch(*cp) {           /* character after a \ */
        case 'E':
          outc(ESC);
          break;
        case 'n':
          outc(NL);
          break;
        case 'r':
          outc(CR);
          break;
        case 't':
          outc(TAB);
          break;
        case 'b':
          outc(BS);
          break;
        case 'f':
          outc(FF);
          break;
        case '^':
          outc('^');
          break;
        case '\\':
          outc('\\');
          break;
        }
      } /* end of else, so not an octal number */
      break;
      
    case '^':                   /* control character */
      outc(toupper(*++cp) - '@'); /* this line assumes ascii */
      break;
      
    default:
      outc(*cp);
      break;
    }
    cp++;
  }
#ifdef FUTURE
}
#endif
}
