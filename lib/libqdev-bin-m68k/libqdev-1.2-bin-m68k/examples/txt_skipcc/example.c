/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_skipcc()
 *
*/

#include "../gid.h"

#define COMMENTS                                         \
"/* Line 1 */Heavily /* Word 2 */commented /* Word 3 */" \
"text /* Why numbered? */is difficult to read...\n"      \
"/*\n"                                                   \
" * Line 2\n"                                            \
"*/\n"                                                   \
"/*Line 3*/I would love to /* Make more comments? */get" \
" rid of these /* Comments? */comments please!\n"



/*
 * As you can see this function is macroized, so that it
 * is easier to use it.
*/
int GID_main(void)
{
  QDEV_TXT_SKIPCCTYPE(sf);
  UBYTE *text = COMMENTS;
  LONG old = -1;


  /*
   * This will establish function input, such as when to
   * skip the comments.
  */
  QDEV_TXT_SKIPCCINIT(sf);

  /*
   * The iterator will take care of everything and will
   * always return a chunk of text that is free from
   * comments nearby.
  */
  QDEV_TXT_SKIPCCITER(text, sf)
  {
    /*
     * Most important thing is to save the old character
     * before temporarily destroying the string.
    */
    if (sf.sf_start)
    {
      old = *sf.sf_start;

      *sf.sf_start = '\0';
    }

    /*
     * You will have to inspect the byte of  'sf_ptr' to
     * see if there is a point to read anything.
    */
    if (*sf.sf_ptr)
    {
      FPrintf(Output(), "%s", (LONG)sf.sf_ptr);
    }

    /*
     * Now fix what was destroyed.
    */
    if (sf.sf_start)
    {
      *sf.sf_start = old;
    }
  }

  return 0;
}
