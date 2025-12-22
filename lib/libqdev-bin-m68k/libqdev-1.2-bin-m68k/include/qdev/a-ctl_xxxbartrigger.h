/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * ctl_xxxbartrigger.h
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
 * $VER: a-ctl_xxxbartrigger.h 1.04 (18/08/2014)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXBARTRIGGER_H_INCLUDED___
#define ___XXXBARTRIGGER_H_INCLUDED___

#define QDEV_CTL_PRV_SUBSTACK   4096
#define QDEV_CTL_PRV_SUBPRI      127
#define QDEV_CTL_PRV_COOPPRI       0
#define QDEV_CTL_PRV_SUBMAX        3
#define QDEV_CTL_PRV_SYNCSIG    SIGBREAKF_CTRL_F



struct ctl_trg_data
{
  struct ctl_csn_cwin      td_cc;         /* Trigger window (1x1)           */
  struct ctl_csn_ient      td_ci;         /* Trigger handler node           */
  struct SignalSemaphore   td_trigsem;    /* Trigger semaphore              */
  WORD                     td_spad;       /* Semaphore padding              */
  struct Window          **td_trigfwin;   /* Focus-back win(addr).          */
  struct Task             *td_trigtask;   /* Trigger task address           */
  volatile LONG            td_trigcnt;    /* Trigger subtask count          */
  LONG                     td_trigbar;    /* State of the title bar         */
  UBYTE                    td_trigcol[2]; /* Color of the window            */
};

#endif /* ___XXXBARTRIGGER_H_INCLUDED___ */
