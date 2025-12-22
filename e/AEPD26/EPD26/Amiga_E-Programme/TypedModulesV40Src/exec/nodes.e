OPT MODULE
OPT EXPORT

OPT PREPROCESS

OBJECT expansionrom
  type:CHAR
  product:CHAR
  flags:CHAR
  reserved03:CHAR
  manufacturer:INT  -> This is unsigned
  serialnumber:LONG
  initdiagvec:INT  -> This is unsigned
  reserved0c:CHAR
  reserved0d:CHAR
  reserved0e:CHAR
  reserved0f:CHAR
ENDOBJECT     /* SIZEOF=16 */

OBJECT expansioncontrol
  interrupt:CHAR
  z3_highbase:CHAR
  baseaddress:CHAR
  shutup:CHAR
  reserved14:CHAR
  reserved15:CHAR
  reserved16:CHAR
  reserved17:CHAR
  reserved18:CHAR
  reserved19:CHAR
  reserved1a:CHAR
  reserved1b:CHAR
  reserved1c:CHAR
  reserved1d:CHAR
  reserved1e:CHAR
  reserved1f:CHAR
ENDOBJECT     /* SIZEOF=16 */

CONST E_SLOTSIZE=$10000,
      E_SLO