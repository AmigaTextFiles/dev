/****************************************************************************

* $Source: MASTER:include/ext/version.i,v $
* $Revision: 1.0 $
* $Date: 1994/01/07 15:12:38 $

* Public include declaring structures and definitions used to embed version
* information in modules.

****************************************************************************/

   STRUCTURE VersionInfo,0
      UWORD vi_version              ;major
      UWORD vi_revision             ;minor
      APTR  vi_name                 ;module name
      APTR  vi_idstring             ;format: name version.revision (date)
      APTR  vi_tagstring            ;format: $VER: idstring
      LABEL VI_SIZE
