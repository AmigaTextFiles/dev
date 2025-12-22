/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_fnv64hash()
 * txt_fnv64ihash()
 *
*/

#include "../gid.h"

#define TEXT   "The quick brown fox jumps over the lazy dog"



int GID_main(void)
{
  VUQUAD vuq;
  UBYTE buf[128];


  txt_fnv64hash(&vuq, TEXT);

  txt_psnprintf(
          buf, sizeof(buf), "C: 0x%016qx", *(UQUAD *)&vuq);

  FPrintf(Output(), "%s\n", (LONG)buf);

  txt_fnv64ihash(&vuq, TEXT);

  txt_psnprintf(
          buf, sizeof(buf), "I: 0x%016qx", *(UQUAD *)&vuq);

  FPrintf(Output(), "%s\n", (LONG)buf);

  return 0;
}
