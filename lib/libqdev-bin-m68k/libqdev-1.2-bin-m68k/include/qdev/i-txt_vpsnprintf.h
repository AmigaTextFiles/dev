/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * txt_vpsnprintf.h
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
 * $VER: i-txt_vpsnprintf.h 1.05 (08/01/2011)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___VPSNPRINTF_H_INCLUDED___
#define ___VPSNPRINTF_H_INCLUDED___

#define QDEV_STR_PRV_NULLTEXT   "<NULL>"
#define QDEV_STR_PRV_FSPACEPAD  0x00000020   /* Pseudo flag!                */
#define QDEV_STR_PRV_FZEROPAD   0x00000030   /* Pseudo flag!                */
#define QDEV_STR_PRV_FSHOWNULL  0x00000100
#define QDEV_STR_PRV_FINTQUAD   0x00000200
#define QDEV_STR_PRV_FCASENAT   0x00000400
#define QDEV_STR_PRV_FCASEUC    0x00000800
#define QDEV_STR_PRV_FBITVALUE  0x00001000

#endif /* ___VPSNPRINTF_H_INCLUDED___ */
