/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * mod_xxxmodule.h
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
 * $VER: a-mod_xxxmodule.h 1.04 (26/12/2010)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXMODULE_H_INCLUDED___
#define ___XXXMODULE_H_INCLUDED___

#define QDEV_MOD_PRV_ADENAMELEN  128
#define QDEV_MOD_PRV_ADEIDSTRLEN 128
#define QDEV_MOD_PRV_ADEUSRBUF     4



struct mod_ade_data
{
  struct mod_ktl_head ad_kh;    /* Header of the module                     */
  UBYTE               ad_name[QDEV_MOD_PRV_ADENAMELEN];
                                /* Name space of the module                 */
  UBYTE               ad_idstr[QDEV_MOD_PRV_ADEIDSTRLEN];
                                /* Id string space of the module            */
  UBYTE               ad_data[QDEV_MOD_PRV_ADEUSRBUF];
                                /* User data, min 4 bytes!                  */
  /* 
   * No new members allowed at this point, because user space may be
   * larger than 4 bytes!!!
  */
};

#endif /* ___XXXMODULE_H_INCLUDED___ */
