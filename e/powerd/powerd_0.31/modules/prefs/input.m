MODULE 'libraries/iffparse','devices/timer'

CONST ID_INPT=$494E5054

OBJECT InputPrefs
  Keymap[16]:UBYTE,
  PointerTicks:UWORD,
  DoubleClick:timeval,
  KeyRptDelay:timeval,
  KeyRptSpeed:timeval,
  MouseAccel:WORD
