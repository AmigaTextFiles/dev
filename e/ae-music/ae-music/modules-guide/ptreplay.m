ShowModule v1.10 (c) 1992 $#%!
now showing: "ptreplay.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY ptreplaybase         /* informal notation */
  PtLoadModule(A0)     /* -30 (1E) */
  PtUnloadModule(A0)     /* -36 (24) */
  PtPlay(A0)     /* -42 (2A) */
  PtStop(A0)     /* -48 (30) */
  PtPause(A0)     /* -54 (36) */
  PtResume(A0)     /* -60 (3C) */
  PtFade(A0,D0)     /* -66 (42) */
  PtSetVolume(A0,D0)     /* -72 (48) */
  PtSongPos(A0)     /* -78 (4E) */
  PtSongLen(A0)     /* -84 (54) */
  PtSongPattern(A0,D0)     /* -90 (5A) */
  PtPatternPos(A0)     /* -96 (60) */
  PtPatternData(A0,D0,D1)     /* -102 (66) */
  PtInstallBits(A0,D0,D1,D2,D3)     /* -108 (6C) */
  PtSetupMod(A0)     /* -114 (72) */
  PtFreeMod(A0)     /* -120 (78) */
  PtStartFade(A0,D0)     /* -126 (7E) */
  PtOnChannel(A0,D0)     /* -132 (84) */
  PtOffChannel(A0,D0)     /* -138 (8A) */
  PtSetPos(A0,D0)     /* -144 (90) */
  PtSetPri(D0)     /* -150 (96) */
  PtGetPri()     /* -156 (9C) */
  PtGetChan()     /* -162 (A2) */
  PtGetSample(A0,D0)     /* -168 (A8) */
ENDLIBRARY

