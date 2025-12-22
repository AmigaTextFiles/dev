OPT MODULE
OPT EXPORT

OBJECT ln
  succ:PTR TO ln
  pred:PTR TO ln
  type:CHAR
  pri:CHAR  -> This is signed
  name:PTR TO CHAR
ENDOBJECT     /* SIZEOF=14 */

OBJECT mln
  succ:PTR TO mln
  pred:PTR TO mln
ENDOBJECT     /* SIZEOF=8 */

CONST NT_UNKNO