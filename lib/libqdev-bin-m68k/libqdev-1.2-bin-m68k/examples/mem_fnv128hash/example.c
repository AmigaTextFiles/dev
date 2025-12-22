/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_fnv128hash()
 *
*/

#include "../gid.h"

#define FILETOHASH   "example.c"



/*
 * This example shows that the 'mem_fnv128hash()' can also
 * be used on streams. The 'buf' can be of any size.
*/
int GID_main(void)
{
  VUQ128 vuq = {0, 0, 0, 0};
  UBYTE buf[32];
  LONG read;
  LONG fd;


  if ((fd = Open(FILETOHASH, MODE_OLDFILE)))
  {
    while ((read = Read(fd, buf, sizeof(buf))) > 0)
    {
      mem_fnv128hash(&vuq, buf, read);
    }

    Close(fd);

    FPrintf(Output(), "vuq = 0x%08lx%08lx%08lx%08lx\n",
       vuq.vuhi_hi, vuq.vuhi_lo, vuq.vulo_hi, vuq.vulo_lo);
  }

  return 0;
}
