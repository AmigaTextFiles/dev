MODULE 'libraries/iffparse','graphics/gfx'

CONST ID_WBNC=$57424E43,
 ID_WBHD=$57424844

OBJECT WorkbenchPrefs
  DefaultStackSize:ULONG,
  TypeRestartTime:ULONG,
  IconPrecision:ULONG,
  EmbossRect:Rectangle,
  Borderless:BOOL,
  MaxNameLength:LONG,
  NewIconsSupport:BOOL,
  ColorIconSupport:BOOL,
  ImageMemType:ULONG, /* V45 */
  LockPens:BOOL,
  NoTitleBar:BOOL,
  NoGauge:BOOL

OBJECT WorkbenchHiddenDevicePrefs
  Name[0]:UBYTE
