/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_pjw64hash()
 *
*/

#include "../gid.h"

#define FILETOHASH   "example.c"



/*
 * This example shows that the 'mem_pjw64hash()' can
 * also be used on streams. The 'buf' can be of any
 * size. I just made it small to squeeze more loops.
*/
int GID_main(void)
{
  VUQUAD vuq = {0, 0};
  UBYTE buf[32];
  LONG read;
  LONG fd;


  if ((fd = Open(FILETOHASH, MODE_OLDFILE)))
  {
    while ((read = Read(fd, buf, sizeof(buf))) > 0)
    {
      mem_pjw64hash(&vuq, buf, read);
    }

    Close(fd);

    FPrintf(Output(), "vuq = 0x%08lx%08lx\n",
                           vuq.vuq_hi, vuq.vuq_lo);
  }

  return 0;
}
