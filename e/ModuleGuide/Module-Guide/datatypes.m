@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "datatypes.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY datatypesbase               /* informal notation */
  RlDispatch(A0,A1)                 /* -30 (1E) */
  ObtainDataTypeA(D0,A0,A1)         /* -36 (24) */
  ReleaseDataType(A0)               /* -42 (2A) */
  NewDTObjectA(D0,A0)               /* -48 (30) */
  DisposeDTObject(A0)               /* -54 (36) */
  SetDTAttrsA(A0,A1,A2,A3)          /* -60 (3C) */
  GetDTAttrsA(A0,A2)                /* -66 (42) */
  AddDTObject(A0,A1,A2,D0)          /* -72 (48) */
  RefreshDTObjectA(A0,A1,A2,A3)     /* -78 (4E) */
  DoAsyncLayout(A0,A1)              /* -84 (54) */
  DoDTMethodA(A0,A1,A2,A3)          /* -90 (5A) */
  RemoveDTObject(A0,A1)             /* -96 (60) */
  GetDTMethods(A0)                  /* -102 (66) */
  GetDTTriggerMethods(A0)           /* -108 (6C) */
  PrintDTObjectA(A0,A1,A2,A3)       /* -114 (72) */
  GetDTString(D0)                   /* -138 (8A) */
ENDLIBRARY
@endnode
