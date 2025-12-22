ShowModule v1.10 (c) 1992 $#%!
now showing: "rtgextra.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY rtgextrabase         /* informal notation */
  OpenClient(A0,A1,D0,D1,D2)     /* -30 (1E) */
  OpenServer(A0,D0,D1,D2)     /* -36 (24) */
  CloseClient(A0,A1)     /* -42 (2A) */
  CloseServer(A0,A1)     /* -48 (30) */
  RunServer(A0,A1,A2,A3,D0)     /* -54 (36) */
  RtgSend(A0,A1,A2,A3,D0)     /* -60 (3C) */
  RtgRecv(A0,A1,A2,A3,D0)     /* -66 (42) */
  RtgAccept(A0,A1)     /* -72 (48) */
  RtgIoctl(A0,A1,A2)     /* -78 (4E) */
  GetUDPName(A0,A1)     /* -84 (54) */
  RtgInAdr(A0,A1)     /* -90 (5A) */
ENDLIBRARY

