OPT MODULE, PREPROCESS
OPT EXPORT

OBJECT code
  name:PTR TO CHAR
  val
ENDOBJECT

DEF prioritynames:PTR TO code,
    facilitynames:PTR TO code

ENUM LOG_EMERG, LOG_ALERT, LOG_CRIT, LOG_ERR, LOG_WARNING, LOG_NOTICE, LOG_INFO,
     LOG_DEBUG

CONST LOG_PRIMASK=7

#define LOG_PRI(p)           ((p) AND LOG_PRIMASK)
#define LOG_MAKEPRI(fac,pri) (Shl((fac), 3) OR (pri))

CONST LOG_NFACILITIES=24

CONST INTERNAL_NOPRI=$10,
      INTERNAL_MARK=LOG_NFACILITIES*8

#define _prioritynames ['alert',   LOG_ALERT, \
                        'crit',    LOG_CRIT, \
                        'debug',   LOG_DEBUG, \
                        'emerg',   LOG_EMERG, \
                        'err',     LOG_ERR, \
                        'error',   LOG_ERR, \
                        'info',    LOG_INFO, \
                        'none',    INTERNAL_NOPRI, \
                        'notice',  LOG_NOTICE, \
                        'panic',   LOG_EMERG, \
                        'warn',    LOG_WARNING, \
                        'warning', LOG_WARNING, \
                        NIL,       -1]:code

CONST LOG_KERN=    0*8,
      LOG_USER=    1*8,
      LOG_MAIL=    2*8,
      LOG_DAEMON=  3*8,
      LOG_AUTH=    4*8,
      LOG_SYSLOG=  5*8,
      LOG_LPR=     6*8,
      LOG_NEWS=    7*8,
      LOG_UUCP=    8*8,
      LOG_CRON=    9*8,
      LOG_AUTHPRIV=10*8

CONST LOG_LOCAL0=16*8,
      LOG_LOCAL1=17*8,
      LOG_LOCAL2=18*8,
      LOG_LOCAL3=19*8,
      LOG_LOCAL4=20*8,
      LOG_LOCAL5=21*8,
      LOG_LOCAL6=22*8,
      LOG_LOCAL7=23*8

CONST LOG_FACMASK=$03F8

#define LOG_FAC(p) Shr((p) AND LOG_FACMASK, 3)

#define _facilitynames ['auth',     LOG_AUTH, \
                        'authpriv', LOG_AUTHPRIV, \
                        'cron',     LOG_CRON, \
                        'daemon',   LOG_DAEMON, \
                        'kern',     LOG_KERN, \
                        'lpr',      LOG_LPR, \
                        'mail',     LOG_MAIL, \
                        'mark',     INTERNAL_MARK, \
                        'news',     LOG_NEWS, \
                        'security', LOG_AUTH, \
                        'syslog',   LOG_SYSLOG, \
                        'user',     LOG_USER, \
                        'uucp',     LOG_UUCP, \
                        'local0',   LOG_LOCAL0, \
                        'local1',   LOG_LOCAL1, \
                        'local2',   LOG_LOCAL2, \
                        'local3',   LOG_LOCAL3, \
                        'local4',   LOG_LOCAL4, \
                        'local5',   LOG_LOCAL5, \
                        'local6',   LOG_LOCAL6, \
                        'local7',   LOG_LOCAL7, \
                        NIL,       -1]:code

#define LOG_MASK(pri) Shl(1,(pri))
#define LOG_UPTO(pri) (Shl(1,(pri)+1)-1)

SET LOG_PID, LOG_CONS, LOG_ODELAY, LOG_NDELAY, LOG_NOWAIT, LOG_PERROR

PROC syslog_init_names()
  IF prioritynames=NIL
    prioritynames:=_prioritynames
    facilitynames:=_facilitynames
  ENDIF
ENDPROC

