/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * ctl_devunmount.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * Following  contents covered by the  BSIPM  license not to be used in
 * commercial products nor redistributed separately nor modified by the
 * 3-rd parties other than mentioned in the license and under the terms
 * prior to recipient status.
 *
 * A  copy  of  the  BSIPM  document  and/or  source  code  along  with
 * commented modifications and/or separate changelog should be included
 * in this archive.
 *
 * NO WARRANTY OF ANY KIND APPLIES. ALL THE RISK AS TO THE QUALITY  AND
 * PERFORMANCE  OF  THIS  SOFTWARE  IS  WITH  YOU. SEE THE 'BLACK SALLY
 * IMITABLE PACKAGE MARK' DOCUMENT FOR MORE DETAILS.
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: a-ctl_devunmount.h 1.03 (29/03/2012)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___DEVUNMOUNT_H_INCLUDED___
#define ___DEVUNMOUNT_H_INCLUDED___

#define QDEV_CTL_PRV_RNAMELEN    32
#define QDEV_CTL_PRV_DNAMELEN   255
#define QDEV_CTL_PRV_INSIGNAL   SIGBREAKF_CTRL_C
#define QDEV_CTL_PRV_RESNAME    "devunmount.resource"



struct ctl_unm_res
{
  struct Library     ur_lib;             /* Resource structure              */
  struct Interrupt   ur_is;              /* Interrupt skeleton              */
  void             (*ur_devhan)(
                      REGARG(struct MsgPort *, a1));
                                         /* Device handler func.            */
  ULONG            (*ur_inject)(REGARG(ULONG, d0),
                                REGARG(void *, a1));
                                         /* Exit injector func.             */
  UBYTE              ur_name[QDEV_CTL_PRV_RNAMELEN];
                                         /* Name of this res.               */
};

#endif /* ___DEVUNMOUNT_H_INCLUDED___ */
