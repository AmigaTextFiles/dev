OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
{#include <x86_64-linux-gnu/bits/types/struct_tm.h>}
->NATIVE {__struct_tm_defined} CONST __STRUCT_TM_DEFINED = 1

/* ISO C `broken-down time' structure.  */
NATIVE {tm} OBJECT tm
  {tm_sec}	sec	:VALUE			/* Seconds.	[0-60] (1 leap second) */
  {tm_min}	min	:VALUE			/* Minutes.	[0-59] */
  {tm_hour}	hour	:VALUE			/* Hours.	[0-23] */
  {tm_mday}	mday	:VALUE			/* Day.		[1-31] */
  {tm_mon}	mon	:VALUE			/* Month.	[0-11] */
  {tm_year}	year	:VALUE			/* Year	- 1900.  */
  {tm_wday}	wday	:VALUE			/* Day of week.	[0-6] */
  {tm_yday}	yday	:VALUE			/* Days in year.[0-365]	*/
  {tm_isdst}	isdst	:VALUE			/* DST.		[-1/0/1]*/

  {tm_gmtoff}	gmtoff	:CLONG		/* Seconds east of UTC.  */
  {tm_zone}	zone	:ARRAY OF CHAR		/* Timezone abbreviation.  */
ENDOBJECT
