/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mod_addmodule()
 * mod_delmodule()
 *
*/

#include "../gid.h"

/*
 * This is the machine code of the 'beep.asm' disassembly.
 *
 * TIP: If you would like to call this code directly here
 * you need to insert __attribute__ ((section (".text")))
 * in front of the symbol declaration and then attach it
 * to fp like: static void (*beepfp)(void) = (void *)beep;
*/
static WORD beep[] =
{
  0x48e7, 0x00e0,
  0x2c78, 0x0004,
  0x7007,
  0x43fa, 0x00a8,
  0x41fa, 0x006c,
  0x2348, 0x0012,
  0x41fa, 0x0098,
  0x2348, 0x000e,
  0x4eae, 0xff5e,
  0x2440,
  0x41f9, 0x00df, 0xf000,
  0x43fa, 0x007c,
  0x2149, 0x00a0,
  0x317c, 0x0004, 0x00a4,
  0x317c, 0x0040, 0x00a8,
  0x317c, 0x01bf, 0x00a6,
  0x317c, 0x8201, 0x0096,
  0x317c, 0x0080, 0x009c,
  0x317c, 0x8080, 0x009a,
  0x203c, 0x0000, 0x1000,
  0x4eae, 0xfec2,
  0x41f9, 0x00df, 0xf000,
  0x317c, 0x0001, 0x0096,
  0x7007,
  0x224a,
  0x4eae, 0xff5e,
  0x4cdf, 0x0700,
  0x7000,
  0x4e75,
  0x5391,
  0x4a91,
  0x6622,
  0x41f9, 0x00df, 0xf000,
  0x317c, 0x0080, 0x009a,
  0x2c78, 0x0004,
  0x93c9,
  0x4eae, 0xfeda,
  0x2240,
  0x203c, 0x0000, 0x1000,
  0x4eae, 0xfebc,
  0x7000,
  0x4e75,
  0x005a, 0x7f5a,
  0x00a6, 0x81a6, 0x0001,
  0x86a0,
  0x0000, 0x0000,
  0x0000, 0x0000,
  0x0200, 0x0000,
  0x0000, 0x0000,
  0x0000, 0x0000,
  0x0000, 0x0000
};

int GID_main(void)
{
  struct mod_ade_feed af;
  void *mod;


  /*
   * Creating resident module is as easy as can be. All the
   * mess is taken away from the programmer. You just need
   * to fill in the feed structure and you are done. First
   * thing to do is to pick the right memory. As the 'beep'
   * requires data to be put in chip memory we will pick it
   * this time.
  */
  af.af_memflags = MEMF_CHIP;

  /*
   * The range is really useful when the memory type is to
   * be MEMF_LOCAL, so that there is a chance of using fast
   * memory for the module.
  */
  af.af_memstart = QDEV_MOD_ADE_24BITLOWER;

  af.af_memend = QDEV_MOD_ADE_32BITUPPER;

  /*
   * The module will often initialize something thus this
   * flag. In our case we just want to beep.
  */
  af.af_rtflags = RTF_COLDSTART;

  /*
   * As to type, priority and version of the module it is up
   * to you: what, when and why ;-) . Read on priorities in
   * RKM!
  */
  af.af_type = NT_UNKNOWN;

  af.af_pri = 0;

  af.af_ver = 1;

  /*
   * And now the members weve been waiting for. As you see
   * it is amazingly easy, just attach the pointer and pass
   * the size of the code/data.
  */
  af.af_datalen = sizeof(beep);

  af.af_dataptr = (UBYTE *)&beep;

  /*
   * Do not forget to provide some ID marks though, so it
   * is easy to find and deal with the module.
  */
  af.af_nameptr = "BeepModule";

  af.af_idstrptr = "BeepModule 1.0 (8/8/2012)";

  /*
   * Finally, install the damn thing. At this point if you
   * will reboot the machine you should hear the beep upon
   * startup.
  */
  if ((mod = mod_addmodule(&af)))
  {
    /*
     * Cancellation is possible though by pressiing CTRL+C
     * keys.
    */
    Wait(SIGBREAKF_CTRL_C);

    mod_delmodule(mod);
  }

  return 0;
}
