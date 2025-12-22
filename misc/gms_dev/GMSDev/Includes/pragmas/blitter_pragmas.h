#ifndef _INCLUDE_PRAGMA_BLITTER_LIB_H
#define _INCLUDE_PRAGMA_BLITTER_LIB_H

#ifndef CLIB_BLITTER_PROTOS_H
#include <clib/blitter_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(BLTBase,0x006,AllocBlitMem(d0,d1))
#pragma amicall(BLTBase,0x00C,DrawRGBPixel(a0,d1,d2,d3))
#pragma amicall(BLTBase,0x012,SortBobList(a0,d0))
#pragma amicall(BLTBase,0x018,SortMBob(a0,d0))
#pragma amicall(BLTBase,0x01E,CopyBuffer(a0,d0,d1))
#pragma amicall(BLTBase,0x024,CreateMasks(a1))
#pragma amicall(BLTBase,0x02A,DrawBob(a1))
#pragma amicall(BLTBase,0x030,DrawBobList(a1))
#pragma amicall(BLTBase,0x036,DrawLine(a0,d1,d2,d3,d4,d5,d6))
#pragma amicall(BLTBase,0x03C,DrawPixel(a0,d1,d2,d3))
#pragma amicall(BLTBase,0x042,DrawPixelList(a0,a1))
#pragma amicall(BLTBase,0x048,DrawUCLine(a0,d1,d2,d3,d4,d5,d6))
#pragma amicall(BLTBase,0x04E,DrawUCPixelList(a0,a1))
#pragma amicall(BLTBase,0x054,DrawUCPixel(a0,d1,d2,d3))
#pragma amicall(BLTBase,0x05A,FreeBlitMem(d0))
#pragma amicall(BLTBase,0x060,DrawUCRGBPixel(a0,d1,d2,d3))
#pragma amicall(BLTBase,0x066,ReadPixel(a0,d1,d2))
#pragma amicall(BLTBase,0x06C,ReadPixelList(a0,a1))
#pragma amicall(BLTBase,0x072,SetBobDimensions(a1,d0,d1,d2))
#pragma amicall(BLTBase,0x078,SetBobDrawMode(a1,d0))
#pragma amicall(BLTBase,0x07E,SetBobFrames(a1))
#pragma amicall(BLTBase,0x084,TakeOSBlitter())
#pragma amicall(BLTBase,0x08A,GiveOSBlitter())
#pragma amicall(BLTBase,0x090,ReadRGBPixel(a0,d1,d2))
#pragma amicall(BLTBase,0x096,DrawRGBLine(a0,d1,d2,d3,d4,d5,d6))
#pragma amicall(BLTBase,0x09C,DrawUCRGBLine(a0,d1,d2,d3,d4,d5,d6))
#pragma amicall(BLTBase,0x0A2,DrawRGBPixelList(a0,a1))
#pragma amicall(BLTBase,0x0A8,GetBmpType())
#pragma amicall(BLTBase,0x0AE,PenRect(a0,d0,d1,d2,d3,d4))
#pragma amicall(BLTBase,0x0B4,CopyLine(a0,a1,d0,d1,d2,d3))
#pragma amicall(BLTBase,0x0BA,BlitArea(a0,a1,d0,d1,d2,d3,d4,d5,d6))
#pragma amicall(BLTBase,0x0C0,SetRGBPen(a0,d0))
#pragma amicall(BLTBase,0x0C6,PenPixel(a0,d0,d1))
#pragma amicall(BLTBase,0x0CC,PenLine(a0,d0,d1,d2,d3,d4))
#pragma amicall(BLTBase,0x0D2,GetRGBPen(a0))
#pragma amicall(BLTBase,0x0D8,PenUCLine(a0,d0,d1,d2,d3,d4))
#pragma amicall(BLTBase,0x0DE,PenCircle(a0,d0,d1,d2,d3))
#pragma amicall(BLTBase,0x0E4,PenEllipse(a0,d0,d1,d2,d3,d4))
#pragma amicall(BLTBase,0x0EA,Flood(a0,d0,d1,d2))
#pragma amicall(BLTBase,0x0F0,FlipHBitmap(a0))
#pragma amicall(BLTBase,0x0F6,FlipVBitmap(a0))
#pragma amicall(BLTBase,0x0FC,SetPenShape(a0,d0,d1))
#pragma amicall(BLTBase,0x102,PenLinePxl(a0,d0,d1,d2,d3,d4))
#pragma amicall(BLTBase,0x108,DrawPen(a0,d0,d1))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall BLTBase AllocBlitMem         006 1002
#pragma libcall BLTBase DrawRGBPixel         00C 321804
#pragma libcall BLTBase SortBobList          012 0802
#pragma libcall BLTBase SortMBob             018 0802
#pragma libcall BLTBase CopyBuffer           01E 10803
#pragma libcall BLTBase CreateMasks          024 901
#pragma libcall BLTBase DrawBob              02A 901
#pragma libcall BLTBase DrawBobList          030 901
#pragma libcall BLTBase DrawLine             036 654321807
#pragma libcall BLTBase DrawPixel            03C 321804
#pragma libcall BLTBase DrawPixelList        042 9802
#pragma libcall BLTBase DrawUCLine           048 654321807
#pragma libcall BLTBase DrawUCPixelList      04E 9802
#pragma libcall BLTBase DrawUCPixel          054 321804
#pragma libcall BLTBase FreeBlitMem          05A 001
#pragma libcall BLTBase DrawUCRGBPixel       060 321804
#pragma libcall BLTBase ReadPixel            066 21803
#pragma libcall BLTBase ReadPixelList        06C 9802
#pragma libcall BLTBase SetBobDimensions     072 210904
#pragma libcall BLTBase SetBobDrawMode       078 0902
#pragma libcall BLTBase SetBobFrames         07E 901
#pragma libcall BLTBase TakeOSBlitter        084 00
#pragma libcall BLTBase GiveOSBlitter        08A 00
#pragma libcall BLTBase ReadRGBPixel         090 21803
#pragma libcall BLTBase DrawRGBLine          096 654321807
#pragma libcall BLTBase DrawUCRGBLine        09C 654321807
#pragma libcall BLTBase DrawRGBPixelList     0A2 9802
#pragma libcall BLTBase GetBmpType           0A8 00
#pragma libcall BLTBase PenRect              0AE 43210806
#pragma libcall BLTBase CopyLine             0B4 32109806
#pragma libcall BLTBase BlitArea             0BA 65432109809
#pragma libcall BLTBase SetRGBPen            0C0 0802
#pragma libcall BLTBase PenPixel             0C6 10803
#pragma libcall BLTBase PenLine              0CC 43210806
#pragma libcall BLTBase GetRGBPen            0D2 801
#pragma libcall BLTBase PenUCLine            0D8 43210806
#pragma libcall BLTBase PenCircle            0DE 3210805
#pragma libcall BLTBase PenEllipse           0E4 43210806
#pragma libcall BLTBase Flood                0EA 210804
#pragma libcall BLTBase FlipHBitmap          0F0 801
#pragma libcall BLTBase FlipVBitmap          0F6 801
#pragma libcall BLTBase SetPenShape          0FC 10803
#pragma libcall BLTBase PenLinePxl           102 43210806
#pragma libcall BLTBase DrawPen              108 10803
#endif

#endif	/*  _INCLUDE_PRAGMA_BLITTER_LIB_H  */