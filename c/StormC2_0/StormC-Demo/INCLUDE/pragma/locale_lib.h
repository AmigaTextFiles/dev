#ifndef _INCLUDE_PRAGMA_LOCALE_LIB_H
#define _INCLUDE_PRAGMA_LOCALE_LIB_H

/*
**  $VER: locale_lib.h 10.2 (29.12.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef  CLIB_LOCALE_PROTOS_H
#include <clib/locale_protos.h>
#endif

#ifdef __cplusplus
extern "C" {
#endif

#pragma amicall(LocaleBase, 0x24, CloseCatalog(a0))
#pragma amicall(LocaleBase, 0x2a, CloseLocale(a0))
#pragma amicall(LocaleBase, 0x30, ConvToLower(a0,d0))
#pragma amicall(LocaleBase, 0x36, ConvToUpper(a0,d0))
#pragma amicall(LocaleBase, 0x3c, FormatDate(a0,a1,a2,a3))
#pragma amicall(LocaleBase, 0x42, FormatString(a0,a1,a2,a3))
#pragma amicall(LocaleBase, 0x48, GetCatalogStr(a0,d0,a1))
#pragma amicall(LocaleBase, 0x4e, GetLocaleStr(a0,d0))
#pragma amicall(LocaleBase, 0x54, IsAlNum(a0,d0))
#pragma amicall(LocaleBase, 0x5a, IsAlpha(a0,d0))
#pragma amicall(LocaleBase, 0x60, IsCntrl(a0,d0))
#pragma amicall(LocaleBase, 0x66, IsDigit(a0,d0))
#pragma amicall(LocaleBase, 0x6c, IsGraph(a0,d0))
#pragma amicall(LocaleBase, 0x72, IsLower(a0,d0))
#pragma amicall(LocaleBase, 0x78, IsPrint(a0,d0))
#pragma amicall(LocaleBase, 0x7e, IsPunct(a0,d0))
#pragma amicall(LocaleBase, 0x84, IsSpace(a0,d0))
#pragma amicall(LocaleBase, 0x8a, IsUpper(a0,d0))
#pragma amicall(LocaleBase, 0x90, IsXDigit(a0,d0))
#pragma amicall(LocaleBase, 0x96, OpenCatalogA(a0,a1,a2))
#pragma tagcall(LocaleBase, 0x96, OpenCatalogA(a0,a1,a2)) // New
#pragma amicall(LocaleBase, 0x9c, OpenLocale(a0))
#pragma amicall(LocaleBase, 0xa2, ParseDate(a0,a1,a2,a3))
#pragma amicall(LocaleBase, 0xae, StrConvert(a0,a1,a2,d0,d1))
#pragma amicall(LocaleBase, 0xb4, StrnCmp(a0,a1,a2,d0,d1))

#ifdef __cplusplus
}
#endif

#endif
