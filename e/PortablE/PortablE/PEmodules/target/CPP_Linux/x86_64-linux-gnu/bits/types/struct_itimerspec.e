OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/x86_64-linux-gnu/bits/types/struct_timespec'
{#include <x86_64-linux-gnu/bits/types/struct_itimerspec.h>}

->NATIVE {__itimerspec_defined} CONST __ITIMERSPEC_DEFINED = 1


/* POSIX.1b structure for timer start values and intervals.  */
NATIVE {itimerspec} OBJECT itimerspec
    {it_interval}	interval	:timespec
    {it_value}	value	:timespec
  ENDOBJECT
