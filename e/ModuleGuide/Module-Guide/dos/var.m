@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "dos/var.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

@{fg shine}(----)@{fg text} OBJECT localvar
@{fg shine}(   0)@{fg text}   node:ln @{fg shine}(or ARRAY OF ln)@{fg text}
@{fg shine}(  14)@{fg text}   flags:INT
@{fg shine}(  16)@{fg text}   value:PTR TO CHAR
@{fg shine}(  20)@{fg text}   len:LONG
@{fg shine}(----)@{fg text} ENDOBJECT     /* SIZEOF=24 */

CONST LVF_IGNORE=$80,
      LVB_IGNORE=7,
      LV_ALIAS=1,
      GVF_SAVE_VAR=$1000,
      GVB_SAVE_VAR=12,
      GVF_BINARY_VAR=$400,
      GVB_BINARY_VAR=10,
      LV_VAR=0,
      GVF_LOCAL_ONLY=$200,
      GVB_LOCAL_ONLY=9,
      GVF_GLOBAL_ONLY=$100,
      GVB_GLOBAL_ONLY=8,
      GVF_DONT_NULL_TERM=$800,
      GVB_DONT_NULL_TERM=11
@endnode
