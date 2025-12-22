#ifndef PRAGMAS_CALENDAR_MCC_PRAGMAS_H
#define PRAGMAS_CALENDAR_MCC_PRAGMAS_H

/*
**  $VER: Calendar_mcc_pragmas.h 18.3 (27.7.2005)
**  Includes Release 18.3
**
**  Written by Alfonso Ranieri <alforan@tin.it>.
**  All Rights Reserved.
*/

#ifndef CLIB_CALENDAR_MCC_PROTOS_H
#include <clib/Calendar_mcc_protos.h>
#endif

#if defined(AZTEC_C) || defined(__MAXON__) || defined(__STORM__)
#pragma amicall(CalendarBase,0x060,CALDateToGreg(d0,d1,d2))
#pragma amicall(CalendarBase,0x066,CALGregToDate(d0,a0,a1,a2))
#pragma amicall(CalendarBase,0x06c,CALIsLeap(d0))
#pragma amicall(CalendarBase,0x072,CALGetMonthDays(d0,d1))
#pragma amicall(CalendarBase,0x078,CALValidateDate(a0,a1,a2))
#pragma amicall(CalendarBase,0x07e,CALGetToday())
#pragma amicall(CalendarBase,0x084,CALGregWeekday(d0))
#pragma amicall(CalendarBase,0x08a,CALDateWeekday(d0,d1,d2))
#pragma amicall(CalendarBase,0x090,CALGetDay(d0))
#pragma amicall(CalendarBase,0x096,CALGetMonth(d0))
#pragma amicall(CalendarBase,0x09c,CALGetYear(d0))
#pragma amicall(CalendarBase,0x0a2,CALGetEaster(d0,a0,a1))
#pragma amicall(CalendarBase,0x0a8,CALGetJulian(d0))
#pragma amicall(CalendarBase,0x0ae,CALFormatDate(a0,a1,d0,a2,d1))
#endif
#if defined(_DCC) || defined(__SASC)
#pragma  libcall CalendarBase CALDateToGreg          060 21003
#pragma  libcall CalendarBase CALGregToDate          066 a98004
#pragma  libcall CalendarBase CALIsLeap              06c 001
#pragma  libcall CalendarBase CALGetMonthDays        072 1002
#pragma  libcall CalendarBase CALValidateDate        078 a9803
#pragma  libcall CalendarBase CALGetToday            07e 00
#pragma  libcall CalendarBase CALGregWeekday         084 001
#pragma  libcall CalendarBase CALDateWeekday         08a 21003
#pragma  libcall CalendarBase CALGetDay              090 001
#pragma  libcall CalendarBase CALGetMonth            096 001
#pragma  libcall CalendarBase CALGetYear             09c 001
#pragma  libcall CalendarBase CALGetEaster           0a2 98003
#pragma  libcall CalendarBase CALGetJulian           0a8 001
#pragma  libcall CalendarBase CALFormatDate          0ae 1a09805
#endif

#endif /* PRAGMAS_Calendar_mcc_PRAGMAS_H */
