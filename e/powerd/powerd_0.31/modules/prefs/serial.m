MODULE  'libraries/iffparse'

CONST ID_SERL=$5345524C,
 PARITY_NONE=0,
 PARITY_EVEN=1,
 PARITY_ODD=2,
 PARITY_MARK=3,
 PARITY_SPACE=4,
 HSHAKE_XON=0,
 HSHAKE_RTS=1,
 HSHAKE_NONE=2

OBJECT SerialPrefs
  Reserved[3]:LONG,
  Unit0Map:ULONG,
  BaudRate:ULONG,
  InputBuffer:ULONG,
  OutputBuffer:ULONG,
  InputHandshake:UBYTE,
  OutputHandshake:UBYTE,
  Parity:UBYTE,
  BitsPerChar:UBYTE,
  StopBits:UBYTE
