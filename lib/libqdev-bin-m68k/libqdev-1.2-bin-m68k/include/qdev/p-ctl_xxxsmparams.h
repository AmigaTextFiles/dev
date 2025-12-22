/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * ctl_xxxsmparams.h
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
 * $VER: p-ctl_xxxsmparams.h 1.01 (31/03/2011)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___XXXSMPARAMS_H_INCLUDED___
#define ___XXXSMPARAMS_H_INCLUDED___

#define QDEV_NFO_PRV_PREFSLEN  62
#define QDEV_NFO_PRV_DEFDEPTH   3



/*
 * Default 'screenmode.prefs' file. First four NULL values are
 * modeid and the other two are depth.
*/
static UBYTE qdev_ctl_prv_smprefs[QDEV_NFO_PRV_PREFSLEN] = 
{ 
     0x46,       0x4F,       0x52,       0x4D,       0x00,
     0x00,       0x00,       0x36,       0x50,       0x52,
     0x45,       0x46,       0x50,       0x52,       0x48,
     0x44,       0x00,       0x00,       0x00,       0x06,
     0x00,       0x00,       0x00,       0x00,       0x00,
     0x00,       0x53,       0x43,       0x52,       0x4D,
     0x00,       0x00,       0x00,       0x1C,       0x00,
     0x00,       0x00,       0x00,       0x00,       0x00,
     0x00,       0x00,       0x00,       0x00,       0x00,
     0x00,       0x00,       0x00,       0x00,       0x00,
     NULL,       NULL,       NULL,       NULL,       0xFF,
     0xFF,       0xFF,       0xFF,       NULL,       NULL,
     0x00,       0x01                                
};

#endif /* ___XXXSMPARAMS_H_INCLUDED___ */
