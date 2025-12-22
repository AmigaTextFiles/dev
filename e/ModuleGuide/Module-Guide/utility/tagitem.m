@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "utility/tagitem.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT tagitem
@{fg shine}(   0)@{fg text}   tag:LONG
@{fg shine}(   4)@{fg text}   data:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=8 */

CONST TAG_DONE=0,
      TAG_SKIP=3,
      TAG_IGNORE=1,
      TAG_END=0,
      TAG_USER=$80000000,
      TAGFILTER_AND=0,
      MAP_KEEP_NOT_FOUND=1,
      MAP_REMOVE_NOT_FOUND=0,
      TAG_MORE=2,
      TAGFILTER_NOT=1
@endnode
