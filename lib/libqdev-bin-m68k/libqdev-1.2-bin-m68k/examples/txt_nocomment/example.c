/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_nocomment()
 *
*/

#include "../gid.h"

#define TEXTLINE1 "\r\r\rLots of CRs was there\r\r\r"
#define TEXTLINE2 "\n\n\nLots of LFs was there\n\n\n"
#define TEXTLINE3 "\t\"Quoted no more\" #Comment"
#define TEXTLINE4 "/* IN */Braced no more/* OUT */"
#define TEXTLINE5 "\n\r\t\"\'Still free;from comment"
#define TEXTLINE6 "/* Does not even exist! */"



/*
 * Function 'txt_nocomment()' allows not only to remove
 * comments but also to strip basic control and quotation
 * characters.
*/
int GID_main(void)
{
  UBYTE *text[] =
  {
    TEXTLINE1,
    TEXTLINE2,
    TEXTLINE3,
    TEXTLINE4,
    TEXTLINE5,
    TEXTLINE6,
    NULL
  };
  UBYTE **array = text;
  UBYTE *ptr;
  LONG old;


  while (*array)
  {
    if ((ptr = txt_nocomment(*array, QDEV_TXT_NC_F_REW)))
    {
      /*
       * Make a copy of this character and NULL terminate
       * the string at this point.
      */
      old = *ptr;

      *ptr = '\0';

      FPrintf(Output(), "%s\n",
         (LONG)txt_nocomment(*array, QDEV_TXT_NC_F_FWD));

      /*
       * Restore the old charcter.
      */
      *ptr = old;
    }

    array++;
  }

  return 0;
}
