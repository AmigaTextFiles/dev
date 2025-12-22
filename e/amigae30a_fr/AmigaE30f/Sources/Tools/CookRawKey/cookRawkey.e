/*----------------------------------------------------------------------------*
  cookRawkey.e - Utilise le console.device pour convertir les rawkeys en ascii.
 *----------------------------------------------------------------------------*/
OPT MODULE

MODULE 'console',
       'devices/console',
       'devices/conunit',
       'devices/inputevent',
       'devices/keymap',
       'exec/io',
       'exec/ports'

EXPORT CONST ER_NONE        = 0,
             ER_CREATEPORT  = "PORT",
             ER_CREATEIO    = "IO",
             ER_OPENDEVICE  = "DEV",
             ER_ASKKEYMAP   = "KMAP"

DEF consoleMessagePort:PTR TO mp,
    consoleIO:PTR TO iostd

EXPORT PROC warmupRawkeyCooker()
  IF (consoleMessagePort:=CreateMsgPort())=NIL THEN RETURN ER_CREATEPORT
  IF (consoleIO:=CreateIORequest(consoleMessagePort, SIZEOF iostd))=
       NIL THEN RETURN ER_CREATEIO
  IF OpenDevice('console.device', CONU_LIBRARY,
                consoleIO, CONFLAG_DEFAULT) THEN RETURN ER_OPENDEVICE
  consoleIO.command:=CD_ASKKEYMAP
  consoleIO.length:=SIZEOF keymap
  consoleIO.data:=NewR(SIZEOF keymap)
  IF DoIO(consoleIO) THEN RETURN ER_ASKKEYMAP
  IF (consoleIO.flags AND IOF_QUICK)=0 THEN WaitIO(consoleIO)
  consoledevice:=consoleIO.device
ENDPROC  ER_NONE
  /* allume la marmite Rawkey */

EXPORT PROC shutdownRawkeyCooker()
  IF consoleIO
    IF consoleIO.data THEN Dispose(consoleIO.data)
    IF consoleIO.device
      AbortIO(consoleIO)
      CloseDevice(consoleIO)
    ENDIF
    DeleteIORequest(consoleIO)
  ENDIF
  IF consoleMessagePort THEN DeleteMsgPort(consoleMessagePort)
ENDPROC
  /* éteint la marmite */

EXPORT PROC cookRawkey(idcmpCode, idcmpQualifier, iAddress)
  DEF asciiChar=0, ie:inputevent, buffer[1]:STRING, actual
  ie.nextevent:=NIL
  ie.class:=IECLASS_RAWKEY
  ie.subclass:=0
  ie.code:=idcmpCode
  ie.qualifier:=idcmpQualifier
  PutLong(ie+10, iAddress)
  actual:=RawKeyConvert(ie, buffer, 1, consoleIO.data)
  IF actual=1 THEN asciiChar:=buffer[0]
ENDPROC  asciiChar
  /* cookRawkey */
