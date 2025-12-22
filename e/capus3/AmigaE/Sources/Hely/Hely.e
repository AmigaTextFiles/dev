->> EDEVHEADER
/*= © NasGûl =========================
 ESOURCE Hely.e
 EDIR    Workbench:AmigaE/Sources/Fun
 ECOPT   ERRLINE
 EXENAME Hely
 MAKE    EC
 AUTHOR  NasGûl
 TYPE    EXEDOS
 =====================================*/
-><
->> ©/DISTRIBUTION/UTILISATION
/*=====================================

 - TOUTE UTILISATION COMMERCIALE DES CES SOURCES EST
   INTERDITE SANS MON AUTORISATION.

 - TOUTE DISTRIBUTION DOIT ETRE FAITES EN TOTALITE (EXECUTABLES/MODULES E/SOURCES E).

 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 !! TOUTE INCLUSION SUR UN CD-ROM EST INTERDITE SANS MON AUTORISATION.!!
 !! SEULES LES DISTRIBUTIONS DE FRED FISH ET AMINET CDROM SONT AUTO-  !!
 !! RISES A DISTRIBUER CES PROGRAMMES/SOURCES.                        !!
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

=====================================*/
-><
->> MODULES

MODULE 'intuition/intuitionbase'
MODULE 'intuition/intuition'
MODULE 'intuition/screens'
MODULE 'graphics/sprite','graphics/view'
MODULE 'exec/memory'
MODULE 'utility/tagitem'
MODULE 'dos/var','dos/var'

-><
->> DEFINITIONS GLOBALES

/*=== image of hely ===*/
DEF ch_img0,
    ch_img1,
    ch_img2,
    ch_img3,
    ch_img4,
    ch_img5

/*=== Image of explosion ===*/
DEF ex01,ex02,ex03,ex04,ex05,ex06,ex07,ex08,ex09,ex10,ex11,ex12
/*=== Image empty (no more click.. ) ===*/
DEF ept
/*=== screen dimension ===*/
DEF endscreen,heightscr
/*=== Game parameters ===*/
DEF sinfactor=7
DEF minspeed=4,maxspeed=20,numclick=20
DEF totalscore=0,numpas=0,game=TRUE

-><
->> main()
PROC main()
    DEF rdargs=NIL,myargs:PTR TO LONG
    myargs:=[0,0,0,0,0]
    IF rdargs:=ReadArgs('SinFactor/K/N,MinSpeed/K/N,MaxSpeed/K/N,NumClick/K/N,NoGame/S',myargs,NIL)
    IF myargs[0] THEN sinfactor:=Long(myargs[0]) ELSE sinfactor:=7
    IF myargs[1] THEN minspeed:=Long(myargs[1]) ELSE minspeed:=4
    IF myargs[2] THEN maxspeed:=Long(myargs[2]) ELSE maxspeed:=20
    IF myargs[3] THEN numclick:=Long(myargs[3]) ELSE numclick:=20
    IF myargs[4] THEN game:=FALSE
    doGame()
    FreeArgs(rdargs)
    ELSE
    WriteF('Bad Args\n')
    ENDIF
