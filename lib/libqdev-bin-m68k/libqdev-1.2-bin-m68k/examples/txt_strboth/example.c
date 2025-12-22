/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strboth()
 * txt_striboth()
 *
*/

#include "../gid.h"

#define MYDUMMYTEXT "Once upon a time(apparently) there was a text."



void testfunction(UBYTE *name,
   LONG (*func)(const UBYTE *str1, const UBYTE *str2))
{
  UBYTE *text1 = MYDUMMYTEXT;
  UBYTE *text2 = MYDUMMYTEXT;


  if (func(text1, text2))
  {
    FPrintf(Output(), "%s: "
     "Both strings are the same, duh!\n", (LONG)name);
  }
  else
  {
    FPrintf(Output(), "%s: "
     "Hum, how come they are not, eh?\n", (LONG)name);
  }
}

void testfunction2(UBYTE *name,
   LONG (*func)(const UBYTE *str1, const UBYTE *str2))
{
  UBYTE *text1 = MYDUMMYTEXT;
  UBYTE *text2 = "#?apparently#?";


  if (func(text1, text2))
  {
    FPrintf(Output(), "%s: "
    "I found the pattern, gimme five!\n", (LONG)name);
  }
  else
  {
    FPrintf(Output(), "%s: "
    "I did not find the damn pattern.\n", (LONG)name);
  }
}

/*
 * Case sensitive 'txt_strboth()' and case insensitive
 * 'txt_striboth()' are combo functions! They do allow
 * text compare and pattern matching at the same time.
*/
int GID_main(void)
{
  /*
   * Look what happens when you try to compare using
   * just pattern matching.
  */
  testfunction("txt_stripat()", txt_stripat);

  testfunction2("txt_stripat()", txt_stripat);

  /*
   * Now let's repeat the test using 'txt_striboth()'.
  */
  testfunction("txt_striboth()", txt_striboth);

  testfunction2("txt_striboth()", txt_striboth);

  return 0;
}
