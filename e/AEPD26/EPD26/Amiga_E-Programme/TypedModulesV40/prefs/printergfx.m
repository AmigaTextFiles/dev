OPT MODULE
OPT EXPORT

MODULE 'dos/dos'

OBJECT anchorpath
  base:PTR TO achain
  last:PTR TO achain
  breakbits:LONG
  foundbreak:LONG
  flags:CHAR  -> This is signed
  reserved:CHAR
  strlen:INT
  info:fileinfoblock
-> Um, what about 'buf[1]:ARRAY'?
ENDOBJECT     /* SIZEOF=280 */

CONST APB_DOWILD=0,
      APF_DOWILD=1,
      APB_ITSWILD=1,
      APF_ITSWILD=2,
      APB_DODIR=2,
      APF_DODIR=4,
      APB_DIDDIR=3,
      APF_DIDDIR=8,
      APB_NOMEMERR=4,
      APF_NOMEMERR=16,
      APB_DODOT=5,
      APF_DODOT=$20,
      APB_DIRCHANGED=6,
      APF_DIRCHANGED=$40,
      APB_FOLLOWHLINKS=7,
      APF_FOLLOWHLINKS=$80

OBJECT achain
  child:PTR TO achain
  parent:PTR TO achain
  lock:LONG
  info:fileinfoblock
  flags:CHAR  -> This is signed
-> Um, what about 'string[1]:ARRAY'?
ENDOBJECT     /* SIZEOF=273 */

CONST DDB_PATTERNBIT=0,
      DDF_PATTERNBIT=1,
      DDB_EXAMIN