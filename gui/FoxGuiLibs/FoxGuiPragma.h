#ifndef _INCLUDE_PRAGMA_FUI_LIB_H
#define _INCLUDE_PRAGMA_FUI_LIB_H

//ifndef CLIB_FUI_PROTOS_H
//include <clib/FUI_protos.h>
//endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(FUIBase,0x01E,SetSeed(d0))
#pragma amicall(FUIBase,0x024,Random(d0))
#pragma amicall(FUIBase,0x02A,CloseConsole(a0))
#pragma amicall(FUIBase,0x030,OpenConsole(a0,a1,a2))
#pragma amicall(FUIBase,0x036,ConPutChar(a0,d0))
#pragma amicall(FUIBase,0x03C,QueueRead(a0,a1))
#pragma amicall(FUIBase,0x042,ConMayGetChar(a0,a1))
#pragma amicall(FUIBase,0x048,ConGetChar(a0,a1))
#pragma amicall(FUIBase,0x04E,ConPrint(a0,a1))
#pragma amicall(FUIBase,0x054,ConClear(a0))
#pragma amicall(FUIBase,0x05A,ConHome(a0))
#pragma amicall(FUIBase,0x060,ConBlankToEOL(a0))
#pragma amicall(FUIBase,0x066,ConTab(a0,d0,d1))
#pragma amicall(FUIBase,0x06C,ConPrintTab(a0,d0,d1,a1))
#pragma amicall(FUIBase,0x072,ConWrapOff(a0))
#pragma amicall(FUIBase,0x078,ConWrapOn(a0))
#pragma amicall(FUIBase,0x07E,ConHideCursor(a0))
#pragma amicall(FUIBase,0x084,ConShowCursor(a0))
#pragma amicall(FUIBase,0x08A,ConPrintHi(a0,a1,d0))
#pragma amicall(FUIBase,0x090,GuiGetLastErr(a0,a1,a2))
#pragma amicall(FUIBase,0x096,GuiTextLength(a0,a1))
#pragma amicall(FUIBase,0x09C,GetWindow(a0))
#pragma amicall(FUIBase,0x0A2,RegisterGadget(a0,a1,a2))
#pragma amicall(FUIBase,0x0A8,UnRegisterGadget(a0))
#pragma amicall(FUIBase,0x0AE,Destroy(a0,d0))
#pragma amicall(FUIBase,0x0B4,DestroyM(d0,a0,d1))
#pragma amicall(FUIBase,0x0BA,EnableControl(a0,d0))
#pragma amicall(FUIBase,0x0C0,EnableM(d0,a0,d1))
#pragma amicall(FUIBase,0x0C6,DisableControl(a0,d0))
#pragma amicall(FUIBase,0x0CC,DisableM(d0,a0,d1))
#pragma amicall(FUIBase,0x0D2,Hide(a0))
#pragma amicall(FUIBase,0x0D8,Show(a0))
#pragma amicall(FUIBase,0x0DE,LibVersion())
#pragma amicall(FUIBase,0x0E4,SleepPointer(a0))
#pragma amicall(FUIBase,0x0EA,WakePointer(a0))
#pragma amicall(FUIBase,0x0F0,SetGuiPensFromPubScreen(a0))
#pragma amicall(FUIBase,0x0F6,SetGuiPens(d0,d1))
#pragma amicall(FUIBase,0x0FC,ShowMessage(a0,a1,a2,a3,d0))
#pragma amicall(FUIBase,0x102,DestroyMessage())
#pragma amicall(FUIBase,0x108,SetPeriod(d0))
#pragma amicall(FUIBase,0x10E,SetDelay(d0))
#pragma amicall(FUIBase,0x114,UseSafeMallocs())
#pragma amicall(FUIBase,0x11A,GuiMalloc(d0,d1))
#pragma amicall(FUIBase,0x120,WasGuiMallocd(a0))
#pragma amicall(FUIBase,0x126,GuiFreeMem(a0,d0,a1))
#pragma amicall(FUIBase,0x12C,SetProgress(a0,d0))
#pragma amicall(FUIBase,0x132,SetProgressMax(a0,d0))
#pragma amicall(FUIBase,0x138,MakeProgressBar(a0,d0,d1,d2,d3,d4,d5,a1))
#pragma amicall(FUIBase,0x13E,MakeTimer(d0,a0,a1))
#pragma amicall(FUIBase,0x144,StartTimer(a0))
#pragma amicall(FUIBase,0x14A,StopTimer(a0))
#pragma amicall(FUIBase,0x150,PauseTimer(a0))
#pragma amicall(FUIBase,0x156,UnpauseTimer(a0))
#pragma amicall(FUIBase,0x15C,AddTime(a0,d0))
#pragma amicall(FUIBase,0x162,SetTime(a0,d0))
#pragma amicall(FUIBase,0x168,DrawLines(a0,a1,d0,d1))
#pragma amicall(FUIBase,0x16E,OpenGuiScreen(d0,d1,d2,a0,a1,d3,a2,d4,d5,d6,a3))
#pragma amicall(FUIBase,0x174,GuiMessage(a0,a1,a2,d0,d1,d2))
#pragma amicall(FUIBase,0x17A,SetupSizeOutlineData(d0,d1,d2,d3,d4,d5))
#pragma amicall(FUIBase,0x180,IntuiWindow(a0))
#pragma amicall(FUIBase,0x186,CheckMessages())
#pragma amicall(FUIBase,0x18C,GuiLoop())
#pragma amicall(FUIBase,0x192,SetDefaultCols(d0,d1,d2))
#pragma amicall(FUIBase,0x198,SetDefaultFont(a0,d0,d1))
#pragma amicall(FUIBase,0x19E,MakeButton(a0,a1,d0,d1,d2,d3,d4,a2,a3,d5,d6))
#pragma amicall(FUIBase,0x1A4,MakeTabControlArray(a0,d0,d1,d2,d3,d4,d5,a1,a2,a3))
#pragma amicall(FUIBase,0x1AA,TabControlFrame(a0,d0))
#pragma amicall(FUIBase,0x1B0,SetFrameDragPointer(a0,a1,d0,d1,d2,d3))
#pragma amicall(FUIBase,0x1B6,MakeFrame(a0,a1,d0,d1,d2,d3,a2,a3,d4,d5))
#pragma amicall(FUIBase,0x1BC,ActiveRadioButton(a0))
#pragma amicall(FUIBase,0x1C2,MakeRadioButton(a0,a1,d0,d1,d2,d3,d4,a2,d5,a3))
#pragma amicall(FUIBase,0x1C8,SetTickBoxValue(a0,d0))
#pragma amicall(FUIBase,0x1CE,TickBoxValue(a0))
#pragma amicall(FUIBase,0x1D4,MakeTickBox(a0,d0,d1,d2,d3,a1,d4,a2))
#pragma amicall(FUIBase,0x1DA,ClearDDListBox(a0))
#pragma amicall(FUIBase,0x1E0,RemoveFromDDListBox(a0,a1))
#pragma amicall(FUIBase,0x1E6,AddToDDListBox(a0,a1))
#pragma amicall(FUIBase,0x1EC,SortDDListBox(a0,d0))
#pragma amicall(FUIBase,0x1F2,SetDDListBoxPopup(a0,d0,d1,d2,d3))
#pragma amicall(FUIBase,0x1F8,AssociateDDListBox(a0,a1))
#pragma amicall(FUIBase,0x1FE,MakeSubDDListBox(a0,a1,d0,d1,d2,d3,d4,a2,a3))
#pragma amicall(FUIBase,0x204,MakeDDListBox(a0,d0,d1,d2,d3,d4,d5,a1,d6,a2))
#pragma amicall(FUIBase,0x20A,RefreshEditBox(a0))
#pragma amicall(FUIBase,0x210,SetEditBoxFocus(a0))
#pragma amicall(FUIBase,0x216,SetEditBoxCols(a0,d0,d1,d2))
#pragma amicall(FUIBase,0x21C,GetEditBoxText(a0))
#pragma amicall(FUIBase,0x222,GetEditBoxInt(a0))
#pragma amicall(FUIBase,0x228,GetEditBoxDouble(a0))
#pragma amicall(FUIBase,0x22E,SetEditBoxText(a0,a1))
#pragma amicall(FUIBase,0x234,SetEditBoxInt(a0,d0))
#pragma amicall(FUIBase,0x23A,SetEditBoxDouble(a0,d0))
#pragma amicall(FUIBase,0x240,SetEditBoxDP(a0,d0))
#pragma amicall(FUIBase,0x246,MakeEditBox(a0,d0,d1,d2,d3,d4,a1,d5,a2))
#pragma amicall(FUIBase,0x24C,SetOutputBoxDP(a0,d0))
#pragma amicall(FUIBase,0x252,SetOutputBoxInt(a0,d0))
#pragma amicall(FUIBase,0x258,SetOutputBoxText(a0,a1))
#pragma amicall(FUIBase,0x25E,SetOutputBoxDouble(a0,d0))
#pragma amicall(FUIBase,0x264,SetOutputBoxCols(a0,d0,d1,d2))
#pragma amicall(FUIBase,0x26A,MakeOutputBox(a0,d0,d1,d2,d3,d4,a1,d5,a2))
#pragma amicall(FUIBase,0x270,SortListBox(a0,d0,d1,d2))
#pragma amicall(FUIBase,0x276,ClearListBoxTabStops(a0,d0))
#pragma amicall(FUIBase,0x27C,SetListBoxTabStopsArray(a0,d0,d1,a1))
#pragma amicall(FUIBase,0x282,SetListBoxTopNum(a0,d0,d1))
#pragma amicall(FUIBase,0x288,SetListBoxHiNum(a0,d0,d1))
#pragma amicall(FUIBase,0x28E,SetListBoxHiElem(a0,a1,d0))
#pragma amicall(FUIBase,0x294,NoTitles(a0))
#pragma amicall(FUIBase,0x29A,NoLines(a0))
#pragma amicall(FUIBase,0x2A0,TopNum(a0))
#pragma amicall(FUIBase,0x2A6,HiNum(a0))
#pragma amicall(FUIBase,0x2AC,HiElem(a0))
#pragma amicall(FUIBase,0x2B2,HiText(a0))
#pragma amicall(FUIBase,0x2B8,ListColumnText(a0,d0))
#pragma amicall(FUIBase,0x2BE,AddListBoxTitle(a0,a1,d0))
#pragma amicall(FUIBase,0x2C4,AddListBoxItem(a0,a1,d0))
#pragma amicall(FUIBase,0x2CA,ReplaceListBoxItem(a0,a1,a2,d0))
#pragma amicall(FUIBase,0x2D0,InsertListBoxItem(a0,a1,a2,d0))
#pragma amicall(FUIBase,0x2D6,ListBoxRefresh(a0))
#pragma amicall(FUIBase,0x2DC,ClearListBoxTitles(a0,d0))
#pragma amicall(FUIBase,0x2E2,ClearListBoxItems(a0,d0))
#pragma amicall(FUIBase,0x2E8,FindListText(a0,a1,d0))
#pragma amicall(FUIBase,0x2EE,MakeListBox(a0,d0,d1,d2,d3,d4,d5,d6,a1,a2))
#pragma amicall(FUIBase,0x2F4,SetListBoxDragPointer(a0,a1,d0,d1,d2,d3))
#pragma amicall(FUIBase,0x2FA,MakeTreeControl(a0,d0,d1,d2,d3,d4,d5,d6,a1,a2))
#pragma amicall(FUIBase,0x300,SetTreeControlDragPointer(a0,a1,d0,d1,d2,d3))
#pragma amicall(FUIBase,0x306,AddItem(a0,a1,a2,a3,d0,d1,d2))
#pragma amicall(FUIBase,0x30C,ItemIsOpen(a0))
#pragma amicall(FUIBase,0x312,RemoveItem(a0))
#pragma amicall(FUIBase,0x318,OpenItem(a0))
#pragma amicall(FUIBase,0x31E,CloseItem(a0))
#pragma amicall(FUIBase,0x324,TCHiItem(a0))
#pragma amicall(FUIBase,0x32A,TCHiText(a0))
#pragma amicall(FUIBase,0x330,SetTreeControlHiItem(a0,a1,d0))
#pragma amicall(FUIBase,0x336,ItemData(a0))
#pragma amicall(FUIBase,0x33C,TCItemText(a0))
#pragma amicall(FUIBase,0x342,ClearTreeControl(a0))
#pragma amicall(FUIBase,0x348,FindTreeItem(a0,a1))
#pragma amicall(FUIBase,0x34E,ReplaceTCItem(a0,a1,a2,a3))
#pragma amicall(FUIBase,0x354,SetWindowLimits(a0,d0,d1,d2,d3))
#pragma amicall(FUIBase,0x35A,OpenGuiWindow(a0,d0,d1,d2,d3,d4,d5,a1,d6,a2,a3))
#pragma amicall(FUIBase,0x360,ShowFileRequester(a0,a1,a2,a3,d0,d1,d2))
#pragma amicall(FUIBase,0x366,SetFName(a0))
#pragma amicall(FUIBase,0x36C,SetPath(a0))
#pragma amicall(FUIBase,0x372,UpdateFList())
#pragma amicall(FUIBase,0x378,LoadBitMap(a0))
#pragma amicall(FUIBase,0x37E,ShowBitMap(a0,a1,d0,d1,d2))
#pragma amicall(FUIBase,0x384,HideBitMap(a0))
#pragma amicall(FUIBase,0x38A,FreeGuiBitMap(a0))
#pragma amicall(FUIBase,0x390,ScaleBitMap(a0,d0,d1))
#pragma amicall(FUIBase,0x396,RedrawBitMap(a0))
#pragma amicall(FUIBase,0x39C,AttachBitMapToControl(a0,a1,d0,d1,d2,d3,d4))
#pragma amicall(FUIBase,0x3A2,ScreenColoursFromILBM(a0,a1))
#pragma amicall(FUIBase,0x3A8,DisableWinMenus(a0))
#pragma amicall(FUIBase,0x3AE,EnableWinMenus(a0))
#pragma amicall(FUIBase,0x3B4,DisableMenu(a0,a1))
#pragma amicall(FUIBase,0x3BA,EnableMenu(a0,a1))
#pragma amicall(FUIBase,0x3C0,DisableMenuItem(a0,a1))
#pragma amicall(FUIBase,0x3C6,EnableMenuItem(a0,a1))
#pragma amicall(FUIBase,0x3CC,SetWinMenuFn(a0,a1))
#pragma amicall(FUIBase,0x3D2,ClearMenus(a0))
#pragma amicall(FUIBase,0x3D8,ShareMenus(a0,a1))
#pragma amicall(FUIBase,0x3DE,AddMenu(a0,a1,d0,d1))
#pragma amicall(FUIBase,0x3E4,AddMenuItem(a0,a1,a2,a3,d0,d1,d2,d3,d4,d5))
#pragma amicall(FUIBase,0x3EA,AddSubMenuItem(a0,a1,a2,a3,d0,d1,d2,d3,d4,d5))
#pragma amicall(FUIBase,0x3F0,RemoveMenuItem(a0,a1))
#pragma amicall(FUIBase,0x3F6,IsMenuChecked(a0))
#pragma amicall(FUIBase,0x3FC,SetMenuChecked(a0,a1,d0))
#pragma amicall(FUIBase,0x402,GetNextAvailableDisplayMode(d0))
#pragma amicall(FUIBase,0x408,ShowDisplayList(a0,a1,d0,d1,a2))
#pragma amicall(FUIBase,0x40E,GetModeName(d0,a0,d1))
#pragma amicall(FUIBase,0x414,GetDefaultFontCopy(a0,d0,a1,a2))
#pragma amicall(FUIBase,0x41A,WriteText(a0,a1,d0,d1))
#pragma amicall(FUIBase,0x420,GetScreenDetails(a0,a1,a2,a3,d0,d1,d2,d3,d4,d5))
#pragma amicall(FUIBase,0x426,ClonePublicScreen(d0,a3,a0,a1,d1,a2,d5,d2))
#pragma amicall(FUIBase,0x42C,GetModeSize(d0,a0,a1))
#pragma amicall(FUIBase,0x432,ItemElem(a0,d0))
#pragma amicall(FUIBase,0x438,WinPrint(a0,a1))
#pragma amicall(FUIBase,0x43E,WinTab(a0,d0,d1))
#pragma amicall(FUIBase,0x444,WinPrintTab(a0,d0,d1,a1))
#pragma amicall(FUIBase,0x44A,WinPrintCol(a0,a1,d0))
#pragma amicall(FUIBase,0x450,WinShowCursor(a0))
#pragma amicall(FUIBase,0x456,WinHideCursor(a0))
#pragma amicall(FUIBase,0x45C,WinClear(a0))
#pragma amicall(FUIBase,0x462,WinHome(a0))
#pragma amicall(FUIBase,0x468,WinBlankToEOL(a0))
#pragma amicall(FUIBase,0x46E,WinWrapOn(a0))
#pragma amicall(FUIBase,0x474,WinWrapOff(a0))
#pragma amicall(FUIBase,0x47A,SetDDListBoxText(a0,a1))
#pragma amicall(FUIBase,0x480,GetDDListBoxText(a0))
#pragma amicall(FUIBase,0x486,GetEditBoxID(a0))
#pragma amicall(FUIBase,0x48C,GetDDListBoxID(a0))
#pragma amicall(FUIBase,0x492,GetOutputBoxID(a0))
#pragma amicall(FUIBase,0x498,SetPreText(a0,a1))
#pragma amicall(FUIBase,0x49E,SetPostText(a0,a1))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall FUIBase SetSeed              01E 001
#pragma  libcall FUIBase Random               024 001
#pragma  libcall FUIBase CloseConsole         02A 801
#pragma  libcall FUIBase OpenConsole          030 A9803
#pragma  libcall FUIBase ConPutChar           036 0802
#pragma  libcall FUIBase QueueRead            03C 9802
#pragma  libcall FUIBase ConMayGetChar        042 9802
#pragma  libcall FUIBase ConGetChar           048 9802
#pragma  libcall FUIBase ConPrint             04E 9802
#pragma  libcall FUIBase ConClear             054 801
#pragma  libcall FUIBase ConHome              05A 801
#pragma  libcall FUIBase ConBlankToEOL        060 801
#pragma  libcall FUIBase ConTab               066 10803
#pragma  libcall FUIBase ConPrintTab          06C 910804
#pragma  libcall FUIBase ConWrapOff           072 801
#pragma  libcall FUIBase ConWrapOn            078 801
#pragma  libcall FUIBase ConHideCursor        07E 801
#pragma  libcall FUIBase ConShowCursor        084 801
#pragma  libcall FUIBase ConPrintHi           08A 09803
#pragma  libcall FUIBase GuiGetLastErr        090 A9803
#pragma  libcall FUIBase GuiTextLength        096 9802
#pragma  libcall FUIBase GetWindow            09C 801
#pragma  libcall FUIBase RegisterGadget       0A2 A9803
#pragma  libcall FUIBase UnRegisterGadget     0A8 801
#pragma  libcall FUIBase Destroy              0AE 0802
#pragma  libcall FUIBase DestroyM             0B4 18003
#pragma  libcall FUIBase EnableControl        0BA 0802
#pragma  libcall FUIBase EnableM              0C0 18003
#pragma  libcall FUIBase DisableControl       0C6 0802
#pragma  libcall FUIBase DisableM             0CC 18003
#pragma  libcall FUIBase Hide                 0D2 801
#pragma  libcall FUIBase Show                 0D8 801
#pragma  libcall FUIBase LibVersion           0DE 00
#pragma  libcall FUIBase SleepPointer         0E4 801
#pragma  libcall FUIBase WakePointer          0EA 801
#pragma  libcall FUIBase SetGuiPensFromPubScreen 0F0 801
#pragma  libcall FUIBase SetGuiPens           0F6 1002
#pragma  libcall FUIBase ShowMessage          0FC 0BA9805
#pragma  libcall FUIBase DestroyMessage       102 00
#pragma  libcall FUIBase SetPeriod            108 001
#pragma  libcall FUIBase SetDelay             10E 001
#pragma  libcall FUIBase UseSafeMallocs       114 00
#pragma  libcall FUIBase GuiMalloc            11A 1002
#pragma  libcall FUIBase WasGuiMallocd        120 801
#pragma  libcall FUIBase GuiFreeMem           126 90803
#pragma  libcall FUIBase SetProgress          12C 0802
#pragma  libcall FUIBase SetProgressMax       132 0802
#pragma  libcall FUIBase MakeProgressBar      138 9543210808
#pragma  libcall FUIBase MakeTimer            13E 98003
#pragma  libcall FUIBase StartTimer           144 801
#pragma  libcall FUIBase StopTimer            14A 801
#pragma  libcall FUIBase PauseTimer           150 801
#pragma  libcall FUIBase UnpauseTimer         156 801
#pragma  libcall FUIBase AddTime              15C 0802
#pragma  libcall FUIBase SetTime              162 0802
#pragma  libcall FUIBase DrawLines            168 109804
#pragma  libcall FUIBase OpenGuiScreen        16E B654A3982100B
#pragma  libcall FUIBase GuiMessage           174 210A9806
#pragma  libcall FUIBase SetupSizeOutlineData 17A 54321006
#pragma  libcall FUIBase IntuiWindow          180 801
#pragma  libcall FUIBase CheckMessages        186 00
#pragma  libcall FUIBase GuiLoop              18C 00
#pragma  libcall FUIBase SetDefaultCols       192 21003
#pragma  libcall FUIBase SetDefaultFont       198 10803
#pragma  libcall FUIBase MakeButton           19E 65BA43210980B
#pragma  libcall FUIBase MakeTabControlArray  1A4 BA954321080A
#pragma  libcall FUIBase TabControlFrame      1AA 0802
#pragma  libcall FUIBase SetFrameDragPointer  1B0 32109806
#pragma  libcall FUIBase MakeFrame            1B6 54BA3210980A
#pragma  libcall FUIBase ActiveRadioButton    1BC 801
#pragma  libcall FUIBase MakeRadioButton      1C2 B5A43210980A
#pragma  libcall FUIBase SetTickBoxValue      1C8 0802
#pragma  libcall FUIBase TickBoxValue         1CE 801
#pragma  libcall FUIBase MakeTickBox          1D4 A493210808
#pragma  libcall FUIBase ClearDDListBox       1DA 801
#pragma  libcall FUIBase RemoveFromDDListBox  1E0 9802
#pragma  libcall FUIBase AddToDDListBox       1E6 9802
#pragma  libcall FUIBase SortDDListBox        1EC 0802
#pragma  libcall FUIBase SetDDListBoxPopup    1F2 3210805
#pragma  libcall FUIBase AssociateDDListBox   1F8 9802
#pragma  libcall FUIBase MakeSubDDListBox     1FE BA432109809
#pragma  libcall FUIBase MakeDDListBox        204 A6954321080A
#pragma  libcall FUIBase RefreshEditBox       20A 801
#pragma  libcall FUIBase SetEditBoxFocus      210 801
#pragma  libcall FUIBase SetEditBoxCols       216 210804
#pragma  libcall FUIBase GetEditBoxText       21C 801
#pragma  libcall FUIBase GetEditBoxInt        222 801
#pragma  libcall FUIBase GetEditBoxDouble     228 801
#pragma  libcall FUIBase SetEditBoxText       22E 9802
#pragma  libcall FUIBase SetEditBoxInt        234 0802
#pragma  libcall FUIBase SetEditBoxDouble     23A 0802
#pragma  libcall FUIBase SetEditBoxDP         240 0802
#pragma  libcall FUIBase MakeEditBox          246 A5943210809
#pragma  libcall FUIBase SetOutputBoxDP       24C 0802
#pragma  libcall FUIBase SetOutputBoxInt      252 0802
#pragma  libcall FUIBase SetOutputBoxText     258 9802
#pragma  libcall FUIBase SetOutputBoxDouble   25E 0802
#pragma  libcall FUIBase SetOutputBoxCols     264 210804
#pragma  libcall FUIBase MakeOutputBox        26A A5943210809
#pragma  libcall FUIBase SortListBox          270 210804
#pragma  libcall FUIBase ClearListBoxTabStops 276 0802
#pragma  libcall FUIBase SetListBoxTabStopsArray 27C 910804
#pragma  libcall FUIBase SetListBoxTopNum     282 10803
#pragma  libcall FUIBase SetListBoxHiNum      288 10803
#pragma  libcall FUIBase SetListBoxHiElem     28E 09803
#pragma  libcall FUIBase NoTitles             294 801
#pragma  libcall FUIBase NoLines              29A 801
#pragma  libcall FUIBase TopNum               2A0 801
#pragma  libcall FUIBase HiNum                2A6 801
#pragma  libcall FUIBase HiElem               2AC 801
#pragma  libcall FUIBase HiText               2B2 801
#pragma  libcall FUIBase ListColumnText       2B8 0802
#pragma  libcall FUIBase AddListBoxTitle      2BE 09803
#pragma  libcall FUIBase AddListBoxItem       2C4 09803
#pragma  libcall FUIBase ReplaceListBoxItem   2CA 0A9804
#pragma  libcall FUIBase InsertListBoxItem    2D0 0A9804
#pragma  libcall FUIBase ListBoxRefresh       2D6 801
#pragma  libcall FUIBase ClearListBoxTitles   2DC 0802
#pragma  libcall FUIBase ClearListBoxItems    2E2 0802
#pragma  libcall FUIBase FindListText         2E8 09803
#pragma  libcall FUIBase MakeListBox          2EE A9654321080A
#pragma  libcall FUIBase SetListBoxDragPointer 2F4 32109806
#pragma  libcall FUIBase MakeTreeControl      2FA A9654321080A
#pragma  libcall FUIBase SetTreeControlDragPointer 300 32109806
#pragma  libcall FUIBase AddItem              306 210BA9807
#pragma  libcall FUIBase ItemIsOpen           30C 801
#pragma  libcall FUIBase RemoveItem           312 801
#pragma  libcall FUIBase OpenItem             318 801
#pragma  libcall FUIBase CloseItem            31E 801
#pragma  libcall FUIBase TCHiItem             324 801
#pragma  libcall FUIBase TCHiText             32A 801
#pragma  libcall FUIBase SetTreeControlHiItem 330 09803
#pragma  libcall FUIBase ItemData             336 801
#pragma  libcall FUIBase TCItemText           33C 801
#pragma  libcall FUIBase ClearTreeControl     342 801
#pragma  libcall FUIBase FindTreeItem         348 9802
#pragma  libcall FUIBase ReplaceTCItem        34E BA9804
#pragma  libcall FUIBase SetWindowLimits      354 3210805
#pragma  libcall FUIBase OpenGuiWindow        35A BA6954321080B
#pragma  libcall FUIBase ShowFileRequester    360 210BA9807
#pragma  libcall FUIBase SetFName             366 801
#pragma  libcall FUIBase SetPath              36C 801
#pragma  libcall FUIBase UpdateFList          372 00
#pragma  libcall FUIBase LoadBitMap           378 801
#pragma  libcall FUIBase ShowBitMap           37E 2109805
#pragma  libcall FUIBase HideBitMap           384 801
#pragma  libcall FUIBase FreeGuiBitMap        38A 801
#pragma  libcall FUIBase ScaleBitMap          390 10803
#pragma  libcall FUIBase RedrawBitMap         396 801
#pragma  libcall FUIBase AttachBitMapToControl 39C 432109807
#pragma  libcall FUIBase ScreenColoursFromILBM 3A2 9802
#pragma  libcall FUIBase DisableWinMenus      3A8 801
#pragma  libcall FUIBase EnableWinMenus       3AE 801
#pragma  libcall FUIBase DisableMenu          3B4 9802
#pragma  libcall FUIBase EnableMenu           3BA 9802
#pragma  libcall FUIBase DisableMenuItem      3C0 9802
#pragma  libcall FUIBase EnableMenuItem       3C6 9802
#pragma  libcall FUIBase SetWinMenuFn         3CC 9802
#pragma  libcall FUIBase ClearMenus           3D2 801
#pragma  libcall FUIBase ShareMenus           3D8 9802
#pragma  libcall FUIBase AddMenu              3DE 109804
#pragma  libcall FUIBase AddMenuItem          3E4 543210BA980A
#pragma  libcall FUIBase AddSubMenuItem       3EA 543210BA980A
#pragma  libcall FUIBase RemoveMenuItem       3F0 9802
#pragma  libcall FUIBase IsMenuChecked        3F6 801
#pragma  libcall FUIBase SetMenuChecked       3FC 09803
#pragma  libcall FUIBase GetNextAvailableDisplayMode 402 001
#pragma  libcall FUIBase ShowDisplayList      408 A109805
#pragma  libcall FUIBase GetModeName          40E 18003
#pragma  libcall FUIBase GetDefaultFontCopy   414 A90804
#pragma  libcall FUIBase WriteText            41A 109804
#pragma  libcall FUIBase GetScreenDetails     420 543210BA980A
#pragma  libcall FUIBase ClonePublicScreen    426 25A198B008
#pragma  libcall FUIBase GetModeSize          42C 98003
#pragma  libcall FUIBase ItemElem             432 0802
#pragma  libcall FUIBase WinPrint             438 9802
#pragma  libcall FUIBase WinTab               43E 10803
#pragma  libcall FUIBase WinPrintTab          444 910804
#pragma  libcall FUIBase WinPrintCol          44A 09803
#pragma  libcall FUIBase WinShowCursor        450 801
#pragma  libcall FUIBase WinHideCursor        456 801
#pragma  libcall FUIBase WinClear             45C 801
#pragma  libcall FUIBase WinHome              462 801
#pragma  libcall FUIBase WinBlankToEOL        468 801
#pragma  libcall FUIBase WinWrapOn            46E 801
#pragma  libcall FUIBase WinWrapOff           474 801
#pragma  libcall FUIBase SetDDListBoxText     47A 9802
#pragma  libcall FUIBase GetDDListBoxText     480 801
#pragma  libcall FUIBase GetEditBoxID         486 801
#pragma  libcall FUIBase GetDDListBoxID       48C 801
#pragma  libcall FUIBase GetOutputBoxID       492 801
#pragma  libcall FUIBase SetPreText           498 9802
#pragma  libcall FUIBase SetPostText          49E 9802
#endif

#endif	/*  _INCLUDE_PRAGMA_FUI_LIB_H  */
