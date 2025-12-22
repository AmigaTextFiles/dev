OPT MODULE, PREPROCESS
OPT EXPORT

MODULE 'amitcp/net/if'

CONST WORKAREA_SIZE=IFNAMSIZ+12

OBJECT sockaddr_dl
  len:CHAR
  family:CHAR
  index:INT
  type
  nlen:CHAR
  alen:CHAR
  slen:CHAR
  data[WORKAREA_SIZE]:ARRAY
ENDOBJECT

PROC lladdr(s:PTR TO sockaddr_dl) IS s.data+s.nlen

#define LLADDR(s) lladdr(s)
