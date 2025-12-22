
MODULE 'intuition/intuition'


OBJECT point
  x
  y
  a
  b
ENDOBJECT

DEF old:point
DEF new:point



PROC main()

DEF class, count
DEF bouncewin:PTR TO window
DEF dx=3, dy=4, da=5, db=6
DEF port, mes:PTR TO intuimessage


  old := [100,100,130,130]
  new := [0,0,0,0]

  IF bouncewin := OpenW(0,0,200,200,
                       (IDCMP_CLOSEWINDOW),
                       (WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR
                        WFLG_CLOSEGADGET OR WFLG_ACTIVATE),
                       'Bouncing Lines',0,1,0)

    port := bouncewin.userport
   /* WriteF('Borderleft   = \d\n', bouncewin.borderleft)
    WriteF('Borderright  = \d\n', bouncewin.borderright) */

    IF (mes := GetMsg(port))=NIL
      REPEAT
        IF (old.x+dx>(199-bouncewin.borderright)) OR
(old.x+dx<bouncewin.borderleft) THEN dx := dx * -1
        IF (old.y+dy>(199-bouncewin.borderbottom)) OR
(old.y+dy<bouncewin.bordertop) THEN dy := dy * -1
        IF (old.a+da>(199-bouncewin.borderright)) OR
(old.a+da<bouncewin.borderleft) THEN da := da * -1
        IF (old.b+db>(199-bouncewin.borderbottom)) OR
(old.b+db<bouncewin.bordertop) THEN db := db * -1
/* ^^^^ paste these lines back together my editor screwed them */
        new.x := old.x + dx
        new.y := old.y + dy
        new.a := old.a + da
        new.b := old.b + db

        Line(new.x, new.y, new.a, new.b, 1)
        Line(old.x, old.y, old.a, old.b, 0)

        old.x := new.x
        old.y := new.y
        old.a := new.a
        old.b := new.b

        WaitTOF()
        /*Delay(1)*/
      UNTIL (mes := GetMsg(port))<>NIL
    ENDIF

    ReplyMsg(mes)
    CloseW(bouncewin)

  ENDIF

  CleanUp(0)

ENDPROC
