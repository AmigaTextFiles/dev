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

CONST CONDUCTF_EXTERNAL=1,
      CONDUCTF_GOTTICK=2,
      CONDUCTF_METROSET=4,
      CONDUCTF_PRIVATE=8,
      CONDUCTB_EXTERNAL=0,
      CONDUCTB_GOTTICK=1,
      CONDUCTB_METROSET=2,
      CONDUCTB_PRIVATE=3,
      CONDSTATE_STOPPED=0,
      CONDSTATE_PAUSED=1,
      CONDSTATE_LOCATE=2,
      CONDSTATE_RUNNING=3,
      CONDSTATE_METRIC=-1,
      CONDSTATE_SHUTTLE=-2,
      CONDSTATE_LOCATE_SET=-3

OBJECT player
  ln:ln
  reserved0:CHAR
  reserved1:CHAR
  hook:PTR TO hook
  source:PTR TO conductor
  task:P