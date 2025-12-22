@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "nofrag.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY nofragbase          /* informal notation */
  GetMemoryChain(D0)        /* -30 (1E) */
  AllocItem(A0,D0,D1)       /* -36 (24) */
  FreeItem(A0,A1,D0)        /* -42 (2A) */
  FreeMemoryChain(A0,D0)    /* -48 (30) */
  AllocVecItem(A0,D0,D1)    /* -54 (36) */
  FreeVecItem(A0,A1)        /* -60 (3C) */
ENDLIBRARY
@endnode
