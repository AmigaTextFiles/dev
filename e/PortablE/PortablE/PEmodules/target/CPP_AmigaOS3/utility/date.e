/* $VER: date.h 39.1 (20.1.1992) */
OPT NATIVE
MODULE 'target/exec/types'
{#include <utility/date.h>}
NATIVE {UTILITY_DATE_H} CONST

NATIVE {ClockData} OBJECT clockdata
    {sec}	sec	:UINT
    {min}	min	:UINT
    {hour}	hour	:UINT
    {mday}	mday	:UINT
    {month}	month	:UINT
    {year}	year	:UINT
    {wday}	wday	:UINT
ENDOBJECT
