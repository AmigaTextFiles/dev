@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/datetime.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT datetime
@{fg shine}(   0)@{fg text}   stamp:datestamp @{fg shine}(or ARRAY OF datestamp)@{fg text}
@{fg shine}(  12)@{fg text}   format:CHAR
@{fg shine}(  13)@{fg text}   flags:CHAR
@{fg shine}(  14)@{fg text}   strday:PTR TO CHAR
@{fg shine}(  18)@{fg text}   strdate:PTR TO CHAR
@{fg shine}(  22)@{fg text}   strtime:PTR TO CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=26 */

CONST FORMAT_INT=1,
      FORMAT_DOS=0,
      FORMAT_USA=2,
      DTF_FUTURE=2,
      DTB_FUTURE=1,
      FORMAT_CDN=3,
      LEN_DATSTRING=16,
      DTF_SUBST=1,
      DTB_SUBST=0,
      FORMAT_MAX=3
@endnode
