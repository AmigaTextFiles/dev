MODULE 'libraries/iffparse'

CONST ID_SCRM=$5343524D,
 SMB_AUTOSCROLL=1,
 SMF_AUTOSCROLL=(1<<0)


OBJECT ScreenModePrefs
  Reserved[4]:ULONG,
  DisplayID:ULONG,
  Width:UWORD,
  Height:UWORD,
  Depth:UWORD,
  Control:UWORD
