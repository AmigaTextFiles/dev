OPT MODULE
OPT EXPORT

OPT PREPROCESS

MODULE 'exec/lists',
       'exec/nodes',
       'exec/ports'

OBJECT nexxstr
  ivalue:LONG
  length:INT  -> This is unsigned
  flags:CHAR
  hash:CHAR
  buff[8]:ARRAY
ENDOBJECT     /* SIZEOF=16 */

#define IVALUE(nsPtr) (nsPtr.ivalue)

CONST NXADDLEN=9,
      NSB_KEEP=0,
      NSB_STRING=1,
      NSB_NOTNUM=2,
      NSB_NUMBER=3,
      NSB_BINARY=4,
      NSB_FLOAT=5,
      NSB_EXT=6,
      NSB_SOURCE=7,
      NSF_KEEP=1,
      NSF_STRING=2,
      NSF_NOTNUM=4,
      NSF_NUMBER=8,
      NSF_BINARY=16,
      NSF_FLOAT=$20,
      NSF_EXT=$40,
      NSF_SOURCE=$80,
      NSF_INTNUM=26,
      NSF_DPNUM=$28,
      NSF_ALPHA=6,
      