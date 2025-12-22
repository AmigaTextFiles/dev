@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "utility.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY utilitybase                 /* informal notation */
  FindTagItem(D0,A0)                /* -30 (1E) */
  GetTagData(D0,D1,A0)              /* -36 (24) */
  PackBoolTags(D0,A0,A1)            /* -42 (2A) */
  NextTagItem(A0)                   /* -48 (30) */
  FilterTagChanges(A0,A1,D0)        /* -54 (36) */
  MapTags(A0,A1,D0)                 /* -60 (3C) */
  AllocateTagItems(D0)              /* -66 (42) */
  CloneTagItems(A0)                 /* -72 (48) */
  FreeTagItems(A0)                  /* -78 (4E) */
  RefreshTagItemClones(A0,A1)       /* -84 (54) */
  TagInArray(D0,A0)                 /* -90 (5A) */
  FilterTagItems(A0,A1,D0)          /* -96 (60) */
  CallHookPkt(A0,A2,A1)             /* -102 (66) */
  Amiga2Date(D0,A0)                 /* -120 (78) */
  Date2Amiga(A0)                    /* -126 (7E) */
  CheckDate(A0)                     /* -132 (84) */
  Smult32(D0,D1)                    /* -138 (8A) */
  Umult32(D0,D1)                    /* -144 (90) */
  SdivMod32(D0,D1)                  /* -150 (96) */
  UdivMod32(D0,D1)                  /* -156 (9C) */
  Stricmp(A0,A1)                    /* -162 (A2) */
  Strnicmp(A0,A1,D0)                /* -168 (A8) */
  ToUpper(D0)                       /* -174 (AE) */
  ToLower(D0)                       /* -180 (B4) */
  ApplyTagChanges(A0,A1)            /* -186 (BA) */
  Smult64(D0,D1)                    /* -198 (C6) */
  Umult64(D0,D1)                    /* -204 (CC) */
  PackStructureTags(A0,A1,A2)       /* -210 (D2) */
  UnpackStructureTags(A0,A1,A2)     /* -216 (D8) */
  AddNamedObject(A0,A1)             /* -222 (DE) */
  AllocNamedObjectA(A0,A1)          /* -228 (E4) */
  AttemptRemNamedObject(A0)         /* -234 (EA) */
  FindNamedObject(A0,A1,A2)         /* -240 (F0) */
  FreeNamedObject(A0)               /* -246 (F6) */
  NamedObjectName(A0)               /* -252 (FC) */
  ReleaseNamedObject(A0)            /* -258 (102) */
  RemNamedObject(A0,A1)             /* -264 (108) */
  GetUniqueID()                     /* -270 (10E) */
ENDLIBRARY
@endnode
