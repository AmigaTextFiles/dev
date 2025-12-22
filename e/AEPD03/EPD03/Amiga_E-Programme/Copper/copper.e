/*
        Copperdemo
        ----------
        Ein kleines Proramm für den Copper mit Amiga_E
        © by JCL Power 1993

*/
    MODULE 'exec/memory', 'graphics/copper', 'dos/dos'

DEF clist1, clist2, i, screen, window, vp

PROC main()

    clist1 := AllocMem(252,MEMF_CHIP+MEMF_CLEAR) /* Speicher für die Copper-Liste */
    clist2 := AllocMem(252,MEMF_CHIP+MEMF_CLEAR)

    IF clist1 = 0 THEN RETURN
    IF clist2 = 0 THEN RETURN

    screen := OpenS(640,256,4,$8000,'Copperdemo in E')
    window := OpenW(0,0,640,256,$242,$140F,'Sieht gut aus, gell?',screen,15,NIL)
    vp := ViewPortAddress(window)
    vp := vp + 20
    i := 0

    REPEAT
        i++
        IF i > 2 THEN i := 1
        makecoplist(i)
        IF i = 1 THEN PutLong(vp,clist1) ELSE PutLong(vp,clist2)
        RethinkDisplay()
        Delay(50)
    UNTIL Mouse()<>0

    PutLong(vp,NIL)
    RethinkDisplay()

    CloseW(window)
    CloseS(screen)

    FreeMem(clist1,252)
    FreeMem(clist2,252)
ENDPROC

PROC makecoplist(nr)
/* Baut in abhängigkeit zu nr, eine "wilde" Copperliste auf. */

DEF tt
IF nr = 1
    /* Erste Copper Liste aufbauen. */
    FOR tt:=1 TO 10
        Cwait(clist1,Rnd(200),Rnd(200))
        Cbump(clist1)
        Cmove(clist1,384,Rnd($FFF))
        Cbump(clist1)
    ENDFOR
    Cwait(clist1,10000,255) /* Unmögliche Position */
    RETURN
ENDIF

IF nr = 2
    /* Zweite Copper Liste aufbauen. */
    FOR tt:=1 TO 10
        Cwait(clist2,Rnd(200),Rnd(200))
        Cbump(clist2)
        Cmove(clist2,384,Rnd($FFF))
        Cbump(clist2)
    ENDFOR
    Cwait(clist2,10000,255) /* Unmögliche Position */
    RETURN
ENDIF

ENDPROC
