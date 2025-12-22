@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "vmem.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY vmembase            /* informal notation */
  VmAllocMem(D0,D1,D2)      /* -30 (1E) */
  VmFreeMem(A1,D0)          /* -36 (24) */
  VmAvailMem(D1,D0)         /* -42 (2A) */
  VmTypeOfMem(A1)           /* -48 (30) */
  VmGetPageSize()           /* -54 (36) */
  VmAllocVec(D0,D1,D2)      /* -60 (3C) */
  VmFreeVec(A1)             /* -66 (42) */
ENDLIBRARY
@endnode
