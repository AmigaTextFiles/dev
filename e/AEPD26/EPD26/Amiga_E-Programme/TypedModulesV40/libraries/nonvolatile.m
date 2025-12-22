OPT MODULE
OPT EXPORT

MODULE 'devices/serial',
       'devices/timer',
       'exec/libraries',
       'exec/ports',
       'exec/tasks',
       'intuition/preferences'

CONST DEVICES_PRTBASE_I=1

OBJECT devicedata
  lib:lib
  segment:LONG
  execbase:LONG
  cmdvectors:LONG
  cmdbytes:PTR TO CHAR
  numcommands:INT  -> This is unsigned
ENDOBJECT     /* SIZEOF=52 */

CONST DU_FLAGS=9,
    