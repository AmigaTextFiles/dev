OPT MODULE, PREPROCESS
OPT EXPORT

CONST FSHIFT=8,
      FSCALE=%100000000,
      CPUSTATES=4,
      DK_NDRIVE=4

OBJECT rstat_timeval
  sec
  usec
ENDOBJECT

OBJECT statstime
  cp_time[CPUSTATES]:ARRAY OF LONG
  dk_xfer[DK_NDRIVE]:ARRAY OF LONG
  v_pgpgin
  v_pgpgout
  v_pswpin
  v_pswpout
  v_intr
  if_ipackets
  if_ierrors
  if_oerrors
  if_collisions
  v_swtch
  avenrun[3]:ARRAY OF LONG
  boottime:rstat_timeval
  curtime:rstat_timeval
  if_opackets
ENDOBJECT

OBJECT statsswtch
  cp_time[CPUSTATES]:ARRAY OF LONG
  dk_xfer[DK_NDRIVE]:ARRAY OF LONG
  v_pgpgin
  v_pgpgout
  v_pswpin
  v_pswpout
  v_intr
  if_ipackets
  if_ierrors
  if_oerrors
  if_collisions
  v_swtch
  avenrun[3]:ARRAY OF LONG
  boottime:rstat_timeval
  if_opackets
ENDOBJECT  

OBJECT stats
  cp_time[CPUSTATES]:ARRAY OF LONG
  dk_xfer[DK_NDRIVE]:ARRAY OF LONG
  v_pgpgin
  v_pgpgout
  v_pswpin
  v_pswpout
  v_intr
  if_ipackets
  if_ierrors
  if_oerrors
  if_collisions
  if_opackets
ENDOBJECT  

CONST RSTATPROG=100001,
      RSTATVERS_TIME=3

ENUM RSTATPROC_STATS=1, RSTATPROC_HAVEDISK
