OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'exec/devices',
       'exec/io',
       'exec/ports'

#define NETINFONAME 'AmiTCP:devs/netinfo.device'

OBJECT netinforeq
  message:mn
  device:PTR TO dd
  unit:PTR TO unit
  command:INT
  flags:CHAR
  error:CHAR
  actual
  length
  data
  offset
ENDOBJECT

ENUM NETINFO_PASSWD_UNIT, NETINFO_GROUP_UNIT, NETINFO_UNITS

CONST NI_GETBYID=CMD_NONSTD+0,
      NI_GETBYNAME=CMD_NONSTD+1,
      NI_MEMBERS=CMD_NONSTD+2,
      NI_END=CMD_NONSTD+3

ENUM NIERR_NOTFOUND=2, NIERR_TOOSMALL=7, NIERR_NOMEM=12, NIERR_ACCESS,
     NIERR_NULL_POINTER, NIERR_INVAL=22

OBJECT netinfopasswd
  name:PTR TO CHAR
  passwd:PTR TO CHAR
  uid
  gid
  gecos:PTR TO CHAR
  dir:PTR TO CHAR
  shell:PTR TO CHAR
ENDOBJECT

OBJECT netinfogroup
  name:PTR TO CHAR
  passwd:PTR TO CHAR
  gid
  mem:PTR TO LONG
ENDOBJECT
