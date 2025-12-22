ShowModule v1.10 (c) 1992 $#%!
now showing: "bfbplaysub.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY bfbplaysubbase         /* informal notation */
  SuBLoadModule(A0)     /* -30 (1E) */
  SuBUnLoadModule(A0)     /* -36 (24) */
  SuBPlayModule(A0)     /* -42 (2A) */
  SuBStopModule(A0)     /* -48 (30) */
  SuBContModule(A0)     /* -54 (36) */
  SuBNextPage(A0)     /* -60 (3C) */
  SuBPreviousPage(A0)     /* -66 (42) */
  SuBChangeModule(A0)     /* -72 (48) */
  SuBGetSamplenames(A0)     /* -78 (4E) */
  SuBAuthorInfo(A0)     /* -84 (54) */
ENDLIBRARY

