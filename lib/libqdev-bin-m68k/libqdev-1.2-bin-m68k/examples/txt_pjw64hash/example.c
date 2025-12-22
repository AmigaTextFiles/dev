/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_pjw64hash()
 * txt_pjw64ihash()
 *
*/

#include "../gid.h"

#define TEXT   "The quick brown fox jumps over the lazy dog"



/*
 * PJW64 barely borrows on real PJW technique, but as it
 * resembles the original i decided to honour the author
 * for its idea in general. Observe the output, you can
 * clearly see that this routine does not opearate on 64
 * bit integer, but merges two LONGs. Despite the method
 * still quite usable and without primes and bloaty math!
*/
int GID_main(void)
{
  VUQUAD vuq;
  UBYTE buf[128];


  txt_pjw64hash(&vuq, TEXT);

  txt_psnprintf(
          buf, sizeof(buf), "C: 0x%016qx", *(UQUAD *)&vuq);

  FPrintf(Output(), "%s\n", (LONG)buf);

  txt_pjw64ihash(&vuq, TEXT);

  txt_psnprintf(
          buf, sizeof(buf), "I: 0x%016qx", *(UQUAD *)&vuq);

  FPrintf(Output(), "%s\n", (LONG)buf);

  return 0;
}
