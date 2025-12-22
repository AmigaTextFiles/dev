@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "gtx.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY gtxbase                         /* informal notation */
  GtX_TagInArray(D0,A0)                 /* -30 (1E) */
  GtX_SetTagData(D0,D1,A0)              /* -36 (24) */
  GtX_GetNode(A0,D0)                    /* -42 (2A) */
  GtX_GetNodeNumber(A0,A1)              /* -48 (30) */
  GtX_CountNodes(A0)                    /* -54 (36) */
  GtX_MoveNode(A0,A1,D0)                /* -60 (3C) */
  GtX_IFFErrToStr(D0,D1)                /* -66 (42) */
  GtX_GetHandleA(A0)                    /* -72 (48) */
  GtX_FreeHandle(A0)                    /* -78 (4E) */
  GtX_RefreshWindow(A0,A1,A2)           /* -84 (54) */
  GtX_CreateGadgetA(A0,D0,A1,A2,A3)     /* -90 (5A) */
  GtX_RawToVanilla(A0,D0,D1)            /* -96 (60) */
  GtX_GetIMsg(A0,A1)                    /* -102 (66) */
  GtX_ReplyIMsg(A0,A1)                  /* -108 (6C) */
  GtX_SetGadgetAttrsA(A0,A1,A2)         /* -114 (72) */
  GtX_DetachLabels(A0,A1)               /* -120 (78) */
  GtX_DrawBox(A0,D0,D1,D2,D3,A1,D4)     /* -126 (7E) */
  GtX_InitTextClass()                   /* -132 (84) */
  GtX_InitGetFileClass()                /* -138 (8A) */
  GtX_SetHandleAttrsA(A0,A1)            /* -144 (90) */
  GtX_BeginRefresh(A0)                  /* -150 (96) */
  GtX_EndRefresh(A0,D0)                 /* -156 (9C) */
  Dum()                                 /* -162 (A2) */
  Dum()                                 /* -168 (A8) */
  Dum()                                 /* -174 (AE) */
  Dum()                                 /* -180 (B4) */
  Dum()                                 /* -186 (BA) */
  Dum()                                 /* -192 (C0) */
  Dum()                                 /* -198 (C6) */
  Dum()                                 /* -204 (CC) */
  Dum()                                 /* -210 (D2) */
  Dum()                                 /* -216 (D8) */
  Dum()                                 /* -222 (DE) */
  GtX_FreeWindows(A0,A1)                /* -228 (E4) */
  GtX_LoadGUIA(A0,A1,A2)                /* -234 (EA) */
ENDLIBRARY
@endnode
