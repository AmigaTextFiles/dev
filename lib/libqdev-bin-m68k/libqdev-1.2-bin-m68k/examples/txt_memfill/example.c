/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_memfill()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  ULONG mem[32];
  LONG cnt;


  /*
   * Remember though that the second argument is seen as
   * an 8bit value, so the result will be '0x0D'!
  */
  txt_memfill(mem, 0x0BADF00D, sizeof(mem));

  FPrintf(Output(), "txt_memfill():\n");

  for (cnt = 0; cnt < (sizeof(mem) >> 2) >> 2; cnt++)
  {
    FPrintf(Output(),
            "0x%08lx: 0x%08lx 0x%08lx 0x%08lx 0x%08lx\n",
              (LONG)((LONG *)mem + (cnt << 2)), mem[cnt],
               mem[cnt + 1], mem[cnt + 2], mem[cnt + 3]);
  }

  /*
   * If you need to fill per word width then use macro:
   * QDEV_HLP_QUICKFILL() .
  */
  QDEV_HLP_QUICKFILL(mem, LONG, 0x0BADF00D, sizeof(mem));

  FPrintf(Output(), "\nQDEV_HLP_QUICKFILL():\n");

  for (cnt = 0; cnt < (sizeof(mem) >> 2) >> 2; cnt++)
  {
    FPrintf(Output(),
            "0x%08lx: 0x%08lx 0x%08lx 0x%08lx 0x%08lx\n",
              (LONG)((LONG *)mem + (cnt << 2)), mem[cnt],
               mem[cnt + 1], mem[cnt + 2], mem[cnt + 3]);
  }

  return 0;
}
