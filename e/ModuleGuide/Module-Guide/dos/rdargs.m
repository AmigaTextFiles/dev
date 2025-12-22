@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/rdargs.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT rdargs
@{fg shine}(   0)@{fg text}   source:csource @{fg shine}(or ARRAY OF csource)@{fg text}
@{fg shine}(  12)@{fg text}   dalist:LONG
@{fg shine}(  16)@{fg text}   buffer:PTR TO CHAR
@{fg shine}(  20)@{fg text}   bufsiz:LONG
@{fg shine}(  24)@{fg text}   exthelp:PTR TO CHAR
@{fg shine}(  28)@{fg text}   flags:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=32 */

@{fg shine}(----)@{fg text} OBJECT csource
@{fg shine}(   0)@{fg text}   buffer:PTR TO CHAR
@{fg shine}(   4)@{fg text}   length:LONG
@{fg shine}(   8)@{fg text}   curchr:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST RDAF_STDIN=1,
      RDAB_STDIN=0,
      RDAF_NOPROMPT=4,
      RDAB_NOPROMPT=2,
      RDAF_NOALLOC=2,
      RDAB_NOALLOC=1,
      MAX_TEMPLATE_ITEMS=$64,
      MAX_MULTIARGS=$80
@endnode
