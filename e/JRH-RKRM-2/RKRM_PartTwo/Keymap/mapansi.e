-> mapansi.e - Converts a string to input events using MapANSI() function.
->
-> This example will also take the created input events and add them to the
-> input stream using the simple commodities.library function AddIEvents(). 
-> Alternately, you could open the input.device and use the input device
-> command IND_WRITEEVENT to add events to the input stream.

->>> Header (globals)
MODULE 'commodities',
       'keymap',
       'devices/inputevent'

ENUM ERR_NONE, ERR_INT, ERR_LIB, ERR_OVER

RAISE ERR_LIB IF OpenLibrary()=NIL

DEF inputEvent=NIL:PTR TO inputevent
->>>

->>> PROC main()
PROC main() HANDLE
  DEF string, tmp1, tmp2, i,
      iebuffer[6]:ARRAY  -> Space for two dead keys + 1 key + qualifiers
  openall()
  string:=';String converted to input events and sent to input device\n'
  inputEvent.class:=IECLASS_RAWKEY
  -> Turn each character into an inputevent
  tmp1:=string
  WHILE tmp1[]
    -> Convert one character, use default key map
    i:=MapANSI(tmp1, 1, iebuffer, 3, NIL)
    -> Make sure we start without deadkeys
    inputEvent.prev1downcode:=0
    inputEvent.prev1downqual:=0
    inputEvent.prev2downcode:=0
    inputEvent.prev2downqual:=0

    tmp2:=iebuffer
    SELECT i
    CASE -2
      WriteF('Internal error\n')
      Raise(ERR_INT)
    CASE -1
      WriteF('Overflow\n')
      Raise(ERR_OVER)
    CASE 0
      WriteF('Can''t generate code\n')
    CASE 3
      inputEvent.prev2downcode:=tmp2[]++
      inputEvent.prev2downqual:=tmp2[]++
      inputEvent.prev1downcode:=tmp2[]++
      inputEvent.prev1downqual:=tmp2[]++
      inputEvent.code:=tmp2[]++
      inputEvent.qualifier:=tmp2[]
    CASE 2
      inputEvent.prev1downcode:=tmp2[]++
      inputEvent.prev1downqual:=tmp2[]++
      inputEvent.code:=tmp2[]++
      inputEvent.qualifier:=tmp2[]
    CASE 1
      inputEvent.code:=tmp2[]++
      inputEvent.qualifier:=tmp2[]
    ENDSELECT

    -> Send the key down event
    AddIEvents(inputEvent)
    -> Create a key up event
    inputEvent.code:=inputEvent.code OR IECODE_UP_PREFIX
    -> Send the key up event
    AddIEvents(inputEvent)
    tmp1++
  ENDWHILE
EXCEPT DO
  closeall()
  SELECT exception
  CASE ERR_INT;   WriteF('Error: MapANSI() internal error\n')
  CASE ERR_LIB;   WriteF('Error: could not open required library\n')
  CASE ERR_OVER;  WriteF('Error: MapANSI() overflow error\n')
  CASE "MEM";     WriteF('Error: ran out of memory\n')
  ENDSELECT
ENDPROC
->>>

->>> PROC openall()
PROC openall()
  keymapbase:=OpenLibrary('keymap.library', 37)
  cxbase:=OpenLibrary('commodities.library', 37)
  NEW inputEvent
ENDPROC
->>>

->>> PROC closeall()
PROC closeall()
  IF inputEvent THEN END inputEvent
  IF cxbase THEN CloseLibrary(cxbase)
  IF keymapbase THEN CloseLibrary(keymapbase)
ENDPROC
->>>

