/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * dev_getdiskcmdset.h
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
 * $VER: a-dev_getdiskcmdset.h 1.00 (26/12/2010)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___GETDISKCMDSET_H_INCLUDED___
#define ___GETDISKCMDSET_H_INCLUDED___

#define QDEV_DEV_PRV_TDREAD64  (CMD_NONSTD + 15)
#define QDEV_DEV_PRV_NSDREAD64 0xC000
#define QDEV_DEV_PRV_NSDQUERY  0x4000



struct dev_nsd_data
{
  ULONG nd_devqueryformat;    /* Device query format                        */
  ULONG nd_sizeavailable;     /* Size available                             */
  UWORD nd_devicetype;        /* Type of the device                         */
  UWORD nd_devicesubtype;     /* Subtype of the device                      */
  UWORD *nd_suppcommands;     /* Supported NSD commands                     */
};

#endif /* ___GETDISKCMDSET_H_INCLUDED___ */
