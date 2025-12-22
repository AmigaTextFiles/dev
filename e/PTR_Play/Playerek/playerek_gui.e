
OPT OSVERSION=37

MODULE 'intuition/intuition',
       'gadtools',
       'libraries/gadtools',
       'intuition/gadgetclass',
       'intuition/screens',
       'graphics/text',
       'exec/lists',
       'exec/nodes',
       'exec/ports',
       'utility/tagitem',
       'ptreplay',
       'dos/dos',
       'exec/memory',
       'reqtools',
       'libraries/reqtools'

/*endfold*/

->ENUM
ENUM GPLAY,GPAUSE,GEJECT,GNEXT,GPREV,GTYTUL,GAUTOR
ENUM NONE,NOCONTEXT,NOGADGET,NOSCR,NOVISUAL,OPENGT,NOWINDOW,OPENPT,OPENREQ
ENUM ERR_MEM

/*endfold*/

->DEF do GUI
DEF screen:PTR TO screen,
    mainwnd:PTR TO window,
    tattr:PTR TO textattr,
    visual=NIL,
    offx,
    offy,
    checkquit=FALSE,
    mainglist=NIL

DEF gty:PTR TO gadget,
    gat:PTR TO gadget,
    gpl:PTR TO gadget,
    gpa:PTR TO gadget,
    gne:PTR TO gadget,
    gpr:PTR TO gadget,
    gej:PTR TO gadget,
    class,code,iadd:PTR TO gadget

/*endfold*/
->DEF do programu
DEF tytul[20]:STRING,  -> nazwa moduîu
    name[108]:STRING,  -> nazwa pliku
    autor[25]:STRING,  -> autor moduîu
    ptreplaybase,
    module,            -> uchwyt do modulu (RAM)
    mod,               -> poczatek modulu w RAM-ie
    len,               -> dlugosc modulu
    pauza              -> pauza on/off

DEF req:PTR TO rtfilerequester

/*endfold*/

->PROC-edury do GUI

PROC setup() HANDLE
  IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(OPENGT)
  IF (ptreplaybase:=OpenLibrary('ptreplay.library',5))=NIL THEN Raise(OPENPT)
  IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise(OPENREQ)
  IF (screen:=LockPubScreen('Workbench'))=NIL THEN Raise(NOSCR)
  IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(NOVISUAL)
  offy:=screen.wbortop+Int(screen.rastport+58)-10
  tattr:=['topaz.font',8,0,0]:textattr
EXCEPT DO
  RETURN exception
ENDPROC

PROC closeall()
  IF visual THEN FreeVisualInfo(visual)
  IF screen THEN UnlockPubScreen(NIL,screen)
  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
  IF ptreplaybase THEN CloseLibrary(ptreplaybase)
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
  IF req THEN RtFreeRequest(req)
ENDPROC

PROC openmainwindow() HANDLE

  IF (mainglist:=CreateContext({mainglist}))=NIL THEN Raise(NOCONTEXT)

  IF (gty:=CreateGadgetA(TEXT_KIND,mainglist,
      [offx+73,offy+14,234,13,'Tytuî :',tattr,GTYTUL,0,visual,0]:newgadget,
      [GTTX_TEXT,tytul,
       GTTX_BORDER,TRUE,
       TAG_DONE]))=NIL THEN Raise(NOGADGET)

  IF (gat:=CreateGadgetA(TEXT_KIND,gty,
      [offx+73,offy+27,234,13,'Autor :',tattr,GAUTOR,1,visual,0]:newgadget,
      [GTTX_TEXT,autor,
       GTTX_BORDER,1,
       TAG_DONE]))=NIL THEN Raise(NOGADGET)

  IF (gpl:=CreateGadgetA(BUTTON_KIND,gat,
      [offx+313,offy+14,45,13,'Play',tattr,GPLAY,16,visual,0]:newgadget,
      [TAG_DONE]))=NIL THEN Raise(NOGADGET)

  IF (gpr:=CreateGadgetA(BUTTON_KIND,gpl,
      [offx+313,offy+27,23,13,'<',tattr,GPREV,16,visual,0]:newgadget,
      [TAG_DONE]))=NIL THEN Raise(NOGADGET)

  IF (gpa:=CreateGadgetA(BUTTON_KIND,gpr,
      [offx+358,offy+14,47,13,'Pause',tattr,GPAUSE,16,visual,0]:newgadget,
      [TAG_DONE]))=NIL THEN Raise(NOGADGET)

  IF (gej:=CreateGadgetA(BUTTON_KIND,gpa,
      [offx+358,offy+27,47,13,'Eject',tattr,GEJECT,16,visual,0]:newgadget,
      [TAG_DONE]))=NIL THEN Raise(NOGADGET)

  IF (gne:=CreateGadgetA(BUTTON_KIND,gej,
      [offx+335,offy+27,23,13,'>',tattr,GNEXT,16,visual,0]:newgadget,
      [TAG_DONE]))=NIL THEN Raise(NOGADGET)

  IF (mainwnd:=OpenWindowTagList(NIL,
      [WA_LEFT,77,
       WA_TOP,39,
       WA_WIDTH,416,
       WA_HEIGHT,48,
       WA_FLAGS,(WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR WFLG_DRAGBAR OR
                 WFLG_SMART_REFRESH OR WFLG_RMBTRAP OR WFLG_ACTIVATE),
       WA_IDCMP,(IDCMP_REFRESHWINDOW OR IDCMP_CLOSEWINDOW OR IDCMP_GADGETUP),
       WA_GADGETS,mainglist,
       WA_TITLE,'Playerek',
       TAG_DONE]))=NIL THEN Raise(NOWINDOW)

