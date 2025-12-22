/****************************************************************************

$Source: MASTER:include/ext/version.h,v $
$Revision: 1.0 $
$Date: 1994/01/07 15:11:59 $

Public include declaring structures and definitions used to embed version
information in modules.

****************************************************************************/

struct VersionInfo
   {
   UWORD  version;            /* major */
   UWORD  revision;           /* minor */
   char  *name;               /* module name */
   char  *idstring;           /* format: name version.revision (date) */
   char  *tagstring;          /* format: $VER: idstring */
   };
