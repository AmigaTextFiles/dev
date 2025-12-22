/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_fnv128hash()
 * txt_fnv128ihash()
 *
*/

#include "../gid.h"

#define TEXT   "The quick brown fox jumps over the lazy dog"



int GID_main(void)
{
  VUQ128 vuq128;
  UBYTE buf[128];


  txt_fnv128hash(&vuq128, TEXT);

  txt_psnprintf(buf, sizeof(buf), "C: 0x%016qx%016qx",
     *(UQUAD *)&vuq128.vuhi_hi, *(UQUAD *)&vuq128.vulo_hi);

  FPrintf(Output(), "%s\n", (LONG)buf);

  txt_fnv128ihash(&vuq128, TEXT);

  txt_psnprintf(buf, sizeof(buf), "I: 0x%016qx%016qx",
     *(UQUAD *)&vuq128.vuhi_hi, *(UQUAD *)&vuq128.vulo_hi);

  FPrintf(Output(), "%s\n", (LONG)buf);

  return 0;
}
