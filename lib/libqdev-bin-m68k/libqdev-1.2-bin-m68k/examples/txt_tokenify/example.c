/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_tokenify()
 *
*/

#include "../gid.h"

#define MYTEXT    "Amiga 500;Amiga 600;Amiga 1200;Amiga CD32"
#define MYDELIM   ';'



/*
 * This func. is way quicker and way simplier to use than
 * 'txt_strtok()'. The only drawback is the delimiter that
 * can only be represented as an integer.
*/
int GID_main(void)
{
  LONG addr = (LONG)MYTEXT;
  UBYTE *ptr;
  LONG old;


  while ((ptr = txt_tokenify((UBYTE *)addr, &addr, MYDELIM)))
  {
    QDEV_TXT_TOKENSET(old, addr);

    FPrintf(Output(), "%s\n", (LONG)ptr);

    QDEV_TXT_TOKENCLR(old, addr);
  }

  return 0;
}
