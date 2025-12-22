/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strlen()
 *
*/

#include "../gid.h"

#define FUNNYTEXT   "bottlefeed the unbitter Gila monster with poop!"



int GID_main(void)
{
  UBYTE *text = FUNNYTEXT;


  FPrintf(Output(),
        "TEXT: %s\nSIZE: %ld\n", (LONG)text, (LONG)txt_strlen(text));

  return 0;
}
