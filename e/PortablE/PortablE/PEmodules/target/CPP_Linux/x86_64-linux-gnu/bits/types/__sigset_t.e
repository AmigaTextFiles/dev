OPT NATIVE
MODULE 'std/pUnsigned'
{#include <x86_64-linux-gnu/bits/types/__sigset_t.h>}
->NATIVE {____sigset_t_defined} DEF

NATIVE {_SIGSET_NWORDS} CONST SIGSET_NWORDS_ = (1024 / (8 * SIZEOF UCLONG))

NATIVE {__sigset_t Typedef} OBJECT __sigset_t
	{__val} __val[SIGSET_NWORDS_]:ARRAY OF UCLONG
ENDOBJECT
