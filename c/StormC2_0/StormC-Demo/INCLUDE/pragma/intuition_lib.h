#ifndef _INCLUDE_PRAGMA_INTUITION_LIB_H
#define _INCLUDE_PRAGMA_INTUITION_LIB_H

/*
**  $VER: intuition_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_INTUITION_PROTOS_H
#include <clib/intuition_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(IntuitionBase, 0x1e, OpenIntuition())
#pragma amicall(IntuitionBase, 0x24, Intuition(a0))
#pragma amicall(IntuitionBase, 0x2a, AddGadget(a0,a1,d0))
#pragma amicall(IntuitionBase, 0x30, ClearDMRequest(a0))
#pragma amicall(IntuitionBase, 0x36, ClearMenuStrip(a0))
#pragma amicall(IntuitionBase, 0x3c, ClearPointer(a0))
#pragma amicall(IntuitionBase, 0x42, CloseScreen(a0))
#pragma amicall(IntuitionBase, 0x48, CloseWindow(a0))
#pragma amicall(IntuitionBase, 0x4e, CloseWorkBench())
#pragma amicall(IntuitionBase, 0x54, CurrentTime(a0,a1))
#pragma amicall(IntuitionBase, 0x5a, DisplayAlert(d0,a0,d1))
#pragma amicall(IntuitionBase, 0x60, DisplayBeep(a0))
#pragma amicall(IntuitionBase, 0x66, DoubleClick(d0,d1,d2,d3))
#pragma amicall(IntuitionBase, 0x6c, DrawBorder(a0,a1,d0,d1))
#pragma amicall(IntuitionBase, 0x72, DrawImage(a0,a1,d0,d1))
#pragma amicall(IntuitionBase, 0x78, EndRequest(a0,a1))
#pragma amicall(IntuitionBase, 0x7e, GetDefPrefs(a0,d0))
#pragma amicall(IntuitionBase, 0x84, GetPrefs(a0,d0))
#pragma amicall(IntuitionBase, 0x8a, InitRequester(a0))
#pragma amicall(IntuitionBase, 0x90, ItemAddress(a0,d0))
#pragma amicall(IntuitionBase, 0x96, ModifyIDCMP(a0,d0))
#pragma amicall(IntuitionBase, 0x9c, ModifyProp(a0,a1,a2,d0,d1,d2,d3,d4))
#pragma amicall(IntuitionBase, 0xa2, MoveScreen(a0,d0,d1))
#pragma amicall(IntuitionBase, 0xa8, MoveWindow(a0,d0,d1))
#pragma amicall(IntuitionBase, 0xae, OffGadget(a0,a1,a2))
#pragma amicall(IntuitionBase, 0xb4, OffMenu(a0,d0))
#pragma amicall(IntuitionBase, 0xba, OnGadget(a0,a1,a2))
#pragma amicall(IntuitionBase, 0xc0, OnMenu(a0,d0))
#pragma amicall(IntuitionBase, 0xc6, OpenScreen(a0))
#pragma amicall(IntuitionBase, 0xcc, OpenWindow(a0))
#pragma amicall(IntuitionBase, 0xd2, OpenWorkBench())
#pragma amicall(IntuitionBase, 0xd8, PrintIText(a0,a1,d0,d1))
#pragma amicall(IntuitionBase, 0xde, RefreshGadgets(a0,a1,a2))
#pragma amicall(IntuitionBase, 0xe4, RemoveGadget(a0,a1))
#pragma amicall(IntuitionBase, 0xea, ReportMouse(d0,a0))
#pragma amicall(IntuitionBase, 0xf0, Request(a0,a1))
#pragma amicall(IntuitionBase, 0xf6, ScreenToBack(a0))
#pragma amicall(IntuitionBase, 0xfc, ScreenToFront(a0))
#pragma amicall(IntuitionBase, 0x102, SetDMRequest(a0,a1))
#pragma amicall(IntuitionBase, 0x108, SetMenuStrip(a0,a1))
#pragma amicall(IntuitionBase, 0x10e, SetPointer(a0,a1,d0,d1,d2,d3))
#pragma amicall(IntuitionBase, 0x114, SetWindowTitles(a0,a1,a2))
#pragma amicall(IntuitionBase, 0x11a, ShowTitle(a0,d0))
#pragma amicall(IntuitionBase, 0x120, SizeWindow(a0,d0,d1))
#pragma amicall(IntuitionBase, 0x126, ViewAddress())
#pragma amicall(IntuitionBase, 0x12c, ViewPortAddress(a0))
#pragma amicall(IntuitionBase, 0x132, WindowToBack(a0))
#pragma amicall(IntuitionBase, 0x138, WindowToFront(a0))
#pragma amicall(IntuitionBase, 0x13e, WindowLimits(a0,d0,d1,d2,d3))
#pragma amicall(IntuitionBase, 0x144, SetPrefs(a0,d0,d1))
#pragma amicall(IntuitionBase, 0x14a, IntuiTextLength(a0))
#pragma amicall(IntuitionBase, 0x150, WBenchToBack())
#pragma amicall(IntuitionBase, 0x156, WBenchToFront())
#pragma amicall(IntuitionBase, 0x15c, AutoRequest(a0,a1,a2,a3,d0,d1,d2,d3))
#pragma amicall(IntuitionBase, 0x162, BeginRefresh(a0))
#pragma amicall(IntuitionBase, 0x168, BuildSysRequest(a0,a1,a2,a3,d0,d1,d2))
#pragma amicall(IntuitionBase, 0x16e, EndRefresh(a0,d0))
#pragma amicall(IntuitionBase, 0x174, FreeSysRequest(a0))
#pragma amicall(IntuitionBase, 0x17a, MakeScreen(a0))
#pragma amicall(IntuitionBase, 0x180, RemakeDisplay())
#pragma amicall(IntuitionBase, 0x186, RethinkDisplay())
#pragma amicall(IntuitionBase, 0x18c, AllocRemember(a0,d0,d1))
#pragma amicall(IntuitionBase, 0x192, AlohaWorkbench(a0))
#pragma amicall(IntuitionBase, 0x198, FreeRemember(a0,d0))
#pragma amicall(IntuitionBase, 0x19e, LockIBase(d0))
#pragma amicall(IntuitionBase, 0x1a4, UnlockIBase(a0))
#pragma amicall(IntuitionBase, 0x1aa, GetScreenData(a0,d0,d1,a1))
#pragma amicall(IntuitionBase, 0x1b0, RefreshGList(a0,a1,a2,d0))
#pragma amicall(IntuitionBase, 0x1b6, AddGList(a0,a1,d0,d1,a2))
#pragma amicall(IntuitionBase, 0x1bc, RemoveGList(a0,a1,d0))
#pragma amicall(IntuitionBase, 0x1c2, ActivateWindow(a0))
#pragma amicall(IntuitionBase, 0x1c8, RefreshWindowFrame(a0))
#pragma amicall(IntuitionBase, 0x1ce, ActivateGadget(a0,a1,a2))
#pragma amicall(IntuitionBase, 0x1d4, NewModifyProp(a0,a1,a2,d0,d1,d2,d3,d4,d5))
#pragma amicall(IntuitionBase, 0x1da, QueryOverscan(a0,a1,d0))
#pragma amicall(IntuitionBase, 0x1e0, MoveWindowInFrontOf(a0,a1))
#pragma amicall(IntuitionBase, 0x1e6, ChangeWindowBox(a0,d0,d1,d2,d3))
#pragma amicall(IntuitionBase, 0x1ec, SetEditHook(a0))
#pragma amicall(IntuitionBase, 0x1f2, SetMouseQueue(a0,d0))
#pragma amicall(IntuitionBase, 0x1f8, ZipWindow(a0))
#pragma amicall(IntuitionBase, 0x1fe, LockPubScreen(a0))
#pragma amicall(IntuitionBase, 0x204, UnlockPubScreen(a0,a1))
#pragma amicall(IntuitionBase, 0x20a, LockPubScreenList())
#pragma amicall(IntuitionBase, 0x210, UnlockPubScreenList())
#pragma amicall(IntuitionBase, 0x216, NextPubScreen(a0,a1))
#pragma amicall(IntuitionBase, 0x21c, SetDefaultPubScreen(a0))
#pragma amicall(IntuitionBase, 0x222, SetPubScreenModes(d0))
#pragma amicall(IntuitionBase, 0x228, PubScreenStatus(a0,d0))
#pragma amicall(IntuitionBase, 0x22e, ObtainGIRPort(a0))
#pragma amicall(IntuitionBase, 0x234, ReleaseGIRPort(a0))
#pragma amicall(IntuitionBase, 0x23a, GadgetMouse(a0,a1,a2))
#pragma amicall(IntuitionBase, 0x246, GetDefaultPubScreen(a0))
#pragma amicall(IntuitionBase, 0x24c, EasyRequestArgs(a0,a1,a2,a3))
#pragma tagcall(IntuitionBase, 0x24c, EasyRequest(a0,a1,a2,a3)) // New
#pragma amicall(IntuitionBase, 0x252, BuildEasyRequestArgs(a0,a1,d0,a3))
#pragma tagcall(IntuitionBase, 0x252, BuildEasyRequest(a0,a1,d0,a3)) // New
#pragma amicall(IntuitionBase, 0x258, SysReqHandler(a0,a1,d0))
#pragma amicall(IntuitionBase, 0x25e, OpenWindowTagList(a0,a1))
#pragma tagcall(IntuitionBase, 0x25e, OpenWindowTags(a0,a1)) // New
#pragma amicall(IntuitionBase, 0x264, OpenScreenTagList(a0,a1))
#pragma tagcall(IntuitionBase, 0x264, OpenScreenTags(a0,a1)) // New
#pragma amicall(IntuitionBase, 0x26a, DrawImageState(a0,a1,d0,d1,d2,a2))
#pragma amicall(IntuitionBase, 0x270, PointInImage(d0,a0))
#pragma amicall(IntuitionBase, 0x276, EraseImage(a0,a1,d0,d1))
#pragma amicall(IntuitionBase, 0x27c, NewObjectA(a0,a1,a2))
#pragma tagcall(IntuitionBase, 0x27c, NewObject(a0,a1,a2)) // New
#pragma amicall(IntuitionBase, 0x282, DisposeObject(a0))
#pragma amicall(IntuitionBase, 0x288, SetAttrsA(a0,a1))
#pragma tagcall(IntuitionBase, 0x288, SetAttrs(a0,a1)) // New
#pragma amicall(IntuitionBase, 0x28e, GetAttr(d0,a0,a1))
#pragma amicall(IntuitionBase, 0x294, SetGadgetAttrsA(a0,a1,a2,a3))
#pragma tagcall(IntuitionBase, 0x294, SetGadgetAttrs(a0,a1,a2,a3)) // New
#pragma amicall(IntuitionBase, 0x29a, NextObject(a0))
#pragma amicall(IntuitionBase, 0x2a6, MakeClass(a0,a1,a2,d0,d1))
#pragma amicall(IntuitionBase, 0x2ac, AddClass(a0))
#pragma amicall(IntuitionBase, 0x2b2, GetScreenDrawInfo(a0))
#pragma amicall(IntuitionBase, 0x2b8, FreeScreenDrawInfo(a0,a1))
#pragma amicall(IntuitionBase, 0x2be, ResetMenuStrip(a0,a1))
#pragma amicall(IntuitionBase, 0x2c4, RemoveClass(a0))
#pragma amicall(IntuitionBase, 0x2ca, FreeClass(a0))
#pragma amicall(IntuitionBase, 0x300, AllocScreenBuffer(a0,a1,d0))
#pragma amicall(IntuitionBase, 0x306, FreeScreenBuffer(a0,a1))
#pragma amicall(IntuitionBase, 0x30c, ChangeScreenBuffer(a0,a1))
#pragma amicall(IntuitionBase, 0x312, ScreenDepth(a0,d0,a1))
#pragma amicall(IntuitionBase, 0x318, ScreenPosition(a0,d0,d1,d2,d3,d4))
#pragma amicall(IntuitionBase, 0x31e, ScrollWindowRaster(a1,d0,d1,d2,d3,d4,d5))
#pragma amicall(IntuitionBase, 0x324, LendMenus(a0,a1))
#pragma amicall(IntuitionBase, 0x32a, DoGadgetMethodA(a0,a1,a2,a3))
#pragma tagcall(IntuitionBase, 0x32a, DoGadgetMethod(a0,a1,a2,a3)) // New
#pragma amicall(IntuitionBase, 0x330, SetWindowPointerA(a0,a1))
#pragma tagcall(IntuitionBase, 0x330, SetWindowPointer(a0,a1)) // New
#pragma amicall(IntuitionBase, 0x336, TimedDisplayAlert(d0,a0,d1,a1))
#pragma amicall(IntuitionBase, 0x33c, HelpControl(a0,d0))

#ifdef __cplusplus
}
#endif

#endif
