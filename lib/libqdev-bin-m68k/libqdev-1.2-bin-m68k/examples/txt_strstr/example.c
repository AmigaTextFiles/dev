/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strstr()
 * txt_stristr()
 *
*/

#include "../gid.h"

#define FULLTEXT "net fish the Fijian rand with the" \
                 " immovably miniature Iowa crab"
#define PARTTEXT "miniature"


/*
 * The 'txt_strstr()' function returns pointer past the
 * finding!
*/
int GID_main(void)
{
  UBYTE *fulltext = FULLTEXT;
  UBYTE *parttext = PARTTEXT;
  UBYTE *ptr;


  if ((ptr = txt_strstr(fulltext, parttext)))
  {
    FPrintf(Output(), "PAST: %s\n", (LONG)ptr);

    FPrintf(Output(),
     "WORD: %s\n", (LONG)ptr - (sizeof(PARTTEXT) - 1));
  }

  return 0;
}
