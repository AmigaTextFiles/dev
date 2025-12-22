@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "libraries/nonvolatile.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT nventry
@{fg shine}(   0)@{fg text}   node:mln @{fg shine}(or ARRAY OF mln)@{fg text}
@{fg shine}(   8)@{fg text}   name:PTR TO CHAR
@{fg shine}(  12)@{fg text}   size:LONG
@{fg shine}(  16)@{fg text}   protection:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=20 */

@{fg shine}(----)@{fg text} OBJECT nvinfo
@{fg shine}(   0)@{fg text}   maxstorage:LONG
@{fg shine}(   4)@{fg text}   freestorage:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST NVERR_FAIL=3,
      NVERR_FATAL=4,
      NVERR_WRITEPROT=2,
      NVEF_DELETE=1,
      NVEB_DELETE=0,
      NVERR_BADNAME=1,
      NVEF_APPNAME=$80000000,
      NVEB_APPNAME=31

#define SizeNVData/1
@endnode
