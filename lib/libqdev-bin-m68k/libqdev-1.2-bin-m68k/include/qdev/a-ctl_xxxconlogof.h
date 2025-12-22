/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * ctl_xxxconlogof.h
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
 * $VER: a-ctl_xxxconlogof.h 1.15 (29/07/2014)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXCONLOGOF_H_INCLUDED___
#define ___XXXCONLOGOF_H_INCLUDED___

#define QDEV_CTL_PRV_MINFRAMERATE   25000
#define QDEV_CTL_PRV_MAXFRAMERATE   250000000

#define QDEV_CTL_PRV_MANPRIORITY    0x40000000
#define QDEV_CTL_PRV_LOWPRIORITY    0x80000000



struct ctl_acf_data
{
  struct ctl_csn_cwin     *ad_cc;         /* Screen shell window            */
  struct SignalSemaphore   ad_sem;        /* Subtask synchronisation        */
  WORD                     ad_spad;       /* Semaphore padding              */
  struct Task             *ad_task;       /* Animation subtask pointer      */
  struct BitMap          **ad_bm;         /* Logo frames                    */
  struct BitMap          **ad_lbm;        /* Last time position             */
  struct MsgPort          *ad_tmp;        /* Timer message port             */
  struct timerequest      *ad_treq;       /* Timer request space            */
  ULONG                    ad_fdly;       /* Frame delay in micros          */
  ULONG                    ad_cdly;       /* Cycle delay in micros          */
  UWORD                    ad_xpos;       /* Logo position in X axis        */
  UWORD                    ad_ypos;       /* Logo position in Y axis        */
  void                    *ad_logo;       /* Logo handle                    */
  LONG                     ad_pri;        /* Animation subtask priority     */
  void                   (*ad_start)(struct ctl_acf_data *);
                                          /* Start animating func.          */
  void                   (*ad_stop)(struct ctl_acf_data *);
                                          /* Stop animating func.           */
  struct ctl_csn_ient      ad_eva;        /* IDCMP carry for active         */
  struct ctl_csn_ient      ad_evi;        /* IDCMP carry for inactive       */
};

#endif /* ___XXXCONLOGOF_H_INCLUDED___ */
