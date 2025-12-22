OPT MODULE
OPT EXPORT

MODULE 'exec/nodes'

OBJECT localvar
  node:ln
  flags:INT  -> This is unsigned
  value:PTR TO CHAR
  len:LONG
ENDOBJECT     /* SIZEOF=24 */

CONST LV_VAR=0,
      LV_ALIAS=1,
      LVB_IGNORE=7,
      L