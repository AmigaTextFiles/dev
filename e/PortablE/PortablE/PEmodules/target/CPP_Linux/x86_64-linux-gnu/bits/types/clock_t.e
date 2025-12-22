OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
{#include <x86_64-linux-gnu/bits/types/clock_t.h>}
->NATIVE {__clock_t_defined} CONST __CLOCK_T_DEFINED = 1

/* Returned by `clock'.  */
NATIVE {clock_t} OBJECT
TYPE CLOCK_T IS NATIVE {clock_t} CLOCK_T__
