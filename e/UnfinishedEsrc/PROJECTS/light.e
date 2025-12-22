->By Ian Chapman
->Simple lightning simulator

MODULE 'intuition/screens'

DEF scr:PTR TO screen,rastptr

PROC main()

    IF (scr:=OpenS(640,400,2,$8000,NIL,NIL))<>NIL
        rastptr:=scr.rastport
        black()
        SetColour(scr,2,255,255,0)
        flash()
        CloseS(scr)
    ELSE
        PrintF('Unable to open screen!\n')
    ENDIF

ENDPROC



PROC flash()
DEF i,z,x

    black()
    FOR i:=1 TO 20
        x:=Rnd(5)
        IF x=0 THEN x:=1
        Delay(Rnd(300))
        FOR z:=1 TO x
            blue()
            Delay(1)
            black()
        ENDFOR

        lightdraw()
    ENDFOR

ENDPROC



PROC lightdraw()
DEF i,y,x,start

    Colour(2)
    start:=Rnd(400)
    IF (start<200) THEN start:=200
    Move(rastptr,start,30)
    y:=10
    x:=0
    FOR i:=1 TO 20
        y:=y+Rnd(20)
        x:=x+Rnd(30)
        Draw(rastptr,x,y)
    ENDFOR
    Move(rastptr,0,0)
    ClearScreen(rastptr)
ENDPROC


PROC black()
    SetColour(scr,0,0,0,0)
ENDPROC


PROC blue()
    SetColour(scr,0,45,65,174)
ENDPROC
