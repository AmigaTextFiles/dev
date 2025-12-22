/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_stripansi()
 *
*/

#include "../gid.h"

#define ANSISTUFF "\x1b[32;46mroost \x1b[1mthe \x1b[22mdosed" \
                  " \x1b[35mmaleficence with \x9b" "33mthe"   \
                  " professorially \x1b[35;3mcreaseless"      \
                  " breach\x9b" "0m"



int GID_main(void)
{
  UBYTE *text = ANSISTUFF;
  UBYTE out[sizeof ANSISTUFF];


  txt_stripansi(out, text);

  FPrintf(Output(), "B: %s\nA: %s\n", (LONG)text, (LONG)out);

  return 0;
}
