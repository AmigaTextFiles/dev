EDED(t) (IF t AND ERT_MEMMASK THEN Shl(1, (t AND ERT_MEMMASK)-1) ELSE $80)
#define EC_MEMADDR(slot) (Shl(slot, E_SLOTSHIFT))

OBJECT diagarea
  config:CHAR
  flags:CHAR
  size:INT  -> This is unsigned
  diagpoint:INT  -> This is unsigned
  bootpoint:INT  -> This is unsigned
  name:INT  -> This is unsigned
  reserved01:INT
  reserved02:INT
ENDOBJECT     /* SIZEOF=14 */

