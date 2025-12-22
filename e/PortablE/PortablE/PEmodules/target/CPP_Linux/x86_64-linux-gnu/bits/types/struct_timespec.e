OPT NATIVE
MODULE 'target/x86_64-linux-gnu/bits/types'
MODULE 'target/x86_64-linux-gnu/bits/endian'
{#include <x86_64-linux-gnu/bits/types/struct_timespec.h>}
/* NB: Include guard matches what <linux/time.h> uses.  */
NATIVE {_STRUCT_TIMESPEC} CONST ->_STRUCT_TIMESPEC = 1

/* POSIX.1b structure for a time value.  This is like a `struct timeval' but
   has nanoseconds instead of microseconds.  */
NATIVE {timespec} OBJECT timespec
  {tv_sec}	sec	:TIME_T__		/* Seconds.  */
  {tv_nsec}	nsec	:SYSCALL_SLONG_T__	/* Nanoseconds.  */
ENDOBJECT
