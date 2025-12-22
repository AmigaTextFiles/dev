
-> MyLittlePaint - Ett E-exempel.
->
-> / Leif S

MODULE 'intuition/intuition', 'intuition/screens', 'graphics/text'

PROC main()
     DEF wnd:PTR TO window,idcmp,wflags,msg:PTR TO intuimessage,
          exit,class,lmb,rmb,cmsg:PTR TO intuimessage

     lmb:=FALSE
     rmb:=FALSE

     /*             Flaggor och IDCMP för fönstret.             */
     idcmp:=IDCMP_CLOSEWINDOW OR IDCMP_MOUSEMOVE OR IDCMP_VANILLAKEY
     idcmp:=idcmp OR IDCMP_NEWSIZE OR IDCMP_MOUSEBUTTONS
     wflags:=WFLG_CLOSEGADGET OR WFLG_DRAGBAR
     wflags:=wflags OR WFLG_SIZEGADGET OR WFLG_DEPTHGADGET OR WFLG_RMBTRAP
     wflags:=wflags OR WFLG_SMART_REFRESH OR WFLG_REPORTMOUSE

     wnd:=OpenW(20,50,400,300,idcmp, wflags, 'Mygraphics window',NIL,1,NIL)
     IF wnd
          exit:=FALSE
          REPEAT  -> snurra tills någon trycker på stängknappen...
               WaitPort(wnd.userport) ->vänta på meddelande från intuition.
               WHILE (msg:=GetMsg(wnd.userport)) ->hämta meddelande.
                    cmsg.class:=msg.class ->ta ut IDCMP.
                    cmsg.code:=msg.code ->ta ut kod.
                    cmsg.mousex:=msg.mousex ->ta ut x.
                    cmsg.mousey:=msg.mousey -> ta ut y.
                    ReplyMsg(msg) ->svara på meddelandet.
                    class:=cmsg.class
                    SELECT class
                    CASE IDCMP_MOUSEMOVE
                         title(wnd,cmsg)       -> uppdatera titelraden.
                         paint(cmsg,lmb,rmb)   -> rita.
                    CASE IDCMP_MOUSEBUTTONS
                         lmb,rmb:=handlebut(wnd,cmsg)
                    CASE IDCMP_VANILLAKEY
                         handlekeys(wnd,cmsg)
                    CASE IDCMP_NEWSIZE      -> ändring av storlek ?
                         RefreshWindowFrame(wnd)
                         title(wnd,cmsg)
                    CASE IDCMP_CLOSEWINDOW  -> stängknappen ?
                         exit:=TRUE
                    ->DEFAULT
                    ENDSELECT
               ENDWHILE
          UNTIL exit
          CloseW(wnd)
     ELSE
          WriteF('Va i helv... Kunde inte öppna fönstret!\n')
     ENDIF
CleanUp(NIL)
ENDPROC

PROC title(win:PTR TO window,mess:PTR TO intuimessage)
     DEF wtitle[80]:STRING
     StringF(wtitle,'  \lX : \d[6] \lY : \d[6]   \lSIZE : \d[3]x\d[3]',
                    mess.mousex-win.borderleft,
                    mess.mousey-win.bordertop,
                    win.width-win.borderleft-win.borderright,
                    win.height-win.bordertop-win.borderbottom)
     SetWindowTitles(win,NIL,wtitle)  -> fixa titeln.
ENDPROC

PROC paint(mess:PTR TO intuimessage,lmb,rmb)
          IF (lmb<>rmb)                         -> ska vi rita/sudda ?
               IF lmb                           -> rita om lmb
                  Box(mess.mousex,
                         mess.mousey,
                         mess.mousex+10,
                         mess.mousey+10,1)
               ELSE                             -> sudda annars.
                  Box(mess.mousex,
                         mess.mousey,
                         mess.mousex+10,
                         mess.mousey+10,0)
               ENDIF
          ENDIF
ENDPROC

PROC handlebut(wnd,msg:PTR TO intuimessage) -> denna rutin komer ihåg
DEF code, lm, rm                            -> musknapparnas status tills
     lm:=FALSE                              -> intuition säger nåt annat.
     rm:=FALSE                              -> tar även hand om lite annat
     code:=msg.code                         -> krafs...
     SELECT code
     CASE SELECTDOWN
          lm:=TRUE
          paint(msg,lm,rm)
     CASE SELECTUP
          lm:=FALSE
          RefreshWindowFrame(wnd)
          title(wnd,msg)
     CASE MENUDOWN
          rm:=TRUE
          paint(msg,lm,rm)
     CASE MENUUP
          rm:=FALSE
          RefreshWindowFrame(wnd)
          title(wnd,msg)
     DEFAULT
     ENDSELECT
ENDPROC lm, rm      -> lämna tebax musknapparnas status.

PROC floodwindow(window:PTR TO window,colour)   /* fyll föstret med nån */
                                                        /* färg... */
    SetAPen(window.rport,colour)
    RectFill(window.rport,  window.borderleft,
                            window.bordertop,
                            window.width-window.borderright-1,
                            window.height-window.borderbottom-1)

ENDPROC

PROC handlekeys(wnd,msg:PTR TO intuimessage)            /* hit kommer vi om */
     IF (msg.code > 47) AND (msg.code < 58)  /* 0-9 */  /* nån tangent */
          /* rensa fönstret med tangenterna 0-9 ! */    /* trycks ner */
          floodwindow(wnd,msg.code-48)
     ENDIF
ENDPROC







