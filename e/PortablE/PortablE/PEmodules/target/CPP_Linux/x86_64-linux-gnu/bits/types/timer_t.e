OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
{#include <x86_64-linux-gnu/bits/types/timer_t.h>}
->NATIVE {__timer_t_defined} CONST __TIMER_T_DEFINED = 1

/* Timer ID returned by `timer_create'.  */
NATIVE {timer_t} OBJECT
TYPE TIMER_T IS NATIVE {timer_t} TIMER_T__
