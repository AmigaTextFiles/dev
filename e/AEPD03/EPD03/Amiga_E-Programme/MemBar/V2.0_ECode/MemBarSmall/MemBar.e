MODULE 'exec/execbase'
MODULE 'exec/lists'
MODULE 'exec/memory'
MODULE 'exec/nodes'
MODULE 'exec/ports'
MODULE 'exec/types'
MODULE 'graphics/rastport'
MODULE 'intuition/intuition'
MODULE 'intuition/screens'

PMODULE 'PMODULES:systime'

/*************/
/* CONSTANTS */
/*************/

CONST MAXMODE = 2,
      WTF_THRESHOLD = 10

/***********/
/* GLOBALS */
/***********/

DEF dateStr [8] : STRING,
    win : PTR TO window



PROC succFrom (listNode)
  DEF node : ln
  /*----------------------------------------------*/
  /* Extract successor from a listnode structure. */
  /*----------------------------------------------*/
  node := listNode
ENDPROC  node.succ



PROC maxMem (memType)
  DEF execBase : PTR TO execbase,
      blockSize = 0,
      memHeader : PTR TO mh,
      memList : PTR TO lh

  /*---------------------------------------------------------------*/
  /* Calculate max memory of type memType.  memType will be either */
  /* MEMF_CHIP for chip memory, or MEMF_FAST for fast memory.      */
  /* The memory is gotten from the memList in execbase, which is a */
  /* list of memory available to the system.                       */
  /*---------------------------------------------------------------*/

  Forbid ()

  /* Break down execBase. */
  execBase := execbase
  memList := execBase.memlist
  memHeader := memList.head

  /* Follow the memlist to accumulate total ram of type memType. */
  WHILE succFrom (memHeader.ln) /* MemHeader.mh_Node.ln_Succ */
    IF (memHeader.attributes AND memType)
      blockSize := blockSize + memHeader.upper - memHeader.lower
    ENDIF
    memHeader := succFrom (memHeader.ln)
  ENDWHILE

  Permit ()

ENDPROC  blockSize



PROC cleanUp (errMsg)
  IF errMsg THEN WriteF ('\s\n', errMsg)
  IF win THEN CloseW (win)
ENDPROC



PROC main ()
  DEF mode = 0,
      delay = 20,
      bool = TRUE,
      msg : PTR TO intuimessage,
      class,
      code,
      max,
      x,
      wtfLevel = WTF_THRESHOLD

  /*----------------------------------------------------------------------*/
  /* Open a window on workbench screen, width of about half the titlebar, */
  /* height of titlebar, which will display a guage of chip and fast      */
  /* memory.  If right mouse button is pressed in the window, the display */
  /* will toggle to datetime and back to memory guage.                    */
  /*----------------------------------------------------------------------*/

  IF (win := OpenW (0, 0, 68, 10,
                    (IDCMP_MOUSEBUTTONS + IDCMP_CLOSEWINDOW),
                    (WFLG_CLOSEGADGET + WFLG_DRAGBAR +
                     WFLG_SMART_REFRESH + WFLG_NOCAREREFRESH +
                     WFLG_RMBTRAP),
                    '     ',
                    NIL,
                    WBENCHSCREEN,
                    NIL)) = NIL
    cleanUp ('MemBar : Can\at open window.')
  ENDIF

  FOR x := 0 TO 9 DO Line (0, x, 30, x, 1)

  WHILE bool

    Delay (delay)
    INC wtfLevel

    IF wtfLevel >= (WTF_THRESHOLD + exp (mode + 1, 3))
      WindowToFront (win)
      wtfLevel := 0
    ENDIF

    WHILE msg := GetMsg (win.userport)

      class := msg.class
      code := msg.code

      ReplyMsg (msg)

      SELECT class
        CASE IDCMP_CLOSEWINDOW
          bool := FALSE
        CASE IDCMP_MOUSEBUTTONS
          IF code = MENUUP
            INC mode
            IF mode = MAXMODE THEN mode := 0
          ENDIF
      ENDSELECT

    ENDWHILE

    SELECT mode
      CASE 0
        /*-------------*/
        /* show membar */
        /*-------------*/

        /* Fill meter background. */
        Line (2, 1,  2, 8, 2)  /* Vert, left edge. */
        Line (3, 1,  3, 8, 2)  /* Vert, left edge. */
        Line (4, 1, 65, 1, 2)  /* Horiz...         */
        Line (4, 4, 65, 4, 2)
        Line (4, 5, 65, 5, 2)
        Line (4, 8, 65, 8, 2)

        /* Draw chip guage. */

        max := maxMem (MEMF_CHIP)

        x := Div (Mul (61, (max - AvailMem (MEMF_CHIP))), max) + 4

        Line (4, 2, x, 2, 3)
        Line (4, 3, x, 3, 3)

        INC x

        Line (65, 2, x, 2, 2)
        Line (65, 3, x, 3, 2)

        /* Draw fast guage. */

        max := maxMem (MEMF_FAST)
        x := Div (Mul (61, (max - AvailMem (MEMF_FAST))), max) + 4

        Line (4, 6, x, 6, 3)
        Line (4, 7, x, 7, 3)

        INC x

        Line (65, 6, x, 6, 2)
        Line (65, 7, x, 7, 2)

        delay := 20

      CASE 1
        /*-----------*/
        /* show time */
        /*-----------*/

        IF delay <> 10
          Colour (1, 0)
          delay := 10  /* Eat as little CPU as possible      */
                       /* while remaining somewhat accurate. */
        ENDIF
        TextF (2, 7, '\s', systemTimeStr (dateStr))

    ENDSELECT

  ENDWHILE

  cleanUp (NIL)

ENDPROC
