@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "powerpacker.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY ppbase                      /* informal notation */
  PpLoadData(A0,D0,D1,A1,A2,A3)     /* -30 (1E) */
  PpDecrunchBuffer(A0,A1,A2,D0)     /* -36 (24) */
  PpCalcChecksum(A0)                /* -42 (2A) */
  PpCalcPasskey(A0)                 /* -48 (30) */
  PpDecrypt(A0,D0,D1)               /* -54 (36) */
  PpGetPassword(A0,A1,D0,D1)        /* -60 (3C) */
  Dum()                             /* -66 (42) */
  Dum()                             /* -72 (48) */
  Dum()                             /* -78 (4E) */
  Dum()                             /* -84 (54) */
  Dum()                             /* -90 (5A) */
  PpAllocCrunchInfo(D0,D1,A0,A1)    /* -96 (60) */
  PpFreeCrunchInfo(A0)              /* -102 (66) */
  PpCrunchBuffer(A0,A1,D0)          /* -108 (6C) */
  PpWriteDataHeader(D0,D1,D2,D3)    /* -114 (72) */
  PpEnterPassword(A0,A1)            /* -120 (78) */
  Dum()                             /* -126 (7E) */
  PpErrorMessage(D0)                /* -132 (84) */
ENDLIBRARY
@endnode
