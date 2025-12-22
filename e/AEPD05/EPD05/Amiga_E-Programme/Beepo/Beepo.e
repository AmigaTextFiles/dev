/*      Beepo, a little stupid game. Should give some of you a little help
when writing gadtools programs and such... Written by Mathias Dahl, 1993 (c)
*/

MODULE 'intuition/intuition', 'gadtools', 'libraries/gadtools',
        'intuition/gadgetclass', 'exec/nodes', 'intuition/screens',
        'graphics/displayinfo', 'graphics/text','dos/dos','exec/memory',
        'intuition/sghooks'

DEF scr=NIL:PTR TO screen,
    visual=NIL,
    main_win=NIL:PTR TO window,
    glist=NIL,
    g,
    type,infos,
    bye=NIL,
    rast,
    tonemem

ENUM SQ1,SQ2,SQ3,SQ4,QUIT,ABOUT,START,NAME

PROC openall()

        gadtoolsbase:=OpenLibrary('gadtools.library',37)
        scr:=LockPubScreen('Workbench')
        visual:=GetVisualInfoA(scr,NIL)
        g:=CreateContext({glist})

        g:=CreateGadgetA(BUTTON_KIND,g,[69,20,65,33  ,'1',['topaz.font',8,0,0]:textattr,SQ1,PLACETEXT_IN  ,visual,0]:newgadget,0)
        g:=CreateGadgetA(BUTTON_KIND,g,[156,20,65,33 ,'2',['topaz.font',8,0,0]:textattr,SQ2,PLACETEXT_IN  ,visual,0]:newgadget,0)
        g:=CreateGadgetA(BUTTON_KIND,g,[69,66,65,33  ,'3',['topaz.font',8,0,0]:textattr,SQ3,PLACETEXT_IN  ,visual,0]:newgadget,0)
        g:=CreateGadgetA(BUTTON_KIND,g,[156,66,65,33 ,'4',['topaz.font',8,0,0]:textattr,SQ4,PLACETEXT_IN  ,visual,0]:newgadget,0)

        g:=CreateGadgetA(BUTTON_KIND,g,[29,137,58,16 ,'Quit',['topaz.font',8,0,0]:textattr,QUIT,PLACETEXT_IN ,visual,0]:newgadget,0)
        g:=CreateGadgetA(BUTTON_KIND,g,[117,137,58,16,'Help',['topaz.font',8,0,0]:textattr,ABOUT,PLACETEXT_IN,visual,0]:newgadget,0)
        g:=CreateGadgetA(BUTTON_KIND,g,[200,137,58,16,'Start',['topaz.font',8,0,0]:textattr,START,PLACETEXT_IN,visual,0]:newgadget,0)

        g:=CreateGadgetA(STRING_KIND,g,[69,160,189,14,'Name',['topaz.font',8,0,0]:textattr,NAME,PLACETEXT_LEFT,visual,0]:newgadget,[GTST_STRING,'Brainz Software 1993',GTST_MAXCHARS,20,NIL])

        main_win:=OpenWindowTagList(0,[WA_GADGETS,glist,WA_LEFT,161,WA_TOP,35,
        WA_WIDTH,288,WA_HEIGHT,180,
        WA_FLAGS,WFLG_DRAGBAR+WFLG_DEPTHGADGET+WFLG_CLOSEGADGET+WFLG_ACTIVATE,
        WA_IDCMP,IDCMP_GADGETUP+IDCMP_VANILLAKEY+IDCMP_CLOSEWINDOW,
        WA_TITLE,'BeepO v0.99h',
        WA_SCREENTITLE,'BeepO, c Copyright 1993, Brainz Software',
        WA_ACTIVATE,TRUE,0])

        Gt_RefreshWindow(main_win,NIL)

        rast:=main_win.rport
        DrawBevelBoxA(rast,29,104,229,28,[GTBB_RECESSED,TRUE,GT_VISUALINFO,visual,0])
ENDPROC

PROC closeall()
        IF visual THEN FreeVisualInfo(visual)
        IF main_win THEN CloseWindow(main_win)
        IF glist THEN FreeGadgets(glist)
        IF scr THEN UnlockPubScreen(NIL,scr)
        IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC

PROC main()
        IF (tonemem:=AllocMem(16,MEMF_CHIP))=0
                CleanUp(5)
        ENDIF
        openall()
        SetStdRast(rast)
        SetAPen(rast,1)
        REPEAT
                wait4message(main_win)
                SELECT type
                        CASE IDCMP_GADGETUP
                                SELECT infos
                                        CASE QUIT
                                                quit()
                                        CASE START
                                                start()
                                        CASE ABOUT
                                                about()
                                ENDSELECT
                        CASE IDCMP_VANILLAKEY
                                SELECT infos
                                        CASE "h"
                                                about()
                                        CASE "q"
                                                quit()
                                        CASE "s"
                                                start()
                                ENDSELECT
                        CASE IDCMP_CLOSEWINDOW
                                quit()
                ENDSELECT
        UNTIL bye
        closeall()
        FreeMem(tonemem,16)
ENDPROC

PROC wait4message(win:PTR TO window)
        DEF mes:PTR TO intuimessage,g:PTR TO gadget
        REPEAT
                type:=0
                IF mes:=Gt_GetIMsg(win.userport)
                        type:=mes.class
                        IF type=IDCMP_MENUPICK
                                        infos:=mes.code
                                ELSEIF (type=IDCMP_GADGETUP)
                                        g:=mes.iaddress
                                        infos:=g.gadgetid
                                ELSEIF type=IDCMP_VANILLAKEY
                                        infos:=mes.code
                                ELSEIF type=IDCMP_REFRESHWINDOW
                                        Gt_BeginRefresh(win)
                                        Gt_EndRefresh(win,TRUE)
                                        type:=0
                                ELSEIF type<>IDCMP_CLOSEWINDOW
                                        type:=0
                        ENDIF
                        Gt_ReplyIMsg(mes)
                ELSE
                        Wait(-1)
                ENDIF
        UNTIL type
