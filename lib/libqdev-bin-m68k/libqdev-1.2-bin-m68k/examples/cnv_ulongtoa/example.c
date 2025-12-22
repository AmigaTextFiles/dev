/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * cnv_ulongtoa()
 * cnv_uquadtoa()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  UBYTE buf[QDEV_CNV_UXXXLEN];
  UBYTE *ptr;
  ULONG num;
  VUQUAD vuq;


  num = 1200;

  ptr = cnv_ULONGtoA(buf, num, QDEV_CNV_UXXXFBE_B |
          QDEV_CNV_UXXXFDSGN | QDEV_CNV_UXXXFALGN);

  FPrintf(Output(), "%s\n", (LONG)ptr);

  ptr = cnv_ULONGtoA(buf, num, QDEV_CNV_UXXXFBE_O |
          QDEV_CNV_UXXXFDSGN | QDEV_CNV_UXXXFALGN);

  FPrintf(Output(), "%s\n", (LONG)ptr);

  ptr = cnv_ULONGtoA(buf, num, QDEV_CNV_UXXXFBE_D |
          QDEV_CNV_UXXXFDSGN | QDEV_CNV_UXXXFALGN);

  FPrintf(Output(), "%s\n", (LONG)ptr);

  ptr = cnv_ULONGtoA(buf, num, QDEV_CNV_UXXXFBE_H |
          QDEV_CNV_UXXXFDSGN | QDEV_CNV_UXXXFALGN);

  FPrintf(Output(), "%s\n", (LONG)ptr);

  vuq.vuq_hi = 0xF00D0000;

  vuq.vuq_lo = 0x00000BAD;

  ptr = cnv_UQUADtoA(
          buf, *(UQUAD *)&vuq, QDEV_CNV_UXXXFBE_H |
          QDEV_CNV_UXXXFOSGN | QDEV_CNV_UXXXFALGN);

  FPrintf(Output(), "%s\n", (LONG)ptr);

  ptr = cnv_QUADtoA(
          buf, *(UQUAD *)&vuq, QDEV_CNV_UXXXFBE_H |
          QDEV_CNV_UXXXFOSGN | QDEV_CNV_UXXXFALGN);

  FPrintf(Output(), "%s\n", (LONG)ptr);

  return 0;
}
