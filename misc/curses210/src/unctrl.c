/* -*-C-*-
 *
 *
 * Filename : SRC:lib/curses/src/unctrl.c
 *
 * Author   : Simon J Raybould.    (sie@fulcrum.co.uk).
 *
 * Date     : Wed Jan 20 23:24:03 1993
 *
 * Desc     : converts control caracters to printable sequences of the form
 *            "^A" for control-A
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
 * $Log: unctrl.c,v $
 * Revision 1.1  1993/05/17  23:33:10  sie
 * Initial revision
 *
 *
 */

#ifndef lint
static char *rcsid = "$Header: /SRC/lib/curses/src/RCS/unctrl.c,v 1.1 1993/05/17 23:33:10 sie Exp $";
#endif /* lint */


char *
unctrl(char ch)
{
  static char buf[3];           /* longest string is 2 chars + terminator */

  if(ch < 32) {
    buf[0] = '^';
    buf[1] = ch + '@';          /* control-@ is 0 in ASCII */
    buf[2] = '\0';
  } else {
    buf[0] = ch;
    buf[1] = '\0';
  }
  return buf;
}
