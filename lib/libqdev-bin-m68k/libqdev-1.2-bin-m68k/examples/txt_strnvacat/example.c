/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strnvacat()
 *
*/

#include "../gid.h"

#define MIGGYTYPE 1200
#define COMMOTYPE   64



/*
 * Variable argument string concatenation is something
 * that may really help in case you need to construct
 * complex text configurations. Func. 'txt_strnvacat()'
 * combines the power of 'txt_vpsnprintf()' and the
 * comfort of usage of 'txt_strnpcat()'.
*/
int GID_main(void)
{
  UBYTE buf[256];
  LONG addr;
  LONG size;


  addr = (LONG)buf;

  size = sizeof(buf);

  txt_strnvacat(&addr, &size,
  "My favourive home computer system is Amiga %ld!\n",
                                           MIGGYTYPE);

  txt_strnvacat(&addr, &size,
   "Aside from that i also like the Commodore %ld.\n",
                                           COMMOTYPE);

  txt_strnvacat(&addr, &size,
           "Late 80's and early 90's that was it!\n");

  FPuts(Output(), buf);

  return 0;
}
