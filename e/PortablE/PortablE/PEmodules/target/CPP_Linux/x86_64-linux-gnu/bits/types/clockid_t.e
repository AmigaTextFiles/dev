OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
{#include <x86_64-linux-gnu/bits/types/clockid_t.h>}
->NATIVE {__clockid_t_defined} CONST __CLOCKID_T_DEFINED = 1

/* Clock ID used in clock and timer functions.  */
NATIVE {clockid_t} OBJECT
TYPE CLOCKID_T IS NATIVE {clockid_t} CLOCKID_T__
