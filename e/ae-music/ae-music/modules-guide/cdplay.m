ShowModule v1.10 (c) 1992 $#%!
now showing: "cdplay.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY cdplaybase         /* informal notation */
  CdOpenDrive(A0,D0)     /* -30 (1E) */
  CdCloseDrive(A1)     /* -36 (24) */
  CdUpdate(A1)     /* -42 (2A) */
  CdInquiry(A0,A1)     /* -48 (30) */
  CdLockDrive(D0,A1)     /* -54 (36) */
  CdOpen(A1)     /* -60 (3C) */
  CdClose(A1)     /* -66 (42) */
  CdPlay(D0,A1)     /* -72 (48) */
  CdPause(D0,A1)     /* -78 (4E) */
  CdStop(A1)     /* -84 (54) */
  CdJump(D0,A1)     /* -90 (5A) */
  CdNext(A1)     /* -96 (60) */
  CdPrev(A1)     /* -102 (66) */
  CdGetVolume(A0,A1)     /* -108 (6C) */
  CdSetVolume(A0,A1)     /* -114 (72) */
ENDLIBRARY

