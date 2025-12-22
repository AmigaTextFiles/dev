OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types/__sigset_t'
{#include <x86_64-linux-gnu/bits/types/sigset_t.h>}
->NATIVE {__sigset_t_defined} CONST ->__SIGSET_T_DEFINED = 1

/* A set of signals to be blocked, unblocked, or waited for.  */
NATIVE {sigset_t Typedef} OBJECT sigset_t OF __sigset_t
ENDOBJECT
