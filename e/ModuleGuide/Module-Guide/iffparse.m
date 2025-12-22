@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "iffparse.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY iffparsebase                   /* informal notation */
  AllocIFF()                           /* -30 (1E) */
  OpenIFF(A0,D0)                       /* -36 (24) */
  ParseIFF(A0,D0)                      /* -42 (2A) */
  CloseIFF(A0)                         /* -48 (30) */
  FreeIFF(A0)                          /* -54 (36) */
  ReadChunkBytes(A0,A1,D0)             /* -60 (3C) */
  WriteChunkBytes(A0,A1,D0)            /* -66 (42) */
  ReadChunkRecords(A0,A1,D0,D1)        /* -72 (48) */
  WriteChunkRecords(A0,A1,D0,D1)       /* -78 (4E) */
  PushChunk(A0,D0,D1,D2)               /* -84 (54) */
  PopChunk(A0)                         /* -90 (5A) */
  EntryHandler(A0,D0,D1,D2,A1,A2)      /* -102 (66) */
  ExitHandler(A0,D0,D1,D2,A1,A2)       /* -108 (6C) */
  PropChunk(A0,D0,D1)                  /* -114 (72) */
  PropChunks(A0,A1,D0)                 /* -120 (78) */
  StopChunk(A0,D0,D1)                  /* -126 (7E) */
  StopChunks(A0,A1,D0)                 /* -132 (84) */
  CollectionChunk(A0,D0,D1)            /* -138 (8A) */
  CollectionChunks(A0,A1,D0)           /* -144 (90) */
  StopOnExit(A0,D0,D1)                 /* -150 (96) */
  FindProp(A0,D0,D1)                   /* -156 (9C) */
  FindCollection(A0,D0,D1)             /* -162 (A2) */
  FindPropContext(A0)                  /* -168 (A8) */
  CurrentChunk(A0)                     /* -174 (AE) */
  ParentChunk(A0)                      /* -180 (B4) */
  AllocLocalItem(D0,D1,D2,D3)          /* -186 (BA) */
  LocalItemData(A0)                    /* -192 (C0) */
  SetLocalItemPurge(A0,A1)             /* -198 (C6) */
  FreeLocalItem(A0)                    /* -204 (CC) */
  FindLocalItem(A0,D0,D1,D2)           /* -210 (D2) */
  StoreLocalItem(A0,A1,D0)             /* -216 (D8) */
  StoreItemInContext(A0,A1,A2)         /* -222 (DE) */
  InitIFF(A0,D0,A1)                    /* -228 (E4) */
  InitIFFasDOS(A0)                     /* -234 (EA) */
  InitIFFasClip(A0)                    /* -240 (F0) */
  OpenClipboard(D0)                    /* -246 (F6) */
  CloseClipboard(A0)                   /* -252 (FC) */
  GoodID(D0)                           /* -258 (102) */
  GoodType(D0)                         /* -264 (108) */
  IdtoStr(D0,A0)                       /* -270 (10E) */
ENDLIBRARY
@endnode