ENDPROC
-><
->> doGame()
PROC doGame()
    DEF mysp:PTR TO simplesprite,quit=FALSE
    DEF r
    DEF t,frame=0
    DEF mx=0,my=100,cy
    DEF fy
    DEF task
    DEF speedx=10
    DEF vp:PTR TO viewport
    DEF oneclick=0
    task:=FindTask(NIL)
    vp:=getViewPort()
    SetTaskPri(task,-1)
    IF t:=initImageSP()
    IF t:=initExplosion()
        changeColorSP()
        mysp:=[ch_img0,12,0,0,2]:simplesprite
        r:=GetSprite(mysp,2)
        IF r=2
        cy:=Rnd(heightscr)
        fy:=Rnd(sinfactor)!
        ChangeSprite(vp,mysp,ch_img0)
        REPEAT
            INC frame
            IF frame>5 THEN frame:=0
            SELECT frame
            CASE 0; ChangeSprite(vp,mysp,ch_img0)
            CASE 1; ChangeSprite(vp,mysp,ch_img1)
            CASE 2; ChangeSprite(vp,mysp,ch_img2)
            CASE 3; ChangeSprite(vp,mysp,ch_img3)
            CASE 4; ChangeSprite(vp,mysp,ch_img4)
            CASE 5; ChangeSprite(vp,mysp,ch_img5)
            ENDSELECT

            my:=makeCoordSin(mx,cy,fy)
            MoveSprite(vp,mysp,mx,my)
            IF game
            IF Mouse()=1
                INC oneclick
                IF ((checkMouse(mx,my)) AND (oneclick<=numclick))
                INC numpas
                paletteExplosion()
                mysp.height:=15
                animExplode(vp,mysp)
                fy:=fy+5.0
                totalscore:=totalscore+(speedx*(!fy!))+(endscreen-mx)
                setScore(totalscore/numpas)
                changeColorSP()
                mysp.height:=12
                mx:=0
                fy:=Rnd(sinfactor)!
                cy:=Rnd(heightscr)
                oneclick:=0
                ELSEIF oneclick>numclick
                mysp.height:=11
                ChangeSprite(vp,mysp,ept)
                mysp.height:=12
                ENDIF
            ENDIF
            ENDIF
            mx:=mx+speedx
            IF mx>=endscreen
            INC numpas
            setScore(totalscore/numpas)
            mysp.height:=12
            cy:=Rnd(heightscr)
            mx:=0
            fy:=Rnd(sinfactor)!
            speedx:=Rnd(maxspeed)
            IF speedx<minspeed THEN speedx:=minspeed
            changeColorSP()
            oneclick:=0
            INC numpas
            ENDIF
            IF CtrlC() THEN JUMP fin
            WaitTOF()
        UNTIL quit=TRUE
        fin:
        paletteExplosion()
        mysp.height:=15
        animExplode(vp,mysp)
        ENDIF
        IF mysp.num<>-1 THEN FreeSprite(mysp.num)
        remExplosion()
    ELSE
        WriteF('Image alloc failed.\n')
    ENDIF
    remImageSP()
    ELSE
    WriteF('Image alloc failed.\n')
    ENDIF
ENDPROC
-><
->> setScore(t)
PROC setScore(t)
    DEF cmd[256]:STRING
    StringF(cmd,'\d',t)
    SetVar('HELY',cmd,StrLen(cmd),GVF_GLOBAL_ONLY)
ENDPROC
-><
->> checkMouse(curx,cury)
PROC checkMouse(curx,cury)
    DEF ret=FALSE
    DEF moux,mouy
    moux:=getMouseX()
    mouy:=getMouseY()
    IF moux>=(curx+8)
    IF moux<=(curx+16)
        IF mouy>=(cury+2)
        IF mouy<=(cury+10)
            ret:=TRUE
        ENDIF
        ENDIF
    ENDIF
    ENDIF
ENDPROC ret
-><
->> getViewPort()
PROC getViewPort()
    DEF i:PTR TO intuitionbase
    DEF s:PTR TO screen
    i:=intuitionbase
    s:=i.activescreen
    endscreen:=s.width
    heightscr:=s.height
ENDPROC s.viewport
-><
->> getMouseY()
PROC getMouseY()
    DEF intui:PTR TO intuitionbase
    DEF w:PTR TO window
    DEF s:PTR TO screen
    intui:=intuitionbase
    w:=intui.activewindow
    s:=w.wscreen
ENDPROC s.mousey
-><
->> getMouseX()
PROC getMouseX()
    DEF intui:PTR TO intuitionbase
    DEF w:PTR TO window
    DEF s:PTR TO screen
    intui:=intuitionbase
    w:=intui.activewindow
    s:=w.wscreen
ENDPROC s.mousex
-><
->> makeCoordSin(valx,cury,factory)
PROC makeCoordSin(valx,cury,factory)
    DEF tt,t,valy
    tt:=cury
    t:=(Fsin(((valx!*factory)*3.14159)/180.0))*10.0
    tt:=!t!
    valy:=cury+tt
