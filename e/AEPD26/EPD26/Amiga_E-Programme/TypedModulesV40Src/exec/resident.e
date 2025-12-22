OPT MODULE
OPT EXPORT

MODULE 'exec/nodes',
       'libraries/configregs'

OBJECT configdev
  node:ln
  flags:CHAR
  pad:CHAR
  rom:expansionrom
  boardaddr:LONG
  boardsize:LONG
  slotaddr:INT  -> This is unsigned
  slotsize:INT  -> This is unsigned
  driver:LONG
  nextcd:PTR TO configdev
  unused[4]:ARRAY OF LONG
ENDOBJECT     /* SIZEOF=68 */

CONST CDB_SHUTUP=0,
      CDB_CONFIGME=1,
      CDB_BADMEMORY=2,
      CDB_