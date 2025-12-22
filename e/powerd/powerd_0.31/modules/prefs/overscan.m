MODULE 'libraries/iffparse','graphics/gfx'

CONST ID_OSCN=$4F53434E,
  OSCAN_MAGIC=$FEDCBA89

OBJECT OverscanPrefs
  Reserved:ULONG,
  Magic:ULONG,
  HStart:UWORD,
  HStop:UWORD,
  VStart:UWORD,
  VStop:UWORD,
  DisplayID:ULONG,
  ViewPos:tPoint,
  Text:tPoint,
  Standard:Rectangle