ENDPROC valy
-><
->> changeColorSP()
PROC changeColorSP()
    DEF intui:PTR TO intuitionbase
    DEF w:PTR TO window
    DEF s:PTR TO screen
    DEF c
    intui:=intuitionbase
    w:=intui.activewindow
    s:=w.wscreen
    c:=Rnd(6)

    SELECT c
    CASE 0
        SetRGB4( s.viewport, 21, $0,$0,$0 ) /* Black */
        SetRGB4( s.viewport, 22, $0,$8, $0 ) /* DGreen */
        SetRGB4( s.viewport, 23, $0,$D, $0 ) /* Green */
    CASE 1
        SetRGB4( s.viewport, 21, $0,$0,$0 ) /* Black */
        SetRGB4( s.viewport, 22, $8,$0, $0 ) /* DGreen */
        SetRGB4( s.viewport, 23, $D,$0, $0 ) /* Green */
    CASE 2
        SetRGB4( s.viewport, 21, $0,$0,$0 ) /* Black */
        SetRGB4( s.viewport, 22, $0,$2, $8 ) /* DGreen */
        SetRGB4( s.viewport, 23, $0,$2, $F ) /* Green */
    CASE 3
        SetRGB4( s.viewport, 21, $0,$0,$0 ) /* Black */
        SetRGB4( s.viewport, 22, $0,$8, $8 ) /* DGreen */
        SetRGB4( s.viewport, 23, $0,$D, $D ) /* Green */
    CASE 4
        SetRGB4( s.viewport, 21, $0,$0,$0 ) /* Black */
        SetRGB4( s.viewport, 22, $8,$8, $0 ) /* DGreen */
        SetRGB4( s.viewport, 23, $D,$D, $0 ) /* Green */
    CASE 5
        SetRGB4( s.viewport, 21, $0,$0,$0 ) /* Black */
        SetRGB4( s.viewport, 22, $8,$0, $8 ) /* DGreen */
        SetRGB4( s.viewport, 23, $D,$0, $D ) /* Green */
    ENDSELECT
ENDPROC
-><
->> animExplode(v,s)
PROC animExplode(v,s)
    DEF b
    FOR b:=0 TO 11
    SELECT b
        CASE 0; ChangeSprite(v,s,ex01)
        CASE 1; ChangeSprite(v,s,ex02)
        CASE 2; ChangeSprite(v,s,ex03)
        CASE 3; ChangeSprite(v,s,ex04)
        CASE 4; ChangeSprite(v,s,ex05)
        CASE 5; ChangeSprite(v,s,ex06)
        CASE 6; ChangeSprite(v,s,ex07)
        CASE 7; ChangeSprite(v,s,ex08)
        CASE 8; ChangeSprite(v,s,ex09)
        CASE 9; ChangeSprite(v,s,ex10)
        CASE 10; ChangeSprite(v,s,ex11)
        CASE 11; ChangeSprite(v,s,ex12)
    ENDSELECT
    Delay(1)
    WaitTOF()
    ENDFOR
ENDPROC
-><
->> paletteExplosion()
PROC paletteExplosion()
    DEF intui:PTR TO intuitionbase
    DEF w:PTR TO window
    DEF s:PTR TO screen
    intui:=intuitionbase
    w:=intui.activewindow
    s:=w.wscreen
    SetRGB4( s.viewport, 21, $e,$0,$0 ) /* Black */
    SetRGB4( s.viewport, 22, $e,$8, $8 ) /* DGreen */
    SetRGB4( s.viewport, 23, $e,$e, $e ) /* Green */
ENDPROC
-><
->> remImageSP()
PROC remImageSP()
    IF ept THEN FreeVec(ept)
    IF ch_img0 THEN FreeVec(ch_img0)
    IF ch_img1 THEN FreeVec(ch_img1)
    IF ch_img2 THEN FreeVec(ch_img2)
    IF ch_img3 THEN FreeVec(ch_img3)
    IF ch_img4 THEN FreeVec(ch_img4)
    IF ch_img5 THEN FreeVec(ch_img5)
ENDPROC
-><
->> remExplosion()
PROC remExplosion()
    IF ex01 THEN FreeVec(ex01)
    IF ex02 THEN FreeVec(ex02)
    IF ex03 THEN FreeVec(ex03)
    IF ex04 THEN FreeVec(ex04)
    IF ex05 THEN FreeVec(ex05)
    IF ex06 THEN FreeVec(ex06)
    IF ex07 THEN FreeVec(ex07)
    IF ex08 THEN FreeVec(ex08)
    IF ex09 THEN FreeVec(ex09)
    IF ex10 THEN FreeVec(ex10)
    IF ex11 THEN FreeVec(ex11)
    IF ex12 THEN FreeVec(ex12)
