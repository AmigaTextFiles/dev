OPT MODULE
OPT EXPORT

CONST ID_SERL=$5345524C

OBJECT serialprefs
  reserved[3]:ARRAY OF LONG
  unit0map:LONG
  baudrate:LONG
  inputbuffer:LONG
  outputbuffer:LONG
  inputhandshake:CHAR
  outputhandshake:CHAR
  parity:CHAR
  bitsperchar:CHAR
  stopbits:CHAR
ENDOBJECT     /* SIZEOF=