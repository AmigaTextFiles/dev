/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * nfo_fsquery.h
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
 * $VER: a-nfo_fsquery.h 1.03 (26/12/2010)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___FSQUERY_H_INCLUDED___
#define ___FSQUERY_H_INCLUDED___

#define QDEV_NFO_PRV_FSQMINBUF 1024
#define QDEV_NFO_PRV_FSQUSRBUF 4
#define QDEV_NFO_PRV_FSQTOTAL                 \
       (QDEV_NFO_PRV_FSQMINBUF +              \
        QDEV_NFO_PRV_FSQUSRBUF)



struct nfo_fsq_data
{
  struct ExAllControl *fd_eac;        /* ExAllControl stuff                 */
  struct ExAllData    *fd_ead;        /* ExAllData indicators               */
  struct nfo_fsq_cb    fd_fc;         /* Filesystem query callback          */
  BOOL                 fd_check;      /* Boolean to indicate new entries    */
  BPTR                 fd_lock;       /* Object lock                        */
  UBYTE                fd_buf[QDEV_NFO_PRV_FSQTOTAL];
                                      /* 'ExAll()' and user space           */
  /* 
   * No new members allowed at this point, because 'ExAll()' and user
   * space may be larger than that minimum!!!
  */
};

#endif /* ___FSQUERY_H_INCLUDED___ */
