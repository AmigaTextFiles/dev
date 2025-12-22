-> eventloop.e - standard technique to handle IntuiMessages from an IDCMP.

MODULE 'exec/ports',
       'intuition/intuition'

ENUM ERR_NONE, ERR_WIN

RAISE ERR_WIN IF OpenWindowTagList()=NIL

PROC main() HANDLE
  DEF signals, done, win=NIL:PTR TO window
  win:=OpenWindowTagList(NIL,
                        [WA_TITLE,       'Press Keys and Mouse in this Window',
                         WA_WIDTH,       500,
                         WA_HEIGHT,      50,
                         WA_ACTIVATE,    TRUE,
                         WA_CLOSEGADGET, TRUE,
                         WA_RMBTRAP,     TRUE,
                         WA_IDCMP, IDCMP_CLOSEWINDOW OR IDCMP_VANILLAKEY OR
                            IDCMP_RAWKEY OR IDCMP_DISKINSERTED OR
                            IDCMP_DISKREMOVED OR IDCMP_MOUSEBUTTONS,
                         NIL])

  -> Perform this loop until the message handling routine signals that we
  -> are done.
  ->
  -> When the Wait() returns, check which signal hit and process the correct
  -> port.  There is only one port here, so the test could be eliminated.  If
  -> multiple ports were being watched, the test would become:
  ->
  ->    signals:=Wait(Shl(1, win1.userport.sigbit) OR
  ->                  Shl(1, win2.userport.sigbit) OR
  ->                  Shl(1, win3.userport.sigbit))
  ->    IF signals AND Shl(1, win1.userport.sigbit)
  ->      done:=handleWin1IDCMP(win1, done)
  ->    ELSEIF signals AND Shl(1, win2.userport.sigbit)
  ->      done:=handleWin2IDCMP(win2, done)
  ->    ELSEIF signals AND Shl(1, win3.userport.sigbit)
  ->      done:=handleWin3IDCMP(win3, done)
  ->    ENDIF
  ->
  -> Note that these could all call the same routine with different window
  -> pointers (if the handling was identical).
  ->
  -> handleIDCMP() should remove all of the messages from the port.
  -> E-Note: since this example should be generalisable to more than one
  ->         window, WaitIMessage is not used (for a change!)
  done:=FALSE
  REPEAT
    signals:=Wait(Shl(1, win.userport.sigbit))
    IF signals AND Shl(1, win.userport.sigbit)
      done:=handleIDCMP(win, done)
    ENDIF
  UNTIL done

EXCEPT DO
  IF win THEN CloseWindow(win)
  SELECT exception
  CASE ERR_WIN; WriteF('Error: Failed to open window.\n')
  ENDSELECT
ENDPROC

-> handleIDCMP() - Handle all of the messages from an IDCMP.
PROC handleIDCMP(win:PTR TO window, done)
  DEF message:PTR TO intuimessage, code, mousex, mousey, class

  -> Remove all of the messages from the port by calling GetMsg() until
  -> it returns NULL.
  ->
  -> The code should be able to handle three cases:
  ->
  -> 1.  No messages waiting at the port, and the first call to GetMsg()
  -> returns NULL.  In this case the code should do nothing.
  ->
  -> 2.  A single message waiting.  The code should remove the message,
  -> processes it, and finish.
  ->
  -> 3.  Multiple messages waiting.  The code should process each waiting
  -> message, and finish.
  WHILE message:=GetMsg(win.userport)
    -> It is often convenient to copy the data out of the message.  In many
    -> cases, this lets the application reply to the message quickly.  Copying
    -> the data is not required, if the code does not reply to the message
    -> until the end of the loop, then it may directly reference the message
    -> information anywhere before the reply.
    class:=message.class
    code:=message.code
    mousex:=message.mousex
    mousey:=message.mousey

    -> The loop should reply as soon as possible.  Note that the code may not
    -> reference data in the message after replying to the message.  Thus, the
    -> application should not reply to the message until it is done referencing
    -> information in it.
    ->
    -> Be sure to reply to every message received with GetMsg().
    ReplyMsg(message)

    -> The class contains the IDCMP type of the message.
    SELECT class
    CASE IDCMP_CLOSEWINDOW
      done:=TRUE
    CASE IDCMP_VANILLAKEY
      WriteF('IDCMP_VANILLAKEY (\c)\n', code)
    CASE IDCMP_RAWKEY
      WriteF('IDCMP_RAWKEY\n')
    CASE IDCMP_DISKINSERTED
      WriteF('IDCMP_DISKINSERTED\n')
    CASE IDCMP_DISKREMOVED
      WriteF('IDCMP_DISKREMOVED\n')
    CASE IDCMP_MOUSEBUTTONS
      -> The code often contains useful data, such as the ASCII value (for
      -> IDCMP_VANILLAKEY), or the type of button event here.
      SELECT code
      CASE SELECTUP
        WriteF('SELECTUP at \d,\d\n', mousex, mousey)
      CASE SELECTDOWN
        WriteF('SELECTDOWN at \d,\d\n', mousex, mousey)
      CASE MENUUP
        WriteF('MENUUP\n')
      CASE MENUDOWN
        WriteF('MENUDOWN\n')
      DEFAULT
        WriteF('UNKNOWN CODE\n')
      ENDSELECT
    DEFAULT
      WriteF('Unknown IDCMP message\n')
    ENDSELECT
  ENDWHILE
ENDPROC done
