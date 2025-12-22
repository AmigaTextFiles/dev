/*---------------------------------------------------------------------------*
  cookRawkey.e - Use console.device to convert rawkeys to asciikeys.

  Modifications:
    Rev 1, 4 Oct 94, Barry Wills
      cookRawkey() modified to correctly process deadkeys;
      1) changed parameter 'iAddress' to 'iAddress:PTR TO LONG';
      2) changed statement 'PutLong(ie+10, iAddress)' to
         'PutLong(ie+10, iAddress[])'
 *---------------------------------------------------------------------------*/
OPT MODULE, POINTER

MODULE 'console',
       'devices/console',
       'devices/conunit',
       'devices/inputevent',
       'devices/keymap',
       'exec/io',
       'exec/ports'
MODULE 'exec'

CONST ER_NONE        = 0,
             ER_CREATEPORT  = "PORT",
             ER_CREATEIO    = "IO",
             ER_OPENDEVICE  = "DEV",
             ER_ASKKEYMAP   = "KMAP"

DEF consoleMessagePort:PTR TO mp,
    consoleIO:PTR TO iostd

PROC warmupRawkeyCooker()
	DEF ret:QUAD
  IF (consoleMessagePort:=CreateMsgPort())=NIL THEN RETURN ER_CREATEPORT
  IF (consoleIO:=CreateIORequest(consoleMessagePort, SIZEOF iostd) !!VALUE!!PTR TO iostd)=NIL THEN RETURN ER_CREATEIO
  IF OpenDevice('console.device', CONU_LIBRARY,
                consoleIO !!PTR!!PTR TO io, CONFLAG_DEFAULT) THEN RETURN ER_OPENDEVICE
  consoleIO.command:=CD_ASKKEYMAP
  consoleIO.length:=SIZEOF keymap
  consoleIO.data:=NewR(SIZEOF keymap)
  IF DoIO(consoleIO !!PTR!!PTR TO io) THEN RETURN ER_ASKKEYMAP
  IF (consoleIO.flags AND IOF_QUICK)=0 THEN WaitIO(consoleIO !!PTR!!PTR TO io)
  consoledevice:=consoleIO.device
  ret := ER_NONE
ENDPROC ret
  /* warmupRawkeyCooker */

PROC shutdownRawkeyCooker()
  IF consoleIO
    IF consoleIO.data THEN Dispose(consoleIO.data)
    IF consoleIO.device
      AbortIO(consoleIO !!PTR!!PTR TO io)
      CloseDevice(consoleIO !!PTR!!PTR TO io)
    ENDIF
    DeleteIORequest(consoleIO !!PTR!!PTR TO io)
  ENDIF
  IF consoleMessagePort THEN DeleteMsgPort(consoleMessagePort)
ENDPROC
  /* shutdownRawkeyCooker */

PROC cookRawkey(idcmpCode:UINT, idcmpQualifier:UINT, iAddress:PTR TO LONG)
  DEF asciiChar, ie:inputevent, buffer[1]:STRING, actual
  asciiChar := 0
  ie.nextevent:=NIL
  ie.class:=IECLASS_RAWKEY
  ie.subclass:=0
  ie.code:=idcmpCode
  ie.qualifier:=idcmpQualifier
  PutLong(ie+10 !!PTR!!PTR TO LONG, iAddress[])
  actual:=RawKeyConvert(ie, buffer, 1, consoleIO.data)
  IF actual=1 THEN asciiChar:=buffer[0]
ENDPROC  asciiChar
  /* cookRawkey */
