/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_datdat()
 * txt_datidat()
 *
*/

#include "../gid.h"

#define MYPATTERN "Larry Knucklefuck"
#define MYDATASET "Media said that Larry Knucklefuck was innocent."



int GID_main(void)
{
  UBYTE *data1 = MYDATASET;
  UBYTE *data2 = MYPATTERN;


  if (txt_datdat(
               data1, txt_strlen(data1), data2, txt_strlen(data2)))
  {
    FPrintf(Output(), "Pattern was found!\n");
  }

  return 0;
}
