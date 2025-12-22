OPT MODULE
OPT EXPORT

MODULE 'amitcp/sys/socket'

CONST ARPHRD_ETHER=1,
      ARPHRD_ARCNET=7,
      ARPOP_REQUEST=1,
      ARPOP_REPLY=2

OBJECT arphdr
  hrd:INT
  pro:INT
  hln:CHAR
  pln:CHAR
  op:INT
ENDOBJECT

CONST MAXADDRARP=16

OBJECT arpha
  len:CHAR
  family:CHAR
  data[MAXADDRARP]:ARRAY
ENDOBJECT

OBJECT arpreq
  pa:sockaddr
  ha:arpha
  flags
ENDOBJECT

SET ATF_INUSE, ATF_COM, ATF_PERM, ATF_PUBL, ATF_USETRAILERS

OBJECT arptabreq
  arpreq:arpreq
  size
  inuse
  table:PTR TO arpreq
ENDOBJECT
