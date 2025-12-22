/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * cnv_atoulong()
 * cnv_atouquad()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG res;
  ULONG num = 0;
  VUQUAD vuq = {0, 0};


  if ((res = cnv_AtoULONG("-1", &num, 0)))
  {
    FPrintf(Output(), "res = %ld, %ld\n", res, num);
  }

  if ((res = cnv_AtoLONG("-1", &num, 0)))
  {
    FPrintf(Output(), "res = %ld, %ld\n", res, num);
  }

  if ((res = cnv_AtoUQUAD(
           "0xFFFFEEEEFFFFEEEE", (UQUAD *)&vuq, 0)))
  {
    FPrintf(Output(), "res = %ld, 0x%08lx%08lx\n",
                       res, vuq.vuq_hi, vuq.vuq_lo);
  }

  if ((res = cnv_AtoQUAD(
            "-0o37777777777777", (UQUAD *)&vuq, 0)))
  {
    FPrintf(Output(), "res = %ld, 0x%08lx%08lx\n",
                       res, vuq.vuq_hi, vuq.vuq_lo);
  }

  return 0;
}
