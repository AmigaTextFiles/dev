-> DeviceUse.e - an example of using an Amiga device (here, serial device)
->    - attempt to create a message port with createPort()   (from amigalib)
->    - attempt to create the I/O request with ereateExtIO() (from amigalib)
->    - attempt to open the serial device with Exec OpenDevice()
->
-> If successful, use the serial command SDCMD_QUERY, then reverse our steps.
-> If we encounter an error at any time, we will gracefully exit.  Note that
-> applications which require at least V37 OS should use the Exec functions
-> CreateMsgPort()/DeleteMsgPort() and CreateIORequest()/DeleteIORequest()
-> instead of the similar amigalib functions which are used in this example.

OPT PREPROCESS

MODULE 'amigalib/io',
       'amigalib/ports',
       'devices/serial',
       'exec/io',
       'exec/ports'

ENUM ERR_NONE, ERR_DEV, ERR_IO, ERR_PORT

RAISE ERR_DEV IF OpenDevice()<>0

PROC main() HANDLE
  DEF serialMP=NIL:PTR TO mp, serialIO=NIL:PTR TO ioextser,
      reply:PTR TO ioextser
  -> Create the message port.
  IF NIL=(serialMP:=createPort(NIL,NIL)) THEN Raise(ERR_PORT)

  -> Create the I/O request.  Note that 'devices/serial' defines the type of
  -> io required by the serial device--an ioextser.  Many devices require
  -> specialised extended IO requests which start with an embedded io object.
  -> E-Note: ignore the rubbish about casting
  IF NIL=(serialIO:=createExtIO(serialMP, SIZEOF ioextser)) THEN Raise(ERR_IO)

  -> Open the serial device (non-zero return value means failure here).
  OpenDevice(SERIALNAME, 0, serialIO, 0)

  -> Device is open
  serialIO.iostd.command:=SDCMD_QUERY
  -> DoIO - demonstrates synchronous device use, returns error or 0.
  IF DoIO(serialIO)
    WriteF('Query failed.  Error - \d\n', serialIO.iostd.error)
  ELSE
    -> Print serial device status - see include file for meaning.
    -> Note that with DoIO, the Wait and GetMsg are done by Exec.
    WriteF('Serial device status: $\h\n\n', serialIO.status)
  ENDIF

  serialIO.iostd.command:=SDCMD_QUERY
  -> SendIO - demonstrates asynchronous device use (returns immediately).
  SendIO(serialIO)
  -> We could do other things here while the query is being done.  And to
  -> manage our asynchronous device IO:
  ->   - we can CheckIO(serialIO) to check for completion
  ->   - we can AbortIO(serialIO) to abort the command
  ->   - we can WaitPort(serialMP) to wait for any serial port reply
  ->  OR we can WaitIO(serialIO) to wait for this specific IO request
  ->  OR we can Wait(Shl(1, serialMP.sigbit)) for reply port signal
  Wait(Shl(1, serialMP.sigbit))

  WHILE reply:=GetMsg(serialMP)
    -> Since we sent out only one serialIO request the while loop is not
    -> really needed--we only expect one reply to our one query command, and
    -> the reply message pointer returned by GetMsg() will just be another
    -> pointer to our one serialIO request.  With Wait() or WaitPort(), you
    -> must GetMsg() the message.
    IF reply.iostd.error
      WriteF('Query failed.  Error - \d\n', reply.iostd.error)
    ELSE
      WriteF('Serial device status: $\h\n\n', reply.status)
    ENDIF
  ENDWHILE
  CloseDevice(serialIO)  -> Close the serial device.
EXCEPT DO
  IF serialIO THEN deleteExtIO(serialIO)  -> Delete the I/O request.
  IF serialMP THEN deletePort(serialMP)   -> Delete the message port.
  SELECT exception
  CASE ERR_DEV;  WriteF('Error: \s did not open\n', SERIALNAME)
  -> Inform user that the I/O request could be created.
  CASE ERR_IO;   WriteF('Error: Could not create I/O request\n')
  -> Inform user that the message port could not be created.
  CASE ERR_PORT; WriteF('Error: Could not create message port\n')
  ENDSELECT
ENDPROC