ENDPROC


PROC request(body,gadgets,args)
ENDPROC EasyRequestArgs(main_win,[20,0,0,body,gadgets],0,args)

PROC quit()
        IF (request('Wanna quit?','Yep|Nope',NIL)) THEN bye:=TRUE
ENDPROC

PROC about()
        request('Press \aStart\a to start game.\nLook at the number(s) that comes\nup in the box.\nTry to press the same number.\nIf you guess right, the computer adds\na number to the list and it\ngets harder to remember all of them.\nRepeat all of the above.\n\nHave fun!\n\nc Copyright 1993, Brainz Software\nThis game is freeware','I see',NIL)
ENDPROC

PROC start()
        DEF wrong=NIL,i,gissa[20]:ARRAY,nr,val,nummerknapp,
        seed,tonlist[4]:LIST,score,typeok

        MOVE.L $dff006,seed
        Rnd(seed*-1)

        tonlist:=[1046,1175,1318,1396]
        nummerknapp:=FALSE
        nr:=0
        score:=0
        SetAPen(rast,0)
        TextF(29+75,120,'Game Over.')
        SetAPen(rast,1)

        REPEAT

                gissa[nr]:=Rnd(4)+1

                FOR i:=0 TO nr
                        TextF(140-(8*3),126,'>> \d <<',gissa[i])
                        play(ListItem(tonlist,gissa[i]-1),15)

                        SetAPen(rast,0)
                        TextF(140-(8*3),126,'>> \d <<',gissa[i])
                        wait(15)
                        SetAPen(rast,1)
                ENDFOR

                FOR i:=0 TO nr

                        TextF(110,113,'Try # \d',nr+1)
                        nummerknapp:=FALSE

                        REPEAT
                                REPEAT
                                typeok:=FALSE
                                wait4message(main_win)
                                IF type=IDCMP_GADGETUP THEN typeok:=TRUE
                                IF type=IDCMP_VANILLAKEY THEN typeok:=TRUE
                                UNTIL typeok

                                SELECT type
                                        CASE IDCMP_GADGETUP
                                                SELECT infos
                                                        CASE SQ1
                                                                val:=1
                                                                nummerknapp:=TRUE
                                                                play(ListItem(tonlist,val-1),15)
                                                        CASE SQ2
                                                                val:=2
                                                                nummerknapp:=TRUE
                                                                play(ListItem(tonlist,val-1),15)
                                                        CASE SQ3
                                                                val:=3
                                                                nummerknapp:=TRUE
                                                                play(ListItem(tonlist,val-1),15)
                                                        CASE SQ4
                                                                val:=4
                                                                nummerknapp:=TRUE
                                                                play(ListItem(tonlist,val-1),15)
                                                ENDSELECT
                                        CASE IDCMP_VANILLAKEY
                                                SELECT infos
                                                        CASE "4"
                                                                val:=1
                                                                nummerknapp:=TRUE
                                                                play(ListItem(tonlist,val-1),15)
                                                        CASE "5"
                                                                val:=2
                                                                nummerknapp:=TRUE
                                                                play(ListItem(tonlist,val-1),15)
                                                        CASE "1"
                                                                val:=3
                                                                nummerknapp:=TRUE
                                                                play(ListItem(tonlist,val-1),15)
                                                        CASE "2"
                                                                val:=4
                                                                nummerknapp:=TRUE
                                                                play(ListItem(tonlist,val-1),15)
                                                ENDSELECT
                                ENDSELECT
                        UNTIL nummerknapp

                        IF gissa[i]<>val
                                wrong:=TRUE
                        ELSE
                                INC score
                        ENDIF

                ENDFOR

                INC nr

                IF wrong=FALSE
                        TextF(115,126,'Right!')
                        SetAPen(rast,0)
                        wait(25)
                        TextF(115,126,'Right!')
                        SetAPen(rast,1)
                        wait(50)
                ENDIF

        UNTIL wrong

        SetAPen(rast,0)
        TextF(110,113,'Try # \d',nr+1)

        SetAPen(rast,2)
        TextF(29+75,120,'Game Over.')

        SetAPen(rast,1)

        testscore(score)

ENDPROC

PROC wait(n)
  Delay(n)
ENDPROC

PROC play(f,d)

/* This procedure is probably very BAD... Writing to the hardware an so on...
I didn't know how to do it otherwise. Maybe someone else could help. */

        DEF period,sample[16]:LIST

        MOVE.W  #$00F,$DFF096           /* OFF WITH SOUND DMA */
        MOVE.L  tonemem,$DFF0B0         /* AUD1LOC */
        MOVE.W  #16,$DFF0b4                     /* AUD1LEN */
        period:=3579545/(16*f)
        MOVE.L  period,D0
        MOVE.W  D0,$dff0b6                      /* aud1per */
        MOVE.W  #64,$DFF0B8                     /* AUD1VOL */
        MOVE.W  #$8202,$DFF096          /* TURN ON DMA */

        wait(d)

        MOVE.W  #$0003,$DFF096          /* SHUT SOUND DMA OFF AGAIN*/
        MOVE.W  #$0011,$DFF09E          /* RESTORE ADKCON */

        sample:=[10,20,30,40,50,60,70,80,70,60,50,40,30,20,10,0] /* Sample */

        CopyMem({sample},tonemem,16)

ENDPROC

PROC testscore(score)
        DEF filescore
ENDPROC
