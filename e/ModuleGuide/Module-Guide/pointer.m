@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "pointer.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY pointerbase         /* informal notation */
  SetBusyPointer(A0)        /* -30 (1E) */
  LoadPointer(A0)           /* -36 (24) */
  FreePointer(A0)           /* -42 (2A) */
ENDLIBRARY
@endnode
