/* $Id: date.h 12757 2001-12-08 22:23:57Z chodorowski $ */
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
