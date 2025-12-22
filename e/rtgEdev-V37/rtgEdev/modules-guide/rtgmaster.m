ShowModule v1.10 (c) 1992 $#%!
now showing: "rtgmaster.m"
NOTE: don't use this output in your code, use the module instead.

LIBRARY rtgmasterbase         /* informal notation */
  OpenRtgScreen(A0,A1)     /* -30 (1E) */
  CloseRtgScreen(A0)     /* -36 (24) */
  SwitchScreens(A0,D0)     /* -42 (2A) */
  LoadRGBRtg(A0,A1)     /* -48 (30) */
  LockRtgScreen(A0)     /* -54 (36) */
  UnlockRtgScreen(A0)     /* -60 (3C) */
  GetBufAdr(A0,D0)     /* -66 (42) */
  GetRtgScreenData(A0,A1)     /* -72 (48) */
  RtgAllocSRList(A0)     /* -78 (4E) */
  FreeRtgSRList(A0)     /* -84 (54) */
  RtgScreenAtFront(A0)     /* -90 (5A) */
  RtgScreenModeReq(A0)     /* -96 (60) */
  FreeRtgScreenModeReq(A0)     /* -102 (66) */
  WriteRtgPixel(A0,A1,D0,D1,D2)     /* -108 (6C) */
  WriteRtgPixelRGB(A0,A1,D0,D1,D2)     /* -114 (72) */
  FillRtgRect(A0,A1,D0,D1,D2,D3,D4)     /* -120 (78) */
  FillRtgRectRGB(A0,A1,D0,D1,D2,D3,D4)     /* -126 (7E) */
  WriteRtgPixelArray(A0,A1,A2,D0,D1,D2,D3)     /* -132 (84) */
  WriteRtgPixelRGBArray(A0,A1,A2,D0,D1,D2,D3)     /* -138 (8A) */
  CopyRtgPixelArray(A0,A1,A2,D0,D1,D2,D3,D4,D5)     /* -144 (90) */
  CopyRtgBlit(A0,A1,A2,A3,D0,D1,D2,D3,D4,D5,D6,D7)     /* -150 (96) */
  DrawRtgLine(A0,A1,D0,D1,D2,D3,D4)     /* -156 (9C) */
  DrawRtgLineRGB(A0,A1,D0,D1,D2,D3,D4)     /* -162 (A2) */
  WaitRtgSwitch(A0)     /* -168 (A8) */
  WaitRtgBlit(A0)     /* -174 (AE) */
  RtgWaitTOF(A0)     /* -180 (B4) */
  RtgBlit(A0,A1,A2,D0,D1,D2,D3,D4,D5,D6)     /* -186 (BA) */
  RtgBltClear(A0,A1,D0,D1,D2,D3)     /* -192 (C0) */
  CallRtgC2P(A0,A1,A2,D0,D1,D2,D3,D4,D5)     /* -198 (C6) */
  RtgBestSR(A0)     /* -204 (CC) */
  RtgCheckVSync(A0)     /* -210 (D2) */
  InitRtgBobSystem(A0,D0)     /* -216 (D8) */
  CheckPPCCommand(A0,D0)     /* -222 (DE) */
  CloseRtgBobSystem(A0)     /* -228 (E4) */
  RtgBobRefreshBuffer(A0,A1,A2,D0)     /* -234 (EA) */
  RtgBobDrawSprite(A0,A1,A2,D0,D1,D2,D3)     /* -240 (F0) */
  Private4()     /* -246 (F6) */
  Private5()     /* -252 (FC) */
  Private6()     /* -258 (102) */
  Private7()     /* -264 (108) */
  RtgText(A0,A1,A2,D0,D1,D2)     /* -270 (10E) */
  RtgSetFont(A0,A1)     /* -276 (114) */
  RtgClearPointer(A0)     /* -282 (11A) */
  RtgSetPointer(A0,A1,D0,D1,D2,D3)     /* -288 (120) */
  RtgSetTextMode(A0,D0,D1,D2)     /* -294 (126) */
  RtgOpenFont(A0,A1)     /* -300 (12C) */
  RtgCloseFont(A0,A1)     /* -306 (132) */
  RtgSetTextModeRGB(A0,D0,D1,D2)     /* -312 (138) */
  RtgInitRDCMP(A0)     /* -318 (13E) */
  RtgWaitRDCMP(A0)     /* -324 (144) */
  RtgGetMsg(A0)     /* -330 (14A) */
  RtgReplyMsg(A0,A1)     /* -336 (150) */
ENDLIBRARY

