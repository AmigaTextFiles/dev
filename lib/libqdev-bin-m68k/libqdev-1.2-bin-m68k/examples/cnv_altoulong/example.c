/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * cnv_altoulong()
 * cnv_altouquad()
 *
*/

#include "../gid.h"



/*
 * This function was made to deal with digit grouped numbers,
 * so that it is easy to convert them back to datatypes with
 * no need to preprocess the string first.
*/
int GID_main(void)
{
  ULONG num = 0;
  VUQUAD vuq = {0, 0};


  if (cnv_ALtoULONG("1,200,000", &num, 0))
  {
    FPrintf(Output(), "%ld\n", num);
  }

  if (cnv_ALtoULONG("1'200'000", &num, 0))
  {
    FPrintf(Output(), "%ld\n", num);
  }

  if (cnv_ALtoULONG("1.200.000", &num, 0))
  {
    FPrintf(Output(), "%ld\n", num);
  }

  if (cnv_ALtoULONG("1 200 000", &num, 0))
  {
    FPrintf(Output(), "%ld\n", num);
  }

  if (cnv_ALtoULONG(
       "0  x  0 0 1 2  4 F 8 0", &num, 0))
  {
    FPrintf(Output(), "%ld\n", num);
  }

  if (cnv_ALtoUQUAD(
                  "0x0001 1765 92E0 0027",
                        (UQUAD *)&vuq, 0))
  {
    FPrintf(Output(), "0x%08lx%08lx\n",
                  vuq.vuq_hi, vuq.vuq_lo);
  }

  return 0;
}
