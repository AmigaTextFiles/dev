@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "iff.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY iffbase                             /* informal notation */
  Dum()                                     /* -30 (1E) */
  IfFL_CloseIFF(A1)                         /* -36 (24) */
  IfFL_FindChunk(A1,D0)                     /* -42 (2A) */
  IfFL_GetBMHD(A1)                          /* -48 (30) */
  IfFL_GetColorTab(A1,A0)                   /* -54 (36) */
  IfFL_DecodePic(A1,A0)                     /* -60 (3C) */
  IfFL_SaveBitMap(A0,A1,A2,D0)              /* -66 (42) */
  IfFL_SaveClip(A0,A1,A2,D0,D1,D2,D3,D4)    /* -72 (48) */
  IfFL_IFFError()                           /* -78 (4E) */
  IfFL_GetViewModes(A1)                     /* -84 (54) */
  Dum()                                     /* -90 (5A) */
  IfFL_ModifyFrame(A1,A0)                   /* -96 (60) */
  Dum()                                     /* -102 (66) */
  Dum()                                     /* -108 (6C) */
  Dum()                                     /* -114 (72) */
  IfFL_OpenIFF(A0,D0)                       /* -120 (78) */
  IfFL_PushChunk(A0,D0,D1)                  /* -126 (7E) */
  IfFL_PopChunk(A0)                         /* -132 (84) */
  IfFL_WriteChunkBytes(A0,A1,D0)            /* -138 (8A) */
  IfFL_CompressBlock(A0,A1,D0,D1)           /* -144 (90) */
  IfFL_DecompressBlock(A0,A1,D0,D1)         /* -150 (96) */
ENDLIBRARY
@endnode
