/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dev_sizeingigs()
 *
*/

#include "../gid.h"

/*
 * Pseudo ATA parameters.
*/
#define CYLINDER        40000
#define BLOCKSIZE         512
#define BLOCKSPERTRACK    255
#define HEADS              16



int GID_main(void)
{
  LONG gig;


  /*
   * Please note that order of parameters must be exact
   * or else computation may be wrong. This is due to
   * 32 bit ops! Yes, by default this function does not
   * use QUAD!
  */
  gig = dev_sizeingigs(
           CYLINDER, BLOCKSIZE, BLOCKSPERTRACK, HEADS);

  FPrintf(Output(), "gig = %ld\n", gig);

  return 0;
}
