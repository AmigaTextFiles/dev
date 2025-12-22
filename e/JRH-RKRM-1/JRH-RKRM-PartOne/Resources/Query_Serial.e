-> Query_Serial.e - Try to open the serial device and if unsuccessful,
->                  return the name of the owner.

OPT PREPROCESS  -> E-Note: we are using the NAME macros

-> E-Note: E does not (as of v3.1a) support Resources in the conventional way
MODULE 'amigalib/io',
       'amigalib/ports',
       'other/misc',
       'devices/serial',
       'dos/dos',
       'exec/io',
       'resources/misc'

ENUM ERR_NONE, ERR_CRIO, ERR_PORT

CONST UNIT_NUMBER=0

DEF serialMP=NIL, serialIO=NIL:PTR TO ioextser

PROC main() HANDLE
  DEF status,  -> Return value of SDCMD_QUERY
      user     -> Name of serial port owner if not us

  IF NIL=(serialMP:=createPort(NIL, NIL)) THEN Raise(ERR_PORT)
  IF NIL=(serialIO:=createExtIO(serialMP, SIZEOF ioextser)) THEN Raise(ERR_CRIO)
  IF OpenDevice(SERIALNAME, UNIT_NUMBER, serialIO, 0)
    WriteF('\n\s did not open', SERIALNAME)

    miscbase:=OpenResource(MISCNAME)

    -> Find out who has the serial device
    IF NIL=(user:=allocMiscResource(MR_SERIALPORT, 'Us'))
      WriteF('\n')
      freeMiscResource(MR_SERIALPORT)
    ELSE
      WriteF(' because \s owns it\n\n', user)
    ENDIF
  ELSE
    serialIO.iostd.command:=SDCMD_QUERY
    SendIO(serialIO)  -> Execute query

    status:=serialIO.status  -> Store returned status

    WriteF('\t The serial port status is \h\n', status)

    AbortIO(serialIO)
    WaitIO(serialIO)

    CloseDevice(serialIO)
  ENDIF

EXCEPT DO
  IF serialIO THEN deleteExtIO(serialIO)
  IF serialMP THEN deletePort(serialMP)
  SELECT exception
  CASE ERR_CRIO;  WriteF('Can''t create IO request\n')
  CASE ERR_PORT;  WriteF('Can''t create message port\n')
  ENDSELECT
ENDPROC IF exception<>ERR_NONE THEN RETURN_FAIL ELSE RETURN_OK
