OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/sys/types'

SET FD_ACCEPT, FD_CONNECT, FD_OOB, FD_READ, FD_WRITE, FD_ERROR, FD_CLOSE

CONST UNIQUE_ID=-1

ENUM SOCK_STREAM=1, SOCK_DGRAM, SOCK_RAW, SOCK_RDM, SOCK_SEQPACKET

SET SO_DEBUG, SO_ACCEPTCONN, SO_REUSEADDR, SO_KEEPALIVE, SO_DONTROUTE,
    SO_BROADCAST, SO_USELOOPBACK, SO_LINGER, SO_OOBINLINE

ENUM SO_SNDBUF=$1001, SO_RCVBUF, SO_SNDLOWAT, SO_RCVLOWAT, SO_SNDTIMEO,
     SO_RCVTIMEO, SO_ERROR, SO_TYPE

CONST SO_EVENTMASK=$2001

OBJECT linger
  onoff
  linger
ENDOBJECT

CONST SOL_SOCKET=$FFFF

ENUM AF_UNSPEC, AF_UNIX, AF_INET, AF_IMPLINK, AF_PUP, AF_CHAOS, AF_NS, AF_ISO,
     AF_ECMA, AF_DATAKIT, AF_CCITT, AF_SNA, AF_DECNET, AF_DLI, AF_LAT,
     AF_HYLINK, AF_APPLETALK, AF_ROUTE, AF_LINK, PSEUDO_AF_XTP, AF_MAX

CONST AF_OSI=AF_ISO

OBJECT sockaddr
  len:CHAR
  family:CHAR
  data[14]:ARRAY
ENDOBJECT

OBJECT sockproto
  family:INT
  protocol:INT
ENDOBJECT

ENUM PF_UNSPEC, PF_UNIX, PF_INET, PF_IMPLINK, PF_PUP, PF_CHAOS, PF_NS, PF_ISO,
     PF_ECMA, PF_DATAKIT, PF_CCITT, PF_SNA, PF_DECNET, PF_DLI, PF_LAT,
     PF_HYLINK, PF_APPLETALK, PF_ROUTE, PF_LINK, PSEUDO_PF_XTP, PF_MAX

CONST PF_OSI=PF_ISO

CONST SOMAXCONN=5

OBJECT iovec
  base:caddr_t
  len
ENDOBJECT

OBJECT msghdr
  name:caddr_t
  namelen
  iov:PTR TO iovec
  iovlen
  control:caddr_t
  controllen
  flags
ENDOBJECT

SET MSG_OOB, MSG_PEEK, MSG_DONTROUTE, MSG_EOR, MSG_TRUNC, MSG_CTRUNC,
    MSG_WAITALL

OBJECT cmsghdr
  len
  level
  type
ENDOBJECT

PROC cmsg_data(cmsg) IS cmsg+SIZEOF cmsghdr

#define CMSG_DATA(cmsg) cmsg_data(cmsg)

#define ALIGN(p) (((p)+3) AND $FFFFFFFC)

PROC cmsg_nxthdr(mhdr:PTR TO msghdr, cmsg:PTR TO cmsghdr) IS
  IF (cmsg+cmsg.len+SIZEOF cmsghdr) > (mhdr.control+mhdr.controllen) THEN
    NIL ELSE (cmsg+ALIGN(cmsg.len))

#define CMSG_NXTHDR(mhdr,cmsg) cmsg_nxthdr(mhdr,cmsg)

PROC cmsg_firsthdr(mhdr:PTR TO msghdr) IS mhdr.control

#define CMSG_FIRSTHDR(mhdr) cmsg_firsthdr(mhdr)

CONST SCM_RIGHTS=1

OBJECT osockaddr
  family:INT
  data[14]:ARRAY
ENDOBJECT

OBJECT omsghdr
  name:caddr_t
  namelen
  iov:PTR TO iovec
  iovlen
  accrights:caddr_t
  accrightslen
ENDOBJECT
