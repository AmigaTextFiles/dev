@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "req.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY reqbase                                 /* informal notation */
  Center(A0,D0,D1)                              /* -30 (1E) */
  SetSize(D0,D1)                                /* -36 (24) */
  SetLocation(D0,D1,D2)                         /* -42 (2A) */
  ReadLocation(D0,D1,D2)                        /* -48 (30) */
  ReqFormat(A0,A1,A2)                           /* -54 (36) */
  Dum()                                         /* -60 (3C) */
  Dum()                                         /* -66 (42) */
  Dum()                                         /* -72 (48) */
  Dum()                                         /* -78 (4E) */
  FileRequester(A0)                             /* -84 (54) */
  ColorRequester(D0)                            /* -90 (5A) */
  DrawBox(A0,D0,D1,D2,D3)                       /* -96 (60) */
  MakeButton(A0,A1,A2,D0,D1,D2)                 /* -102 (66) */
  MakeScrollBar(A0,D0,D1,D2,D3)                 /* -108 (6C) */
  PurgeFiles(A0)                                /* -114 (72) */
  Dum()                                         /* -120 (78) */
  MakeGadget(A0,A1,D0,D1)                       /* -126 (7E) */
  MakeString(A0,A1,A2,D0,D1,D2,D3)              /* -132 (84) */
  MakeProp(A0,D0,D1,D2)                         /* -138 (8A) */
  LinkGadget(A0,A1,A3,D0,D1)                    /* -144 (90) */
  LinkStringGadget(A0,A1,A2,A3,D0,D1,D2,D3)     /* -150 (96) */
  LinkPropGadget(A0,A3,D0,D1,D2,D3,D4)          /* -156 (9C) */
  GetString(A0,A1,A2,D0,D1)                     /* -162 (A2) */
  RealTimeScroll(A0)                            /* -168 (A8) */
  TextRequest(A0)                               /* -174 (AE) */
  GetLong(A0)                                   /* -180 (B4) */
  RawKeyToAscii(D0,D1,A0)                       /* -186 (BA) */
  ExtendedColorRequester(A0)                    /* -192 (C0) */
  NewGetString(A0)                              /* -198 (C6) */
ENDLIBRARY
@endnode
