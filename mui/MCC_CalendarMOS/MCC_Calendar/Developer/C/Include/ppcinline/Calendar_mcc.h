/* Automatically generated header! Do not edit! */

#ifndef _PPCINLINE_CALENDAR_MCC_H
#define _PPCINLINE_CALENDAR_MCC_H

#ifndef __PPCINLINE_MACROS_H
#include <ppcinline/macros.h>
#endif /* !__PPCINLINE_MACROS_H */

#ifndef CALENDAR_MCC_BASE_NAME
#define CALENDAR_MCC_BASE_NAME CalendarBase
#endif /* !CALENDAR_MCC_BASE_NAME */

#define CALGetYear(__p0) \
	LP1(156, ULONG , CALGetYear, \
		ULONG , __p0, d0, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALGetToday() \
	LP0(126, ULONG , CALGetToday, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALGetJulian(__p0) \
	LP1(168, ULONG , CALGetJulian, \
		ULONG , __p0, d0, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALGetEaster(__p0, __p1, __p2) \
	LP3NR(162, CALGetEaster, \
		ULONG , __p0, d0, \
		ULONG *, __p1, a0, \
		ULONG *, __p2, a1, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALGregToDate(__p0, __p1, __p2, __p3) \
	LP4(102, ULONG , CALGregToDate, \
		ULONG , __p0, d0, \
		ULONG *, __p1, a0, \
		ULONG *, __p2, a1, \
		ULONG *, __p3, a2, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALDateToGreg(__p0, __p1, __p2) \
	LP3(96, ULONG , CALDateToGreg, \
		ULONG , __p0, d0, \
		ULONG , __p1, d1, \
		ULONG , __p2, d2, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALGetMonth(__p0) \
	LP1(150, ULONG , CALGetMonth, \
		ULONG , __p0, d0, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALGetMonthDays(__p0, __p1) \
	LP2(114, ULONG , CALGetMonthDays, \
		ULONG , __p0, d0, \
		ULONG , __p1, d1, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALFormatDate(__p0, __p1, __p2, __p3, __p4) \
	LP5(174, char *, CALFormatDate, \
		struct Locale *, __p0, a0, \
		char *, __p1, a1, \
		int , __p2, d0, \
		char *, __p3, a2, \
		ULONG , __p4, d1, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALDateWeekday(__p0, __p1, __p2) \
	LP3(138, ULONG , CALDateWeekday, \
		ULONG , __p0, d0, \
		ULONG , __p1, d1, \
		ULONG , __p2, d2, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALValidateDate(__p0, __p1, __p2) \
	LP3NR(120, CALValidateDate, \
		ULONG *, __p0, a0, \
		ULONG *, __p1, a1, \
		ULONG *, __p2, a2, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALGetDay(__p0) \
	LP1(144, ULONG , CALGetDay, \
		ULONG , __p0, d0, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALIsLeap(__p0) \
	LP1(108, ULONG , CALIsLeap, \
		ULONG , __p0, d0, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#define CALGregWeekday(__p0) \
	LP1(132, ULONG , CALGregWeekday, \
		ULONG , __p0, d0, \
		, CALENDAR_MCC_BASE_NAME, 0, 0, 0, 0, 0, 0)

#endif /* !_PPCINLINE_CALENDAR_MCC_H */
