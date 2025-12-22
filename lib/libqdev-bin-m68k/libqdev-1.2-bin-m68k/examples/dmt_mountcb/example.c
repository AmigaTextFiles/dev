/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * dmt_mountcb()
 *
*/

#include "../gid.h"

/*
 * This private header defines DOS device buffer size and the name
 * length.
*/
#include "p-nfo_scanml.h"



int GID_main(void)
{
  /*
   * Warning! This structure is something like 232 bytes, so think
   * twice before using stack! The next variables steal another 512
   * bytes!
  */
  struct nfo_sml_cb sc;
  UBYTE dosdevbuf[QDEV_NFO_PRV_NAMELEN];
  UBYTE doshanbuf[QDEV_NFO_PRV_NAMELEN];
  ULONG flags;
  LONG res;


  /*
   * Zero the structure. Really a must do. Do not forget about it!
  */
  txt_memfill(&sc, 0, sizeof(struct nfo_sml_cb));

  /*
   * Right on! Lets now try to mount RAD entirely from within this
   * code. Notice the very first assignment. This has to be memory
   * region and cannot be a constant!
  */
  sc.sc_sd.sd_dosdevice = dosdevbuf;

  *sc.sc_sd.sd_dosdevice = '\0';

  txt_strncatuc(
            sc.sc_sd.sd_dosdevice, "RAD15", QDEV_NFO_PRV_MDEVLEN);

  /*
   * Same applies to the handler member, but in this case we dont
   * need a handler.
  */
  sc.sc_sd.sd_handler = doshanbuf;

  *sc.sc_sd.sd_handler = '\0';

  sc.sc_sd.sd_hantype = QDEV_NFO_SCANML_HANFS;

  /*
   * Device name can be constant though. Things change a little bit
   * in case of unit as it is considered mixed type. The first NULL
   * will indicate that the rest of the structure member is LONG.
   * We will mount 'RAD15' on unit 15.
  */
  sc.sc_sd.sd_device = "ramdrive.device";

  sc.sc_sd.sd_unit = "\x00\x00\x00\x00\x0F";

  sc.sc_sd.sd_flags = "\x00\x00\x00\x00\x00";

  /*
   * Other fields that carry text must also be initialised in some
   * way.
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

  sc.sc_sd.sd_forceload = 1;

  /*
   * And of course quick, literal error detection. We are perfect
   * about mountblock ;-) .
  */
  sc.sc_sd.sd_errors = "";

  /*
   * Almost there. All we need is to tell the OS about the physical
   * properties of the new device. No worries we do not need to put
   * all this boring stuff by hand. There is a handy macro.
  */
  QDEV_NFO_SCANML_PREPDE(&sc.sc_de);

  /*
   * For the sake of example lets reduce the amount of cylinders so
   * memory can be conserved and lets decrease the init priority so
   * after rebooting this device wont be booted from.
  */
  sc.sc_de.de_HighCyl = 3;

  sc.sc_de.de_BootPri = -128;

  /*
   * OK. Last preparation step is to pass control flags that the CB
   * uses. We have no special requirements except that we do want
   * filesystems to be dispatched.
  */
  flags = QDEV_CTL_DMT_FDISPFS;

  sc.sc_file = (UBYTE *)&flags;
  
  /*
   * Now we can mount the damn thing. Can it be even simplier? I do
   * not think so. I do agree however that the template is somewhat
   * fuzzy. Sorry about that.
  */
  res = dmt_mountcb(&sc);

  /*
   * When res == -1 && sc_gerror == 0 then all went just fine. Be
   * aware though that RAD15 may emit 2 Enforcer hits upon startup
   * when ramdrive.device is 39.35 ...
  */
  FPrintf(Output(),
            "res = %ld, sc_gerror = 0x%08lx\n", res, sc.sc_gerror);

  return 0;
}
  