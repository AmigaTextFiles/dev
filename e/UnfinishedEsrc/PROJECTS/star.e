-> By Ian Chapman
-> STAR TWINKLER

MODULE  'graphics/gfx',
        'intuition/screens'

PROC main()
DEF scr:PTR TO screen,
    rast,
    x,
    r,
    s,
    v

Rnd(-0.12121)

IF (scr:=OpenS(640,256,6,$8000,'STAR TWINKLER',NIL))<>NIL
    rast:=scr.rastport
    FOR v:=1 TO 50
        r:=Rnd(619)+21
        s:=Rnd(620)+21
        FOR x:=1 TO 21
            Colour(1)
            Plot(r-x,s,1)
            Plot(r+x,s,1)
            Plot(r,s-x,1)
            Plot(r,s+x,1)
            Delay(1)
        ENDFOR

        FOR x:=21 TO 1 STEP -1
            Colour(0)
            Plot(r-x,s,0)
            Plot(r+x,s,0)
            Plot(r,s-x,0)
            Plot(r,s+x,0)
            Delay(1)
        ENDFOR
    ENDFOR
    CloseS(scr)

ELSE
    PrintF('Unable to open screen.\n')
ENDIF

ENDPROC

