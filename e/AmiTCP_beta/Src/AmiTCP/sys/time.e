OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'exec/io'

OBJECT compatible_timeval
  sec  -> Unioned with secs
  usec  -> Unioned with micro
ENDOBJECT

#define timeval compatible_timeval

OBJECT compatible_timerequest
  node:io
  time:timeval
ENDOBJECT

#define timerequest compatible_timerequest

OBJECT timezone
  minuteswest
  dsttime
ENDOBJECT

ENUM DST_NONE, DST_USA, DST_AUST, DST_WET, DST_MET, DST_EET, DST_CAN

PROC timerisset(tvp:PTR TO timeval) IS tvp.sec OR tvp.usec

-> As is, timercmp is not easy to define in E

PROC timerclear(tvp:PTR TO timeval)
  tvp.sec:=0
  tvp.usec:=0
ENDPROC
