ShowModule v1.10 (c) 1992 $#%!
now showing: "bfbplay.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY bfbplaybase         /* informal notation */
  BfBCheckModule(A0)     /* -30 (1E) */
  BfBLoadModule(A0)     /* -36 (24) */
  BfBUnLoadModule(A0)     /* -42 (2A) */
  BfBForceLoadModule(A0)     /* -48 (30) */
  BfBPlayModule(A0)     /* -54 (36) */
  BfBStopModule(A0)     /* -60 (3C) */
  BfBContModule(A0)     /* -66 (42) */
  BfBNextPage(A0)     /* -72 (48) */
  BfBPreviousPage(A0)     /* -78 (4E) */
  BfBChangeModule(A0)     /* -84 (54) */
  BfBGetSamplenames(A0)     /* -90 (5A) */
  BfBAuthorInfo(A0)     /* -96 (60) */
  BfBGetError(D0)     /* -102 (66) */
  BfBAllocChannels()     /* -108 (6C) */
  BfBFreeChannels()     /* -114 (72) */
ENDLIBRARY

