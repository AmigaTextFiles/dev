#ifndef _INCLUDE_PRAGMA_INTUITION_LIB_H
#define _INCLUDE_PRAGMA_INTUITION_LIB_H

#ifndef CLIB_INTUITION_PROTOS_H
#include <clib/intuition_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(IntuitionBase,0x01e,OpenIntuition())
#pragma amicall(IntuitionBase,0x024,Intuition(a0))
#pragma amicall(IntuitionBase,0x02a,AddGadget(a0,a1,d0))
#pragma amicall(IntuitionBase,0x030,ClearDMRequest(a0))
#pragma amicall(IntuitionBase,0x036,ClearMenuStrip(a0))
#pragma amicall(IntuitionBase,0x03c,ClearPointer(a0))
#pragma amicall(IntuitionBase,0x042,CloseScreen(a0))
#pragma amicall(IntuitionBase,0x048,CloseWindow(a0))
#pragma amicall(IntuitionBase,0x04e,CloseWorkBench())
#pragma amicall(IntuitionBase,0x054,CurrentTime(a0,a1))
#pragma amicall(IntuitionBase,0x05a,DisplayAlert(d0,a0,d1))
#pragma amicall(IntuitionBase,0x060,DisplayBeep(a0))
#pragma amicall(IntuitionBase,0x066,DoubleClick(d0,d1,d2,d3))
#pragma amicall(IntuitionBase,0x06c,DrawBorder(a0,a1,d0,d1))
#pragma amicall(IntuitionBase,0x072,DrawImage(a0,a1,d0,d1))
#pragma amicall(IntuitionBase,0x078,EndRequest(a0,a1))
#pragma amicall(IntuitionBase,0x07e,GetDefPrefs(a0,d0))
#pragma amicall(IntuitionBase,0x084,GetPrefs(a0,d0))
#pragma amicall(IntuitionBase,0x08a,InitRequester(a0))
#pragma amicall(IntuitionBase,0x090,ItemAddress(a0,d0))
#pragma amicall(IntuitionBase,0x096,ModifyIDCMP(a0,d0))
#pragma amicall(IntuitionBase,0x09c,ModifyProp(a0,a1,a2,d0,d1,d2,d3,d4))
#pragma amicall(IntuitionBase,0x0a2,MoveScreen(a0,d0,d1))
#pragma amicall(IntuitionBase,0x0a8,MoveWindow(a0,d0,d1))
#pragma amicall(IntuitionBase,0x0ae,OffGadget(a0,a1,a2))
#pragma amicall(IntuitionBase,0x0b4,OffMenu(a0,d0))
#pragma amicall(IntuitionBase,0x0ba,OnGadget(a0,a1,a2))
#pragma amicall(IntuitionBase,0x0c0,OnMenu(a0,d0))
#pragma amicall(IntuitionBase,0x0c6,OpenScreen(a0))
#pragma amicall(IntuitionBase,0x0cc,OpenWindow(a0))
#pragma amicall(IntuitionBase,0x0d2,OpenWorkBench())
#pragma amicall(IntuitionBase,0x0d8,PrintIText(a0,a1,d0,d1))
#pragma amicall(IntuitionBase,0x0de,RefreshGadgets(a0,a1,a2))
#pragma amicall(IntuitionBase,0x0e4,RemoveGadget(a0,a1))
#pragma amicall(IntuitionBase,0x0ea,ReportMouse(d0,a0))
#pragma amicall(IntuitionBase,0x0ea,ReportMouse1(d0,a0))
#pragma amicall(IntuitionBase,0x0f0,Request(a0,a1))
#pragma amicall(IntuitionBase,0x0f6,ScreenToBack(a0))
#pragma amicall(IntuitionBase,0x0fc,ScreenToFront(a0))
#pragma amicall(IntuitionBase,0x102,SetDMRequest(a0,a1))
#pragma amicall(IntuitionBase,0x108,SetMenuStrip(a0,a1))
#pragma amicall(IntuitionBase,0x10e,SetPointer(a0,a1,d0,d1,d2,d3))
#pragma amicall(IntuitionBase,0x114,SetWindowTitles(a0,a1,a2))
#pragma amicall(IntuitionBase,0x11a,ShowTitle(a0,d0))
#pragma amicall(IntuitionBase,0x120,SizeWindow(a0,d0,d1))
#pragma amicall(IntuitionBase,0x126,ViewAddress())
#pragma amicall(IntuitionBase,0x12c,ViewPortAddress(a0))
#pragma amicall(IntuitionBase,0x132,WindowToBack(a0))
#pragma amicall(IntuitionBase,0x138,WindowToFront(a0))
#pragma amicall(IntuitionBase,0x13e,WindowLimits(a0,d0,d1,d2,d3))
#pragma amicall(IntuitionBase,0x144,SetPrefs(a0,d0,d1))
#pragma amicall(IntuitionBase,0x14a,IntuiTextLength(a0))
#pragma amicall(IntuitionBase,0x150,WBenchToBack())
#pragma amicall(IntuitionBase,0x156,WBenchToFront())
#pragma amicall(IntuitionBase,0x15c,AutoRequest(a0,a1,a2,a3,d0,d1,d2,d3))
#pragma amicall(IntuitionBase,0x162,BeginRefresh(a0))
#pragma amicall(IntuitionBase,0x168,BuildSysRequest(a0,a1,a2,a3,d0,d1,d2))
#pragma amicall(IntuitionBase,0x16e,EndRefresh(a0,d0))
#pragma amicall(IntuitionBase,0x174,FreeSysRequest(a0))
#pragma amicall(IntuitionBase,0x17a,MakeScreen(a0))
#pragma amicall(IntuitionBase,0x180,RemakeDisplay())
#pragma amicall(IntuitionBase,0x186,RethinkDisplay())
#pragma amicall(IntuitionBase,0x18c,AllocRemember(a0,d0,d1))
#pragma amicall(IntuitionBase,0x198,FreeRemember(a0,d0))
#pragma amicall(IntuitionBase,0x19e,LockIBase(d0))
#pragma amicall(IntuitionBase,0x1a4,UnlockIBase(a0))
#pragma amicall(IntuitionBase,0x1aa,GetScreenData(a0,d0,d1,a1))
#pragma amicall(IntuitionBase,0x1b0,RefreshGList(a0,a1,a2,d0))
#pragma amicall(IntuitionBase,0x1b6,AddGList(a0,a1,d0,d1,a2))
#pragma amicall(IntuitionBase,0x1bc,RemoveGList(a0,a1,d0))
#pragma amicall(IntuitionBase,0x1c2,ActivateWindow(a0))
#pragma amicall(IntuitionBase,0x1c8,RefreshWindowFrame(a0))
#pragma amicall(IntuitionBase,0x1ce,ActivateGadget(a0,a1,a2))
#pragma amicall(IntuitionBase,0x1d4,NewModifyProp(a0,a1,a2,d0,d1,d2,d3,d4,d5))
#pragma amicall(IntuitionBase,0x1da,QueryOverscan(a0,a1,d0))
#pragma amicall(IntuitionBase,0x1e0,MoveWindowInFrontOf(a0,a1))
#pragma amicall(IntuitionBase,0x1e6,ChangeWindowBox(a0,d0,d1,d2,d3))
#pragma amicall(IntuitionBase,0x1ec,SetEditHook(a0))
#pragma amicall(IntuitionBase,0x1f2,SetMouseQueue(a0,d0))
#pragma amicall(IntuitionBase,0x1f8,ZipWindow(a0))
#pragma amicall(IntuitionBase,0x1fe,LockPubScreen(a0))
#pragma amicall(IntuitionBase,0x204,UnlockPubScreen(a0,a1))
#pragma amicall(IntuitionBase,0x20a,LockPubScreenList())
#pragma amicall(IntuitionBase,0x210,UnlockPubScreenList())
#pragma amicall(IntuitionBase,0x216,NextPubScreen(a0,a1))
#pragma amicall(IntuitionBase,0x21c,SetDefaultPubScreen(a0))
#pragma amicall(IntuitionBase,0x222,SetPubScreenModes(d0))
#pragma amicall(IntuitionBase,0x228,PubScreenStatus(a0,d0))
#pragma amicall(IntuitionBase,0x22e,ObtainGIRPort(a0))
#pragma amicall(IntuitionBase,0x234,ReleaseGIRPort(a0))
#pragma amicall(IntuitionBase,0x23a,GadgetMouse(a0,a1,a2))
#pragma amicall(IntuitionBase,0x246,GetDefaultPubScreen(a0))
#pragma amicall(IntuitionBase,0x24c,EasyRequestArgs(a0,a1,a2,a3))
#pragma amicall(IntuitionBase,0x252,BuildEasyRequestArgs(a0,a1,d0,a3))
#pragma amicall(IntuitionBase,0x258,SysReqHandler(a0,a1,d0))
#pragma amicall(IntuitionBase,0x25e,OpenWindowTagList(a0,a1))
#pragma amicall(IntuitionBase,0x264,OpenScreenTagList(a0,a1))
#pragma amicall(IntuitionBase,0x26a,DrawImageState(a0,a1,d0,d1,d2,a2))
#pragma amicall(IntuitionBase,0x270,PointInImage(d0,a0))
#pragma amicall(IntuitionBase,0x276,EraseImage(a0,a1,d0,d1))
#pragma amicall(IntuitionBase,0x27c,NewObjectA(a0,a1,a2))
#pragma amicall(IntuitionBase,0x282,DisposeObject(a0))
#pragma amicall(IntuitionBase,0x288,SetAttrsA(a0,a1))
#pragma amicall(IntuitionBase,0x28e,GetAttr(d0,a0,a1))
#pragma amicall(IntuitionBase,0x294,SetGadgetAttrsA(a0,a1,a2,a3))
#pragma amicall(IntuitionBase,0x29a,NextObject(a0))
#pragma amicall(IntuitionBase,0x2a6,MakeClass(a0,a1,a2,d0,d1))
#pragma amicall(IntuitionBase,0x2ac,AddClass(a0))
#pragma amicall(IntuitionBase,0x2b2,GetScreenDrawInfo(a0))
#pragma amicall(IntuitionBase,0x2b8,FreeScreenDrawInfo(a0,a1))
#pragma amicall(IntuitionBase,0x2be,ResetMenuStrip(a0,a1))
#pragma amicall(IntuitionBase,0x2c4,RemoveClass(a0))
#pragma amicall(IntuitionBase,0x2ca,FreeClass(a0))
#pragma amicall(IntuitionBase,0x300,AllocScreenBuffer(a0,a1,d0))
#pragma amicall(IntuitionBase,0x306,FreeScreenBuffer(a0,a1))
#pragma amicall(IntuitionBase,0x30c,ChangeScreenBuffer(a0,a1))
#pragma amicall(IntuitionBase,0x312,ScreenDepth(a0,d0,a1))
#pragma amicall(IntuitionBase,0x318,ScreenPosition(a0,d0,d1,d2,d3,d4))
#pragma amicall(IntuitionBase,0x31e,ScrollWindowRaster(a1,d0,d1,d2,d3,d4,d5))
#pragma amicall(IntuitionBase,0x324,LendMenus(a0,a1))
#pragma amicall(IntuitionBase,0x32a,DoGadgetMethodA(a0,a1,a2,a3))
#pragma amicall(IntuitionBase,0x330,SetWindowPointerA(a0,a1))
#pragma amicall(IntuitionBase,0x336,TimedDisplayAlert(d0,a0,d1,a1))
#pragma amicall(IntuitionBase,0x33c,HelpControl(a0,d0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall IntuitionBase OpenIntuition          01e 00
#pragma  libcall IntuitionBase Intuition              024 801
#pragma  libcall IntuitionBase AddGadget              02a 09803
#pragma  libcall IntuitionBase ClearDMRequest         030 801
#pragma  libcall IntuitionBase ClearMenuStrip         036 801
#pragma  libcall IntuitionBase ClearPointer           03c 801
#pragma  libcall IntuitionBase CloseScreen            042 801
#pragma  libcall IntuitionBase CloseWindow            048 801
#pragma  libcall IntuitionBase CloseWorkBench         04e 00
#pragma  libcall IntuitionBase CurrentTime            054 9802
#pragma  libcall IntuitionBase DisplayAlert           05a 18003
#pragma  libcall IntuitionBase DisplayBeep            060 801
#pragma  libcall IntuitionBase DoubleClick            066 321004
#pragma  libcall IntuitionBase DrawBorder             06c 109804
#pragma  libcall IntuitionBase DrawImage              072 109804
#pragma  libcall IntuitionBase EndRequest             078 9802
#pragma  libcall IntuitionBase GetDefPrefs            07e 0802
#pragma  libcall IntuitionBase GetPrefs               084 0802
#pragma  libcall IntuitionBase InitRequester          08a 801
#pragma  libcall IntuitionBase ItemAddress            090 0802
#pragma  libcall IntuitionBase ModifyIDCMP            096 0802
#pragma  libcall IntuitionBase ModifyProp             09c 43210a9808
#pragma  libcall IntuitionBase MoveScreen             0a2 10803
#pragma  libcall IntuitionBase MoveWindow             0a8 10803
#pragma  libcall IntuitionBase OffGadget              0ae a9803
#pragma  libcall IntuitionBase OffMenu                0b4 0802
#pragma  libcall IntuitionBase OnGadget               0ba a9803
#pragma  libcall IntuitionBase OnMenu                 0c0 0802
#pragma  libcall IntuitionBase OpenScreen             0c6 801
#pragma  libcall IntuitionBase OpenWindow             0cc 801
#pragma  libcall IntuitionBase OpenWorkBench          0d2 00
#pragma  libcall IntuitionBase PrintIText             0d8 109804
#pragma  libcall IntuitionBase RefreshGadgets         0de a9803
#pragma  libcall IntuitionBase RemoveGadget           0e4 9802
#pragma  libcall IntuitionBase ReportMouse            0ea 8002
#pragma  libcall IntuitionBase ReportMouse1           0ea 8002
#pragma  libcall IntuitionBase Request                0f0 9802
#pragma  libcall IntuitionBase ScreenToBack           0f6 801
#pragma  libcall IntuitionBase ScreenToFront          0fc 801
#pragma  libcall IntuitionBase SetDMRequest           102 9802
#pragma  libcall IntuitionBase SetMenuStrip           108 9802
#pragma  libcall IntuitionBase SetPointer             10e 32109806
#pragma  libcall IntuitionBase SetWindowTitles        114 a9803
#pragma  libcall IntuitionBase ShowTitle              11a 0802
#pragma  libcall IntuitionBase SizeWindow             120 10803
#pragma  libcall IntuitionBase ViewAddress            126 00
#pragma  libcall IntuitionBase ViewPortAddress        12c 801
#pragma  libcall IntuitionBase WindowToBack           132 801
#pragma  libcall IntuitionBase WindowToFront          138 801
#pragma  libcall IntuitionBase WindowLimits           13e 3210805
#pragma  libcall IntuitionBase SetPrefs               144 10803
#pragma  libcall IntuitionBase IntuiTextLength        14a 801
#pragma  libcall IntuitionBase WBenchToBack           150 00
#pragma  libcall IntuitionBase WBenchToFront          156 00
#pragma  libcall IntuitionBase AutoRequest            15c 3210ba9808
#pragma  libcall IntuitionBase BeginRefresh           162 801
#pragma  libcall IntuitionBase BuildSysRequest        168 210ba9807
#pragma  libcall IntuitionBase EndRefresh             16e 0802
#pragma  libcall IntuitionBase FreeSysRequest         174 801
#pragma  libcall IntuitionBase MakeScreen             17a 801
#pragma  libcall IntuitionBase RemakeDisplay          180 00
#pragma  libcall IntuitionBase RethinkDisplay         186 00
#pragma  libcall IntuitionBase AllocRemember          18c 10803
#pragma  libcall IntuitionBase FreeRemember           198 0802
#pragma  libcall IntuitionBase LockIBase              19e 001
#pragma  libcall IntuitionBase UnlockIBase            1a4 801
#pragma  libcall IntuitionBase GetScreenData          1aa 910804
#pragma  libcall IntuitionBase RefreshGList           1b0 0a9804
#pragma  libcall IntuitionBase AddGList               1b6 a109805
#pragma  libcall IntuitionBase RemoveGList            1bc 09803
#pragma  libcall IntuitionBase ActivateWindow         1c2 801
#pragma  libcall IntuitionBase RefreshWindowFrame     1c8 801
#pragma  libcall IntuitionBase ActivateGadget         1ce a9803
#pragma  libcall IntuitionBase NewModifyProp          1d4 543210a9809
#pragma  libcall IntuitionBase QueryOverscan          1da 09803
#pragma  libcall IntuitionBase MoveWindowInFrontOf    1e0 9802
#pragma  libcall IntuitionBase ChangeWindowBox        1e6 3210805
#pragma  libcall IntuitionBase SetEditHook            1ec 801
#pragma  libcall IntuitionBase SetMouseQueue          1f2 0802
#pragma  libcall IntuitionBase ZipWindow              1f8 801
#pragma  libcall IntuitionBase LockPubScreen          1fe 801
#pragma  libcall IntuitionBase UnlockPubScreen        204 9802
#pragma  libcall IntuitionBase LockPubScreenList      20a 00
#pragma  libcall IntuitionBase UnlockPubScreenList    210 00
#pragma  libcall IntuitionBase NextPubScreen          216 9802
#pragma  libcall IntuitionBase SetDefaultPubScreen    21c 801
#pragma  libcall IntuitionBase SetPubScreenModes      222 001
#pragma  libcall IntuitionBase PubScreenStatus        228 0802
#pragma  libcall IntuitionBase ObtainGIRPort          22e 801
#pragma  libcall IntuitionBase ReleaseGIRPort         234 801
#pragma  libcall IntuitionBase GadgetMouse            23a a9803
#pragma  libcall IntuitionBase GetDefaultPubScreen    246 801
#pragma  libcall IntuitionBase EasyRequestArgs        24c ba9804
#pragma  libcall IntuitionBase BuildEasyRequestArgs   252 b09804
#pragma  libcall IntuitionBase SysReqHandler          258 09803
#pragma  libcall IntuitionBase OpenWindowTagList      25e 9802
#pragma  libcall IntuitionBase OpenScreenTagList      264 9802
#pragma  libcall IntuitionBase DrawImageState         26a a2109806
#pragma  libcall IntuitionBase PointInImage           270 8002
#pragma  libcall IntuitionBase EraseImage             276 109804
#pragma  libcall IntuitionBase NewObjectA             27c a9803
#pragma  libcall IntuitionBase DisposeObject          282 801
#pragma  libcall IntuitionBase SetAttrsA              288 9802
#pragma  libcall IntuitionBase GetAttr                28e 98003
#pragma  libcall IntuitionBase SetGadgetAttrsA        294 ba9804
#pragma  libcall IntuitionBase NextObject             29a 801
#pragma  libcall IntuitionBase MakeClass              2a6 10a9805
#pragma  libcall IntuitionBase AddClass               2ac 801
#pragma  libcall IntuitionBase GetScreenDrawInfo      2b2 801
#pragma  libcall IntuitionBase FreeScreenDrawInfo     2b8 9802
#pragma  libcall IntuitionBase ResetMenuStrip         2be 9802
#pragma  libcall IntuitionBase RemoveClass            2c4 801
#pragma  libcall IntuitionBase FreeClass              2ca 801
#pragma  libcall IntuitionBase AllocScreenBuffer      300 09803
#pragma  libcall IntuitionBase FreeScreenBuffer       306 9802
#pragma  libcall IntuitionBase ChangeScreenBuffer     30c 9802
#pragma  libcall IntuitionBase ScreenDepth            312 90803
#pragma  libcall IntuitionBase ScreenPosition         318 43210806
#pragma  libcall IntuitionBase ScrollWindowRaster     31e 543210907
#pragma  libcall IntuitionBase LendMenus              324 9802
#pragma  libcall IntuitionBase DoGadgetMethodA        32a ba9804
#pragma  libcall IntuitionBase SetWindowPointerA      330 9802
#pragma  libcall IntuitionBase TimedDisplayAlert      336 918004
#pragma  libcall IntuitionBase HelpControl            33c 0802
#endif
#ifdef __STORM__
#pragma tagcall(IntuitionBase,0x24c,EasyRequest(a0,a1,a2,a3))
#pragma tagcall(IntuitionBase,0x252,BuildEasyRequest(a0,a1,d0,a3))
#pragma tagcall(IntuitionBase,0x25e,OpenWindowTags(a0,a1))
#pragma tagcall(IntuitionBase,0x264,OpenScreenTags(a0,a1))
#pragma tagcall(IntuitionBase,0x27c,NewObject(a0,a1,a2))
#pragma tagcall(IntuitionBase,0x288,SetAttrs(a0,a1))
#pragma tagcall(IntuitionBase,0x294,SetGadgetAttrs(a0,a1,a2,a3))
#pragma tagcall(IntuitionBase,0x32a,DoGadgetMethod(a0,a1,a2,a3))
#pragma tagcall(IntuitionBase,0x330,SetWindowPointer(a0,a1))
#endif
#ifdef __SASC_60
#pragma  tagcall IntuitionBase EasyRequest            24c ba9804
#pragma  tagcall IntuitionBase BuildEasyRequest       252 b09804
#pragma  tagcall IntuitionBase OpenWindowTags         25e 9802
#pragma  tagcall IntuitionBase OpenScreenTags         264 9802
#pragma  tagcall IntuitionBase NewObject              27c a9803
#pragma  tagcall IntuitionBase SetAttrs               288 9802
#pragma  tagcall IntuitionBase SetGadgetAttrs         294 ba9804
#pragma  tagcall IntuitionBase DoGadgetMethod         32a ba9804
#pragma  tagcall IntuitionBase SetWindowPointer       330 9802
#endif

#endif	/*  _INCLUDE_PRAGMA_INTUITION_LIB_H  */
