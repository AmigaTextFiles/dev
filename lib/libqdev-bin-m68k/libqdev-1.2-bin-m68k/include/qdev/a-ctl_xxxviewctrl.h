/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * ctl_xxxviewctrl.h
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
 * $VER: a-ctl_xxxviewctrl.h 1.7 (11/02/2013)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXVIEWCTRL_H_INCLUDED___
#define ___XXXVIEWCTRL_H_INCLUDED___

#define QDEV_CTL_PRV_ZOOMCON     1
#define QDEV_CTL_PRV_REARRANGE   2
#define QDEV_CTL_PRV_RESTORE     4
#define QDEV_CTL_PRV_IDCMPEVA    IDCMP_MOUSEMOVE
#define QDEV_CTL_PRV_IDCMPEVB    IDCMP_VANILLAKEY
#define QDEV_CTL_PRV_EXTRAPIXX   4
#define QDEV_CTL_PRV_EXTRAPIXY   2
#define QDEV_CTL_PRV_SPOTSIZE    16



struct ctl_avc_data
{
  struct ctl_csn_data  *ad_cd;       /* Pointer to screen shell             */
  struct ctl_csn_cwin  *ad_cc;       /* Forward pointer only!               */
  struct GfxBase       *ad_gb;       /* GfxBase pointer                     */
  struct IntuitionBase *ad_ib;       /* IntuitionBase pointer               */
  struct Library       *ad_lb;       /* LayersBase pointer                  */
  struct Layer         *ad_layer;    /* OSD layer                           */
  struct Task          *ad_task;     /* Task to notify                      */
  volatile LONG         ad_cnt;      /* Subtask count                       */
  struct ctl_csn_ient   ad_evia;     /* IDCMP handler A                     */
  struct ctl_csn_ient   ad_evib;     /* IDCMP handler B                     */
  LONG                  ad_flga;     /* Operation(s) to perform             */
  LONG                  ad_flgb;     /* Operation(s) to perform             */
  LONG                  ad_rflg;     /* Rearrange flags                     */
  LONG                  ad_efct;     /* Effective zoom factor               */
  LONG                  ad_mfct;     /* Memorised zoom factor               */
  WORD                  ad_xosd;     /* Right-bottom OSD X size             */
  WORD                  ad_yosd;     /* Right-bottom OSD Y size             */
  ULONG                 ad_xcosd;    /* Right-bottom OSD X chars            */
  ULONG                 ad_ycosd;    /* Right-bottom OSD Y chars            */
};

#endif /* ___XXXVIEWCTRL_H_INCLUDED___ */
