@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "realtime.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY realtimebase                /* informal notation */
  LockRealTime(D0)                  /* -30 (1E) */
  UnlockRealTime(A0)                /* -36 (24) */
  CreatePlayerA(A0)                 /* -42 (2A) */
  DeletePlayer(A0)                  /* -48 (30) */
  SetPlayerAttrsA(A0,A1)            /* -54 (36) */
  SetConductorState(A0,D0,D1)       /* -60 (3C) */
  ExternalSync(A0,D0,D1)            /* -66 (42) */
  NextConductor(A0)                 /* -72 (48) */
  FindConductor(A0)                 /* -78 (4E) */
  GetPlayerAttrsA(A0,A1)            /* -84 (54) */
ENDLIBRARY
@endnode
