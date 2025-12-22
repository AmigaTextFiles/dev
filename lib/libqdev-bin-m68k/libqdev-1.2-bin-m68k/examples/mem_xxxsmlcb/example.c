/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_copysmlcb()
 * mem_freesmlcb()
 *
*/

#include "../gid.h"



/*
 * If you require to make your own device node the this func.
 * will really easify this.
*/
int GID_main(void)
{
  struct nfo_sml_cb sc;
  struct nfo_sml_cb *nsc;
  BSTR text;


  /*
   * Zero the structure. Really a must do. Do not forget about it!
  */
  txt_memfill(&sc, 0, sizeof(struct nfo_sml_cb));

  /*
   * Unlike 'dmt_mountcb()' preparation, we can use constants all
   * the way down.
  */
  sc.sc_sd.sd_dosdevice = "MYDEV0";

  sc.sc_sd.sd_handler = "myfilesystem";

  sc.sc_sd.sd_hantype = QDEV_NFO_SCANML_HANFS;

  sc.sc_sd.sd_device = "mydrive.device";

  /*
   * First BYTE shall be NULL then the LONG is to be expected. It
   * is of course possible to stuff these two with normal text.
  */
  sc.sc_sd.sd_unit = "\x00\x00\x00\x00\x00";

  sc.sc_sd.sd_flags = "\x00\x00\x00\x00\x00";

  /*
   * Other fields that carry NULL terminated text must also be
   * initialised in some way.
  */
  sc.sc_sd.sd_control = "";

  sc.sc_sd.sd_startup = "";

  /*
   * Now it is time to provide some really essential values that
   * no program can function without.
  */
  sc.sc_sd.sd_stacksize = 4096;

  sc.sc_sd.sd_priority = 0;

  sc.sc_sd.sd_globvec = -1;

  sc.sc_sd.sd_activate = 1;

  /*
   * And of course quick, literal error detection. This will not
   * be copied!
  */
  sc.sc_sd.sd_errors = NULL;

  /*
   * Prepare the default DosEnvec to save on typing all this dull
   * stuff.
  */
  QDEV_NFO_SCANML_PREPDE(&sc.sc_de);

  /*
   * Can now make a copy.
  */
  if ((nsc = mem_copysmlcb(&sc)))
  {
    /*
     * We just did a copy, so what? What is so special about it?
     * I tell you what. All members are LONG aligned now, plus all
     * pointer members can become BPTR's who can be passed to the
     * 'FreeMem()' without Guru, but they are all in one big block
     * of memory!
     *
     * Members:
     *   sd_dosdevice, sd_handler, sd_device, sd_unit, sd_flags,
     *   sd_control, sd_startup
     *
     * can be: bstr = QDEV_HLP_MKBADDR(&<member>[-1]);
     *
     * Members:
     *   sc_dol, sc_fssm, sc_de
     *
     * can be: bptr = QDEV_HLP_MKBADDR(<member>); where 'sc_dol'
     * will be master allocation!
    */
    text = QDEV_HLP_MKBADDR(&nsc->sc_sd.sd_device[-1]);

    FPrintf(Output(), "device = %b\n", text);

    mem_freesmlcb(nsc);
  }

  return 0;
}
