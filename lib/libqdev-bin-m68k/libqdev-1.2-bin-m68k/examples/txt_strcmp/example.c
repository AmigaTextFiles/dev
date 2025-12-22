/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_strcmp()
 * txt_stricmp()
 *
*/

#include "../gid.h"

#define TEXTFILE   "textfile.txt"
#define TEXTLINE   "spring the uncontroversial playmate with"  \
                   " the abjectly curtainless Palmer"



int GID_main(void)
{
  LONG fd;
  LONG line = 1;
  UBYTE *ptr;
  UBYTE buf[128];


  if ((fd = Open(TEXTFILE, MODE_OLDFILE)))
  {
    while (FGets(fd, buf, sizeof(buf)))
    {
      if ((ptr = txt_strchr(buf, '\n')))
      {
        *ptr = '\0';
      }

      if (txt_strcmp(buf, TEXTLINE) == 0)
      {
        FPrintf(Output(),
                 "Found this damn thing at line %ld !\n", line);
      }

      line++;
    }

    Close(fd);
  }

  return 0;
}
