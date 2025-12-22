/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_scanml()
 *
*/

#include "../gid.h"

#define SML_LINEBUFFER   1024
#define SML_FILENAME     "MyMountList"
#define SML_TERMSIGNAL   SIGBREAKF_CTRL_C
#define SML_DEVICES      "#?"              // All mountblocks!



LONG usercb(struct nfo_sml_cb *sc)
{
  UBYTE *hantype;


  switch (sc->sc_sd.sd_hantype)
  {
    case QDEV_NFO_SCANML_HANFS:
    {
      hantype = "FileSystem";

      break;
    }

    case QDEV_NFO_SCANML_HANHAN:
    {
      hantype = "Handler   ";

      break;
    }

    case QDEV_NFO_SCANML_HANEHAN:
    {
      hantype = "EHandler  ";

      break;
    }

    default:
    {
      hantype = "???       ";
    }
  }

  FPrintf(Output(), "%s: (%s)\n%s",
                                   (LONG)sc->sc_sd.sd_dosdevice,
                                                  (LONG)hantype,
                                     (LONG)sc->sc_sd.sd_errors);

  /*
   * All OK, continue.
  */
  return -1;
}

/*
 * Function 'nfo_scanml()' is the low level mountlist scanner.
*/
int GID_main(void)
{
  struct DosEnvec de;
  LONG fd;
  LONG res;


  /*
   * Now open the file that will be processed, the mountlist.
  */
  if ((fd = Open(SML_FILENAME, MODE_OLDFILE)))
  {
    /*
     * Unlike 'nfo_grepml()' this function takes default env.
     * instead of range. The env. can be NULL though.
    */
    QDEV_NFO_SCANML_PREPDE(&de);

    res = nfo_scanml(SML_LINEBUFFER, SML_FILENAME, fd,
               SML_TERMSIGNAL, SML_DEVICES, &de, NULL, usercb);

    if (res == -2)
    {
      FPrintf(
           Output(), "Fatal error, cannot allocate memory!\n");
    }

    /*
     * One should reset the signal to be on the safe side.
    */
    SetSignal(0L, SML_TERMSIGNAL);

    Close(fd);
  }

  return 0;
}
