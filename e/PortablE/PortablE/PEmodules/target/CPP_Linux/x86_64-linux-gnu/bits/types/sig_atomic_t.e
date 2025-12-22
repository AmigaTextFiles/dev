OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
{#include <x86_64-linux-gnu/bits/types/sig_atomic_t.h>}
->NATIVE {__sig_atomic_t_defined} CONST __SIG_ATOMIC_T_DEFINED = 1

/* An integral type that can be modified atomically, without the
   possibility of a signal arriving in the middle of the operation.  */
NATIVE {sig_atomic_t} OBJECT
->TYPE sig_atomic_t IS NATIVE {sig_atomic_t} __sig_atomic_t
