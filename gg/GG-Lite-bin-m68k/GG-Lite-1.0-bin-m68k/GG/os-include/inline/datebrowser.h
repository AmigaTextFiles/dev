#ifndef _INLINE_DATEBROWSER_H
#define _INLINE_DATEBROWSER_H

#ifndef CLIB_DATEBROWSER_PROTOS_H
#define CLIB_DATEBROWSER_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif
#ifndef  INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef DATEBROWSER_BASE_NAME
#define DATEBROWSER_BASE_NAME DateBrowserBase
#endif

#define DATEBROWSER_GetClass() \
	LP0(0x1e, Class *, DATEBROWSER_GetClass, \
	, DATEBROWSER_BASE_NAME)

#define JulianWeekDay(day, month, year) \
	LP3(0x24, UWORD, JulianWeekDay, ULONG, day, d0, ULONG, month, d1, LONG, year, d2, \
	, DATEBROWSER_BASE_NAME)

#define JulianMonthDays(month, year) \
	LP2(0x2a, UWORD, JulianMonthDays, ULONG, month, d0, LONG, year, d1, \
	, DATEBROWSER_BASE_NAME)

#define JulianLeapYear(year) \
	LP1(0x30, BOOL, JulianLeapYear, LONG, year, d0, \
	, DATEBROWSER_BASE_NAME)

#endif /*  _INLINE_DATEBROWSER_H  */
