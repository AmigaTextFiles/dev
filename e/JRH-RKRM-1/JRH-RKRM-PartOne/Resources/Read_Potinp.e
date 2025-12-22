-> Read_Potinp.e
->
-> An example of using the potgo.resource to read pins 9 and 5 of port 1
-> (the non-mouse port).  This bypasses the gameport.device.  When the right
-> or middle button on a mouse plugged into port 1 is pressed, the read value
-> will change.
->
-> Use of port 0 (mouse) is unaffected.

-> E-Note: E does not (as of v3.1a) support Resources in the conventional way
MODULE 'other/potgo',
       'dos/dos',
       'hardware/custom'

ENUM ERR_NONE, ERR_POT, ERR_RES

RAISE ERR_RES IF OpenResource()=NIL

CONST OUTRY=$8000, DATRY=$4000, OUTRX=$2000, DATRX=$1000

DEF potbits, value

PROC main() HANDLE
  -> E-Note: set-up "custom"
  DEF custom=CUSTOMADDR:PTR TO custom

  potgobase:=OpenResource('potgo.resource')

  -> Get the bits for the right and middle mouse buttons on the alternate
  -> mouse port.
  potbits:=allocPotBits(OUTRY OR DATRY OR OUTRX OR DATRX)

  IF potbits<>(OUTRY OR DATRY OR OUTRX OR DATRX)
    freePotBits(potbits)
    Raise(ERR_POT)
  ENDIF

  -> Set all ones in the register (masked by potbits)
  writePotgo($FFFFFFFF, potbits)

  WriteF('\n'+
    'Plug a mouse into the second port.  This program will indicate when\n'+
    'the right or middle button (if the mouse is so equipped) is pressed.\n'+
    'Stop the program with Control-C. Press return now to begin.\n')
  -> E-Note: stdout is valid (we've used WriteF()), so try that if no stdin
  Inp(IF stdin THEN stdin ELSE stdout)

  REPEAT
    -> Read word at $DFF016
    value:=custom.potinp

    -> Show what was read (restricted to our allocated bits)
    -> E-Note: use "\b" to prevent a linefeed, giving single line, fast update
    WriteF('POTINP = $\h\b', value AND potbits)
  UNTIL SIGBREAKF_CTRL_C AND SetSignal(0, 0)  -> Until CTRL-C is pressed
  WriteF('\n')

  freePotBits(potbits)

EXCEPT DO
  SELECT exception
  CASE ERR_POT;  WriteF('Pot bits are already allocated! \h\n', potbits)
  CASE ERR_RES;  WriteF('Could not open potgo.resource\n')
  ENDSELECT
ENDPROC
