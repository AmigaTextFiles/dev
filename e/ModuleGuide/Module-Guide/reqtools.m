@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "reqtools.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY reqtoolsbase                /* informal notation */
  RtAllocRequestA(D0,A0)            /* -30 (1E) */
  RtFreeRequest(A1)                 /* -36 (24) */
  RtFreeReqBuffer(A1)               /* -42 (2A) */
  RtChangeReqAttrA(A1,A0)           /* -48 (30) */
  RtFileRequestA(A1,A2,A3,A0)       /* -54 (36) */
  RtFreeFileList(A0)                /* -60 (3C) */
  RtEZRequestA(A1,A2,A3,A4,A0)      /* -66 (42) */
  RtGetStringA(A1,D0,A2,A3,A0)      /* -72 (48) */
  RtGetLongA(A1,A2,A3,A0)           /* -78 (4E) */
  Dum()                             /* -84 (54) */
  Dum()                             /* -90 (5A) */
  RtFontRequestA(A1,A3,A0)          /* -96 (60) */
  RtPaletteRequestA(A2,A3,A0)       /* -102 (66) */
  RtReqHandlerA(A1,D0,A0)           /* -108 (6C) */
  RtSetWaitPointer(A0)              /* -114 (72) */
  RtGetVScreenSize(A0,A1,A2)        /* -120 (78) */
  RtSetReqPosition(D0,A0,A1,A2)     /* -126 (7E) */
  RtSpread(A0,A1,D0,D1,D2,D3)       /* -132 (84) */
  RtScreenToFrontSafely(A0)         /* -138 (8A) */
  RtScreenModeRequestA(A1,A3,A0)    /* -144 (90) */
  RtCloseWindowSafely(A0)           /* -150 (96) */
  RtLockWindow(A0)                  /* -156 (9C) */
  RtUnlockWindow(A0,A1)             /* -162 (A2) */
  RtLockPrefs()                     /* -168 (A8) */
  RtUnlockPrefs()                   /* -174 (AE) */
ENDLIBRARY
@endnode
