@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "cybergraphics.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY cybergfxbase                                /* informal notation */
  Dum()                                             /* -30 (1E) */
  Dum()                                             /* -36 (24) */
  Dum()                                             /* -42 (2A) */
  Dum()                                             /* -48 (30) */
  IsCyberModeID(D0)                                 /* -54 (36) */
  BestCModeIDTagList(A0)                            /* -60 (3C) */
  CmodeRequestTagList(A0,A1)                        /* -66 (42) */
  AllocCModeListTagList(A1)                         /* -72 (48) */
  FreeCModeList(A0)                                 /* -78 (4E) */
  Dum()                                             /* -84 (54) */
  ScalePixelArray(A0,D0,D1,D2,A1,D3,D4,D5,D6,D7)    /* -90 (5A) */
  GetCyberMapAttr(A0,D0)                            /* -96 (60) */
  GetCyberIDAttr(D0,D1)                             /* -102 (66) */
  ReadRGBPixel(A1,D0,D1)                            /* -108 (6C) */
  WriteRGBPixel(A1,D0,D1,D2)                        /* -114 (72) */
  ReadPixelArray(A0,D0,D1,D2,A1,D3,D4,D5,D6,D7)     /* -120 (78) */
  WritePixelArray(A0,D0,D1,D2,A1,D3,D4,D5,D6,D7)    /* -126 (7E) */
  MovePixelArray(D0,D1,A1,D2,D3,D4,D5)              /* -132 (84) */
  SwapPixelArray(A0,D0,D1,D2,A1,D3,D4,D5,D6,D7)     /* -138 (8A) */
  InvertPixelArray(A1,D0,D1,D2,D3)                  /* -144 (90) */
  FillPixelArray(A1,D0,D1,D2,D3,D4)                 /* -150 (96) */
  DoCDrawMethodTagList(A0,A1,A2)                    /* -156 (9C) */
ENDLIBRARY
@endnode
