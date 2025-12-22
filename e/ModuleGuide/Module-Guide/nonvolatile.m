@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "nonvolatile.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY nvbase                      /* informal notation */
  GetCopyNV(A0,A1,D1)               /* -30 (1E) */
  FreeNVData(A0)                    /* -36 (24) */
  StoreNV(A0,A1,A2,D0,D1)           /* -42 (2A) */
  DeleteNV(A0,A1,D1)                /* -48 (30) */
  GetNVInfo(D1)                     /* -54 (36) */
  GetNVList(A0,D1)                  /* -60 (3C) */
  SetNVProtection(A0,A1,D2,D1)      /* -66 (42) */
ENDLIBRARY
@endnode
