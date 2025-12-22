/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_grepml()
 *
*/

#include "../gid.h"

#define GML_LINEBUFFER   1024
#define GML_FILENAME     "MyMountList"
#define GML_TERMSIGNAL   SIGBREAKF_CTRL_C
#define GML_DEVICES      "#?"              // All mountblocks!
#define GML_DEVRANGE     4
#define GML_DEVTOMATCH   "weirddisk.device"



struct userstruct
{
  UBYTE *us_devname;
};



LONG usercb(struct nfo_sml_cb *sc)
{
  struct userstruct *us = sc->sc_userdata;


  /*
   * Here is the deal. As along as the mountblock is a filing
   * system and stays within first 4 gigabytes and the device
   * is GML_DEVTOMATCH we are interested. All other handlers
   * are out of bounds.
  */
  if (!(sc->sc_gerror))
  {
    if (sc->sc_sd.sd_hantype == QDEV_NFO_SCANML_HANFS)
    {
      if (
       txt_stricmp(us->us_devname, sc->sc_sd.sd_device) == 0)
      {
        FPrintf(Output(), "%s -> %s: %s\n",
                                           (LONG)sc->sc_file,
                                (LONG)sc->sc_sd.sd_dosdevice,
        (LONG)(!(sc->sc_pflags & QDEV_NFO_SCANML_PF_LOWCYL) ?
                                         "(warning!)" : ""));
      }
    }
  }

  /*
   * All OK, continue.
  */
  return -1;
}

/*
 * Function 'nfo_grepml()' is considered building block, it is
 * being used by the 'ctl_devmount()'. Of course it is possible
 * to use 'dmt_mountcb()' here, but no tooltypes nor unnamed
 * mountblock are supported directly!
*/
int GID_main(void)
{
  struct userstruct us;
  LONG fd;
  LONG res;


  /*
   * Assign a constant to our only member of userstruct, so we
   * can use it in the CB.
  */
  us.us_devname = GML_DEVTOMATCH;

  /*
   * Now open the file that will be processed, the mountlist.
  */
  if ((fd = Open(GML_FILENAME, MODE_OLDFILE)))
  {
    /*
     * Notice that the GML_FILENAME repeats. This is due to the
     * fact that this function can also accept virtual files,
     * so effectively 2nd arg. can be used to carry something
     * else.
    */
    res = nfo_grepml(GML_LINEBUFFER, GML_FILENAME, fd,
                     GML_TERMSIGNAL, GML_DEVICES, GML_DEVRANGE, 
                                                  &us, usercb);

    if (res == -2)
    {
      FPrintf(
           Output(), "Fatal error, cannot allocate memory!\n");
    }

    /*
     * One should reset the signal to be on the safe side.
    */
    SetSignal(0L, GML_TERMSIGNAL);

    Close(fd);
  }

  return 0;
}
