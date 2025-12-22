#ifndef _INCLUDE_PRAGMA_COLOURS_LIB_H
#define _INCLUDE_PRAGMA_COLOURS_LIB_H

#ifndef CLIB_COLOURS_PROTOS_H
#include <clib/colours_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(COLBase,0x006,BlurArea(a0,d0,d1,d2,d3,d4))
#pragma amicall(COLBase,0x00C,ClosestColour(d0,a0))
#pragma amicall(COLBase,0x012,ConvertHSVToRGB(a0))
#pragma amicall(COLBase,0x018,ConvertRGBToHSV(d0,a0))
#pragma amicall(COLBase,0x01E,CopyPalette(a0,a1,d0,d1,d2))
#pragma amicall(COLBase,0x024,DarkenArea(a0,d0,d1,d2,d3,d4))
#pragma amicall(COLBase,0x02A,LightenArea(a0,d0,d1,d2,d3,d4))
#pragma amicall(COLBase,0x030,RemapBitmap(a0,a1,d0))
#pragma amicall(COLBase,0x036,DarkenPixel(a0,d0,d1,d2))
#pragma amicall(COLBase,0x03C,LightenPixel(a0,d0,d1,d2))
#pragma amicall(COLBase,0x042,CalcBrightness(d0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall COLBase BlurArea             006 43210806
#pragma libcall COLBase ClosestColour        00C 8002
#pragma libcall COLBase ConvertHSVToRGB      012 801
#pragma libcall COLBase ConvertRGBToHSV      018 8002
#pragma libcall COLBase CopyPalette          01E 2109805
#pragma libcall COLBase DarkenArea           024 43210806
#pragma libcall COLBase LightenArea          02A 43210806
#pragma libcall COLBase RemapBitmap          030 09803
#pragma libcall COLBase DarkenPixel          036 210804
#pragma libcall COLBase LightenPixel         03C 210804
#pragma libcall COLBase CalcBrightness       042 001
#endif

#endif	/*  _INCLUDE_PRAGMA_COLOURS_LIB_H  */