/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_fixquotes()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG *array[4];
  LONG **arptr;
  LONG flags;
  UBYTE buf[3][80] = {{NULL}, {NULL}, {NULL}};


  txt_strncat(&buf[0][0],
                "My Amiga loves \\\"0's\\\" and \\\"1's\\\" ^_^",
                                                 sizeof(buf[0]));

  txt_strncat(&buf[1][0],
          "Whenever I feed her with data she *\"feels*\" happy!",
                                                 sizeof(buf[1]));

  txt_strncat(&buf[2][0],
             "She also likes to "
              "'\"d'\"'\"e'\"'\"a'\"'\"l'\" with my demo texts!",
                                                 sizeof(buf[2]));


  array[0] = (LONG *)&buf[0][0];

  array[1] = (LONG *)&buf[1][0];

  array[2] = (LONG *)&buf[2][0];

  array[3] = NULL;


  FPrintf(Output(), "BEFORE\n");

  arptr = array;

  while (*arptr)
  {
    FPrintf(Output(), "%s\n", (LONG)*arptr++);
  }


  /*
   * Unescape quotes in standard notation and keep them where
   * they are.
  */
  flags = QDEV_TXT_FQF_BACKSLASH;

  /*
   * Do that also to Amiga style prefixed quotes.
  */
  flags |= QDEV_TXT_FQF_ASTERISK;

  /*
   * But completly remove quotes prefixed with single quotes.
  */
  flags |= QDEV_TXT_FQF_SINGQUOTE | QDEV_TXT_FQF_REMOVE3;


  txt_fixquotes(array, 3, flags);

  FPrintf(Output(), "\nAFTER\n");

  arptr = array;

  while (*arptr)
  {
    FPrintf(Output(), "%s\n", (LONG)*arptr++);
  }

  return 0;
}
