OPT MODULE
OPT EXPORT

MODULE 'exec/lists',
       'exec/nodes',
       'exec/ports',
       'utility/tagitem'

OBJECT tc
  ln:ln
  flags:CHAR
  state:CHAR
  idnestcnt:BYTE
  tdnestcnt:BYTE
  sigalloc:LONG
  sigwait:LONG
  sigrecvd:LONG
  sigexcept:LONG
  trapalloc:WORD
  trapable:WORD
  etask:LONG @ trapalloc
  exceptdata:LONG
  exceptcode:LONG
  trapdata:LONG
  trapcode:LONG
  spreg:LONG
  splower:LONG
  spupper:LONG
  switch:LONG
  launch:LONG
  mementry:lh
  userdata:LONG
ENDOBJECT     /* SIZEOF=92 */


CONST CHILD_NOTNEW=1,
      CHILD_NOTFOUND=2,
      CHILD_EXITED=3,
      CHILD_ACTIVE=4

OBJECT stackswapstruct
  lower:LONG
  upper:LONG
  pointer:LONG
ENDOBJECT     /* SIZEOF=12 */

CONST TB_PROCTIME=0,
      TB_ETASK=3,
      TB_STACKCHK=4,
      TB_EXCEPT=5,
      TB_SWITCH=6,
      TB_LAUNCH=7,
      TF_PROCTIME=1,
      TF_ETASK=8,
      TF_STACKCHK=16,
      TF_EXCEPT=$20,
      TF_SWITCH=$40,
      TF_LAUNCH=$80,
      TS_INVALID=0,
      TS_ADDED=1,
      TS_RUN=2,
      TS_READY=3,
      TS_WAIT=4,
      TS_EXCEPT=5,
      TS_REMOVED=6,
      TS_CRASHED = 7, -> os4
      TS_SUSPENDED = 8, -> os4
      SIGB_ABORT=0,
      SIGB_CHILD=1,
      SIGB_BLIT=4,
      SIGB_SINGLE=4,
      SIGB_INTUITION=5,
      SIGB_NET=7,
      SIGB_DOS=8,
      SIGF_ABORT=1,
      SIGF_CHILD=2,
      SIGF_BLIT=16,
      SIGF_SINGLE=16,
      SIGF_INTUITION=$20,
      SIGF_NET=$80,
      SIGF_DOS=$100,
      SYS_SIGALLOC=$FFFF,
      SYS_TRAPALLOC=$8000

-> os4
CONST AT_Param1 = TAG_USER + 1
CONST AT_Param2 = TAG_USER + 2
CONST AT_Param3 = TAG_USER + 3
CONST AT_Param4 = TAG_USER + 4
CONST AT_Param5 = TAG_USER + 5
CONST AT_Param6 = TAG_USER + 6
CONST AT_Param7 = TAG_USER + 7
CONST AT_Param8 = TAG_USER + 8

ENUM STB_CRASHED

SET STF_CRASHED


