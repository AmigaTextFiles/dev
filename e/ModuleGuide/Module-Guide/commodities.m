@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "commodities.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY cxbase              /* informal notation */
  CreateCxObj(D0,A0,A1)     /* -30 (1E) */
  CxBroker(A0,D0)           /* -36 (24) */
  ActivateCxObj(A0,D0)      /* -42 (2A) */
  DeleteCxObj(A0)           /* -48 (30) */
  DeleteCxObjAll(A0)        /* -54 (36) */
  CxObjType(A0)             /* -60 (3C) */
  CxObjError(A0)            /* -66 (42) */
  ClearCxObjError(A0)       /* -72 (48) */
  SetCxObjPri(A0,D0)        /* -78 (4E) */
  AttachCxObj(A0,A1)        /* -84 (54) */
  EnqueueCxObj(A0,A1)       /* -90 (5A) */
  InsertCxObj(A0,A1,A2)     /* -96 (60) */
  RemoveCxObj(A0)           /* -102 (66) */
  SetTranslate(A0,A1)       /* -114 (72) */
  SetFilter(A0,A1)          /* -120 (78) */
  SetFilterIX(A0,A1)        /* -126 (7E) */
  ParseIX(A0,A1)            /* -132 (84) */
  CxMsgType(A0)             /* -138 (8A) */
  CxMsgData(A0)             /* -144 (90) */
  CxMsgID(A0)               /* -150 (96) */
  DivertCxMsg(A0,A1,A2)     /* -156 (9C) */
  RouteCxMsg(A0,A1)         /* -162 (A2) */
  DisposeCxMsg(A0)          /* -168 (A8) */
  InvertKeyMap(D0,A0,A1)    /* -174 (AE) */
  AddIEvents(A0)            /* -180 (B4) */
  MatchIX(A0,A1)            /* -204 (CC) */
ENDLIBRARY
@endnode
