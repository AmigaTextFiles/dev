#ifndef _VBCCINLINE_INTUITION_H
#define _VBCCINLINE_INTUITION_H

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

VOID __OpenIntuition(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-30\n"
	"\tblrl";
#define OpenIntuition() __OpenIntuition(IntuitionBase)

VOID __Intuition(struct IntuitionBase *, struct InputEvent * iEvent) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-36\n"
	"\tblrl";
#define Intuition(iEvent) __Intuition(IntuitionBase, (iEvent))

UWORD __AddGadget(struct IntuitionBase *, struct Window * window, struct Gadget * gadget, ULONG position) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-42\n"
	"\tblrl";
#define AddGadget(window, gadget, position) __AddGadget(IntuitionBase, (window), (gadget), (position))

BOOL __ClearDMRequest(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-48\n"
	"\tblrl";
#define ClearDMRequest(window) __ClearDMRequest(IntuitionBase, (window))

VOID __ClearMenuStrip(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-54\n"
	"\tblrl";
#define ClearMenuStrip(window) __ClearMenuStrip(IntuitionBase, (window))

VOID __ClearPointer(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-60\n"
	"\tblrl";
#define ClearPointer(window) __ClearPointer(IntuitionBase, (window))

BOOL __CloseScreen(struct IntuitionBase *, struct Screen * screen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-66\n"
	"\tblrl";
#define CloseScreen(screen) __CloseScreen(IntuitionBase, (screen))

VOID __CloseWindow(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-72\n"
	"\tblrl";
#define CloseWindow(window) __CloseWindow(IntuitionBase, (window))

LONG __CloseWorkBench(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-78\n"
	"\tblrl";
#define CloseWorkBench() __CloseWorkBench(IntuitionBase)

VOID __CurrentTime(struct IntuitionBase *, ULONG * seconds, ULONG * micros) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-84\n"
	"\tblrl";
#define CurrentTime(seconds, micros) __CurrentTime(IntuitionBase, (seconds), (micros))

BOOL __DisplayAlert(struct IntuitionBase *, ULONG alertNumber, CONST_STRPTR string, ULONG height) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tstw\t6,4(2)\n"
	"\tli\t3,-90\n"
	"\tblrl";
#define DisplayAlert(alertNumber, string, height) __DisplayAlert(IntuitionBase, (alertNumber), (string), (height))

VOID __DisplayBeep(struct IntuitionBase *, struct Screen * screen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-96\n"
	"\tblrl";
#define DisplayBeep(screen) __DisplayBeep(IntuitionBase, (screen))

BOOL __DoubleClick(struct IntuitionBase *, ULONG sSeconds, ULONG sMicros, ULONG cSeconds, ULONG cMicros) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,4(2)\n"
	"\tstw\t6,8(2)\n"
	"\tstw\t7,12(2)\n"
	"\tli\t3,-102\n"
	"\tblrl";
#define DoubleClick(sSeconds, sMicros, cSeconds, cMicros) __DoubleClick(IntuitionBase, (sSeconds), (sMicros), (cSeconds), (cMicros))

VOID __DrawBorder(struct IntuitionBase *, struct RastPort * rp, const struct Border * border, LONG leftOffset, LONG topOffset) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tstw\t7,4(2)\n"
	"\tli\t3,-108\n"
	"\tblrl";
#define DrawBorder(rp, border, leftOffset, topOffset) __DrawBorder(IntuitionBase, (rp), (border), (leftOffset), (topOffset))

VOID __DrawImage(struct IntuitionBase *, struct RastPort * rp, struct Image * image, LONG leftOffset, LONG topOffset) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tstw\t7,4(2)\n"
	"\tli\t3,-114\n"
	"\tblrl";
#define DrawImage(rp, image, leftOffset, topOffset) __DrawImage(IntuitionBase, (rp), (image), (leftOffset), (topOffset))

VOID __EndRequest(struct IntuitionBase *, struct Requester * requester, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-120\n"
	"\tblrl";
#define EndRequest(requester, window) __EndRequest(IntuitionBase, (requester), (window))

struct Preferences * __GetDefPrefs(struct IntuitionBase *, struct Preferences * preferences, LONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-126\n"
	"\tblrl";
#define GetDefPrefs(preferences, size) __GetDefPrefs(IntuitionBase, (preferences), (size))

struct Preferences * __GetPrefs(struct IntuitionBase *, struct Preferences * preferences, LONG size) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-132\n"
	"\tblrl";
#define GetPrefs(preferences, size) __GetPrefs(IntuitionBase, (preferences), (size))

VOID __InitRequester(struct IntuitionBase *, struct Requester * requester) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-138\n"
	"\tblrl";
#define InitRequester(requester) __InitRequester(IntuitionBase, (requester))

struct MenuItem * __ItemAddress(struct IntuitionBase *, const struct Menu * menuStrip, ULONG menuNumber) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-144\n"
	"\tblrl";
#define ItemAddress(menuStrip, menuNumber) __ItemAddress(IntuitionBase, (menuStrip), (menuNumber))

BOOL __ModifyIDCMP(struct IntuitionBase *, struct Window * window, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-150\n"
	"\tblrl";
#define ModifyIDCMP(window, flags) __ModifyIDCMP(IntuitionBase, (window), (flags))

VOID __ModifyProp(struct IntuitionBase *, struct Gadget * gadget, struct Window * window, struct Requester * requester, ULONG flags, ULONG horizPot, ULONG vertPot, ULONG horizBody, ULONG vertBody) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,0(2)\n"
	"\tstw\t8,4(2)\n"
	"\tstw\t9,8(2)\n"
	"\tstw\t10,12(2)\n"
	"\tlwz\t11,8(1)\n"
	"\tstw\t11,16(2)\n"
	"\tli\t3,-156\n"
	"\tblrl";
#define ModifyProp(gadget, window, requester, flags, horizPot, vertPot, horizBody, vertBody) __ModifyProp(IntuitionBase, (gadget), (window), (requester), (flags), (horizPot), (vertPot), (horizBody), (vertBody))

VOID __MoveScreen(struct IntuitionBase *, struct Screen * screen, LONG dx, LONG dy) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tli\t3,-162\n"
	"\tblrl";
#define MoveScreen(screen, dx, dy) __MoveScreen(IntuitionBase, (screen), (dx), (dy))

VOID __MoveWindow(struct IntuitionBase *, struct Window * window, LONG dx, LONG dy) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tli\t3,-168\n"
	"\tblrl";
#define MoveWindow(window, dx, dy) __MoveWindow(IntuitionBase, (window), (dx), (dy))

VOID __OffGadget(struct IntuitionBase *, struct Gadget * gadget, struct Window * window, struct Requester * requester) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-174\n"
	"\tblrl";
#define OffGadget(gadget, window, requester) __OffGadget(IntuitionBase, (gadget), (window), (requester))

VOID __OffMenu(struct IntuitionBase *, struct Window * window, ULONG menuNumber) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-180\n"
	"\tblrl";
#define OffMenu(window, menuNumber) __OffMenu(IntuitionBase, (window), (menuNumber))

VOID __OnGadget(struct IntuitionBase *, struct Gadget * gadget, struct Window * window, struct Requester * requester) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-186\n"
	"\tblrl";
#define OnGadget(gadget, window, requester) __OnGadget(IntuitionBase, (gadget), (window), (requester))

VOID __OnMenu(struct IntuitionBase *, struct Window * window, ULONG menuNumber) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-192\n"
	"\tblrl";
#define OnMenu(window, menuNumber) __OnMenu(IntuitionBase, (window), (menuNumber))

struct Screen * __OpenScreen(struct IntuitionBase *, const struct NewScreen * newScreen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-198\n"
	"\tblrl";
#define OpenScreen(newScreen) __OpenScreen(IntuitionBase, (newScreen))

struct Window * __OpenWindow(struct IntuitionBase *, const struct NewWindow * newWindow) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-204\n"
	"\tblrl";
#define OpenWindow(newWindow) __OpenWindow(IntuitionBase, (newWindow))

ULONG __OpenWorkBench(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-210\n"
	"\tblrl";
#define OpenWorkBench() __OpenWorkBench(IntuitionBase)

VOID __PrintIText(struct IntuitionBase *, struct RastPort * rp, const struct IntuiText * iText, LONG left, LONG top) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tstw\t7,4(2)\n"
	"\tli\t3,-216\n"
	"\tblrl";
#define PrintIText(rp, iText, left, top) __PrintIText(IntuitionBase, (rp), (iText), (left), (top))

VOID __RefreshGadgets(struct IntuitionBase *, struct Gadget * gadgets, struct Window * window, struct Requester * requester) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-222\n"
	"\tblrl";
#define RefreshGadgets(gadgets, window, requester) __RefreshGadgets(IntuitionBase, (gadgets), (window), (requester))

UWORD __RemoveGadget(struct IntuitionBase *, struct Window * window, struct Gadget * gadget) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-228\n"
	"\tblrl";
#define RemoveGadget(window, gadget) __RemoveGadget(IntuitionBase, (window), (gadget))

VOID __ReportMouse(struct IntuitionBase *, LONG flag, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tli\t3,-234\n"
	"\tblrl";
#define ReportMouse(flag, window) __ReportMouse(IntuitionBase, (flag), (window))

#define ReportMouse1(flag, window) __ReportMouse((flag), (window), IntuitionBase)

BOOL __Request(struct IntuitionBase *, struct Requester * requester, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-240\n"
	"\tblrl";
#define Request(requester, window) __Request(IntuitionBase, (requester), (window))

VOID __ScreenToBack(struct IntuitionBase *, struct Screen * screen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-246\n"
	"\tblrl";
#define ScreenToBack(screen) __ScreenToBack(IntuitionBase, (screen))

VOID __ScreenToFront(struct IntuitionBase *, struct Screen * screen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-252\n"
	"\tblrl";
#define ScreenToFront(screen) __ScreenToFront(IntuitionBase, (screen))

BOOL __SetDMRequest(struct IntuitionBase *, struct Window * window, struct Requester * requester) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-258\n"
	"\tblrl";
#define SetDMRequest(window, requester) __SetDMRequest(IntuitionBase, (window), (requester))

BOOL __SetMenuStrip(struct IntuitionBase *, struct Window * window, struct Menu * menu) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-264\n"
	"\tblrl";
#define SetMenuStrip(window, menu) __SetMenuStrip(IntuitionBase, (window), (menu))

VOID __SetPointer(struct IntuitionBase *, struct Window * window, UWORD * pointer, LONG height, LONG width, LONG xOffset, LONG yOffset) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tstw\t7,4(2)\n"
	"\tstw\t8,8(2)\n"
	"\tstw\t9,12(2)\n"
	"\tli\t3,-270\n"
	"\tblrl";
#define SetPointer(window, pointer, height, width, xOffset, yOffset) __SetPointer(IntuitionBase, (window), (pointer), (height), (width), (xOffset), (yOffset))

VOID __SetWindowTitles(struct IntuitionBase *, struct Window * window, CONST_STRPTR windowTitle, CONST_STRPTR screenTitle) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-276\n"
	"\tblrl";
#define SetWindowTitles(window, windowTitle, screenTitle) __SetWindowTitles(IntuitionBase, (window), (windowTitle), (screenTitle))

VOID __ShowTitle(struct IntuitionBase *, struct Screen * screen, LONG showIt) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-282\n"
	"\tblrl";
#define ShowTitle(screen, showIt) __ShowTitle(IntuitionBase, (screen), (showIt))

VOID __SizeWindow(struct IntuitionBase *, struct Window * window, LONG dx, LONG dy) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tli\t3,-288\n"
	"\tblrl";
#define SizeWindow(window, dx, dy) __SizeWindow(IntuitionBase, (window), (dx), (dy))

struct View * __ViewAddress(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-294\n"
	"\tblrl";
#define ViewAddress() __ViewAddress(IntuitionBase)

struct ViewPort * __ViewPortAddress(struct IntuitionBase *, const struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-300\n"
	"\tblrl";
#define ViewPortAddress(window) __ViewPortAddress(IntuitionBase, (window))

VOID __WindowToBack(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-306\n"
	"\tblrl";
#define WindowToBack(window) __WindowToBack(IntuitionBase, (window))

VOID __WindowToFront(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-312\n"
	"\tblrl";
#define WindowToFront(window) __WindowToFront(IntuitionBase, (window))

BOOL __WindowLimits(struct IntuitionBase *, struct Window * window, LONG widthMin, LONG heightMin, ULONG widthMax, ULONG heightMax) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tstw\t7,8(2)\n"
	"\tstw\t8,12(2)\n"
	"\tli\t3,-318\n"
	"\tblrl";
#define WindowLimits(window, widthMin, heightMin, widthMax, heightMax) __WindowLimits(IntuitionBase, (window), (widthMin), (heightMin), (widthMax), (heightMax))

struct Preferences  * __SetPrefs(struct IntuitionBase *, const struct Preferences * preferences, LONG size, LONG inform) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tli\t3,-324\n"
	"\tblrl";
#define SetPrefs(preferences, size, inform) __SetPrefs(IntuitionBase, (preferences), (size), (inform))

LONG __IntuiTextLength(struct IntuitionBase *, const struct IntuiText * iText) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-330\n"
	"\tblrl";
#define IntuiTextLength(iText) __IntuiTextLength(IntuitionBase, (iText))

BOOL __WBenchToBack(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-336\n"
	"\tblrl";
#define WBenchToBack() __WBenchToBack(IntuitionBase)

BOOL __WBenchToFront(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-342\n"
	"\tblrl";
#define WBenchToFront() __WBenchToFront(IntuitionBase)

BOOL __AutoRequest(struct IntuitionBase *, struct Window * window, const struct IntuiText * body, const struct IntuiText * posText, const struct IntuiText * negText, ULONG pFlag, ULONG nFlag, ULONG width, ULONG height) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,44(2)\n"
	"\tstw\t8,0(2)\n"
	"\tstw\t9,4(2)\n"
	"\tstw\t10,8(2)\n"
	"\tlwz\t11,8(1)\n"
	"\tstw\t11,12(2)\n"
	"\tli\t3,-348\n"
	"\tblrl";
#define AutoRequest(window, body, posText, negText, pFlag, nFlag, width, height) __AutoRequest(IntuitionBase, (window), (body), (posText), (negText), (pFlag), (nFlag), (width), (height))

VOID __BeginRefresh(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-354\n"
	"\tblrl";
#define BeginRefresh(window) __BeginRefresh(IntuitionBase, (window))

struct Window * __BuildSysRequest(struct IntuitionBase *, struct Window * window, const struct IntuiText * body, const struct IntuiText * posText, const struct IntuiText * negText, ULONG flags, ULONG width, ULONG height) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,44(2)\n"
	"\tstw\t8,0(2)\n"
	"\tstw\t9,4(2)\n"
	"\tstw\t10,8(2)\n"
	"\tli\t3,-360\n"
	"\tblrl";
#define BuildSysRequest(window, body, posText, negText, flags, width, height) __BuildSysRequest(IntuitionBase, (window), (body), (posText), (negText), (flags), (width), (height))

VOID __EndRefresh(struct IntuitionBase *, struct Window * window, LONG complete) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-366\n"
	"\tblrl";
#define EndRefresh(window, complete) __EndRefresh(IntuitionBase, (window), (complete))

VOID __FreeSysRequest(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-372\n"
	"\tblrl";
#define FreeSysRequest(window) __FreeSysRequest(IntuitionBase, (window))

LONG __MakeScreen(struct IntuitionBase *, struct Screen * screen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-378\n"
	"\tblrl";
#define MakeScreen(screen) __MakeScreen(IntuitionBase, (screen))

LONG __RemakeDisplay(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-384\n"
	"\tblrl";
#define RemakeDisplay() __RemakeDisplay(IntuitionBase)

LONG __RethinkDisplay(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-390\n"
	"\tblrl";
#define RethinkDisplay() __RethinkDisplay(IntuitionBase)

APTR __AllocRemember(struct IntuitionBase *, struct Remember ** rememberKey, ULONG size, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tli\t3,-396\n"
	"\tblrl";
#define AllocRemember(rememberKey, size, flags) __AllocRemember(IntuitionBase, (rememberKey), (size), (flags))

VOID __FreeRemember(struct IntuitionBase *, struct Remember ** rememberKey, LONG reallyForget) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-408\n"
	"\tblrl";
#define FreeRemember(rememberKey, reallyForget) __FreeRemember(IntuitionBase, (rememberKey), (reallyForget))

ULONG __LockIBase(struct IntuitionBase *, ULONG dontknow) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-414\n"
	"\tblrl";
#define LockIBase(dontknow) __LockIBase(IntuitionBase, (dontknow))

VOID __UnlockIBase(struct IntuitionBase *, ULONG ibLock) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-420\n"
	"\tblrl";
#define UnlockIBase(ibLock) __UnlockIBase(IntuitionBase, (ibLock))

LONG __GetScreenData(struct IntuitionBase *, APTR buffer, ULONG size, ULONG type, const struct Screen * screen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tstw\t7,36(2)\n"
	"\tli\t3,-426\n"
	"\tblrl";
#define GetScreenData(buffer, size, type, screen) __GetScreenData(IntuitionBase, (buffer), (size), (type), (screen))

VOID __RefreshGList(struct IntuitionBase *, struct Gadget * gadgets, struct Window * window, struct Requester * requester, LONG numGad) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,0(2)\n"
	"\tli\t3,-432\n"
	"\tblrl";
#define RefreshGList(gadgets, window, requester, numGad) __RefreshGList(IntuitionBase, (gadgets), (window), (requester), (numGad))

UWORD __AddGList(struct IntuitionBase *, struct Window * window, struct Gadget * gadget, ULONG position, LONG numGad, struct Requester * requester) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tstw\t7,4(2)\n"
	"\tstw\t8,40(2)\n"
	"\tli\t3,-438\n"
	"\tblrl";
#define AddGList(window, gadget, position, numGad, requester) __AddGList(IntuitionBase, (window), (gadget), (position), (numGad), (requester))

UWORD __RemoveGList(struct IntuitionBase *, struct Window * remPtr, struct Gadget * gadget, LONG numGad) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-444\n"
	"\tblrl";
#define RemoveGList(remPtr, gadget, numGad) __RemoveGList(IntuitionBase, (remPtr), (gadget), (numGad))

VOID __ActivateWindow(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-450\n"
	"\tblrl";
#define ActivateWindow(window) __ActivateWindow(IntuitionBase, (window))

VOID __RefreshWindowFrame(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-456\n"
	"\tblrl";
#define RefreshWindowFrame(window) __RefreshWindowFrame(IntuitionBase, (window))

BOOL __ActivateGadget(struct IntuitionBase *, struct Gadget * gadgets, struct Window * window, struct Requester * requester) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-462\n"
	"\tblrl";
#define ActivateGadget(gadgets, window, requester) __ActivateGadget(IntuitionBase, (gadgets), (window), (requester))

VOID __NewModifyProp(struct IntuitionBase *, struct Gadget * gadget, struct Window * window, struct Requester * requester, ULONG flags, ULONG horizPot, ULONG vertPot, ULONG horizBody, ULONG vertBody, LONG numGad) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,0(2)\n"
	"\tstw\t8,4(2)\n"
	"\tstw\t9,8(2)\n"
	"\tstw\t10,12(2)\n"
	"\tlwz\t11,8(1)\n"
	"\tstw\t11,16(2)\n"
	"\tlwz\t11,12(1)\n"
	"\tstw\t11,20(2)\n"
	"\tli\t3,-468\n"
	"\tblrl";
#define NewModifyProp(gadget, window, requester, flags, horizPot, vertPot, horizBody, vertBody, numGad) __NewModifyProp(IntuitionBase, (gadget), (window), (requester), (flags), (horizPot), (vertPot), (horizBody), (vertBody), (numGad))

LONG __QueryOverscan(struct IntuitionBase *, ULONG displayID, struct Rectangle * rect, LONG oScanType) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-474\n"
	"\tblrl";
#define QueryOverscan(displayID, rect, oScanType) __QueryOverscan(IntuitionBase, (displayID), (rect), (oScanType))

VOID __MoveWindowInFrontOf(struct IntuitionBase *, struct Window * window, struct Window * behindWindow) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-480\n"
	"\tblrl";
#define MoveWindowInFrontOf(window, behindWindow) __MoveWindowInFrontOf(IntuitionBase, (window), (behindWindow))

VOID __ChangeWindowBox(struct IntuitionBase *, struct Window * window, LONG left, LONG top, LONG width, LONG height) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tstw\t7,8(2)\n"
	"\tstw\t8,12(2)\n"
	"\tli\t3,-486\n"
	"\tblrl";
#define ChangeWindowBox(window, left, top, width, height) __ChangeWindowBox(IntuitionBase, (window), (left), (top), (width), (height))

struct Hook * __SetEditHook(struct IntuitionBase *, struct Hook * hook) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-492\n"
	"\tblrl";
#define SetEditHook(hook) __SetEditHook(IntuitionBase, (hook))

LONG __SetMouseQueue(struct IntuitionBase *, struct Window * window, ULONG queueLength) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-498\n"
	"\tblrl";
#define SetMouseQueue(window, queueLength) __SetMouseQueue(IntuitionBase, (window), (queueLength))

VOID __ZipWindow(struct IntuitionBase *, struct Window * window) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-504\n"
	"\tblrl";
#define ZipWindow(window) __ZipWindow(IntuitionBase, (window))

struct Screen * __LockPubScreen(struct IntuitionBase *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-510\n"
	"\tblrl";
#define LockPubScreen(name) __LockPubScreen(IntuitionBase, (name))

VOID __UnlockPubScreen(struct IntuitionBase *, CONST_STRPTR name, struct Screen * screen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-516\n"
	"\tblrl";
#define UnlockPubScreen(name, screen) __UnlockPubScreen(IntuitionBase, (name), (screen))

struct List * __LockPubScreenList(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-522\n"
	"\tblrl";
#define LockPubScreenList() __LockPubScreenList(IntuitionBase)

VOID __UnlockPubScreenList(struct IntuitionBase *) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tli\t3,-528\n"
	"\tblrl";
#define UnlockPubScreenList() __UnlockPubScreenList(IntuitionBase)

STRPTR __NextPubScreen(struct IntuitionBase *, const struct Screen * screen, STRPTR namebuf) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-534\n"
	"\tblrl";
#define NextPubScreen(screen, namebuf) __NextPubScreen(IntuitionBase, (screen), (namebuf))

VOID __SetDefaultPubScreen(struct IntuitionBase *, CONST_STRPTR name) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-540\n"
	"\tblrl";
#define SetDefaultPubScreen(name) __SetDefaultPubScreen(IntuitionBase, (name))

UWORD __SetPubScreenModes(struct IntuitionBase *, ULONG modes) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tli\t3,-546\n"
	"\tblrl";
#define SetPubScreenModes(modes) __SetPubScreenModes(IntuitionBase, (modes))

UWORD __PubScreenStatus(struct IntuitionBase *, struct Screen * screen, ULONG statusFlags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-552\n"
	"\tblrl";
#define PubScreenStatus(screen, statusFlags) __PubScreenStatus(IntuitionBase, (screen), (statusFlags))

struct RastPort	* __ObtainGIRPort(struct IntuitionBase *, struct GadgetInfo * gInfo) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-558\n"
	"\tblrl";
#define ObtainGIRPort(gInfo) __ObtainGIRPort(IntuitionBase, (gInfo))

VOID __ReleaseGIRPort(struct IntuitionBase *, struct RastPort * rp) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-564\n"
	"\tblrl";
#define ReleaseGIRPort(rp) __ReleaseGIRPort(IntuitionBase, (rp))

VOID __GadgetMouse(struct IntuitionBase *, struct Gadget * gadget, struct GadgetInfo * gInfo, WORD * mousePoint) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-570\n"
	"\tblrl";
#define GadgetMouse(gadget, gInfo, mousePoint) __GadgetMouse(IntuitionBase, (gadget), (gInfo), (mousePoint))

VOID __GetDefaultPubScreen(struct IntuitionBase *, STRPTR nameBuffer) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-582\n"
	"\tblrl";
#define GetDefaultPubScreen(nameBuffer) __GetDefaultPubScreen(IntuitionBase, (nameBuffer))

LONG __EasyRequestArgs(struct IntuitionBase *, struct Window * window, const struct EasyStruct * easyStruct, ULONG * idcmpPtr, const APTR args) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,44(2)\n"
	"\tli\t3,-588\n"
	"\tblrl";
#define EasyRequestArgs(window, easyStruct, idcmpPtr, args) __EasyRequestArgs(IntuitionBase, (window), (easyStruct), (idcmpPtr), (args))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
LONG __EasyRequest(struct IntuitionBase *, long, long, long, long, struct Window * window, const struct EasyStruct * easyStruct, ULONG * idcmpPtr, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t8,32(2)\n"
	"\tstw\t9,36(2)\n"
	"\tstw\t10,40(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,44(2)\n"
	"\tli\t3,-588\n"
	"\tblrl";
#define EasyRequest(window, easyStruct, ...) __EasyRequest(IntuitionBase, 0, 0, 0, 0, (window), (easyStruct), __VA_ARGS__)
#endif

struct Window * __BuildEasyRequestArgs(struct IntuitionBase *, struct Window * window, const struct EasyStruct * easyStruct, ULONG idcmp, const APTR args) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tstw\t7,44(2)\n"
	"\tli\t3,-594\n"
	"\tblrl";
#define BuildEasyRequestArgs(window, easyStruct, idcmp, args) __BuildEasyRequestArgs(IntuitionBase, (window), (easyStruct), (idcmp), (args))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
struct Window * __BuildEasyRequest(struct IntuitionBase *, long, long, long, long, struct Window * window, const struct EasyStruct * easyStruct, ULONG idcmp, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t8,32(2)\n"
	"\tstw\t9,36(2)\n"
	"\tstw\t10,0(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,44(2)\n"
	"\tli\t3,-594\n"
	"\tblrl";
#define BuildEasyRequest(window, easyStruct, ...) __BuildEasyRequest(IntuitionBase, 0, 0, 0, 0, (window), (easyStruct), __VA_ARGS__)
#endif

LONG __SysReqHandler(struct IntuitionBase *, struct Window * window, ULONG * idcmpPtr, LONG waitInput) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-600\n"
	"\tblrl";
#define SysReqHandler(window, idcmpPtr, waitInput) __SysReqHandler(IntuitionBase, (window), (idcmpPtr), (waitInput))

struct Window * __OpenWindowTagList(struct IntuitionBase *, const struct NewWindow * newWindow, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-606\n"
	"\tblrl";
#define OpenWindowTagList(newWindow, tagList) __OpenWindowTagList(IntuitionBase, (newWindow), (tagList))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
struct Window * __OpenWindowTags(struct IntuitionBase *, long, long, long, long, long, long, const struct NewWindow * newWindow, ULONG tagList, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t10,32(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-606\n"
	"\tblrl";
#define OpenWindowTags(newWindow, ...) __OpenWindowTags(IntuitionBase, 0, 0, 0, 0, 0, 0, (newWindow), __VA_ARGS__)
#endif

struct Screen * __OpenScreenTagList(struct IntuitionBase *, const struct NewScreen * newScreen, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-612\n"
	"\tblrl";
#define OpenScreenTagList(newScreen, tagList) __OpenScreenTagList(IntuitionBase, (newScreen), (tagList))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
struct Screen * __OpenScreenTags(struct IntuitionBase *, long, long, long, long, long, long, const struct NewScreen * newScreen, ULONG tagList, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t10,32(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-612\n"
	"\tblrl";
#define OpenScreenTags(newScreen, ...) __OpenScreenTags(IntuitionBase, 0, 0, 0, 0, 0, 0, (newScreen), __VA_ARGS__)
#endif

VOID __DrawImageState(struct IntuitionBase *, struct RastPort * rp, struct Image * image, LONG leftOffset, LONG topOffset, ULONG state, const struct DrawInfo * drawInfo) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tstw\t7,4(2)\n"
	"\tstw\t8,8(2)\n"
	"\tstw\t9,40(2)\n"
	"\tli\t3,-618\n"
	"\tblrl";
#define DrawImageState(rp, image, leftOffset, topOffset, state, drawInfo) __DrawImageState(IntuitionBase, (rp), (image), (leftOffset), (topOffset), (state), (drawInfo))

BOOL __PointInImage(struct IntuitionBase *, ULONG point, struct Image * image) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tli\t3,-624\n"
	"\tblrl";
#define PointInImage(point, image) __PointInImage(IntuitionBase, (point), (image))

VOID __EraseImage(struct IntuitionBase *, struct RastPort * rp, struct Image * image, LONG leftOffset, LONG topOffset) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tstw\t7,4(2)\n"
	"\tli\t3,-630\n"
	"\tblrl";
#define EraseImage(rp, image, leftOffset, topOffset) __EraseImage(IntuitionBase, (rp), (image), (leftOffset), (topOffset))

APTR __NewObjectA(struct IntuitionBase *, struct IClass * classPtr, CONST_STRPTR classID, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tli\t3,-636\n"
	"\tblrl";
#define NewObjectA(classPtr, classID, tagList) __NewObjectA(IntuitionBase, (classPtr), (classID), (tagList))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
APTR __NewObject(struct IntuitionBase *, long, long, long, long, long, struct IClass * classPtr, CONST_STRPTR classID, ULONG tagList, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t9,32(2)\n"
	"\tstw\t10,36(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,40(2)\n"
	"\tli\t3,-636\n"
	"\tblrl";
#define NewObject(classPtr, classID, ...) __NewObject(IntuitionBase, 0, 0, 0, 0, 0, (classPtr), (classID), __VA_ARGS__)
#endif

VOID __DisposeObject(struct IntuitionBase *, APTR object) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-642\n"
	"\tblrl";
#define DisposeObject(object) __DisposeObject(IntuitionBase, (object))

ULONG __SetAttrsA(struct IntuitionBase *, APTR object, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-648\n"
	"\tblrl";
#define SetAttrsA(object, tagList) __SetAttrsA(IntuitionBase, (object), (tagList))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
ULONG __SetAttrs(struct IntuitionBase *, long, long, long, long, long, long, APTR object, ULONG tagList, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t10,32(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-648\n"
	"\tblrl";
#define SetAttrs(object, ...) __SetAttrs(IntuitionBase, 0, 0, 0, 0, 0, 0, (object), __VA_ARGS__)
#endif

ULONG __GetAttr(struct IntuitionBase *, ULONG attrID, APTR object, ULONG * storagePtr) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tstw\t6,36(2)\n"
	"\tli\t3,-654\n"
	"\tblrl";
#define GetAttr(attrID, object, storagePtr) __GetAttr(IntuitionBase, (attrID), (object), (storagePtr))

ULONG __SetGadgetAttrsA(struct IntuitionBase *, struct Gadget * gadget, struct Window * window, struct Requester * requester, const struct TagItem * tagList) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,44(2)\n"
	"\tli\t3,-660\n"
	"\tblrl";
#define SetGadgetAttrsA(gadget, window, requester, tagList) __SetGadgetAttrsA(IntuitionBase, (gadget), (window), (requester), (tagList))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
ULONG __SetGadgetAttrs(struct IntuitionBase *, long, long, long, long, struct Gadget * gadget, struct Window * window, struct Requester * requester, ULONG tagList, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t8,32(2)\n"
	"\tstw\t9,36(2)\n"
	"\tstw\t10,40(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,44(2)\n"
	"\tli\t3,-660\n"
	"\tblrl";
#define SetGadgetAttrs(gadget, window, requester, ...) __SetGadgetAttrs(IntuitionBase, 0, 0, 0, 0, (gadget), (window), (requester), __VA_ARGS__)
#endif

APTR __NextObject(struct IntuitionBase *, APTR objectPtrPtr) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-666\n"
	"\tblrl";
#define NextObject(objectPtrPtr) __NextObject(IntuitionBase, (objectPtrPtr))

struct IClass * __MakeClass(struct IntuitionBase *, CONST_STRPTR classID, CONST_STRPTR superClassID, const struct IClass * superClassPtr, ULONG instanceSize, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,0(2)\n"
	"\tstw\t8,4(2)\n"
	"\tli\t3,-678\n"
	"\tblrl";
#define MakeClass(classID, superClassID, superClassPtr, instanceSize, flags) __MakeClass(IntuitionBase, (classID), (superClassID), (superClassPtr), (instanceSize), (flags))

VOID __AddClass(struct IntuitionBase *, struct IClass * classPtr) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-684\n"
	"\tblrl";
#define AddClass(classPtr) __AddClass(IntuitionBase, (classPtr))

struct DrawInfo * __GetScreenDrawInfo(struct IntuitionBase *, struct Screen * screen) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-690\n"
	"\tblrl";
#define GetScreenDrawInfo(screen) __GetScreenDrawInfo(IntuitionBase, (screen))

VOID __FreeScreenDrawInfo(struct IntuitionBase *, struct Screen * screen, struct DrawInfo * drawInfo) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-696\n"
	"\tblrl";
#define FreeScreenDrawInfo(screen, drawInfo) __FreeScreenDrawInfo(IntuitionBase, (screen), (drawInfo))

BOOL __ResetMenuStrip(struct IntuitionBase *, struct Window * window, struct Menu * menu) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-702\n"
	"\tblrl";
#define ResetMenuStrip(window, menu) __ResetMenuStrip(IntuitionBase, (window), (menu))

VOID __RemoveClass(struct IntuitionBase *, struct IClass * classPtr) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-708\n"
	"\tblrl";
#define RemoveClass(classPtr) __RemoveClass(IntuitionBase, (classPtr))

BOOL __FreeClass(struct IntuitionBase *, struct IClass * classPtr) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tli\t3,-714\n"
	"\tblrl";
#define FreeClass(classPtr) __FreeClass(IntuitionBase, (classPtr))

struct ScreenBuffer * __AllocScreenBuffer(struct IntuitionBase *, struct Screen * sc, struct BitMap * bm, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,0(2)\n"
	"\tli\t3,-768\n"
	"\tblrl";
#define AllocScreenBuffer(sc, bm, flags) __AllocScreenBuffer(IntuitionBase, (sc), (bm), (flags))

VOID __FreeScreenBuffer(struct IntuitionBase *, struct Screen * sc, struct ScreenBuffer * sb) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-774\n"
	"\tblrl";
#define FreeScreenBuffer(sc, sb) __FreeScreenBuffer(IntuitionBase, (sc), (sb))

ULONG __ChangeScreenBuffer(struct IntuitionBase *, struct Screen * sc, struct ScreenBuffer * sb) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-780\n"
	"\tblrl";
#define ChangeScreenBuffer(sc, sb) __ChangeScreenBuffer(IntuitionBase, (sc), (sb))

VOID __ScreenDepth(struct IntuitionBase *, struct Screen * screen, ULONG flags, APTR reserved) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,36(2)\n"
	"\tli\t3,-786\n"
	"\tblrl";
#define ScreenDepth(screen, flags, reserved) __ScreenDepth(IntuitionBase, (screen), (flags), (reserved))

VOID __ScreenPosition(struct IntuitionBase *, struct Screen * screen, ULONG flags, LONG x1, LONG y1, LONG x2, LONG y2) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tstw\t7,8(2)\n"
	"\tstw\t8,12(2)\n"
	"\tstw\t9,16(2)\n"
	"\tli\t3,-792\n"
	"\tblrl";
#define ScreenPosition(screen, flags, x1, y1, x2, y2) __ScreenPosition(IntuitionBase, (screen), (flags), (x1), (y1), (x2), (y2))

VOID __ScrollWindowRaster(struct IntuitionBase *, struct Window * win, LONG dx, LONG dy, LONG xMin, LONG yMin, LONG xMax, LONG yMax) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,36(2)\n"
	"\tstw\t5,0(2)\n"
	"\tstw\t6,4(2)\n"
	"\tstw\t7,8(2)\n"
	"\tstw\t8,12(2)\n"
	"\tstw\t9,16(2)\n"
	"\tstw\t10,20(2)\n"
	"\tli\t3,-798\n"
	"\tblrl";
#define ScrollWindowRaster(win, dx, dy, xMin, yMin, xMax, yMax) __ScrollWindowRaster(IntuitionBase, (win), (dx), (dy), (xMin), (yMin), (xMax), (yMax))

VOID __LendMenus(struct IntuitionBase *, struct Window * fromwindow, struct Window * towindow) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-804\n"
	"\tblrl";
#define LendMenus(fromwindow, towindow) __LendMenus(IntuitionBase, (fromwindow), (towindow))

ULONG __DoGadgetMethodA(struct IntuitionBase *, struct Gadget * gad, struct Window * win, struct Requester * req, Msg message) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tstw\t6,40(2)\n"
	"\tstw\t7,44(2)\n"
	"\tli\t3,-810\n"
	"\tblrl";
#define DoGadgetMethodA(gad, win, req, message) __DoGadgetMethodA(IntuitionBase, (gad), (win), (req), (message))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
ULONG __DoGadgetMethod(struct IntuitionBase *, long, long, long, long, struct Gadget * gad, struct Window * win, struct Requester * req, ULONG message, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t8,32(2)\n"
	"\tstw\t9,36(2)\n"
	"\tstw\t10,40(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,44(2)\n"
	"\tli\t3,-810\n"
	"\tblrl";
#define DoGadgetMethod(gad, win, req, ...) __DoGadgetMethod(IntuitionBase, 0, 0, 0, 0, (gad), (win), (req), __VA_ARGS__)
#endif

VOID __SetWindowPointerA(struct IntuitionBase *, struct Window * win, const struct TagItem * taglist) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,36(2)\n"
	"\tli\t3,-816\n"
	"\tblrl";
#define SetWindowPointerA(win, taglist) __SetWindowPointerA(IntuitionBase, (win), (taglist))

#if !defined(NO_INLINE_STDARG) && (__STDC__ == 1L) && (__STDC_VERSION__ >= 199901L)
VOID __SetWindowPointer(struct IntuitionBase *, long, long, long, long, long, long, struct Window * win, ULONG taglist, ...) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t10,32(2)\n"
	"\taddi\t4,1,8\n"
	"\tstw\t4,36(2)\n"
	"\tli\t3,-816\n"
	"\tblrl";
#define SetWindowPointer(win, ...) __SetWindowPointer(IntuitionBase, 0, 0, 0, 0, 0, 0, (win), __VA_ARGS__)
#endif

BOOL __TimedDisplayAlert(struct IntuitionBase *, ULONG alertNumber, CONST_STRPTR string, ULONG height, ULONG time) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,0(2)\n"
	"\tstw\t5,32(2)\n"
	"\tstw\t6,4(2)\n"
	"\tstw\t7,36(2)\n"
	"\tli\t3,-822\n"
	"\tblrl";
#define TimedDisplayAlert(alertNumber, string, height, time) __TimedDisplayAlert(IntuitionBase, (alertNumber), (string), (height), (time))

VOID __HelpControl(struct IntuitionBase *, struct Window * win, ULONG flags) =
	"\tlwz\t11,100(2)\n"
	"\tstw\t3,56(2)\n"
	"\tmtlr\t11\n"
	"\tstw\t4,32(2)\n"
	"\tstw\t5,0(2)\n"
	"\tli\t3,-828\n"
	"\tblrl";
#define HelpControl(win, flags) __HelpControl(IntuitionBase, (win), (flags))

#endif /*  _VBCCINLINE_INTUITION_H  */
