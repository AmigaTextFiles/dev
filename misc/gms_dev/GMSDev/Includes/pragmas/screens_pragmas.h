#ifndef _INCLUDE_PRAGMA_SCREENS_LIB_H
#define _INCLUDE_PRAGMA_SCREENS_LIB_H

#ifndef CLIB_SCREENS_PROTOS_H
#include <clib/screens_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(SCRBase,0x006,AllocVideoMem(d0,d1))
#pragma amicall(SCRBase,0x00C,BlankColours(a0))
#pragma amicall(SCRBase,0x012,BlankOn())
#pragma amicall(SCRBase,0x018,BlankOff())
#pragma amicall(SCRBase,0x01E,ChangeColours(a0,a1,d0,d1))
#pragma amicall(SCRBase,0x024,ColourMorph(a0,d0,d1,d3,d4,d2,d5))
#pragma amicall(SCRBase,0x02A,ColourToPalette(a0,d0,d1,d3,d4,a1,d2))
#pragma amicall(SCRBase,0x030,FreeVideoMem(d0))
#pragma amicall(SCRBase,0x036,ReadySwitch(a0))
#pragma amicall(SCRBase,0x03C,WaitAVBL())
#pragma amicall(SCRBase,0x042,SetBmpOffsets(a0,d0,d1))
#pragma amicall(SCRBase,0x048,prvMoveBitmap(a0))
#pragma amicall(SCRBase,0x04E,SetScrOffsets(a0,d0,d1))
#pragma amicall(SCRBase,0x054,SetScrDimensions(a0,d0,d1))
#pragma amicall(SCRBase,0x05A,PaletteMorph(a0,d0,d1,d3,d4,a1,a2))
#pragma amicall(SCRBase,0x060,PaletteToColour(a0,d0,d1,d3,d4,a1,d2))
#pragma amicall(SCRBase,0x066,RefreshScreen(a0))
#pragma amicall(SCRBase,0x06C,prvRemakeScreen(a0))
#pragma amicall(SCRBase,0x072,prvSwitchScreen())
#pragma amicall(SCRBase,0x078,ReturnDisplay())
#pragma amicall(SCRBase,0x07E,SwapBuffers(a0))
#pragma amicall(SCRBase,0x084,TakeDisplay(a0))
#pragma amicall(SCRBase,0x08A,UpdateColour(a0,d0,d1))
#pragma amicall(SCRBase,0x090,UpdatePalette(a0))
#pragma amicall(SCRBase,0x096,WaitRastLine(a0,d0))
#pragma amicall(SCRBase,0x09C,WaitVBL())
#pragma amicall(SCRBase,0x0A2,WaitSwitch(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall SCRBase AllocVideoMem        006 1002
#pragma libcall SCRBase BlankColours         00C 801
#pragma libcall SCRBase BlankOn              012 00
#pragma libcall SCRBase BlankOff             018 00
#pragma libcall SCRBase ChangeColours        01E 109804
#pragma libcall SCRBase ColourMorph          024 524310807
#pragma libcall SCRBase ColourToPalette      02A 294310807
#pragma libcall SCRBase FreeVideoMem         030 001
#pragma libcall SCRBase ReadySwitch          036 801
#pragma libcall SCRBase WaitAVBL             03C 00
#pragma libcall SCRBase SetBmpOffsets        042 10803
#pragma libcall SCRBase prvMoveBitmap        048 801
#pragma libcall SCRBase SetScrOffsets        04E 10803
#pragma libcall SCRBase SetScrDimensions     054 10803
#pragma libcall SCRBase PaletteMorph         05A A94310807
#pragma libcall SCRBase PaletteToColour      060 294310807
#pragma libcall SCRBase RefreshScreen        066 801
#pragma libcall SCRBase prvRemakeScreen      06C 801
#pragma libcall SCRBase prvSwitchScreen      072 00
#pragma libcall SCRBase ReturnDisplay        078 00
#pragma libcall SCRBase SwapBuffers          07E 801
#pragma libcall SCRBase TakeDisplay          084 801
#pragma libcall SCRBase UpdateColour         08A 10803
#pragma libcall SCRBase UpdatePalette        090 801
#pragma libcall SCRBase WaitRastLine         096 0802
#pragma libcall SCRBase WaitVBL              09C 00
#pragma libcall SCRBase WaitSwitch           0A2 801
#endif

#endif	/*  _INCLUDE_PRAGMA_SCREENS_LIB_H  */
