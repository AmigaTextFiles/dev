/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strtok()
 *
*/

#include "../gid.h"

#define MYTEXT  "Amiga 500;Amiga 600;Amiga 1200;Amiga CD32"
#define MYDELIM ";"



/*
 * This gives some tip on how to use heavily altered C lib
 * 'strtok()' function. Although reentrant, you better see
 * lightweight 'txt_tokenify()' instead.
*/
int GID_main(void)
{
  UBYTE *token;
  UBYTE *string = MYTEXT;
  QDEV_TXT_STRTOKTYPE(tdata);


  /*
   * Before entering the loop gotta probe the text.
  */
  if ((token = QDEV_TXT_STRTOKINIT(string, MYDELIM, tdata)))
  {
    /*
     * Now we can process it until the end or until
     * no delimiter is to be found.
    */
    do
    {
      FPrintf(Output(), "%s\n", (LONG)token);
    } while ((token = QDEV_TXT_STRTOKNEXT(MYDELIM, tdata)));

    /*
     * Dont forget to restore the string to initial
     * state!
    */
    QDEV_TXT_STRTOKTERM(tdata);
  }

  return 0;
}
