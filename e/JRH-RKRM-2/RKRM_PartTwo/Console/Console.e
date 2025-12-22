-> Console.e
->
-> Example of opening a window and using the console device to send text and
-> control sequences to it.  The example can be easily modified to do
-> additional control sequences.

->>> Header (globals)
OPT PREPROCESS

MODULE 'devices/console',
       'exec/io',
       'exec/ports',
       'intuition/intuition',
       'intuition/screens',
       'amigalib/io',
       'amigalib/ports'

ENUM ERR_NONE, ERR_DEV, ERR_IO, ERR_PORT

RAISE ERR_DEV IF OpenDevice()<>0

-> Note - using two character <CSI> ESC[.  Hex 9B could be used instead
#define RESETCON  '\ec'
#define CURSOFF   '\e[0 p'
#define CURSON    '\e[ p'
#define DELCHAR   '\e[P'

-> SGR (set graphic rendition)
#define COLOR02   '\e[32m'
#define COLOR03   '\e[33m'
#define ITALICS   '\e[3m'
#define BOLD      '\e[1m'
#define UNDERLINE '\e[4m'
#define NORMAL    '\e[0m'

DEF win=NIL:PTR TO window, writeReq=NIL:PTR TO iostd, writePort=NIL:PTR TO mp,
    readReq=NIL:PTR TO iostd, readPort=NIL:PTR TO mp, openedConsole=FALSE
->>>
          
->>> PROC main()
PROC main() HANDLE
  DEF winmsg:PTR TO intuimessage, signals, conreadsig, windowsig, lch,
      inControl=0, going=TRUE, ch, ibuf, obuf[200]:STRING, error, class

  -> Create reply port and io block for writing to console
  IF NIL=(writePort:=createPort('RKM.console.write', 0)) THEN Raise(ERR_PORT)
  IF NIL=(writeReq:=createExtIO(writePort, SIZEOF iostd)) THEN Raise(ERR_IO)

  -> Create reply port and io block for reading from console
  IF NIL=(readPort:=createPort('RKM.console.read', 0)) THEN Raise(ERR_PORT)
  IF NIL=(readReq:=createExtIO(readPort, SIZEOF iostd)) THEN Raise(ERR_IO)

  -> Open a window
  win:=OpenWindow([10, 10, 620, 180, -1, -1, IDCMP_CLOSEWINDOW,
                   WFLG_DEPTHGADGET OR WFLG_SIZEGADGET OR WFLG_DRAGBAR OR
                     WFLG_CLOSEGADGET OR WFLG_SMART_REFRESH OR WFLG_ACTIVATE,
                   NIL, NIL, 'Console Test', NIL, NIL,
                   100, 45, 640, 200, WBENCHSCREEN]:nw)

  -> Now, attach a console to the window
  openConsole(writeReq, readReq, win)
  openedConsole:=TRUE

  -> Demonstrate some console escape sequences
  conPuts(writeReq, 'Here''s some normal text\n')
  StringF(obuf, '\s\sHere''s some text in color 3 and italics\n',
                COLOR03, ITALICS)
  conPuts(writeReq, obuf)
  conPuts(writeReq, NORMAL)
  Delay(50)  -> Delay for dramatic effect

  conPuts(writeReq, 'We will now delete this asterisk =*=')
  Delay(50)
  conPuts(writeReq, {bspace})  -> Backspace twice
  Delay(50)
  conPuts(writeReq, DELCHAR)  -> Delete the character
  Delay(50)

  queueRead(readReq, {ibuf})  -> Send the first console read request

  conPuts(writeReq, '\n\nNow reading console\n')
  conPuts(writeReq, 'Type some keys.  Close window when done.\n\n')

  conreadsig:=Shl(1, readPort.sigbit)
  windowsig:=Shl(1, win.userport.sigbit)
  WHILE going
    -> A character, or an IDCMP msg, or both could wake us up
    signals:=Wait(conreadsig OR windowsig)

    -> If a console signal was received, get the character
    IF signals AND conreadsig
      IF -1<>(lch:=conMayGetChar(readPort, {ibuf}))
        ch:=lch
        -> Show hex and ascii (if printable) for char we got.  If you want to
        -> parse received control sequences, such as function or Help keys,
        -> you would buffer control sequences as you receive them, starting to
        -> buffer whenever you receive $9B (or $1B[ for user-typed sequences)
        -> and ending when you receive a valid terminating character for the
        -> type of control sequence you are receiving.  For CSI sequences,
        -> valid terminating characters are generally $40 through $7E.  In our
        -> example, InControl has the following values: 0 = no, 1 = have $1B,
        -> 2 = have $9B OR $1B and [, 3 = now inside control sequence,
        -> -1 = normal end esc, -2 = non-CSI(no [) $1B end esc
        -> NOTE - a more complex parser is required to recognize other types
        -> of control sequences.

        -> $1B ESC not followed by "[", is not CSI seq
        IF inControl=1 THEN (inControl:=IF ch="[" THEN 2 ELSE -2)
        IF (ch=$9B) OR (ch=$1B)  -> Control seq starting
          inControl:=IF ch=$1B THEN 1 ELSE 2
          conPuts(writeReq, '=== Control Seq ===\n')
        ENDIF
        -> We'll show the value of this char we received
        IF ((ch>=$1F) AND (ch<=$7E)) OR (ch>=$A0)
          StringF(obuf, 'Received: hex $\z\h[2] = \c\n', ch, ch)
        ELSE
          StringF(obuf, 'Received: hex $\z\h[2]\n', ch)
        ENDIF
        conPuts(writeReq, obuf)
      ENDIF
    ENDIF

    -> If IDCMP messages received, handle them
    IF signals AND windowsig
      -> We have to ReplyMsg these when done with them
      WHILE winmsg:=GetMsg(win.userport)
        class:=winmsg.class
        SELECT class
        CASE IDCMP_CLOSEWINDOW
          going:=FALSE
        ENDSELECT
        ReplyMsg(winmsg)
      ENDWHILE
    ENDIF
  ENDWHILE

  -> We always have an outstanding queued read request so we must abort it if
  -> it hasn't completed, and we must remove it.
  IF CheckIO(readReq)=FALSE THEN AbortIO(readReq)
  WaitIO(readReq)  -> Clear it from our replyport

EXCEPT DO
  IF openedConsole THEN closeConsole(writeReq)
  IF win THEN CloseWindow(win)
  IF readReq THEN deleteExtIO(readReq)
  IF readPort THEN deletePort(readPort)
  IF writeReq THEN deleteExtIO(writeReq)
  IF writePort THEN deletePort(writePort)
  SELECT exception
  CASE ERR_DEV;   WriteF('Error: could not open console device\n')
  CASE ERR_IO;    WriteF('Error: could not create I/O\n')
  CASE ERR_PORT;  WriteF('Error: could not create port\n')
  ENDSELECT
ENDPROC

-> E-Note: simple way to get a string with two backspaces
bspace:  CHAR 8, 8, 0
->>>

->>> PROC openConsole(writereq:PTR TO iostd, readReq:PTR TO iostd, window)
-> Attach console device to an open Intuition window.
-> E-Note: This function will raise an exception if the console device is not
-> opened correctly.
PROC openConsole(writereq:PTR TO iostd, readreq:PTR TO iostd, window)
  DEF error
  writereq.data:=window
  writereq.length:=SIZEOF window
  error:=OpenDevice('console.device', 0, writereq, 0)
  readreq.device:=writereq.device  -> Clone required parts
  readreq.unit:=writereq.unit
ENDPROC error
->>>

->>> PROC closeConsole(writereq)
PROC closeConsole(writereq) IS CloseDevice(writereq)
->>>

->>> PROC conPutChar(writereq:PTR TO iostd, char)
-> Output a single character to a specified console.
PROC conPutChar(writereq:PTR TO iostd, char)
  writereq.command:=CMD_WRITE
  -> E-Note: use typed list to get address of the CHAR in the LONG 'char'
  writereq.data:=[char]:CHAR
  writereq.length:=1
  DoIO(writereq)
  -> Command works because DoIO blocks until command is done (otherwise
  -> pointer to string could become invalid in the meantime).
ENDPROC
->>>

->>> PROC conWrite(writereq:PTR TO iostd, string, length)
-> Output a stream of known length to a console.
PROC conWrite(writereq:PTR TO iostd, string, length)
  writereq.command:=CMD_WRITE
  writereq.data:=string
  writereq.length:=length
  DoIO(writereq)
ENDPROC
->>>

->>> PROC conPuts(writereq:PTR TO iostd, string)
-> Output a NIL-terminated string of characters to a console.
PROC conPuts(writereq:PTR TO iostd, string)
  writereq.command:=CMD_WRITE
  writereq.data:=string
  writereq.length:=-1  -> This means print until terminating NIL
  DoIO(writereq)
ENDPROC
->>>

->>> PROC queueRead(readreq:PTR TO iostd, whereto)
-> Queue up a read request to console, passing it pointer to a buffer into
-> which it can read the character
PROC queueRead(readreq:PTR TO iostd, whereto)
  readreq.command:=CMD_READ
  readreq.data:=whereto
  readreq.length:=1
  SendIO(readreq)
ENDPROC
->>>

->>> PROC conMayGetChar(msgport, whereto)
-> Check if a character has been received.  If none, return -1
PROC conMayGetChar(msgport, whereto)
  DEF temp, readreq:PTR TO iostd
  IF NIL=(readreq:=GetMsg(msgport)) THEN RETURN -1
  temp:=whereto[]  -> Get the character...
  queueRead(readreq, whereto)  -> ...then re-use the request block
ENDPROC temp
->>>
