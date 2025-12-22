
-> wbObject is an abstraction of every Workbench GUI object.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/any'

CONST NUMSIGNALS=32  -> The maximum number of signals for a Task.

ENUM PASS, CONTINUE, STOPIT, STOPALL

OBJECT wbObject OF any
ENDOBJECT

-> Implements a simple event loop which listens for the Exec Signal.
PROC simpleLoop() OF wbObject
  REPEAT
    Wait(Shl(1,self.signal()))
  UNTIL self.handleActivation() > CONTINUE
ENDPROC

-> Perform the appropriate action when object is activated.
PROC handleActivation() OF wbObject IS STOPALL

-> Exec signal associated with this WB object
PROC signal() OF wbObject IS -1

-> Remove the WB object.
PROC remove() OF wbObject IS EMPTY

