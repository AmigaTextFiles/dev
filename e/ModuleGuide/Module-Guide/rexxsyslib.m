@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "rexxsyslib.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY rexxsysbase         /* informal notation */
  CreateArgstring(A0,D0)    /* -126 (7E) */
  DeleteArgstring(A0)       /* -132 (84) */
  LengthArgstring(A0)       /* -138 (8A) */
  CreateRexxMsg(A0,A1,D0)   /* -144 (90) */
  DeleteRexxMsg(A0)         /* -150 (96) */
  ClearRexxMsg(A0,D0)       /* -156 (9C) */
  FillRexxMsg(A0,D0,D1)     /* -162 (A2) */
  IsRexxMsg(A0)             /* -168 (A8) */
  LockRexxBase(D0)          /* -450 (1C2) */
  UnlockRexxBase(D0)        /* -456 (1C8) */
ENDLIBRARY
@endnode
