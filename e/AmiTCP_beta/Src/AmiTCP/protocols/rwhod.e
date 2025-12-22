OPT MODULE, PREPROCESS
OPT EXPORT

OBJECT outmp
  line[8]:ARRAY
  name[8]:ARRAY
  time
ENDOBJECT

OBJECT whoent
  utmp:outmp
  idle
ENDOBJECT

OBJECT whod
  vers:CHAR
  type:CHAR
  pad[2]:ARRAY
  sendtime
  recvtime
  hostname[32]:ARRAY
  loadav[3]:ARRAY OF LONG
  boottime
  we[42]:ARRAY OF whoent
ENDOBJECT

CONST WHODVERSION=1,
      WHODTYPE_STATUS=1

#define _PATH_RWHODIR '/var/rwho'
