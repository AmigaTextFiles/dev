/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_m68kcputype()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  LONG cpu;
  UBYTE *text;


  cpu = nfo_m68kcputype();

  switch (cpu)
  {
    case AFF_68060:
    {
      text = "68060";

      break;
    }

    case AFF_68040:
    {
      text = "68040";

      break;
    }

    case AFF_68030:
    {
      text = "68030";

      break;
    }

    case AFF_68020:
    {
      text = "68020";

      break;
    }

    case AFF_68010:
    {
      text = "68010";

      break;
    }

    default:
    {
      text = "68000";
    }
  }

  FPrintf(Output(),
     "cpu = 0x%08lx, text = %s\n", cpu, (LONG)text);

  return 0;
}
