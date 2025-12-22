OPT NATIVE, INLINE
PUBLIC MODULE 'target/time'
{#include <sys/time.h>}

NATIVE {_TIMEVAL_DEFINED} DEF
NATIVE {timeval} OBJECT timeval
  {tv_sec}	sec	:VALUE
  {tv_usec}	usec	:VALUE
ENDOBJECT

NATIVE {timerisset} PROC	->timerisset(tvp)	 ((tvp)->tv_sec || (tvp)->tv_usec)
PROC timerisset(tvp:PTR TO timeval) IS NATIVE {timerisset(} tvp {)} ENDNATIVE !!VALUE

NATIVE {timercmp} PROC	->timercmp(tvp, uvp, cmp) (((tvp)->tv_sec != (uvp)->tv_sec) ? ((tvp)->tv_sec cmp (uvp)->tv_sec) : ((tvp)->tv_usec cmp (uvp)->tv_usec))

NATIVE {timerclear} PROC	->timerclear(tvp)	 (tvp)->tv_sec = (tvp)->tv_usec = 0
PROC timerclear(tvp:PTR TO timeval) IS NATIVE {timerclear(} tvp {)} ENDNATIVE
