ShowModule v1.10 (c) 1992 $#%!
now showing: "medplayer.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY medplayerbase         /* informal notation */
  GetPlayer(D0)     /* -30 (1E) */
  FreePlayer()     /* -36 (24) */
  PlayModule(A0)     /* -42 (2A) */
  ContModule(A0)     /* -48 (30) */
  StopPlayer()     /* -54 (36) */
  DimOffPlayer(D0)     /* -60 (3C) */
  SetTempo(D0)     /* -66 (42) */
  LoadModule(A0)     /* -72 (48) */
  UnLoadModule(A0)     /* -78 (4E) */
  GetCurrentModule()     /* -84 (54) */
  ResetMIDI()     /* -90 (5A) */
  SetModnum(D0)     /* -96 (60) */
  RelocModule(A0)     /* -102 (66) */
  RequiredPlayRoutine(A0)     /* -108 (6C) */
  FastMemPlayRecommended(A0)     /* -114 (72) */
  LoadModule_Fast(A0)     /* -120 (78) */
  SetFastMemPlay(D0,D1)     /* -126 (7E) */
ENDLIBRARY

