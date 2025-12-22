/* -*-C-*-
 *
 * Filename : SRC:lib/curses/src/tparm.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.co.uk).
 *
 * Date     : Mon Aug 16 21:40:58 1993
 *
 * Desc     : tparm() call, obvious really.
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
 * $Log: tparm.c,v $
 * Revision 1.1  1994/02/21  22:18:41  sie
 * Initial revision
 *
 *
 *
 */

#ifndef TARGET
#ifndef lint
static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/tparm.c,v 1.1 1994/02/21 22:18:41 sie Exp $";
#endif /* lint */
#endif /* TARGET */





char *
tparm(char *str, ...)
{
  static char buf[80];
  char *ptr = str, *bptr = buf;
  
  while(*ptr) {
    if(*ptr == '%') {
      if(!*++ptr)
        break;
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
