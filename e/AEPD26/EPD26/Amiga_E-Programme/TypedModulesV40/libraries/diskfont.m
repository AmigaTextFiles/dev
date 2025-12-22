  reserved2[4]:ARRAY OF INT  -> Array is unsigned
ENDOBJECT

CONST CDSTSB_CLOSED=0,
      CDSTSB_DISK=1,
      CDSTSB_SPIN=2,
      CDSTSB_TOC=3,
      CDSTSB_CDROM=4,
      CDSTSB_PLAYING=5,
      CDSTSB_PAUSED=6,
      CDSTSB_SEARCH=7,
      CDSTSB_DIRECTION=8,
      CDSTSF_CLOSED=1,
      CDSTSF_DISK=2,
      CDSTSF_SPIN=4,
      CDSTSF_TOC=8,
      CDSTSF_CDROM=$10,
      CDSTSF_PLAYING=$20,
      CDSTSF_PAUSED=$40,
      CDSTSF_SEARCH=$80,
      CDSTSF_DIRECTION=$100,
      CDMODE_NORMAL=0,
      CDMODE_FFWD=1,
      CDMODE_FREV=2

OBJECT rmsf
  reserved:CHAR
  minute:CHAR
  second:CHAR
  frame:CHAR
ENDOBJECT

OBJECT lsnmsf
-> a) next is unioned with "lsn:LONG"
  msf:rmsf
ENDOBJECT

OBJECT cdxl
  node:mln
  buffer:PTR TO CHAR
  length:LONG
  actual:LONG
  intdata:LONG
  intcode:LONG
ENDOBJECT

OBJECT tocsummary
  firsttrack:CHAR
  lasttrack:CHAR
  leadout:lsnmsf
ENDOBJEC