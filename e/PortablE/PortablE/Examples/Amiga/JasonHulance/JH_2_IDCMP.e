/* An old E example converted to PortablE.
  From Jason R Hulance's "A Beginner's Guide to Amiga E". */

OPT POINTER
MODULE 'intuition/intuition'
MODULE 'intuition', 'graphics'

CONST GADGETBUFSIZE = GADGETSIZE, OURGADGET = 1

PROC main()
  DEF buf[GADGETBUFSIZE]:ARRAY OF BYTE, wptr:PTR TO window, class, gad:PTR TO gadget
  Gadget(buf, NIL, OURGADGET, 1, 10, 30, 100, 'Press Me')
  wptr:=OpenW(20,50,200,100,
              IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP,
              WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
              'Gadget message window',NIL,1,buf !!VALUE!!PTR TO gadget)
  IF wptr              /* Check to see we opened a window */
    WHILE (class:=WaitIMessage(wptr))<>IDCMP_CLOSEWINDOW
      gad:=MsgIaddr()  /* Our gadget clicked? */
      IF (class=IDCMP_GADGETUP) AND (gad.userdata=OURGADGET)
        TextF(10,60,
              IF gad.flags=0 THEN 'Gadget off ' ELSE 'Gadget on   ')
      ENDIF
    ENDWHILE
    CloseW(wptr)       /* Close the window */
  ELSE
    Print('Error -- could not open window!')
  ENDIF
ENDPROC
