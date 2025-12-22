@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "amigaguide.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY amigaguidebase                  /* informal notation */
  AgARexxHost(A0,A1)                    /* -30 (1E) */  
  LockAmigaGuideBase(A0)                /* -36 (24) */  
  UnlockAmigaGuideBase(D0)              /* -42 (2A) */  
  OpenAmigaGuideA(A0,A1)                /* -54 (36) */  
  OpenAmigaGuideAsyncA(A0,D0)           /* -60 (3C) */  
  CloseAmigaGuide(A0)                   /* -66 (42) */  
  AmigaGuideSignal(A0)                  /* -72 (48) */  
  GetAmigaGuideMsg(A0)                  /* -78 (4E) */  
  ReplyAmigaGuideMsg(A0)                /* -84 (54) */  
  SetAmigaGuideContextA(A0,D0,D1)       /* -90 (5A) */  
  SendAmigaGuideContextA(A0,D0)         /* -96 (60) */  
  SendAmigaGuideCmdA(A0,D0,D1)          /* -102 (66) */  
  SetAmigaGuideAttrsA(A0,A1)            /* -108 (6C) */  
  GetAmigaGuideAttr(D0,A0,A1)           /* -114 (72) */  
  AddAmigaGuideHostA(A0,D0,A1)          /* -138 (8A) */  
  RemoveAmigaGuideHostA(A0,A1)          /* -144 (90) */  
  GetAmigaGuideString(D0)               /* -210 (D2) */  
ENDLIBRARY
@endnode
