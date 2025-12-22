/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strpat()
 * txt_stripat()
 *
*/

#include "../gid.h"

#define MYDUMMYTEXT "18 years ago Commodore went bust, it was 1994!"
#define MYPATTERN   "#?ago#?went#?19??!"



/*
 * Case sensitive 'txt_strpat()' and case insensitive
 * 'txt_stripat()' are pattern matching functions who
 * wrap OS primitives.
*/
int GID_main(void)
{
  UBYTE *text1 = MYDUMMYTEXT;
  UBYTE *text2 = MYPATTERN;


  /*
   * In Amiga world people do generally know how to 
   * use patterns. The most used are wildcards #? or
   * *. We will try to match several words.
  */
  if (txt_stripat(text1, text2))
  {
    FPrintf(Output(), 
                 "Hey Mr! I'm not friggin blind!\n");
  }
  else
  {
    FPrintf(Output(),
                 "Excause me, but i dont see it!\n");
  }

  return 0;
}
