OPT MODULE
OPT EXPORT

MODULE 'exec/libraries',
       'exec/lists',
       'exec/nodes',
       'exec/tasks',
       'utility/hooks'

CONST TICK_FREQ=$4B0

OBJECT conductor
  ln:ln
  reserved0:INT
  players:mlh
  clocktime:LONG
  starttime:LONG
  externaltime:LONG
  maxexternaltime:LONG
  metronome:LONG
  reserved1:INT
  flags:INT  -> This is unsigned
  state:CHAR
ENDOBJECT

CONST CONDUCTF_E