@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "devices/bootblock.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT bb
@{fg shine}(   0)@{fg text}   id[4]:ARRAY OF CHAR
@{fg shine}(   4)@{fg text}   chksum:LONG
@{fg shine}(   8)@{fg text}   dosblock:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

CONST BOOTSECTS=2,
      BBNAME_DOS=$444F5300,
      BBNAME_KICK=$4B49434B
@endnode
