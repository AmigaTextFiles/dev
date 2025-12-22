
MODULE 'intuition/intuition'

CONST NUMSTARS=200

OBJECT point
  x
  y
  z
  s
ENDOBJECT

DEF star[NUMSTARS]:ARRAY OF point
DEF loop,x,y
DEF d=180

PROC main()

DEF bouncewin:PTR TO window
DEF port, mes:PTR TO intuimessage


  IF bouncewin := OpenW(0,0,400,200,
                       (IDCMP_CLOSEWINDOW),
                       (WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR
                        WFLG_CLOSEGADGET OR WFLG_ACTIVATE),
                       'StarField',0,1,0)

    Box(0,0,400,200,1)
    Rnd(-VbeamPos())
    port := bouncewin.userport
    FOR loop := 1 TO NUMSTARS
      star[loop].x := Rnd(400) - 200
      star[loop].y := Rnd(200) - 100
      star[loop].z := Rnd(200) - 500
      star[loop].s := /*Rnd(4) +*/ 1
    ENDFOR
    /*TextF(20,20,'x \d',star[1].x)*/

    IF (mes := GetMsg(port))=NIL
      REPEAT

        FOR loop := 1 TO NUMSTARS
          x := ((star[loop].x*d)/star[loop].z) + 200
          y := ((star[loop].y*d)/star[loop].z) + 100
          Plot(x,y,1)
        ENDFOR

        FOR loop := 1 TO NUMSTARS
          x := star[loop].z + star[loop].s
          IF (x>=-2) THEN x := x - 200
          star[loop].z := x
        ENDFOR

        FOR loop := 1 TO NUMSTARS
          x := ((star[loop].x*d)/star[loop].z) + 200
          y := ((star[loop].y*d)/star[loop].z) + 100
          Plot(x,y,7)
        ENDFOR

        WaitTOF()
        /*WaitTOF()*/
      UNTIL (mes := GetMsg(port))<>NIL
    ENDIF

    ReplyMsg(mes)
    CloseW(bouncewin)

  ENDIF

  CleanUp(0)

ENDPROC
