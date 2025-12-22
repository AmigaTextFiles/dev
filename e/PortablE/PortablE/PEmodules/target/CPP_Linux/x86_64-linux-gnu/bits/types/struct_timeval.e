OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
{#include <x86_64-linux-gnu/bits/types/struct_timeval.h>}
->NATIVE {__timeval_defined} CONST __TIMEVAL_DEFINED = 1

/* A time value that is accurate to the nearest
   microsecond but also has a range of years.  */
NATIVE {timeval} OBJECT timeval
  {tv_sec}	sec	:TIME_T__		/* Seconds.  */
  {tv_usec}	usec	:SUSECONDS_T__	/* Microseconds.  */
ENDOBJECT
