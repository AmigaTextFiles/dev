/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * ctl_clipath.h
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
 * $VER: a-ctl_clipath.h 1.01 (12/06/2010)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___CLIPATH_H_INCLUDED___
#define ___CLIPATH_H_INCLUDED___

#define QDEV_CTL_PRV_PATHENTRY(pe)            \
  ((struct ctl_cph_data *)QDEV_HLP_BADDR(pe))



struct ctl_cph_data
{
  BPTR cd_next;        /* Next path entry                                   */
  BPTR cd_lock;        /* Lock of this path                                 */
};

#endif /* ___CLIPATH_H_INCLUDED___ */
