/*
*/
MODULE 'intuition/intuition'

CONST GADGETBUFSIZE = GADGETSIZE*3, OURGADGET = 1

PROC main()
  DEF buf[GADGETBUFSIZE]:ARRAY, wptr, class, gad:PTR TO Gadget,next

  next:=Gadget(buf , NIL, 1, 1, 10, 20, 100, 'Press Me')
  next:=Gadget(next, buf, 2, 0, 10, 40, 100, 'Press You')
  next:=Gadget(next, buf, 3, 3, 10, 55, 100, 'Press The Other')
  wptr:=OpenW(20,50,200,100,
              IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP OR IDCMP_MOUSEBUTTONS,
              WFLG_CLOSEGADGET OR WFLG_ACTIVATE,
              'Gadget message window',NIL,1,buf)
  IF wptr              /* Check to see we opened a window */
    WHILE (class:=WaitIMessage(wptr))<>IDCMP_CLOSEWINDOW
      gad:=MsgIaddr()  /* Our gadget clicked? */
      IF (class=IDCMP_GADGETUP) AND (gad.UserData=OURGADGET)
        TextF(10,85,
              IF gad.Flags=0 THEN 'Gadget off ' ELSE 'Gadget on   ')
      ENDIF
    ENDWHILE
    CloseWindow(wptr)       /* Close the window */
  ELSE
    WriteF('Error -- could not open window!')
  ENDIF

ENDPROC

