//     $VER: rtgsublibs.i 1.006 (15 Jan 1998)

#ifndef RTGMASTERPPC_H
#define RTGMASTERPPC_H

#define CMD_OpenRtgScreen 0
#define CMD_CloseRtgScreen 1
#define CMD_SwitchScreens 2
#define CMD_LoadRGBRtg 3
#define CMD_LockRtgScreen 4
#define CMD_UnlockRtgScreen 5
#define CMD_GetBufAdr 6
#define CMD_GetRtgScreenData 7
#define CMD_RtgScreenAtFront 8
#define CMD_RtgScreenModeReq 9
#define CMD_FreeRtgScreenModeReq 10
#define CMD_WriteRtgPixel 11
#define CMD_WriteRtgPixelRGB 12
#define CMD_FillRtgRect 13
#define CMD_FillRtgRectRGB 14
#define CMD_WriteRtgPixelArray 15
#define CMD_WriteRtgPixelRGBArray 16
#define CMD_CopyRtgPixelArray 17
#define CMD_DrawRtgLine 18
#define CMD_DrawRtgLineRGB 19
#define CMD_WaitRtgSwitch 20
#define CMD_WaitRtgBlit 21
#define CMD_RtgWaitTOF 22
#define CMD_RtgBlit 23
#define CMD_RtgBltClear 24
#define CMD_CallRtgC2P 25
#define CMD_RtgText 26
#define CMD_RtgSetFont 27
#define CMD_RtgClearPointer 28
#define CMD_RtgSetPointer 29
#define CMD_RtgSetTextMode 30
#define CMD_RtgOpenFont 31
#define CMD_RtgCloseFont 32
#define CMD_RtgSetTextModeRGB 33
#define CMD_RtgInitRDCMP 34
#define CMD_RtgWaitRDCMP 35
#define CMD_RtgGetMsg 36
#define CMD_RtgReplyMsg 37
#define CMD_RtgCheckVSync 38
#define CMD_RtgAllocSRList 39
#define CMD_FreeRtgSRList 40
#define CMD_RtgBestSR 41
#define CMD_CopyRtgBlit 42
#define CMD_RtgInitBob 43
#define CMD_CheckPPCCommand 44

#endif
