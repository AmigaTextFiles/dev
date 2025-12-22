/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * ctl_devmount()
 *
*/

#include "../gid.h"

#define MLFILE    "FakeMountlist"
#define MLENTRY   "(FAKE0:|FAKE2:)"
#define MLRANGE   0



/*
 * This is totally artifficial structure. It doesnt do anything.
 * Below you can see how to pass it and read in the callback.
*/
struct userstruct
{
  LONG  us_flags;
  void *us_ptr;
};


/*
 * Remeber though that the 'sc' is temporary! You must make a
 * copy of it with 'mem_copysmlcb()' if you want to keep curr.
 * params after callback is complete!
*/
LONG usercb(struct nfo_sml_cb *sc)
{
  struct userstruct *us = sc->sc_userdata;
  ULONG flags = *(ULONG *)sc->sc_file;            // 0x80000000
  LONG res = -1;


  /*
   * If you do not want to write your own mounter then you can use
   * 'dmt_mountcb()' which will take care of everything. After it
   * is done you can inspect things like: sc->sc_gerror member or
   * sc->sc_sd.sd_errors for '\n' separated, NULL terminated text.
   *
   * Commented for a good reason :-) .
  */
  //res = dmt_mountcb(sc);

  /*
   * This code is being used in the 'fsmount' as a debug output.
  */
  FPrintf(Output(), "%s:\n"
                    "%ld,%ld: Handler        = %s\n"
                    "%ld,%ld: EHandler       = %s\n"
                    "%ld,%ld: FileSystem     = %s\n"
                    "%ld,%ld: Device         = %s\n",
                                    (LONG)sc->sc_sd.sd_dosdevice,
                  !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_HANDLER),
                  !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_HANDLER),
                                      (LONG)sc->sc_sd.sd_handler,
                 !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_EHANDLER),
                 !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_EHANDLER),
                                      (LONG)sc->sc_sd.sd_handler,
               !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_FILESYSTEM),
               !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_FILESYSTEM),
                                      (LONG)sc->sc_sd.sd_handler,
                   !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_DEVICE),
                   !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_DEVICE),
                                      (LONG)sc->sc_sd.sd_device);

  if (*sc->sc_sd.sd_unit)
  {
    FPrintf(Output(), "%ld,%ld: Unit           = %s\n",
                     !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_UNIT),
                     !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_UNIT),
                                        (LONG)sc->sc_sd.sd_unit);
  }
  else
  {
    FPrintf(Output(), "%ld,%ld: Unit           = %ld\n",
                     !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_UNIT),
                     !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_UNIT),
                                 *(LONG *)&sc->sc_sd.sd_unit[1]);
  }

  if (*sc->sc_sd.sd_flags)
  {
    FPrintf(Output(), "%ld,%ld: Flags          = %s\n",
                    !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_FLAGS),
                    !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_FLAGS),
                                       (LONG)sc->sc_sd.sd_flags);
  }
  else
  {
    FPrintf(Output(), "%ld,%ld: Flags          = 0x%08lx\n",
                    !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_FLAGS),
                    !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_FLAGS),
                                *(LONG *)&sc->sc_sd.sd_flags[1]);
  }

  FPrintf(Output(), "%ld,%ld: BlockSize      = %ld\n"
                    "%ld,%ld: Surfaces       = %ld\n"
                    "%ld,%ld: BlocksPerTrack = %ld\n"
                    "%ld,%ld: SectorPerBlock = %ld\n"
                    "%ld,%ld: Reserved       = %ld\n"
                    "%ld,%ld: PreAlloc       = %ld\n"
                    "%ld,%ld: Interleave     = %ld\n"
                    "%ld,%ld: LowCyl         = %ld\n"
                    "%ld,%ld: HighCyl        = %ld\n"
                    "%ld,%ld: Buffers        = %ld\n"
                    "%ld,%ld: BufMemType     = %ld\n"
                    "%ld,%ld: MaxTransfer    = 0x%08lx\n"
                    "%ld,%ld: Mask           = 0x%08lx\n"
                    "%ld,%ld: BootPri        = %ld\n"
                    "%ld,%ld: DosType        = 0x%08lx\n"
                    "%ld,%ld: Baud           = %ld\n"
                    "%ld,%ld: Control        = %s\n"
                    "%ld,%ld: BootBlocks     = %ld\n"
                    "%ld,%ld: StackSize      = %ld\n"
                    "%ld,%ld: Priority       = %ld\n"
                    "%ld,%ld: GlobVec        = %ld\n",
                !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_BLOCKSIZE),
                !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_BLOCKSIZE),
                                     sc->sc_de.de_SizeBlock << 2,
                 !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_SURFACES),
                 !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_SURFACES),
                                           sc->sc_de.de_Surfaces,
           !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_BLOCKSPERTRACK),
           !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_BLOCKSPERTRACK),
                                     sc->sc_de.de_BlocksPerTrack,
           !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_SECTORPERBLOCK),
           !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_SECTORPERBLOCK),
                                     sc->sc_de.de_SectorPerBlock,
                 !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_RESERVED),
                 !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_RESERVED),
                                           sc->sc_de.de_Reserved,
                 !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_PREALLOC),
                 !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_PREALLOC),
                                           sc->sc_de.de_PreAlloc,
               !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_INTERLEAVE),
               !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_INTERLEAVE),
                                         sc->sc_de.de_Interleave,
                   !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_LOWCYL),
                   !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_LOWCYL),
                                             sc->sc_de.de_LowCyl,
                  !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_HIGHCYL),
                  !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_HIGHCYL),
                                            sc->sc_de.de_HighCyl,
                  !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_BUFFERS),
                  !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_BUFFERS),
                                         sc->sc_de.de_NumBuffers,
               !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_BUFMEMTYPE),
               !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_BUFMEMTYPE),
                                         sc->sc_de.de_BufMemType,
              !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_MAXTRANSFER),
              !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_MAXTRANSFER),
                                        sc->sc_de.de_MaxTransfer,
                     !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_MASK),
                     !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_MASK),
                                               sc->sc_de.de_Mask,
                  !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_BOOTPRI),
                  !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_BOOTPRI),
                                            sc->sc_de.de_BootPri,
                  !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_DOSTYPE),
                  !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_DOSTYPE),
                                            sc->sc_de.de_DosType,
                     !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_BAUD),
                     !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_BAUD),
                                               sc->sc_de.de_Baud,
                  !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_CONTROL),
                  !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_CONTROL),
                                         (*sc->sc_sd.sd_control ?
                         (LONG)sc->sc_sd.sd_control : (LONG)"0"),
               !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_BOOTBLOCKS),
               !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_BOOTBLOCKS),
                                         sc->sc_de.de_BootBlocks,
                !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_STACKSIZE),
                !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_STACKSIZE),
                                          sc->sc_sd.sd_stacksize,
                 !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_PRIORITY),
                 !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_PRIORITY),
                                           sc->sc_sd.sd_priority,
                  !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_GLOBVEC),
                  !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_GLOBVEC),
                                           sc->sc_sd.sd_globvec);

  if (*sc->sc_sd.sd_startup)
  {
    FPrintf(Output(), "%ld,%ld: Startup        = %s\n",
                  !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_STARTUP),
                  !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_STARTUP),
                                     (LONG)sc->sc_sd.sd_startup);
  }
  else
  {
    FPrintf(Output(), "%ld,%ld: Startup        = 0x%08lx\n",
                  !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_STARTUP),
                  !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_STARTUP),
                              *(LONG *)&sc->sc_sd.sd_startup[1]);
  }

  FPrintf(Output(), "%ld,%ld: Activate       = %ld\n"
                    "%ld,%ld: ForceLoad      = %ld\n"
                    "#\nH_TYPE: (0x%08lx)\nE_CODE: (0x%08lx)\n",
                 !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_ACTIVATE),
                 !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_ACTIVATE),
                                           sc->sc_sd.sd_activate,
                !!(sc->sc_eflags & QDEV_NFO_SCANML_PF_FORCELOAD),
                !!(sc->sc_pflags & QDEV_NFO_SCANML_PF_FORCELOAD),
                                          sc->sc_sd.sd_forceload,
                            sc->sc_sd.sd_hantype, sc->sc_gerror);

  return res;
}

int GID_main(void)
{
  struct userstruct us;
  LONG flags;
  LONG rc;


  /*
   * Lets prepare user structure.
  */
  us.us_flags = 0x00001000 | 0x00002000;

  us.us_ptr = "Meaningless text";

  /*
   * Argument 4 of 'ctl_devmount()' can be used to carry anything.
   * The 'dmt_mountcb()' uses it to get flags(QDEV_CTL_DMT_F#?).
  */
  flags = 0x80000000;

  /*
   * As you can see 'ctl_devmount()' is not a complete mounter.
   * You can still use your own code to actually mount the entries
   * as fished out from the mountlist.
  */
  rc = ctl_devmount(MLFILE, MLENTRY, MLRANGE, flags, &us, usercb);

  FPrintf(Output(), "rc = 0x%08lx\n", rc);

  return 0;
}
