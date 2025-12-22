MODULE 'libraries/iffparse'

CONST ID_PNTR=$504E5452,
 WBP_NORMAL=0,
 WBP_BUSY=1

OBJECT PointerPrefs
  Reserved[4]:ULONG,
  Which:UWORD,
  Size:UWORD,
  Width:UWORD,
  Height:UWORD,
  Depth:UWORD,
  YSize:UWORD,
  X:UWORD,
  Y:UWORD

OBJECT RGBTable
  Red:UBYTE,
  Green:UBYTE,
  Blue:UBYTE
