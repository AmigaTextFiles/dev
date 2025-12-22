@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "graphics/regions.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT regionrectangle
@{fg shine}(   0)@{fg text}   next:PTR TO regionrectangle
@{fg shine}(   4)@{fg text}   prev:PTR TO regionrectangle
@{fg shine}(   8)@{fg text}   bounds:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=16 */

@{fg shine}(----)@{fg text} OBJECT region
@{fg shine}(   0)@{fg text}   bounds:rectangle @{fg shine}(or ARRAY OF rectangle)@{fg text}
@{fg shine}(   8)@{fg text}   regionrectangle:PTR TO regionrectangle
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */
@endnode
