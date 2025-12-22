-> maprawkey.e - Map Intuition RAWKEY events to ANSI with MapRawKey()

->>> Header (globals)
OPT PREPROCESS

MODULE 'keymap',
       'devices/inputevent',
       'exec/ports',
       'intuition/intuition'

ENUM ERR_NONE, ERR_LIB, ERR_WIN

RAISE ERR_LIB IF OpenLibrary()=NIL,
      ERR_WIN IF OpenWindowTagList()=NIL

-> E-Note: used to convert an INT to unsigned
#define UNSIGNED(x) ((x) AND $FFFF)

DEF window=NIL:PTR TO window
->>>

->>> PROC main()
PROC main() HANDLE
  DEF imsg:PTR TO intuimessage, eventptr:PTR TO LONG, windowsignal,
      inputevent:PTR TO inputevent, buffer[8]:ARRAY, i, going=TRUE, class
  openall()
  window:=OpenWindowTagList(NIL,
                           [WA_WIDTH,  500,
                            WA_HEIGHT, 60,
                            WA_TITLE,  'MapRawKey - Press Keys',
                            WA_FLAGS,  WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
                            WA_IDCMP,  IDCMP_RAWKEY OR IDCMP_CLOSEWINDOW,
                            NIL])
  windowsignal:=Shl(1, window.userport.sigbit)

  -> Initialise inputevent object
  -> E-Note: first allocate it cleared using NEW
  NEW inputevent
  inputevent.class:=IECLASS_RAWKEY

  WHILE going
    Wait(windowsignal)

    WHILE imsg:=GetMsg(window.userport)
      class:=imsg.class
      SELECT class
      CASE IDCMP_CLOSEWINDOW
        going:=FALSE
      CASE IDCMP_RAWKEY
        inputevent.code:=imsg.code
        inputevent.qualifier:=UNSIGNED(imsg.qualifier)

        WriteF('RAWKEY: Code=$\z\h[4]  Qualifier=$\z\h[4]\n',
               imsg.code, UNSIGNED(imsg.qualifier))

        -> Make sure deadkeys and qualifiers are taken into account.
        eventptr:=imsg.iaddress
        inputevent.eventaddress:=eventptr[]

        -> Map RAWKEY to ANSI
        i:=MapRawKey(inputevent, buffer, 8, NIL)

        IF i=-1
          WriteF('*Overflow*')
        ELSEIF i
          -> This key or key combination mapped to something
          WriteF('MAPS TO: ')
          Write(stdout, buffer, i)
          WriteF('\n')
        ENDIF
      ENDSELECT
      ReplyMsg(imsg)
    ENDWHILE
  ENDWHILE
EXCEPT DO
  IF window THEN CloseWindow(window)
  closeall()
  SELECT exception
  CASE ERR_LIB;  WriteF('Error: could not open keymap library\n')
  CASE ERR_WIN;  WriteF('Error: could not open window\n')
  CASE "MEM";    WriteF('Error: ran out of memory\n')
  ENDSELECT
ENDPROC
->>>

->>> PROC openall()
PROC openall()
  keymapbase:=OpenLibrary('keymap.library', 37)
ENDPROC
->>>

->>> PROC closeall()
PROC closeall()
  IF keymapbase THEN CloseLibrary(keymapbase)
ENDPROC
->>>

