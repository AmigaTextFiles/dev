@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "vmm.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY vmmbase         /* informal notation */
  AllocVMem(D0,D1)      /* -30 (1E) */
  FreeVMem(A1,D0)       /* -36 (24) */
  AvailVMem(D1)         /* -42 (2A) */
  AllocVVec(D0,D1)      /* -48 (30) */
  FreeVVec(A1)          /* -54 (36) */
ENDLIBRARY
@endnode
