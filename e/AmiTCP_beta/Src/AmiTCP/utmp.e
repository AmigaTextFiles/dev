OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/amitcp/types'

#define	_PATH_UTMP    'AmiTCP:log/utmp'
#define	_PATH_WTMP    'AmiTCP:log/wtmp'
#define	_PATH_LASTLOG 'AmiTCP:log/lastlog'

CONST UT_NAMESIZE=32,
      UT_LINESIZE=32,
      UT_HOSTSIZE=64

OBJECT lastlog
  time
  uid:uid_t
  name[UT_NAMESIZE]:ARRAY
  host[UT_HOSTSIZE]:ARRAY  -> Maybe union with line
ENDOBJECT

OBJECT utmp
  time
  sid
  name[UT_NAMESIZE]:ARRAY
  host[UT_HOSTSIZE]:ARRAY  -> Maybe union with line
ENDOBJECT
