@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "icon.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY iconbase            /* informal notation */
  GetIcon(A0,A1,A2)         /* -42 (2A) */
  PutIcon(A0,A1)            /* -48 (30) */
  FreeFreeList(A0)          /* -54 (36) */
  AddFreeList(A0,A1,A2)     /* -72 (48) */
  GetDiskObject(A0)         /* -78 (4E) */
  PutDiskObject(A0,A1)      /* -84 (54) */
  FreeDiskObject(A0)        /* -90 (5A) */
  FindToolType(A0,A1)       /* -96 (60) */
  MatchToolValue(A0,A1)     /* -102 (66) */
  BumpRevision(A0,A1)       /* -108 (6C) */
  GetDefDiskObject(D0)      /* -120 (78) */
  PutDefDiskObject(A0)      /* -126 (7E) */
  GetDiskObjectNew(A0)      /* -132 (84) */
  DeleteDiskObject(A0)      /* -138 (8A) */
ENDLIBRARY
@endnode
