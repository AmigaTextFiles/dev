@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "exec/lists.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT mlh
@{fg shine}(   0)@{fg text}   head:PTR TO mln
@{fg shine}(   4)@{fg text}   tail:PTR TO mln
@{fg shine}(   8)@{fg text}   tailpred:PTR TO mln
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=12 */

@{fg shine}(----)@{fg text} OBJECT lh
@{fg shine}(   0)@{fg text}   head:PTR TO ln
@{fg shine}(   4)@{fg text}   tail:PTR TO ln
@{fg shine}(   8)@{fg text}   tailpred:PTR TO ln
@{fg shine}(  12)@{fg text}   type:CHAR
@{fg shine}(  13)@{fg text}   pad:CHAR
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=14 */

#define IsMsgPortEmpty/1
#define IsListEmpty/1
@endnode
