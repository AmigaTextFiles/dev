OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
{#include <x86_64-linux-gnu/bits/types/time_t.h>}
->NATIVE {__time_t_defined} CONST __TIME_T_DEFINED = 1

/* Returned by `time'.  */
NATIVE {time_t} OBJECT
TYPE TIME_T IS NATIVE {time_t} TIME_T__
