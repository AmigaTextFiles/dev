/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * ctl_xxxconlogo.h
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
 * $VER: a-ctl_xxxconlogo.h 1.11 (13/02/2013)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXCONLOGO_H_INCLUDED___
#define ___XXXCONLOGO_H_INCLUDED___

#define QDEV_CTL_PRV_REPOSBUF     16
#define QDEV_CTL_PRV_EXTRAPIX      2
#define QDEV_CTL_PRV_SUBSTACK   4096
#define QDEV_CTL_PRV_SUBPRI      127
#define QDEV_CTL_PRV_SUBMAX        3
#define QDEV_CTL_PRV_COOPPRI       0
#define QDEV_CTL_PRV_SYNCSIG    SIGBREAKF_CTRL_F



struct ctl_acl_data
{
  struct ctl_csn_cwin    *ad_cc;        /* Console window details           */
  struct SignalSemaphore  ad_dsem;      /* Drawing semaphore                */
  WORD                    ad_spad;      /* Semaphore struct padder          */
  struct BitMap          *ad_bm;        /* Bitmap containing logo           */
  struct GfxBase         *ad_gb;        /* GfxBase pointer                  */
  struct Task            *ad_task;      /* Task to notify                   */
  void                  (*ad_forbid)(); /* Forbid() function pointer        */
  void                  (*ad_permit)(); /* Permit() function pointer        */
  volatile LONG           ad_cnt;       /* Redrawing subtask count          */
  struct ctl_csn_ient     ad_ev;        /* IDCMP even handler carry         */
  LONG                    ad_rectx;     /* Maximum pixels per X line        */
  LONG                    ad_recty;     /* Maximum pixels per Y line        */
  LONG                    ad_logox;     /* Maximum pixels for X axis        */
  LONG                    ad_logoy;     /* Maximum pixels for Y axis        */
  LONG                    ad_startx;    /* Start drawing at X coord         */
  LONG                    ad_starty;    /* Start drawing at Y coord         */
  LONG                    ad_bmapx;     /* Bitmap size in X axis            */
  LONG                    ad_bmapy;     /* Bitmap size in Y axis            */
};

#endif /* ___XXXCONLOGO_H_INCLUDED___ */
