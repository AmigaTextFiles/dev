/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_scanfile()
 *
*/

#include "../gid.h"

#define DATAFILE     "data.txt"
#define BUFFERSIZE   8192
#define TERMSIG      SIGBREAKF_CTRL_C



LONG scancb(struct mem_sfe_cb *sc)
{
  LONG freshhalve = QDEV_HLP_MIN(sc->sc_datalen, sc->sc_halflen);
  LONG *cnt = (LONG *)sc->sc_userdata;


  /*
   * Each time this callback is being executed new portion of
   * data is ready in the second halve of the buffer. Previous
   * halve is copied to the top of the 'sc_block'. Of course
   * at first entrace 'sc_block' may be filled in total, but
   * generally it all looks like this:
   *
   *               :
   * +-----+- - -+ : +-----+-----+ +-----+-----+ +-----+-----+
   * |     |     | : |     |     | |     |.....| |     |     |
   * |  0  |  1    : |  0  |  1  | |  0  |. 1 .| |  0  |  1  |
   * |     |     | : |     |     | |     |.....| |     |     |
   * |  A  |  B    : |  B  |  B  | |  B  |. A .| |  A  |  A  |
   * +-----+- - -+ : +-----+-----+ +-----+-----+ +-----+-----+
   *               :
   *  total fill       <- copy       1 to fill     <- copy ...
   *
   *
   * Follow the checksums to see where is what, 0's or 1's at
   * this very moment.
  */
  FPrintf(Output(), " %3ld. sc_block(%ld) == 0x%08lx,"
                           " (sc_block + %ld)(%ld) == 0x%08lx\n",
                                                        ++(*cnt),
                                                  sc->sc_halflen,
                 mem_csumchs32((void *)sc->sc_block, freshhalve),
                                                  sc->sc_halflen,
                                                      freshhalve,
     mem_csumchs32((void *)((LONG)sc->sc_block + sc->sc_halflen),
                                                    freshhalve));
  /*
   * All OK. Continue.
  */
  return -1;
}

/*
 * For the sake of better visibility the data file was prepared
 * in such a way that there are three CB calls. Each 4096 chunk
 * of data is filled with logical 0's or 1's. The idea behind
 * this function is to allow memory related ops in low memory
 * environment such that there is no need to load whole dataset
 * to process it. This can be done on the fly by swapping data
 * blocks to create the illusion of infinity.
*/
int GID_main(void)
{
  LONG fd;
  LONG cnt = 0;


  if ((fd = Open(DATAFILE, MODE_OLDFILE)))
  {
    if (mem_scanfile(BUFFERSIZE, fd, TERMSIG, &cnt, scancb) > -2)
    {
      FPrintf(Output(), "All OK.\n");
    }

    Close(fd);
  }
  
  return 0;
}
