->By Ian Chapman
->Draws in an intuition window until you move out of the left edge

MODULE  'intuition/intuition'

DEF win:PTR TO window


PROC main()


IF (win:=OpenW(10,10,600,200,
              IDCMP_MOUSEBUTTONS OR
              IDCMP_MOUSEMOVE OR
              IDCMP_CLOSEWINDOW,
              WFLG_DRAGBAR OR
              WFLG_CLOSEGADGET OR
              WFLG_DEPTHGADGET OR
              WFLG_GIMMEZEROZERO,
              'TEXT PAINT',
              NIL,1,NIL,NIL))<>NIL
Colour(1)

REPEAT
TextF(win.mousex-5,win.mousey-10,'#')
UNTIL win.mousex<0

CloseW(win)

ELSE
    PrintF('Unable to open Window!\n')
ENDIF

ENDPROC
