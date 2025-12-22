@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "expansion.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY expansionbase           /* informal notation */
  AddConfigDev(A0)              /* -30 (1E) */
  AddBootNode(D0,D1,A0,A1)      /* -36 (24) */
  AllocBoardMem(D0)             /* -42 (2A) */
  AllocConfigDev()              /* -48 (30) */
  AllocExpansionMem(D0,D1)      /* -54 (36) */
  ConfigBoard(A0,A1)            /* -60 (3C) */
  ConfigChain(A0)               /* -66 (42) */
  FindConfigDev(A0,D0,D1)       /* -72 (48) */
  FreeBoardMem(D0,D1)           /* -78 (4E) */
  FreeConfigDev(A0)             /* -84 (54) */
  FreeExpansionMem(D0,D1)       /* -90 (5A) */
  ReadExpansionByte(A0,D0)      /* -96 (60) */
  ReadExpansionRom(A0,A1)       /* -102 (66) */
  RemConfigDev(A0)              /* -108 (6C) */
  WriteExpansionByte(A0,D0,D1)  /* -114 (72) */
  ObtainConfigBinding()         /* -120 (78) */
  ReleaseConfigBinding()        /* -126 (7E) */
  SetCurrentBinding(A0,D0)      /* -132 (84) */
  GetCurrentBinding(A0,D0)      /* -138 (8A) */
  MakeDosNode(A0)               /* -144 (90) */
  AddDosNode(D0,D1,A0)          /* -150 (96) */
ENDLIBRARY
@endnode