ENDPROC
-><
->> initImageSP()
PROC initImageSP()
    DEF ret=TRUE
    DEF sp_img0
    DEF sp_img1
    DEF sp_img2
    DEF sp_img3
    DEF sp_img4
    DEF sp_img5
    DEF s_ept
    sp_img0:=[$0000, $0000, $FFF8, $0000, $0200, $0000, $877C, $0000,
          $8786, $027C, $BFBF, $02C6, $EDFF, $1AC2, $A57D, $1AFE,
          $BF19, $02FE, $8F12, $00FC, $04FC, $0000, $0809, $0000,
          $3FFE, $0000, $0000, $0000]:INT


    sp_img1:=[$0000, $0000, $7FF0, $0000, $0200, $0000, $077C, $0000,
          $8786, $027C, $BFBF, $02C6, $EDFF, $1AC2, $A57D, $1AFE,
          $BF19, $02FE, $0F12, $00FC, $04FC, $0000, $0809, $0000,
          $3FFE, $0000, $0000, $0000]:INT

    sp_img2:=[$0000, $0000, $3FE0, $0000, $0200, $0000, $877C, $0000,
          $8786, $027C, $BFBF, $02C6, $EDFF, $1AC2, $A57D, $1AFE,
          $BF19, $02FE, $8F12, $00FC, $04FC, $0000, $0809, $0000,
          $3FFE, $0000, $0000, $0000]:INT

    sp_img3:=[$0000, $0000, $1FC0, $0000, $0200, $0000, $077C, $0000,
          $8786, $027C, $BFBF, $02C6, $EDFF, $1AC2, $A57D, $1AFE,
          $BF19, $02FE, $0F12, $00FC, $04FC, $0000, $0809, $0000,
          $3FFE, $0000, $0000, $0000]:INT

    sp_img4:=[  $0000, $0000, $3FE0, $0000, $0200, $0000, $877C, $0000,
        $8786, $027C, $BFBF, $02C6, $EDFF, $1AC2, $A57D, $1AFE,
        $BF19, $02FE, $8F12, $00FC, $04FC, $0000, $0809, $0000,
        $3FFE, $0000, $0000, $0000]:INT

    sp_img5:=[  $0000, $0000, $7FF0, $0000, $0200, $0000, $077C, $0000,
        $8786, $027C, $BFBF, $02C6, $EDFF, $1AC2, $A57D, $1AFE,
        $BF19, $02FE, $0F12, $00FC, $04FC, $0000, $0809, $0000,
        $3FFE, $0000, $0000, $0000]:INT

    s_ept:=[ $0000,$0000,  /* ctrl data */
          $d556,$d556,
          $8102,$8102,
          $380 ,$380 ,
          $8442,$8442,
          $820 ,$820 ,
          $f83e,$f83e,
          $820 ,$820 ,
          $8442,$8442,
          $380 ,$380 ,
          $8102,$8102,
          $d556,$d556,
          $FFFF,$FFFF]:INT

    IF ept:=AllocVec(52,MEMF_CHIP)
    CopyMemQuick(s_ept,ept,52)
    ELSE
    ret:=FALSE
    ENDIF

    IF ch_img0:=AllocVec(56,MEMF_CHIP)
    CopyMemQuick(sp_img0,ch_img0,56)
    ELSE
    ret:=FALSE
    ENDIF

    IF ch_img1:=AllocVec(56,MEMF_CHIP)
    CopyMemQuick(sp_img1,ch_img1,56)
    ELSE
    ret:=FALSE
    ENDIF

    IF ch_img2:=AllocVec(56,MEMF_CHIP)
    CopyMemQuick(sp_img2,ch_img2,56)
    ELSE
    ret:=FALSE
    ENDIF
    IF ch_img3:=AllocVec(56,MEMF_CHIP)
    CopyMemQuick(sp_img3,ch_img3,56)
    ELSE
    ret:=FALSE
    ENDIF
    IF ch_img4:=AllocVec(56,MEMF_CHIP)
    CopyMemQuick(sp_img4,ch_img4,56)
    ELSE
    ret:=FALSE
    ENDIF
    IF ch_img5:=AllocVec(56,MEMF_CHIP)
    CopyMemQuick(sp_img5,ch_img5,56)
    ELSE
    ret:=FALSE
    ENDIF
