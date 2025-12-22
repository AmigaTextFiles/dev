@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/gfxnodes.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT xln
@{fg shine}(   0)@{fg text}   succ:PTR TO ln
@{fg shine}(   4)@{fg text}   pred:PTR TO ln
@{fg shine}(   8)@{fg text}   type:CHAR
@{fg shine}(   9)@{fg text}   pri:CHAR
@{fg shine}(  10)@{fg text}   name:PTR TO CHAR
@{fg shine}(  14)@{fg text}   subsystem:CHAR
@{fg shine}(  15)@{fg text}   subtype:CHAR
@{fg shine}(  16)@{fg text}   library:LONG
@{fg shine}(  20)@{fg text}   init:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

CONST MONITOR_SPEC_TYPE=4,
      SPECIAL_MONITOR_TYPE=3,
      VIEWPORT_EXTRA_TYPE=2,
      VIEW_EXTRA_TYPE=1,
      SS_GRAPHICS=2
@endnode
