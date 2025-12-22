/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_parseline()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  UBYTE text[] = "arg1 \"arg2 opt1 opt2\" \"\\\"arg3 opt1\\\"\"";
  UBYTE *ptr;
  LONG count;
  LONG **array;
  LONG **aptr;
      

  /*
   * First lets see how many arguments is in this string.
  */
  if ((count = txt_parseline(text, NULL)))
  {
    /*
     * Lets allocate space for the string and the array + 1 so
     * it is easier to deal with it. Note that with sizeof(text)
     * extra byte for the NULL is included!
    */
    if ((array = AllocVec(sizeof(text) +
                     ((count + 1) * sizeof(LONG)), MEMF_PUBLIC)))
    {
      /*
       * NULL the array, 'count' here is actually the last elem.
      */
      array[count] = NULL;

      /*
       * Attach storage for string. In this example it is right
       * after the array. Then copy the string.
      */
      ptr = (UBYTE *)&array[count + 1];

      CopyMem(text, ptr, sizeof(text));

      /*
       * And now just parse the string which will result in args
       * being assigned to respective table entries.
      */
      txt_parseline(ptr, array);

      /*
       * Lets see if it worked ;-). There should be 3 arguments.
      */
      aptr = array;

      count = 0;

      while (*aptr)
      {
        FPrintf(
          Output(), "array[%ld] = %s\n", count++, (LONG)*aptr++);
      }

      FreeVec(array);
    }
  }

  return 0;
}
