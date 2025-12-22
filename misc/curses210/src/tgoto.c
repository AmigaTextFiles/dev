/* -*-C-*-
 *
 *
 * Filename : Workbench2.0:src/curses/tgoto.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.co.uk).
 *
 * Date     : Wed Feb 24 21:48:37 1993
 *
 * Desc     : goto a specified point on the screen.
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
 * or sell it for personal gain. The source is prcolided purely for reference
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
 * $Log: tgoto.c,v $
 * Revision 1.1  1993/05/17  23:33:10  sie
 * Initial revision
 *
 *
 */

#ifndef lint
static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/tgoto.c,v 1.1 1993/05/17 23:33:10 sie Exp $";
#endif /* lint */

#include <stdio.h>

static void swap(int *a, int *b) { int t; t = *a; *a = *b; *b = t; }

char *
tgoto(char *cm, int col, int line)
{
  static char buf[80];
  char *ptr = cm, *bptr = buf;
  
  while(*ptr) {
    if(*ptr == '%') {
      if(!*++ptr) break;
      switch(*ptr) {
      case 'd':                 /* decimal value */
        bptr += sprintf(bptr, "%d", line);
        swap(&line, &col);
        break;
      case '2':                 /* decimal value */
        bptr += sprintf(bptr, "%2d", line);
        swap(&line, &col);
        break;
      case '3':                 /* decimal value */
        bptr += sprintf(bptr, "%3d", line);
        swap(&line, &col);
        break;
      case '.':                 /* character value */
        bptr += sprintf(bptr, "%c", line);
        swap(&line, &col);
        break;
      case 'r':                 /* reverse line and col */
        swap(&line, &col);
        break;
      case 'i':                 /* in line and col */
        line++;
        col++;
        break;
      case '%':
        *bptr++ = '%';
        break;
      }
    } else
      *bptr++ = *ptr;
    ptr++;
  } /* end of while(*ptr) */
  return buf;
}

