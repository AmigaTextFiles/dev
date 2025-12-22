#ifndef GTX_PRAGMAS_H
#define GTX_PRAGMAS_H   1
/*
**      $VER: gtx_pragmas.h 39.1 (12.4.93)
**      GTXLib headers release 2.0.
**
**      gadtoolsbox.library pragma definitions.
**
**      (C) Copyright 1992-1993 Jaba Development.
**          Written by Jan van den Baard
**/

#ifdef AZTEC_C
#pragma amicall(GTXBase, 0x1e, GTX_TagInArray(d0,a0))
#pragma amicall(GTXBase, 0x24, GTX_SetTagData(d0,d1,a0))
#pragma amicall(GTXBase, 0x2a, GTX_GetNode(a0,d0))
#pragma amicall(GTXBase, 0x30, GTX_GetNodeNumber(a0,a1))
#pragma amicall(GTXBase, 0x36, GTX_CountNodes(a0))
#pragma amicall(GTXBase, 0x3c, GTX_MoveNode(a0,a1,d0))
#pragma amicall(GTXBase, 0x42, GTX_IFFErrToStr(d0,d1))
#pragma amicall(GTXBase, 0x48, GTX_GetHandleA(a0))
#pragma amicall(GTXBase, 0x4e, GTX_FreeHandle(a0))
#pragma amicall(GTXBase, 0x54, GTX_RefreshWindow(a0,a1,a2))
#pragma amicall(GTXBase, 0x5a, GTX_CreateGadgetA(a0,d0,a1,a2,a3))
#pragma amicall(GTXBase, 0x60, GTX_RawToVanilla(a0,d0,d1))
#pragma amicall(GTXBase, 0x66, GTX_GetIMsg(a0,a1))
#pragma amicall(GTXBase, 0x6c, GTX_ReplyIMsg(a0,a1))
#pragma amicall(GTXBase, 0x72, GTX_SetGadgetAttrsA(a0,a1,a2))
#pragma amicall(GTXBase, 0x78, GTX_DetachLabels(a0,a1))
#pragma amicall(GTXBase, 0x7e, GTX_DrawBox(a0,d0,d1,d2,d3,a1,d4))
#pragma amicall(GTXBase, 0x84, GTX_InitTextClass())
#pragma amicall(GTXBase, 0x8a, GTX_InitGetFileClass())
#pragma amicall(GTXBase, 0x90, GTX_SetHandleAttrsA(a0,a1))
#pragma amicall(GTXBase, 0x96, GTX_BeginRefresh(a0))
#pragma amicall(GTXBase, 0x9c, GTX_EndRefresh(a0,d0))
#pragma amicall(GTXBase, 0xe4, GTX_FreeWindows(a0,a1))
#pragma amicall(GTXBase, 0xea, GTX_LoadGUIA(a0,a1,a2))
#else
#pragma libcall GTXBase GTX_TagInArray 1e 8002
#pragma libcall GTXBase GTX_SetTagData 24 81003
#pragma libcall GTXBase GTX_GetNode 2a 802
#pragma libcall GTXBase GTX_GetNodeNumber 30 9802
#pragma libcall GTXBase GTX_CountNodes 36 801
#pragma libcall GTXBase GTX_MoveNode 3c 9803
#pragma libcall GTXBase GTX_IFFErrToStr 42 1002
#pragma libcall GTXBase GTX_GetHandleA 48 801
#pragma libcall GTXBase GTX_FreeHandle 4e 801
#pragma libcall GTXBase GTX_RefreshWindow 54 a9803
#pragma libcall GTXBase GTX_CreateGadgetA 5a ba90805
#pragma libcall GTXBase GTX_RawToVanilla 60 10803
#pragma libcall GTXBase GTX_GetIMsg 66 9802
#pragma libcall GTXBase GTX_ReplyIMsg 6c 9802
#pragma libcall GTXBase GTX_SetGadgetAttrsA 72 a9803
#pragma libcall GTXBase GTX_DetachLabels 78 9802
#pragma libcall GTXBase GTX_DrawBox 7e 493210807
#pragma libcall GTXBase GTX_InitTextClass 84 0
#pragma libcall GTXBase GTX_InitGetFileClass 8a 0
#pragma libcall GTXBase GTX_SetHandleAttrsA 90 9802
#pragma libcall GTXBase GTX_BeginRefresh 96 801
#pragma libcall GTXBase GTX_EndRefresh 9c 802
#pragma libcall GTXBase GTX_FreeWindows e4 9802
#pragma libcall GTXBase GTX_LoadGUIA ea a9803
#endif

#endif
