/* $Id: date.h,v 1.12 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <utility/date.h>}
NATIVE {UTILITY_DATE_H} CONST

NATIVE {ClockData} OBJECT clockdata
    {sec}	sec	:UINT   /* 0..59 */
    {min}	min	:UINT   /* 0..59 */
    {hour}	hour	:UINT  /* 0..23 */
    {mday}	mday	:UINT  /* 1..31 */
    {month}	month	:UINT /* 1..12 */
    {year}	year	:UINT  /* 1978.. */
    {wday}	wday	:UINT  /* 0..6; 0 == Sunday */
ENDOBJECT
