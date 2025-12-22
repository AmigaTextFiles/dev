OPT MODULE
OPT EXPORT

MODULE 'devices/timer'

CONST FILENAME_SIZE=30,
      DEVNAME_SIZE=16,
      POINTERSIZE=$24,
      TOPAZ_EIGHTY=8,
      TOPAZ_SIXTY=9

OBJECT preferences
  fontheight:CHAR  -> This is signed
  printerport:CHAR
  baudrate:INT  -> This is unsigned
  keyrptspeed:timeval
  keyrptdelay:timeval
  doubleclick:timeval
  pointermatrix[$24]:ARRAY OF INT  -> Array is unsigned
  xoffset:CHAR  -> This is signed
  yoffset:CHAR  -> This is signed
  color17:INT  -> This is unsigned
  color18