EXCEPT DO
  RETURN exception
ENDPROC

PROC closemainwindow()
  IF mainwnd THEN CloseWindow(mainwnd)
  IF mainglist THEN FreeGadgets(mainglist)
ENDPROC

PROC wait4message(win:PTR TO window)

  DEF mes:PTR TO intuimessage

  REPEAT
    class:=0
    IF mes:=Gt_GetIMsg(win.userport)
      class:=mes.class
      code:=mes.code
      iadd:=mes.iaddress
      Gt_ReplyIMsg(mes)
    ELSE
       WaitPort(win.userport)
    ENDIF
  UNTIL class
ENDPROC

/*endfold*/

-> Gîówna PROC-edura

PROC w4m_main_wnd()
  DEF id
  REPEAT
    wait4message(mainwnd)
    SELECT class
      CASE IDCMP_REFRESHWINDOW
        Gt_BeginRefresh(mainwnd)
        Gt_EndRefresh(mainwnd,TRUE)
      CASE IDCMP_GADGETUP
        id:=iadd.gadgetid
        SELECT id
          CASE GPLAY
            IF module
              PtStop(module)
              play()
            ELSE
              loadreq()
            ENDIF

          CASE GPAUSE
            IF pauza
              PtResume(module)
              pauza := FALSE
            ELSE
              PtPause(module)
              pauza := TRUE
            ENDIF

          CASE GEJECT
            IF module
              eject()
            ENDIF
          CASE GNEXT
            PtSetPos(module,PtSongPos(module)+1)
          CASE GPREV
            PtSetPos(module,PtSongPos(module)-1)
        ENDSELECT
      CASE IDCMP_CLOSEWINDOW
        eject()
        checkquit:=TRUE
    ENDSELECT
  UNTIL checkquit=TRUE
ENDPROC

PROC main() HANDLE

  DEF err
  DEF erlist:PTR TO LONG

  VOID '$VER: E-Player ver.1.006ß (27.11.96) by Leo'

  IF (err:=setup())<>NONE THEN Raise(err)
  IF (err:=openmainwindow())<>NONE THEN Raise(err)
  Gt_SetGadgetAttrsA(gpa,mainwnd,NIL,[GA_DISABLED,TRUE,NIL])
  Gt_SetGadgetAttrsA(gej,mainwnd,NIL,[GA_DISABLED,TRUE,NIL])
  Gt_SetGadgetAttrsA(gne,mainwnd,NIL,[GA_DISABLED,TRUE,NIL])
  Gt_SetGadgetAttrsA(gpr,mainwnd,NIL,[GA_DISABLED,TRUE,NIL])
  req:=RtAllocRequestA(RT_FILEREQ,NIL)
  name:=arg
  len := StrLen(name)
  IF len=0
    loadreq()
  ELSE
    load()
  ENDIF
  w4m_main_wnd()

EXCEPT DO
  closemainwindow()
  closeall()

  IF exception
    erlist:=['get context','create gadget','lock screen','get visual infos',
             'open "gadtools.library" v37+','open window',
             'open "PTReplay.library" v5+','open "ReqTools.library" v38+']
    EasyRequestArgs(0,[20,0,0,'Could not \s!','ok'],0,[erlist[exception-1]])
  ENDIF
  CleanUp(0)

ENDPROC

->PROC-edury do PTReplay

PROC play()

  PtPlay(module)
  PtPause(module)
  PtResume(module)

ENDPROC

PROC eject()

  IF module
    PtStop(module)
    PtFreeMod(module)
    FreeMem(mod,len)
    mod := NIL
    len := NIL
    module := NIL
    StrCopy(tytul,'  Brak moduîu w pamiëci')
    autor[0] := 0
    Gt_SetGadgetAttrsA(gpa,mainwnd,NIL,[GA_DISABLED,TRUE,NIL])
    Gt_SetGadgetAttrsA(gej,mainwnd,NIL,[GA_DISABLED,TRUE,NIL])
    Gt_SetGadgetAttrsA(gne,mainwnd,NIL,[GA_DISABLED,TRUE,NIL])
    Gt_SetGadgetAttrsA(gpr,mainwnd,NIL,[GA_DISABLED,TRUE,NIL])
    title(1)
  ENDIF

ENDPROC

PROC loadreq()

