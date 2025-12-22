-> AskKeymap.e

->>> Header (globals)
MODULE 'devices/console',
       'devices/conunit',
       'devices/keymap',
       'exec/io',
       'exec/memory',
       'exec/ports'

ENUM ERR_NONE, ERR_DEV, ERR_IO, ERR_PORT

RAISE ERR_DEV  IF OpenDevice()<>0,
      ERR_IO   IF CreateIORequest()=NIL,
      ERR_PORT IF CreateMsgPort()=NIL
->>>

->>> PROC main()
PROC main() HANDLE
  DEF consoleMP:PTR TO mp, consoleIO:PTR TO iostd, keymap:PTR TO keymap,
      i, j, prt, dev_open=FALSE
  -> Release 2 (V36) or a later version of the OS is required
  KickVersion(36)
  -> Create the message port
  consoleMP:=CreateMsgPort()
  -> Create the IORequest
  consoleIO:=CreateIORequest(consoleMP, SIZEOF iostd)
  -> Open Console device
  OpenDevice('console.device', CONU_LIBRARY, consoleIO, 0)
  dev_open:=TRUE
  -> Allocate memory for the keymap
  keymap:=NewM(SIZEOF keymap, MEMF_PUBLIC OR MEMF_CLEAR)
  -> Device opened, send query command to it
  consoleIO.length:=SIZEOF keymap
  -> Where to put it
  consoleIO.data:=keymap
  consoleIO.command:=CD_ASKKEYMAP
  IF DoIO(consoleIO)
    -> Inform user that CD_ASKKEYMAP failed
    WriteF('CD_ASKKEYMAP failed.  Error - \d\n', consoleIO.error)
  ELSE
    -> Print values for top row of keyboard
    prt:=keymap.lokeymap
    WriteF('Result of CD_ASKKEYMAP for top row of keyboard\n\n' +
           '\tShift\n' +
           '\tAlt\tAlt\tShift\tNo Qualifier\n')
    FOR j:=0 TO 13
      FOR i:=0 TO 3 DO WriteF('\t\c', prt[]++)
      WriteF('\n')
    ENDFOR
  ENDIF
EXCEPT DO
  IF keymap THEN Dispose(keymap)
  IF dev_open THEN CloseDevice(consoleIO)
  IF consoleIO THEN DeleteIORequest(consoleIO)
  IF consoleMP THEN DeleteMsgPort(consoleMP)
  SELECT exception
  CASE ERR_DEV;   WriteF('Error: could not open console device\n')
  CASE ERR_IO;    WriteF('Error: could not create I/O\n')
  CASE ERR_PORT;  WriteF('Error: could not create port\n')
  CASE "MEM";     WriteF('Error: ran out of memory\n')
  ENDSELECT
ENDPROC
->>>

