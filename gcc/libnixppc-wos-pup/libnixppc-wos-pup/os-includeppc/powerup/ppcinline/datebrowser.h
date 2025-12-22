/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_DATEBROWSER_H
#define _PPCINLINE_DATEBROWSER_H

#ifndef __PPCINLINE_MACROS_H
#include <powerup/ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef DATEBROWSER_BASE_NAME
#define DATEBROWSER_BASE_NAME DateBrowserBase
#endif /* !DATEBROWSER_BASE_NAME */

#define DATEBROWSER_GetClass() \
	LP0(0x1e, Class *, DATEBROWSER_GetClass, \
	, DATEBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define JulianLeapYear(year) \
	LP1(0x30, BOOL, JulianLeapYear, LONG, year, d0, \
	, DATEBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#define JulianWeekDay(day, month, year) \
	LP3(0x24, UWORD, JulianWeekDay, UWORD, day, d0, UWORD, month, d1, LONG, year, d2, \
	, DATEBROWSER_BASE_NAME, IF_CACHEFLUSHALL, NULL, 0, IF_CACHEFLUSHALL, NULL, 0)

#endif /* !_PPCINLINE_DATEBROWSER_H */