ENDPROC ret
-><
->> initExplosion()
PROC initExplosion()
    DEF sex01,sex02,sex03,sex04,sex05,sex06
    DEF sex07,sex08,sex09,sex10,sex11,sex12
    DEF ret=TRUE
    sex01:=[   $0000,$0000,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $300 ,$0   ,
          $800 ,$7c0 ,
          $20  ,$fc0 ,
          $820 ,$7c0 ,
          $840 ,$780 ,
          $740 ,$80  ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex02:=[   $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $380 ,$0   ,
          $820 ,$7c0 ,
          $1010,$fe0 ,
          $1810,$7e0 ,
          $10  ,$1fe0,
          $1000,$ff0 ,
          $1800,$7f0 ,
          $810 ,$7e0 ,
          $4c0 ,$300 ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex03:=[ $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $6000,$0   ,
          $36b0,$140 ,
          $2008,$1ff0,
          $1008,$ff0 ,
          $4   ,$1ff8,
          $c   ,$1ff0,
          $c   ,$1ff0,
          $8   ,$1ff0,
          $1008,$ff0 ,
          $8   ,$1ff0,
          $3688,$170 ,
          $10  ,$8   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex04:=[ $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $8   ,$0   ,
          $8020,$10  ,
          $20c0,$4020,
          $5e20,$21c0,
          $2020,$1fc0,
          $4   ,$1ff8,
          $1030,$fc0 ,
          $10  ,$1fe0,
          $1020,$fc0 ,
          $20  ,$1fc0,
          $2410,$1be0,
          $73d0,$20  ,
          $20  ,$10  ,
          $8   ,$0   ,
          $FFFF,$FFFF]:INT

    sex05:=[$0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $4010,$0   ,
          $3030,$0   ,
          $8a0 ,$1340,
          $1020,$fc0 ,
          $808 ,$7f0 ,
          $1000,$ff0 ,
          $0   ,$1ff0,
          $0   ,$ff0 ,
          $800 ,$7c0 ,
          $a00 ,$1160,
          $20  ,$10  ,
          $8   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex06:=[ $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $10  ,$0   ,
          $2220,$0   ,
          $3040,$600 ,
          $800 ,$1780,
          $3018,$fe0 ,
          $2000,$1ff0,
          $10  ,$3fe0,
          $1000,$2ff0,
          $810 ,$17e0,
          $1940,$680 ,
          $460 ,$200 ,
          $0   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex07:=[ $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $100 ,$620 ,
          $180 ,$640 ,
          $1c00,$3c0 ,
          $10  ,$3fe0,
          $1000,$ff8 ,
          $0   ,$3ff0,
          $3000,$ff0 ,
          $850 ,$7a0 ,
          $a0  ,$740 ,
          $480 ,$300 ,
          $0   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex08:=[ $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $200 ,$100 ,
          $200 ,$1c0 ,
          $420 ,$3c0 ,
          $1010,$fe8 ,
          $838 ,$6c0 ,
          $8   ,$1ff0,
          $830 ,$7c0 ,
          $260 ,$180 ,
          $200 ,$180 ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex09:=[ $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $200 ,$100 ,
          $180 ,$0   ,
          $540 ,$280 ,
          $610 ,$860 ,
          $60  ,$c00 ,
          $1010,$e60 ,
          $80  ,$740 ,
          $40  ,$100 ,
          $300 ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex10:=[ $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $2000,$0   ,
          $100 ,$200 ,
          $200 ,$480 ,
          $ca0 ,$40  ,
          $840 ,$0   ,
          $1020,$840 ,
          $200 ,$480 ,
          $300 ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex11:=[ $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $200 ,$0   ,
          $0   ,$480 ,
          $840 ,$0   ,
          $840 ,$0   ,
          $40  ,$0   ,
          $400 ,$0   ,
          $200 ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    sex12:=[ $0000,$0000,  /* ctrl data */
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $800 ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $80  ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $0   ,$0   ,
          $FFFF,$FFFF]:INT

    IF ex01:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex01,ex01,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex02:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex02,ex02,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex03:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex03,ex03,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex04:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex04,ex04,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex05:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex05,ex05,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex06:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex06,ex06,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex07:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex07,ex07,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex08:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex08,ex08,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex09:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex09,ex09,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex10:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex10,ex10,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex11:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex11,ex11,68)
    ELSE
    ret:=FALSE
    ENDIF
    IF ex12:=AllocVec(68,MEMF_CHIP)
    CopyMemQuick(sex12,ex12,68)
    ELSE
    ret:=FALSE
    ENDIF

ENDPROC ret
-><
