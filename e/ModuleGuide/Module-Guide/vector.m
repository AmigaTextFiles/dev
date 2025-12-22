@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "vector.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY vecbase                     /* informal notation */
  SetVBI(A1)                        /* -30 (1E) */
  InitVBOBs(D0,A0,A1,A2)            /* -36 (24) */
  OpenVScreen(A1)                   /* -42 (2A) */
  CloseVScreen()                    /* -48 (30) */
  UseJoy(D0,A1)                     /* -54 (36) */
  DoAnim(A1)                        /* -60 (3C) */
  RotateX(D0,D1,D2,D3,D4,D5,D6)     /* -66 (42) */
  RotateY(D0,D1,D2,D3,D4,D5,D6)     /* -72 (48) */
  RotateZ(D0,D1,D2,D3,D4,D5,D6)     /* -78 (4E) */
  FreeVBOBs()                       /* -84 (54) */
  AutoScaleOn(D0)                   /* -90 (5A) */
  AutoScaleOff()                    /* -96 (60) */
  FreeJoy()                         /* -102 (66) */
  SetColors(A0,A1)                  /* -108 (6C) */
ENDLIBRARY
@endnode
