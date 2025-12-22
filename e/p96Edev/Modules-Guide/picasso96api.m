ShowModule v1.10 (c) 1992 $#%!
now showing: "picasso96api.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY p96base         /* informal notation */
  PY6AllocBitMap(D0,D1,D2,D3,A0,D7)     /* -30 (1E) */
  PY6FreeBitMap(A0)     /* -36 (24) */
  PY6GetBitMapAttr(A0,D0)     /* -42 (2A) */
  PY6LockBitMap(A0,A1,D0)     /* -48 (30) */
  PY6UnlockBitMap(A0,D0)     /* -54 (36) */
  PY6BestModeIDTagList(A0)     /* -60 (3C) */
  PY6RequestModeIDTagList(A0)     /* -66 (42) */
  PY6AllocModeListTagList(A0)     /* -72 (48) */
  PY6FreeModeList(A0)     /* -78 (4E) */
  PY6GetModeIDAttr(D0,D1)     /* -84 (54) */
  PY6OpenScreenTagList(A0)     /* -90 (5A) */
  PY6CloseScreen(A0)     /* -96 (60) */
  PY6WritePixelArray(A0,D0,D1,A1,D2,D3,D4,D5)     /* -102 (66) */
  PY6ReadPixelArray(A0,D0,D1,A1,D2,D3,D4,D5)     /* -108 (6C) */
  PY6WritePixel(A1,D0,D1,D2)     /* -114 (72) */
  PY6ReadPixel(A1,D0,D1)     /* -120 (78) */
  PY6RectFill(A1,D0,D1,D2,D3,D4)     /* -126 (7E) */
  PY6WriteTrueColorData(A0,D0,D1,A1,D2,D3,D4,D5)     /* -132 (84) */
  PY6ReadTrueColorData(A0,D0,D1,A1,D2,D3,D4,D5)     /* -138 (8A) */
  PY6PIP_OpenTagList(A0)     /* -144 (90) */
  PY6PIP_Close(A0)     /* -150 (96) */
  PY6PIP_SetTagList(A0,A1)     /* -156 (9C) */
  PY6PIP_GetTagList(A0,A1)     /* -162 (A2) */
  PY6PIP_GetIMsg(A0)     /* -168 (A8) */
  PY6PIP_ReplyIMsg(A1)     /* -174 (AE) */
ENDLIBRARY

