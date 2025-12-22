OPT NATIVE
MODULE 'target/aros/cpu'
->{#include <aros/types/timeval_s.h>}		->commented-out to allow compatibility with Icaros v1.2.x
NATIVE {_AROS_TYPES_TIMEVAL_S_H_} DEF

/* The following structure is composed of two anonymous unions so that it
   can be transparently used by both AROS-style programs and POSIX-style
   ones. For binary compatibility reasons the fields in the unions MUST
   have the same size, however they can have different signs (as it is
   the case for microseconds).  */

NATIVE {timeval} OBJECT timeval
    {tv_secs}	secs	:LONG   /* AROS field */
	{tv_sec}	sec	:LONG    /* POSIX field */
    {tv_micro}	micro	:LONG /* AROS field */
	{tv_usec}	usec	:LONG  /* POSIX field */
ENDOBJECT
