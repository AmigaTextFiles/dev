@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "asl.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY aslbase             /* informal notation */
  AllocFileRequest()        /* -30 (1E) */
  FreeFileRequest(A0)       /* -36 (24) */
  RequestFile(A0)           /* -42 (2A) */
  AllocAslRequest(D0,A0)    /* -48 (30) */
  FreeAslRequest(A0)        /* -54 (36) */
  AslRequest(A0,A1)         /* -60 (3C) */
ENDLIBRARY
@endnode
