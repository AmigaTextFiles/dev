/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * nfo_grepml.h
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
 * $VER: a-nfo_grepml.h 1.05 (26/12/2010)
 * AUTH: megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * This is the header file only!
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___GREPML_H_INCLUDED___
#define ___GREPML_H_INCLUDED___

#define QDEV_NFO_PRV_DEVBLOCK   512



struct nfo_grep_data
{
  struct dev_ddv_data   *gd_dd;
                              /* Device handle                              */
  LONG                   gd_range;
                              /* Range value in gigs                        */
  LONG                   gd_rangerev;
                              /* Reversed/workable range value in gigs      */
  LONG                   gd_mlendof;
                              /* End of partition in gigs                   */
  struct RigidDiskBlock *gd_rdb;
                              /* Rigid Disk Block                           */
  struct DriveGeometry  *gd_dg;
                              /* Drive geometry                             */
  struct DosEnvec        gd_de;
                              /* Default var table                          */
  LONG                   gd_rc;
                              /* Return code                                */
  void                  *gd_olduserdata;
                              /* Old userdata pointer                       */
  void                  *gd_userdata;
                              /* Real userdata                              */
  LONG                 (*gd_usercode)(struct nfo_sml_cb *);
                              /* Real usercode                              */
};

#endif /* ___GREPML_H_INCLUDED___ */
