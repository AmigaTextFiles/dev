@DataBase
@Node Main ModuleInformation
@TOC ModuleMain.guide/main
@Index Module.index/main
ShowModule v1.10 (c) 1992 $#%!
@{fg shine}now showing: "lowlevel.m"@{fg text}
NOTE: don't use this output in your code, use the module instead.

LIBRARY lowlevelbase            /* informal notation */
  ReadJoyPort(D0)               /* -30 (1E) */
  GetLanguageSelection()        /* -36 (24) */
  GetKey()                      /* -48 (30) */
  QueryKeys(A0,D1)              /* -54 (36) */
  AddKBInt(A0,A1)               /* -60 (3C) */
  RemKBInt(A1)                  /* -66 (42) */
  SystemControlA(A1)            /* -72 (48) */
  AddTimerInt(A0,A1)            /* -78 (4E) */
  RemTimerInt(A1)               /* -84 (54) */
  StopTimerInt(A1)              /* -90 (5A) */
  StartTimerInt(A1,D0,D1)       /* -96 (60) */
  ElapsedTime(A0)               /* -102 (66) */
  AddVBlankInt(A0,A1)           /* -108 (6C) */
  RemVBlankInt(A1)              /* -114 (72) */
  SetJoyPortAttrsA(D0,A1)       /* -132 (84) */
ENDLIBRARY
@endnode
