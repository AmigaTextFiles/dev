/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * han_binaryifh()
 *
*/

#include "../gid.h"

#define BUFFERSIZE   1024
#define BUFFERTEXT   "Well, well, well! Looks like a job for " \
                     "a virtual file subsystem, eh?\n"



/*
 * Suppose that the code below is closed source and the only
 * way to feed it with data is through the FileHandle. What
 * would you do to avoid real file creation? Just to remind
 * you, one such thing is InternalLoadSeg() ;-) .
*/
void nastyfunction(LONG fd)
{
  UBYTE buf[128];


  FGets(fd, buf, sizeof(buf));

  FPuts(Output(), buf);
}

int GID_main(void)
{
  UBYTE *ptr;
  LONG size;
  LONG fd;


  /*
   * First of, lets allocate the memory that will be used with
   * the virtual file.
  */
  if ((ptr = AllocVec(BUFFERSIZE, MEMF_PUBLIC)))
  {
    /*
     * Lets put something into that buffer, so we can have
     * a clue how all that mumbo-jumbo works...
    */
    *ptr = '\0';

    size = txt_strncat(ptr, BUFFERTEXT, BUFFERSIZE);

    size = QDEV_HLP_ABS(size);

    /*
     * Then, lets access the virtual file using binary handler,
     * which implements 'Read()' and 'Seek()' only.
    */
    if ((fd = mem_openifh(ptr, size, han_binaryifh)))
    {
      /*
       * Execute nasty code that does not allow any other way
       * to pass the data.
      */
      nastyfunction(fd);

      mem_closeifh(fd);
    }

    FreeVec(ptr);
  }

  return 0;
}
