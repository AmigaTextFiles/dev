ShowModule v1.10 (c) 1992 $#%!
now showing: "octamix.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY octamixplayerbase         /* informal notation */
  GetPlayerM()     /* -30 (1E) */
  FreePlayerM()     /* -36 (24) */
  PlayModuleM(A0)     /* -42 (2A) */
  ContModuleM(A0)     /* -48 (30) */
  StopPlayerM()     /* -54 (36) */
  LoadModule_FastM(A0)     /* -60 (3C) */
  UnLoadModuleM(A0)     /* -66 (42) */
  SetModnumM(D0)     /* -72 (48) */
  RelocModuleM(A0)     /* -78 (4E) */
  RequiredPlayRoutineM(A0)     /* -84 (54) */
  Set14BitMode(D0)     /* -90 (5A) */
  SetMixingFrequency(D0)     /* -96 (60) */
  SetMixBufferSize(D0)     /* -102 (66) */
ENDLIBRARY

