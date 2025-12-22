/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_findinfile()
 *
*/

#include "../gid.h"

#define SOURCEFILE  "lyrics.txt"
#define WORDTOFIND  "monster"



int GID_main(void)
{
  LONG fd;
  LONG res;


  if ((fd = Open(SOURCEFILE, MODE_OLDFILE)))
  {
    if ((res = mem_findinfile(
                          -1, fd, WORDTOFIND, -1, -1)) > -1)
    {
      FPrintf(Output(), "Word '%s' was found %ld times\n",
                                     (LONG)WORDTOFIND, res);

      Seek(fd, 0, OFFSET_BEGINNING);

      res = mem_findinfile(-1, fd, WORDTOFIND, -1, 1);

      FPrintf(Output(), "First '%s' is at byte = %ld\n",
                                     (LONG)WORDTOFIND, res);
    }

    Close(fd);
  }

  return 0;
}
