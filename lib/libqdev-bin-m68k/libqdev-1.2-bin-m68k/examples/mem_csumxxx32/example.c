/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_csumchs32()
 * mem_csumeor32()
 * mem_csumint32()
 *
*/

#include "../gid.h"

#define EORBASE 0xAABBCCDD
#define MYDATA  "Checksumming text is not really what you want to do!"



int GID_main(void)
{
  UBYTE *text = MYDATA;
  ULONG sum;


  sum = mem_csumchs32(text, sizeof(MYDATA));

  FPrintf(Output(), "sum = 0x%08lx\n", sum);


  sum = mem_csumeor32(text, sizeof(MYDATA), EORBASE);

  FPrintf(Output(), "sum = 0x%08lx\n", sum);


  sum = mem_csumint32(text, sizeof(MYDATA));

  FPrintf(Output(), "sum = 0x%08lx\n", sum);


  return 0;
}
