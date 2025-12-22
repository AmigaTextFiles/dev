ShowModule v1.10 (c) 1992 $#%!
now showing: "ppc.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY ppclibbase         /* informal notation */
  PpCLoadObject(A0)     /* -30 (1E) */
  PpCUnLoadObject(A0)     /* -36 (24) */
  PpCRunObject(A0,A1)     /* -42 (2A) */
  PpCAllocMem(D0,D1)     /* -48 (30) */
  PpCFreeMem(A1,D0)     /* -54 (36) */
  PpCAllocVec(D0,D1)     /* -60 (3C) */
  PpCFreeVec(A1)     /* -66 (42) */
  PpCDebugMode(D0,D1)     /* -72 (48) */
  PpCReset()     /* -78 (4E) */
  PpCCreateTask(A0,A1)     /* -84 (54) */
  PpCDeleteTask(A0)     /* -90 (5A) */
  PpCSignalTask(A0,D0)     /* -96 (60) */
  PpCFindTask(A0)     /* -102 (66) */
  PpCRunKernelObject(A0,A1)     /* -114 (72) */
  PpCGetTaskAttrs(A0,A1)     /* -132 (84) */
  PpCGetAttrs(A0)     /* -138 (8A) */
  PpCFindTaskObject(A0)     /* -144 (90) */
  PpCRunKernelObjectFPU(D0,D1,A0,D0,A1,D0)     /* -150 (96) */
  PpCReadLong(A0)     /* -156 (9C) */
  PpCWriteLong(A0,D0)     /* -162 (A2) */
  PpCStartTask(A0,A1)     /* -180 (B4) */
  PpCStopTask(A0,A1)     /* -186 (BA) */
  PpCSetTaskAttrs(A0,A1)     /* -192 (C0) */
  PpCGetObjectAttrs(A0,A1,A2)     /* -198 (C6) */
  PpCWriteLongFlush(A0,D0)     /* -204 (CC) */
  PpCReadWord(A0)     /* -210 (D2) */
  PpCWriteWord(A0,D0)     /* -216 (D8) */
  PpCReadByte(A0)     /* -222 (DE) */
  PpCWriteByte(A0,D0)     /* -228 (E4) */
  PpCCreatePool(D0,D1,D2)     /* -234 (EA) */
  PpCDeletePool(A0)     /* -240 (F0) */
  PpCAllocPooled(A0,D0)     /* -246 (F6) */
  PpCFreePooled(A0,A1,D0)     /* -252 (FC) */
  PpCAllocVecPooled(A0,D0)     /* -258 (102) */
  PpCFreeVecPooled(A0,A1)     /* -264 (108) */
  PpCCreatePort(A0)     /* -270 (10E) */
  PpCDeletePort(A0)     /* -276 (114) */
  PpCObtainPort(A0)     /* -282 (11A) */
  PpCReleasePort(A0)     /* -288 (120) */
  PpCCreateMessage(A0,D0)     /* -294 (126) */
  PpCDeleteMessage(A0)     /* -300 (12C) */
  PpCGetMessageAttr(A0,D0)     /* -306 (132) */
  PpCGetMessage(A0)     /* -312 (138) */
  PpCPutMessage(A0,A1)     /* -318 (13E) */
  PpCReplyMessage(A0)     /* -324 (144) */
  PpCSendMessage(A0,A1,A2,D0,D1)     /* -330 (14A) */
  PpCWaitPort(A0)     /* -336 (150) */
  PpCCacheClearE(A0,D0,D1)     /* -342 (156) */
  PpCCacheInvalidE(A0,D0,D1)     /* -348 (15C) */
  PpCCreatePortList(A0,D0)     /* -366 (16E) */
  PpCDeletePortList(A0)     /* -372 (174) */
  PpCAddPortList(A0,A1)     /* -378 (17A) */
  PpCRemPortList(A0,A1)     /* -384 (180) */
  PpCWaitPortList(A0)     /* -390 (186) */
  PpCGetPortListAttr(A0,D0)     /* -396 (18C) */
  PpCSetPortListAttr(A0,D0,D1)     /* -402 (192) */
  PpCLoadObjectTagList(A0)     /* -408 (198) */
  PpCSetAttrs(A0)     /* -414 (19E) */
  PpCCacheTrashE(A0,D0,D1)     /* -432 (1B0) */
ENDLIBRARY

