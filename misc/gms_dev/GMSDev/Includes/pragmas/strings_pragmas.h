#ifndef _INCLUDE_PRAGMA_STRINGS_LIB_H
#define _INCLUDE_PRAGMA_STRINGS_LIB_H

#ifndef CLIB_STRINGS_PROTOS_H
#include <clib/strings_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(STRBase,0x006,StrClone(a0,d0))
#pragma amicall(STRBase,0x00C,StrCompare(a0,a1,d0,d1))
#pragma amicall(STRBase,0x012,StrLength(a0))
#pragma amicall(STRBase,0x018,StrMerge(a0,a1,a2))
#pragma amicall(STRBase,0x01E,StrCopy(a0,a1,d0))
#pragma amicall(STRBase,0x024,StrSearch(a0,a1))
#pragma amicall(STRBase,0x02A,StrUpper(a0))
#pragma amicall(STRBase,0x030,StrLower(a0))
#pragma amicall(STRBase,0x036,StrToInt(a0))
#pragma amicall(STRBase,0x03C,IntToStr(d0,a0))
#pragma amicall(STRBase,0x042,StrCapitalize(a0))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma libcall STRBase StrClone             006 0802
#pragma libcall STRBase StrCompare           00C 109804
#pragma libcall STRBase StrLength            012 801
#pragma libcall STRBase StrMerge             018 A9803
#pragma libcall STRBase StrCopy              01E 09803
#pragma libcall STRBase StrSearch            024 9802
#pragma libcall STRBase StrUpper             02A 801
#pragma libcall STRBase StrLower             030 801
#pragma libcall STRBase StrToInt             036 801
#pragma libcall STRBase IntToStr             03C 8002
#pragma libcall STRBase StrCapitalize        042 801
#endif

#endif	/*  _INCLUDE_PRAGMA_STRINGS_LIB_H  */