DEF temp[120]:STRING,
    test[2]:STRING,
    fname[120]:STRING,
    dir

  test[0] := 0
  fname[0] := 0
  temp[0] := 0
  IF mod THEN FreeMem(mod,len)
  IF RtFileRequestA(req,fname,'Wybierz moduî',0)
    MOVE.L req,A0
    MOVE.L 16(A0),dir
    StrCopy(temp,dir,ALL)
    RightStr(test,temp,1)
    IF StrCmp(test,'/',1)=FALSE AND StrCmp(test,':',1)=FALSE AND StrLen(dir)>0
      StrAdd(temp,'/',1)
    ENDIF
    StrAdd(temp,fname,ALL)
    name := temp
  ENDIF
  StrCopy(tytul,'Zaczekaj ladujë moduî: ')
  autor := fname
  title(1)
  SetStr(autor,0)
  load()
ENDPROC

PROC load()

DEF file,
    tmp,
    mk[4]:STRING

  file := Open(name,OLDFILE)
  IF file > NIL
    Seek(file,NIL,OFFSET_END)
    len := Seek(file,NIL,OFFSET_BEGINNING)
    mod := AllocMem(len,MEMF_CHIP OR MEMF_CLEAR)
    IF mod >NIL
      Read(file,mod,len)
      mk := (mod + 1080)
      tmp := InStr(mk,'M.K.')
      IF (InStr(mk,'M.K.') = 0) OR (InStr(mk,'M!K!') = 0)
        module := PtSetupMod(mod)
        StrCopy(tytul,mod,22)
        play()
        title(1)
        checkautor()
        title(2)
        Gt_SetGadgetAttrsA(gpa,mainwnd,NIL,[GA_DISABLED,FALSE,NIL])
        Gt_SetGadgetAttrsA(gej,mainwnd,NIL,[GA_DISABLED,FALSE,NIL])
        Gt_SetGadgetAttrsA(gne,mainwnd,NIL,[GA_DISABLED,FALSE,NIL])
        Gt_SetGadgetAttrsA(gpr,mainwnd,NIL,[GA_DISABLED,FALSE,NIL])
      ELSE
        StrCopy(tytul,'To nie jest modul')
        IF mod THEN FreeMem(mod,len)
        module := NIL
        mod := NIL
      ENDIF
    ELSE
      StrCopy(tytul,'Zabrakîo pamiëci')
      module := NIL
      mod := NIL
    ENDIF
  ELSEIF file = NIL
    StrCopy(tytul,'Nie mogë odczytaê pliku')
    module := NIL
    mod := NIL
  ENDIF -> IF Open
  title(1)
  IF file THEN Close(file)

ENDPROC

PROC title(n)

  DEF temp[22]:STRING,
      len

  StrCopy(temp,autor)
  IF n = 2
    len := StrLen(autor)
->    SetStr(autor,20)
    StrAdd(temp,'                                ',)
  ENDIF

  Gt_SetGadgetAttrsA(gty,mainwnd,NIL,[GTTX_TEXT,tytul,NIL])
  Gt_SetGadgetAttrsA(gat,mainwnd,NIL,[GTTX_TEXT,temp,NIL])

ENDPROC

PROC checkautor()

DEF temp,
    xtd[22]:STRING,
    str

  Gt_SetGadgetAttrsA(gat,mainwnd,NIL,[GTTX_TEXT,autor,NIL])

  str := (mod + 20)
  temp := InStr(str,'xtd')
  IF temp > -1
    autor := mod + 20 + temp
    RETURN
  ENDIF
  str := (mod + 50)
  temp := InStr(str,'xtd')
  IF temp > -1
    autor := (mod + 50 + temp)
    str := (mod + 20)
    temp := InStr(tytul,'##',4)
    SetStr(tytul,temp)
    temp := InStr(str,'##')
    IF temp > -1
      MidStr(xtd,str,temp+2,StrLen(str)-temp+2)
      StrAdd(tytul,xtd,StrLen(xtd))
    ELSE
      StrAdd(tytul,str,StrLen(str))
    ENDIF
    RETURN
  ENDIF
  str := (mod + 20)
  temp := InStr(str,'#')
  IF temp > -1
    autor := (str + temp)
    RETURN
  ENDIF
  temp := InStr(str,'by')
  IF temp > -1
    autor := mod + 23 + temp
    RETURN
  ENDIF
  str := (mod + 20)
  IF (InStr(str,'maxsoft') > -1) OR (InStr(str,'gilo') > -1)
    autor := mod + 20
    RETURN
  ENDIF
  str := (mod + 50)
  IF (InStr(str,'timer') > -1) OR (InStr(str,'jester') > -1)
    autor := mod + 50
    RETURN
  ENDIF

ENDPROC
/*EE folds
0
4 16 6 5 8 19 9 13 12 10 14 7 16 50 18 3 27 15 20 48 22 35 26 6 31 18 33 27 35 44 37 5 39 55 28 16 
EE folds*/
