#ifndef _INLINE_INTUITION_H
#define _INLINE_INTUITION_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef INTUITION_BASE_NAME
#define INTUITION_BASE_NAME IntuitionBase
#endif

#define OpenIntuition() \
	LP0NR(0x1e, OpenIntuition, \
	, INTUITION_BASE_NAME)

#define Intuition(iEvent) \
	LP1NR(0x24, Intuition, struct InputEvent *, iEvent, a0, \
	, INTUITION_BASE_NAME)

#define AddGadget(window, gadget, position) \
	LP3(0x2a, UWORD, AddGadget, struct Window *, window, a0, struct Gadget *, gadget, a1, ULONG, position, d0, \
	, INTUITION_BASE_NAME)

#define ClearDMRequest(window) \
	LP1(0x30, BOOL, ClearDMRequest, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define ClearMenuStrip(window) \
	LP1NR(0x36, ClearMenuStrip, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define ClearPointer(window) \
	LP1NR(0x3c, ClearPointer, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define CloseScreen(screen) \
	LP1(0x42, BOOL, CloseScreen, struct Screen *, screen, a0, \
	, INTUITION_BASE_NAME)

#define CloseWindow(window) \
	LP1NR(0x48, CloseWindow, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define CloseWorkBench() \
	LP0(0x4e, LONG, CloseWorkBench, \
	, INTUITION_BASE_NAME)

#define CurrentTime(seconds, micros) \
	LP2NR(0x54, CurrentTime, ULONG *, seconds, a0, ULONG *, micros, a1, \
	, INTUITION_BASE_NAME)

#define DisplayAlert(alertNumber, string, height) \
	LP3(0x5a, BOOL, DisplayAlert, ULONG, alertNumber, d0, CONST_STRPTR, string, a0, ULONG, height, d1, \
	, INTUITION_BASE_NAME)

#define DisplayBeep(screen) \
	LP1NR(0x60, DisplayBeep, struct Screen *, screen, a0, \
	, INTUITION_BASE_NAME)

#define DoubleClick(sSeconds, sMicros, cSeconds, cMicros) \
	LP4(0x66, BOOL, DoubleClick, ULONG, sSeconds, d0, ULONG, sMicros, d1, ULONG, cSeconds, d2, ULONG, cMicros, d3, \
	, INTUITION_BASE_NAME)

#define DrawBorder(rp, border, leftOffset, topOffset) \
	LP4NR(0x6c, DrawBorder, struct RastPort *, rp, a0, const struct Border *, border, a1, LONG, leftOffset, d0, LONG, topOffset, d1, \
	, INTUITION_BASE_NAME)

#define DrawImage(rp, image, leftOffset, topOffset) \
	LP4NR(0x72, DrawImage, struct RastPort *, rp, a0, struct Image *, image, a1, LONG, leftOffset, d0, LONG, topOffset, d1, \
	, INTUITION_BASE_NAME)

#define EndRequest(requester, window) \
	LP2NR(0x78, EndRequest, struct Requester *, requester, a0, struct Window *, window, a1, \
	, INTUITION_BASE_NAME)

#define GetDefPrefs(preferences, size) \
	LP2(0x7e, struct Preferences *, GetDefPrefs, struct Preferences *, preferences, a0, LONG, size, d0, \
	, INTUITION_BASE_NAME)

#define GetPrefs(preferences, size) \
	LP2(0x84, struct Preferences *, GetPrefs, struct Preferences *, preferences, a0, LONG, size, d0, \
	, INTUITION_BASE_NAME)

#define InitRequester(requester) \
	LP1NR(0x8a, InitRequester, struct Requester *, requester, a0, \
	, INTUITION_BASE_NAME)

#define ItemAddress(menuStrip, menuNumber) \
	LP2(0x90, struct MenuItem *, ItemAddress, const struct Menu *, menuStrip, a0, ULONG, menuNumber, d0, \
	, INTUITION_BASE_NAME)

#define ModifyIDCMP(window, flags) \
	LP2(0x96, BOOL, ModifyIDCMP, struct Window *, window, a0, ULONG, flags, d0, \
	, INTUITION_BASE_NAME)

#define ModifyProp(gadget, window, requester, flags, horizPot, vertPot, horizBody, vertBody) \
	LP8NR(0x9c, ModifyProp, struct Gadget *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, ULONG, flags, d0, ULONG, horizPot, d1, ULONG, vertPot, d2, ULONG, horizBody, d3, ULONG, vertBody, d4, \
	, INTUITION_BASE_NAME)

#define MoveScreen(screen, dx, dy) \
	LP3NR(0xa2, MoveScreen, struct Screen *, screen, a0, LONG, dx, d0, LONG, dy, d1, \
	, INTUITION_BASE_NAME)

#define MoveWindow(window, dx, dy) \
	LP3NR(0xa8, MoveWindow, struct Window *, window, a0, LONG, dx, d0, LONG, dy, d1, \
	, INTUITION_BASE_NAME)

#define OffGadget(gadget, window, requester) \
	LP3NR(0xae, OffGadget, struct Gadget *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, \
	, INTUITION_BASE_NAME)

#define OffMenu(window, menuNumber) \
	LP2NR(0xb4, OffMenu, struct Window *, window, a0, ULONG, menuNumber, d0, \
	, INTUITION_BASE_NAME)

#define OnGadget(gadget, window, requester) \
	LP3NR(0xba, OnGadget, struct Gadget *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, \
	, INTUITION_BASE_NAME)

#define OnMenu(window, menuNumber) \
	LP2NR(0xc0, OnMenu, struct Window *, window, a0, ULONG, menuNumber, d0, \
	, INTUITION_BASE_NAME)

#define OpenScreen(newScreen) \
	LP1(0xc6, struct Screen *, OpenScreen, const struct NewScreen *, newScreen, a0, \
	, INTUITION_BASE_NAME)

#define OpenWindow(newWindow) \
	LP1(0xcc, struct Window *, OpenWindow, const struct NewWindow *, newWindow, a0, \
	, INTUITION_BASE_NAME)

#define OpenWorkBench() \
	LP0(0xd2, ULONG, OpenWorkBench, \
	, INTUITION_BASE_NAME)

#define PrintIText(rp, iText, left, top) \
	LP4NR(0xd8, PrintIText, struct RastPort *, rp, a0, const struct IntuiText *, iText, a1, LONG, left, d0, LONG, top, d1, \
	, INTUITION_BASE_NAME)

#define RefreshGadgets(gadgets, window, requester) \
	LP3NR(0xde, RefreshGadgets, struct Gadget *, gadgets, a0, struct Window *, window, a1, struct Requester *, requester, a2, \
	, INTUITION_BASE_NAME)

#define RemoveGadget(window, gadget) \
	LP2(0xe4, UWORD, RemoveGadget, struct Window *, window, a0, struct Gadget *, gadget, a1, \
	, INTUITION_BASE_NAME)

#define ReportMouse(flag, window) \
	LP2NR(0xea, ReportMouse, LONG, flag, d0, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define ReportMouse1(flag, window) ReportMouse((flag), (window))

#define Request(requester, window) \
	LP2(0xf0, BOOL, Request, struct Requester *, requester, a0, struct Window *, window, a1, \
	, INTUITION_BASE_NAME)

#define ScreenToBack(screen) \
	LP1NR(0xf6, ScreenToBack, struct Screen *, screen, a0, \
	, INTUITION_BASE_NAME)

#define ScreenToFront(screen) \
	LP1NR(0xfc, ScreenToFront, struct Screen *, screen, a0, \
	, INTUITION_BASE_NAME)

#define SetDMRequest(window, requester) \
	LP2(0x102, BOOL, SetDMRequest, struct Window *, window, a0, struct Requester *, requester, a1, \
	, INTUITION_BASE_NAME)

#define SetMenuStrip(window, menu) \
	LP2(0x108, BOOL, SetMenuStrip, struct Window *, window, a0, struct Menu *, menu, a1, \
	, INTUITION_BASE_NAME)

#define SetPointer(window, pointer, height, width, xOffset, yOffset) \
	LP6NR(0x10e, SetPointer, struct Window *, window, a0, UWORD *, pointer, a1, LONG, height, d0, LONG, width, d1, LONG, xOffset, d2, LONG, yOffset, d3, \
	, INTUITION_BASE_NAME)

#define SetWindowTitles(window, windowTitle, screenTitle) \
	LP3NR(0x114, SetWindowTitles, struct Window *, window, a0, CONST_STRPTR, windowTitle, a1, CONST_STRPTR, screenTitle, a2, \
	, INTUITION_BASE_NAME)

#define ShowTitle(screen, showIt) \
	LP2NR(0x11a, ShowTitle, struct Screen *, screen, a0, LONG, showIt, d0, \
	, INTUITION_BASE_NAME)

#define SizeWindow(window, dx, dy) \
	LP3NR(0x120, SizeWindow, struct Window *, window, a0, LONG, dx, d0, LONG, dy, d1, \
	, INTUITION_BASE_NAME)

#define ViewAddress() \
	LP0(0x126, struct View *, ViewAddress, \
	, INTUITION_BASE_NAME)

#define ViewPortAddress(window) \
	LP1(0x12c, struct ViewPort *, ViewPortAddress, const struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define WindowToBack(window) \
	LP1NR(0x132, WindowToBack, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define WindowToFront(window) \
	LP1NR(0x138, WindowToFront, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define WindowLimits(window, widthMin, heightMin, widthMax, heightMax) \
	LP5(0x13e, BOOL, WindowLimits, struct Window *, window, a0, LONG, widthMin, d0, LONG, heightMin, d1, ULONG, widthMax, d2, ULONG, heightMax, d3, \
	, INTUITION_BASE_NAME)

#define SetPrefs(preferences, size, inform) \
	LP3(0x144, struct Preferences  *, SetPrefs, const struct Preferences *, preferences, a0, LONG, size, d0, LONG, inform, d1, \
	, INTUITION_BASE_NAME)

#define IntuiTextLength(iText) \
	LP1(0x14a, LONG, IntuiTextLength, const struct IntuiText *, iText, a0, \
	, INTUITION_BASE_NAME)

#define WBenchToBack() \
	LP0(0x150, BOOL, WBenchToBack, \
	, INTUITION_BASE_NAME)

#define WBenchToFront() \
	LP0(0x156, BOOL, WBenchToFront, \
	, INTUITION_BASE_NAME)

#define AutoRequest(window, body, posText, negText, pFlag, nFlag, width, height) \
	LP8(0x15c, BOOL, AutoRequest, struct Window *, window, a0, const struct IntuiText *, body, a1, const struct IntuiText *, posText, a2, const struct IntuiText *, negText, a3, ULONG, pFlag, d0, ULONG, nFlag, d1, ULONG, width, d2, ULONG, height, d3, \
	, INTUITION_BASE_NAME)

#define BeginRefresh(window) \
	LP1NR(0x162, BeginRefresh, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define BuildSysRequest(window, body, posText, negText, flags, width, height) \
	LP7(0x168, struct Window *, BuildSysRequest, struct Window *, window, a0, const struct IntuiText *, body, a1, const struct IntuiText *, posText, a2, const struct IntuiText *, negText, a3, ULONG, flags, d0, ULONG, width, d1, ULONG, height, d2, \
	, INTUITION_BASE_NAME)

#define EndRefresh(window, complete) \
	LP2NR(0x16e, EndRefresh, struct Window *, window, a0, LONG, complete, d0, \
	, INTUITION_BASE_NAME)

#define FreeSysRequest(window) \
	LP1NR(0x174, FreeSysRequest, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define MakeScreen(screen) \
	LP1(0x17a, LONG, MakeScreen, struct Screen *, screen, a0, \
	, INTUITION_BASE_NAME)

#define RemakeDisplay() \
	LP0(0x180, LONG, RemakeDisplay, \
	, INTUITION_BASE_NAME)

#define RethinkDisplay() \
	LP0(0x186, LONG, RethinkDisplay, \
	, INTUITION_BASE_NAME)

#define AllocRemember(rememberKey, size, flags) \
	LP3(0x18c, APTR, AllocRemember, struct Remember **, rememberKey, a0, ULONG, size, d0, ULONG, flags, d1, \
	, INTUITION_BASE_NAME)

#define FreeRemember(rememberKey, reallyForget) \
	LP2NR(0x198, FreeRemember, struct Remember **, rememberKey, a0, LONG, reallyForget, d0, \
	, INTUITION_BASE_NAME)

#define LockIBase(dontknow) \
	LP1(0x19e, ULONG, LockIBase, ULONG, dontknow, d0, \
	, INTUITION_BASE_NAME)

#define UnlockIBase(ibLock) \
	LP1NR(0x1a4, UnlockIBase, ULONG, ibLock, a0, \
	, INTUITION_BASE_NAME)

#define GetScreenData(buffer, size, type, screen) \
	LP4(0x1aa, LONG, GetScreenData, APTR, buffer, a0, ULONG, size, d0, ULONG, type, d1, const struct Screen *, screen, a1, \
	, INTUITION_BASE_NAME)

#define RefreshGList(gadgets, window, requester, numGad) \
	LP4NR(0x1b0, RefreshGList, struct Gadget *, gadgets, a0, struct Window *, window, a1, struct Requester *, requester, a2, LONG, numGad, d0, \
	, INTUITION_BASE_NAME)

#define AddGList(window, gadget, position, numGad, requester) \
	LP5(0x1b6, UWORD, AddGList, struct Window *, window, a0, struct Gadget *, gadget, a1, ULONG, position, d0, LONG, numGad, d1, struct Requester *, requester, a2, \
	, INTUITION_BASE_NAME)

#define RemoveGList(remPtr, gadget, numGad) \
	LP3(0x1bc, UWORD, RemoveGList, struct Window *, remPtr, a0, struct Gadget *, gadget, a1, LONG, numGad, d0, \
	, INTUITION_BASE_NAME)

#define ActivateWindow(window) \
	LP1NR(0x1c2, ActivateWindow, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define RefreshWindowFrame(window) \
	LP1NR(0x1c8, RefreshWindowFrame, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define ActivateGadget(gadgets, window, requester) \
	LP3(0x1ce, BOOL, ActivateGadget, struct Gadget *, gadgets, a0, struct Window *, window, a1, struct Requester *, requester, a2, \
	, INTUITION_BASE_NAME)

#define NewModifyProp(gadget, window, requester, flags, horizPot, vertPot, horizBody, vertBody, numGad) \
	LP9NR(0x1d4, NewModifyProp, struct Gadget *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, ULONG, flags, d0, ULONG, horizPot, d1, ULONG, vertPot, d2, ULONG, horizBody, d3, ULONG, vertBody, d4, LONG, numGad, d5, \
	, INTUITION_BASE_NAME)

#define QueryOverscan(displayID, rect, oScanType) \
	LP3(0x1da, LONG, QueryOverscan, ULONG, displayID, a0, struct Rectangle *, rect, a1, LONG, oScanType, d0, \
	, INTUITION_BASE_NAME)

#define MoveWindowInFrontOf(window, behindWindow) \
	LP2NR(0x1e0, MoveWindowInFrontOf, struct Window *, window, a0, struct Window *, behindWindow, a1, \
	, INTUITION_BASE_NAME)

#define ChangeWindowBox(window, left, top, width, height) \
	LP5NR(0x1e6, ChangeWindowBox, struct Window *, window, a0, LONG, left, d0, LONG, top, d1, LONG, width, d2, LONG, height, d3, \
	, INTUITION_BASE_NAME)

#define SetEditHook(hook) \
	LP1(0x1ec, struct Hook *, SetEditHook, struct Hook *, hook, a0, \
	, INTUITION_BASE_NAME)

#define SetMouseQueue(window, queueLength) \
	LP2(0x1f2, LONG, SetMouseQueue, struct Window *, window, a0, ULONG, queueLength, d0, \
	, INTUITION_BASE_NAME)

#define ZipWindow(window) \
	LP1NR(0x1f8, ZipWindow, struct Window *, window, a0, \
	, INTUITION_BASE_NAME)

#define LockPubScreen(name) \
	LP1(0x1fe, struct Screen *, LockPubScreen, CONST_STRPTR, name, a0, \
	, INTUITION_BASE_NAME)

#define UnlockPubScreen(name, screen) \
	LP2NR(0x204, UnlockPubScreen, CONST_STRPTR, name, a0, struct Screen *, screen, a1, \
	, INTUITION_BASE_NAME)

#define LockPubScreenList() \
	LP0(0x20a, struct List *, LockPubScreenList, \
	, INTUITION_BASE_NAME)

#define UnlockPubScreenList() \
	LP0NR(0x210, UnlockPubScreenList, \
	, INTUITION_BASE_NAME)

#define NextPubScreen(screen, namebuf) \
	LP2(0x216, STRPTR, NextPubScreen, const struct Screen *, screen, a0, STRPTR, namebuf, a1, \
	, INTUITION_BASE_NAME)

#define SetDefaultPubScreen(name) \
	LP1NR(0x21c, SetDefaultPubScreen, CONST_STRPTR, name, a0, \
	, INTUITION_BASE_NAME)

#define SetPubScreenModes(modes) \
	LP1(0x222, UWORD, SetPubScreenModes, ULONG, modes, d0, \
	, INTUITION_BASE_NAME)

#define PubScreenStatus(screen, statusFlags) \
	LP2(0x228, UWORD, PubScreenStatus, struct Screen *, screen, a0, ULONG, statusFlags, d0, \
	, INTUITION_BASE_NAME)

#define ObtainGIRPort(gInfo) \
	LP1(0x22e, struct RastPort	*, ObtainGIRPort, struct GadgetInfo *, gInfo, a0, \
	, INTUITION_BASE_NAME)

#define ReleaseGIRPort(rp) \
	LP1NR(0x234, ReleaseGIRPort, struct RastPort *, rp, a0, \
	, INTUITION_BASE_NAME)

#define GadgetMouse(gadget, gInfo, mousePoint) \
	LP3NR(0x23a, GadgetMouse, struct Gadget *, gadget, a0, struct GadgetInfo *, gInfo, a1, WORD *, mousePoint, a2, \
	, INTUITION_BASE_NAME)

#define GetDefaultPubScreen(nameBuffer) \
	LP1NR(0x246, GetDefaultPubScreen, STRPTR, nameBuffer, a0, \
	, INTUITION_BASE_NAME)

#define EasyRequestArgs(window, easyStruct, idcmpPtr, args) \
	LP4(0x24c, LONG, EasyRequestArgs, struct Window *, window, a0, const struct EasyStruct *, easyStruct, a1, ULONG *, idcmpPtr, a2, const APTR, args, a3, \
	, INTUITION_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define EasyRequest(window, easyStruct, idcmpPtr, tags...) \
	({ULONG _tags[] = {tags}; EasyRequestArgs((window), (easyStruct), (idcmpPtr), (const APTR) _tags);})
#endif

#define BuildEasyRequestArgs(window, easyStruct, idcmp, args) \
	LP4(0x252, struct Window *, BuildEasyRequestArgs, struct Window *, window, a0, const struct EasyStruct *, easyStruct, a1, ULONG, idcmp, d0, const APTR, args, a3, \
	, INTUITION_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define BuildEasyRequest(window, easyStruct, idcmp, tags...) \
	({ULONG _tags[] = {tags}; BuildEasyRequestArgs((window), (easyStruct), (idcmp), (const APTR) _tags);})
#endif

#define SysReqHandler(window, idcmpPtr, waitInput) \
	LP3(0x258, LONG, SysReqHandler, struct Window *, window, a0, ULONG *, idcmpPtr, a1, LONG, waitInput, d0, \
	, INTUITION_BASE_NAME)

#define OpenWindowTagList(newWindow, tagList) \
	LP2(0x25e, struct Window *, OpenWindowTagList, const struct NewWindow *, newWindow, a0, const struct TagItem *, tagList, a1, \
	, INTUITION_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define OpenWindowTags(newWindow, tags...) \
	({ULONG _tags[] = {tags}; OpenWindowTagList((newWindow), (const struct TagItem *) _tags);})
#endif

#define OpenScreenTagList(newScreen, tagList) \
	LP2(0x264, struct Screen *, OpenScreenTagList, const struct NewScreen *, newScreen, a0, const struct TagItem *, tagList, a1, \
	, INTUITION_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define OpenScreenTags(newScreen, tags...) \
	({ULONG _tags[] = {tags}; OpenScreenTagList((newScreen), (const struct TagItem *) _tags);})
#endif

#define DrawImageState(rp, image, leftOffset, topOffset, state, drawInfo) \
	LP6NR(0x26a, DrawImageState, struct RastPort *, rp, a0, struct Image *, image, a1, LONG, leftOffset, d0, LONG, topOffset, d1, ULONG, state, d2, const struct DrawInfo *, drawInfo, a2, \
	, INTUITION_BASE_NAME)

#define PointInImage(point, image) \
	LP2(0x270, BOOL, PointInImage, ULONG, point, d0, struct Image *, image, a0, \
	, INTUITION_BASE_NAME)

#define EraseImage(rp, image, leftOffset, topOffset) \
	LP4NR(0x276, EraseImage, struct RastPort *, rp, a0, struct Image *, image, a1, LONG, leftOffset, d0, LONG, topOffset, d1, \
	, INTUITION_BASE_NAME)

#define NewObjectA(classPtr, classID, tagList) \
	LP3(0x27c, APTR, NewObjectA, struct IClass *, classPtr, a0, CONST_STRPTR, classID, a1, const struct TagItem *, tagList, a2, \
	, INTUITION_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define NewObject(classPtr, classID, tags...) \
	({ULONG _tags[] = {tags}; NewObjectA((classPtr), (classID), (const struct TagItem *) _tags);})
#endif

#define DisposeObject(object) \
	LP1NR(0x282, DisposeObject, APTR, object, a0, \
	, INTUITION_BASE_NAME)

#define SetAttrsA(object, tagList) \
	LP2(0x288, ULONG, SetAttrsA, APTR, object, a0, const struct TagItem *, tagList, a1, \
	, INTUITION_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetAttrs(object, tags...) \
	({ULONG _tags[] = {tags}; SetAttrsA((object), (const struct TagItem *) _tags);})
#endif

#define GetAttr(attrID, object, storagePtr) \
	LP3(0x28e, ULONG, GetAttr, ULONG, attrID, d0, APTR, object, a0, ULONG *, storagePtr, a1, \
	, INTUITION_BASE_NAME)

#define SetGadgetAttrsA(gadget, window, requester, tagList) \
	LP4(0x294, ULONG, SetGadgetAttrsA, struct Gadget *, gadget, a0, struct Window *, window, a1, struct Requester *, requester, a2, const struct TagItem *, tagList, a3, \
	, INTUITION_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetGadgetAttrs(gadget, window, requester, tags...) \
	({ULONG _tags[] = {tags}; SetGadgetAttrsA((gadget), (window), (requester), (const struct TagItem *) _tags);})
#endif

#define NextObject(objectPtrPtr) \
	LP1(0x29a, APTR, NextObject, APTR, objectPtrPtr, a0, \
	, INTUITION_BASE_NAME)

#define MakeClass(classID, superClassID, superClassPtr, instanceSize, flags) \
	LP5(0x2a6, struct IClass *, MakeClass, CONST_STRPTR, classID, a0, CONST_STRPTR, superClassID, a1, const struct IClass *, superClassPtr, a2, ULONG, instanceSize, d0, ULONG, flags, d1, \
	, INTUITION_BASE_NAME)

#define AddClass(classPtr) \
	LP1NR(0x2ac, AddClass, struct IClass *, classPtr, a0, \
	, INTUITION_BASE_NAME)

#define GetScreenDrawInfo(screen) \
	LP1(0x2b2, struct DrawInfo *, GetScreenDrawInfo, struct Screen *, screen, a0, \
	, INTUITION_BASE_NAME)

#define FreeScreenDrawInfo(screen, drawInfo) \
	LP2NR(0x2b8, FreeScreenDrawInfo, struct Screen *, screen, a0, struct DrawInfo *, drawInfo, a1, \
	, INTUITION_BASE_NAME)

#define ResetMenuStrip(window, menu) \
	LP2(0x2be, BOOL, ResetMenuStrip, struct Window *, window, a0, struct Menu *, menu, a1, \
	, INTUITION_BASE_NAME)

#define RemoveClass(classPtr) \
	LP1NR(0x2c4, RemoveClass, struct IClass *, classPtr, a0, \
	, INTUITION_BASE_NAME)

#define FreeClass(classPtr) \
	LP1(0x2ca, BOOL, FreeClass, struct IClass *, classPtr, a0, \
	, INTUITION_BASE_NAME)

#define AllocScreenBuffer(sc, bm, flags) \
	LP3(0x300, struct ScreenBuffer *, AllocScreenBuffer, struct Screen *, sc, a0, struct BitMap *, bm, a1, ULONG, flags, d0, \
	, INTUITION_BASE_NAME)

#define FreeScreenBuffer(sc, sb) \
	LP2NR(0x306, FreeScreenBuffer, struct Screen *, sc, a0, struct ScreenBuffer *, sb, a1, \
	, INTUITION_BASE_NAME)

#define ChangeScreenBuffer(sc, sb) \
	LP2(0x30c, ULONG, ChangeScreenBuffer, struct Screen *, sc, a0, struct ScreenBuffer *, sb, a1, \
	, INTUITION_BASE_NAME)

#define ScreenDepth(screen, flags, reserved) \
	LP3NR(0x312, ScreenDepth, struct Screen *, screen, a0, ULONG, flags, d0, APTR, reserved, a1, \
	, INTUITION_BASE_NAME)

#define ScreenPosition(screen, flags, x1, y1, x2, y2) \
	LP6NR(0x318, ScreenPosition, struct Screen *, screen, a0, ULONG, flags, d0, LONG, x1, d1, LONG, y1, d2, LONG, x2, d3, LONG, y2, d4, \
	, INTUITION_BASE_NAME)

#define ScrollWindowRaster(win, dx, dy, xMin, yMin, xMax, yMax) \
	LP7NR(0x31e, ScrollWindowRaster, struct Window *, win, a1, LONG, dx, d0, LONG, dy, d1, LONG, xMin, d2, LONG, yMin, d3, LONG, xMax, d4, LONG, yMax, d5, \
	, INTUITION_BASE_NAME)

#define LendMenus(fromwindow, towindow) \
	LP2NR(0x324, LendMenus, struct Window *, fromwindow, a0, struct Window *, towindow, a1, \
	, INTUITION_BASE_NAME)

#define DoGadgetMethodA(gad, win, req, message) \
	LP4(0x32a, ULONG, DoGadgetMethodA, struct Gadget *, gad, a0, struct Window *, win, a1, struct Requester *, req, a2, Msg, message, a3, \
	, INTUITION_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define DoGadgetMethod(gad, win, req, tags...) \
	({ULONG _tags[] = {tags}; DoGadgetMethodA((gad), (win), (req), (Msg) _tags);})
#endif

#define SetWindowPointerA(win, taglist) \
	LP2NR(0x330, SetWindowPointerA, struct Window *, win, a0, const struct TagItem *, taglist, a1, \
	, INTUITION_BASE_NAME)

#ifndef NO_INLINE_STDARG
#define SetWindowPointer(win, tags...) \
	({ULONG _tags[] = {tags}; SetWindowPointerA((win), (const struct TagItem *) _tags);})
#endif

#define TimedDisplayAlert(alertNumber, string, height, time) \
	LP4(0x336, BOOL, TimedDisplayAlert, ULONG, alertNumber, d0, CONST_STRPTR, string, a0, ULONG, height, d1, ULONG, time, a1, \
	, INTUITION_BASE_NAME)

#define HelpControl(win, flags) \
	LP2NR(0x33c, HelpControl, struct Window *, win, a0, ULONG, flags, d0, \
	, INTUITION_BASE_NAME)

#endif /*  _INLINE_INTUITION_H  */
