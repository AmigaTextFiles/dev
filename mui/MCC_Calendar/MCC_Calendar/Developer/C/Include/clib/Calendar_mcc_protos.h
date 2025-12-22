#ifndef CLIB_CALENDAR_MCC_PROTOS_H
#define CLIB_CALENDAR_MCC_PROTOS_H

/*
**  $VER: Calendar_mcc_protos.h 18.3 (27.7.2005)
**  Includes Release 18.3
**
**  C prototypes. For use with 32 bit integers only.
**
**  Written by Alfonso Ranieri <alforan@tin.it>.
**  All Rights Reserved.
*/

#ifndef LIBRARIES_CALENDAR_MCC_H
#include <libraries/Calendar_mcc.h>
#endif

#ifndef LIBRARIES_LOCALE_H
#include <libraries/locale.h>
#endif

ULONG CALGregToDate ( ULONG greg , ULONG *day , ULONG *month , ULONG *year );
ULONG CALDateToGreg ( ULONG day , ULONG month , ULONG year );
ULONG CALIsLeap ( ULONG year );
ULONG CALGetDay ( ULONG greg );
ULONG CALGetMonth ( ULONG greg );
ULONG CALGetYear ( ULONG greg );
ULONG CALGetMonthDays ( ULONG month , ULONG year );
ULONG CALGetToday ( void );
ULONG CALDateWeekday ( ULONG day , ULONG month , ULONG year );
ULONG CALGregWeekday ( ULONG greg );
void CALValidateDate ( ULONG *day , ULONG *month , ULONG *year );
void CALGetEaster ( ULONG year , ULONG *d , ULONG *m );
ULONG CALGetJulian ( ULONG greg );
char *CALFormatDate ( struct Locale *locale , char *buf , int size , char *fmt , ULONG greg );

#endif /* CLIB_CALENDAR_MCC_PROTOS_H */
