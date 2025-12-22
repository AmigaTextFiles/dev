ShowModule v1.10 (c) 1992 $#%!
now showing: "octaplayer.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY octaplayerbase         /* informal notation */
  GetPlayer8()     /* -30 (1E) */
  FreePlayer8()     /* -36 (24) */
  PlayModule8(A0)     /* -42 (2A) */
  ContModule8(A0)     /* -48 (30) */
  StopPlayer8()     /* -54 (36) */
  LoadModule8(A0)     /* -60 (3C) */
  UnLoadModule8(A0)     /* -66 (42) */
  SetModnum8(D0)     /* -72 (48) */
  RelocModule8(A0)     /* -78 (4E) */
  SetHQ(D0)     /* -84 (54) */
  RequiredPlayRoutine8(A0)     /* -90 (5A) */
  FastMemPlayRecommended8(A0)     /* -96 (60) */
  LoadModule_Fast8(A0)     /* -102 (66) */
  SetFastMemPlay8(D0,D1)     /* -108 (6C) */
ENDLIBRARY

