@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "layers.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY layersbase                                       /* informal notation */
  InitLayers(A0)                                         /* -30 (1E) */
  CreateUpfrontLayer(A0,A1,D0,D1,D2,D3,D4,A2)            /* -36 (24) */
  CreateBehindLayer(A0,A1,D0,D1,D2,D3,D4,A2)             /* -42 (2A) */
  UpfrontLayer(A0,A1)                                    /* -48 (30) */
  BehindLayer(A0,A1)                                     /* -54 (36) */
  MoveLayer(A0,A1,D0,D1)                                 /* -60 (3C) */
  SizeLayer(A0,A1,D0,D1)                                 /* -66 (42) */
  ScrollLayer(A0,A1,D0,D1)                               /* -72 (48) */
  BeginUpdate(A0)                                        /* -78 (4E) */
  EndUpdate(A0,D0)                                       /* -84 (54) */
  DeleteLayer(A0,A1)                                     /* -90 (5A) */
  LockLayer(A0,A1)                                       /* -96 (60) */
  UnlockLayer(A0)                                        /* -102 (66) */
  LockLayers(A0)                                         /* -108 (6C) */
  UnlockLayers(A0)                                       /* -114 (72) */
  LockLayerInfo(A0)                                      /* -120 (78) */
  SwapBitsRastPortClipRect(A0,A1)                        /* -126 (7E) */
  WhichLayer(A0,D0,D1)                                   /* -132 (84) */
  UnlockLayerInfo(A0)                                    /* -138 (8A) */
  NewLayerInfo()                                         /* -144 (90) */
  DisposeLayerInfo(A0)                                   /* -150 (96) */
  FattenLayerInfo(A0)                                    /* -156 (9C) */
  ThinLayerInfo(A0)                                      /* -162 (A2) */
  MoveLayerInFrontOf(A0,A1)                              /* -168 (A8) */
  InstallClipRegion(A0,A1)                               /* -174 (AE) */
  MoveSizeLayer(A0,D0,D1,D2,D3)                          /* -180 (B4) */
  CreateUpfrontHookLayer(A0,A1,D0,D1,D2,D3,D4,A3,A2)     /* -186 (BA) */
  CreateBehindHookLayer(A0,A1,D0,D1,D2,D3,D4,A3,A2)      /* -192 (C0) */
  InstallLayerHook(A0,A1)                                /* -198 (C6) */
  InstallLayerInfoHook(A0,A1)                            /* -204 (CC) */
  SortLayerCR(A0,D0,D1)                                  /* -210 (D2) */
  DoHookClipRects(A0,A1,A2)                              /* -216 (D8) */
ENDLIBRARY
@endnode
