OPT MODULE
OPT EXPORT

OBJECT rt
  matchword:INT  -> This is unsigned
  matchtag:PTR TO rt
  endskip:LONG
  flags:CHAR
  version:CHAR
  type:CHAR
  pri:CHAR  -> This is signed
  name:PTR TO CHAR
  idstring:PTR TO CHAR
  init:LONG
ENDOBJECT     /* SIZEOF=26 */

CONST RTC_MATCHWORD