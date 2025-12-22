OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'dos/dosextens',
       'exec/ports',
       'amitcp/sys/socket'

OBJECT daemonport
  port:mp
  exitcode
ENDOBJECT

#define DAEMONPORTNAME 'inetd.ipc'

OBJECT daemonmessage
  msg:mn
  pid:PTR TO process
  seg:PTR TO segment
  id, retval
 family:CHAR, type:CHAR
ENDOBJECT

CONST DMTYPE_UNKNOWN=-1,
      DMTYPE_INTERNAL=0

CONST DMTYPE_STREAM=SOCK_STREAM,
      DMTYPE_DGRAM=SOCK_DGRAM,
      DMTYPE_RAW=SOCK_RAW,
      DMTYPE_RDM=SOCK_RDM,
      DMTYPE_SEQPACKET=SOCK_SEQPACKET

CONST DERR_LIB=$A0, DERR_OBTAIN=$A1
