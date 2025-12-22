/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * txt_iniparse()
 *
*/

#include "../gid.h"

#define FILETOOPEN  "mydata.ini"
#define DELIMITER   '='



int GID_main(void)
{
  QDEV_TXT_INIPARSETYPE(ini);
  UBYTE buf[256];
  LONG fd;


  if ((fd = Open(FILETOOPEN, MODE_OLDFILE)))
  {
    FPrintf(Output(), "KEY\t\t\tDATA\n\n");

    while (FGets(fd, buf, sizeof(buf)))
    {
      if (QDEV_TXT_INIPARSEINIT(buf, DELIMITER, ini))
      {
        FPrintf(Output(), "%s\t\t%s\n",
              (LONG)ini.ini_key, (LONG)ini.ini_data);

        QDEV_TXT_INIPARSETERM(ini);
      }
    }

    Close(fd);
  }

  return 0;
}
