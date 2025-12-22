/*  MANITOU Boot Menu
    Benötigt WB 2.0
    BootMenu <option>

    options: links  (linke Maustaste)
             rechts (rechte)
             beide  (beide)
             keine  (keine)

    Die Datei S:bootmenu.data enthält die Namen der Menüs. Auf jeden Namen muß ein
    <CR> folgen. Es sind maximal 10 Menüs erlaubt.
    Nach dem Start wird ein Screen geöffnet, und es werden so viele Gadgets
    gezeichnet, wie Namen in S:bootmenu.data vorkommen. Nachdem ein Gadget angewählt
    wurde, wird die dazugehörige startup.x ausgeführt, wobei x der Nummer der Gadgets
    entspricht. Returncode 5 wird ans CLI gesendet.
    Wenn <option> <l>, <r> oder <b> ist und die entsprechenden Tasten nicht gedrückt
    sind, wird keine startup.x ausgeführt und Returncode 0 gesendet.
    Wird <option> k angegeben, wird der Screen immer geöffnet.
    Die Gadgets lönnen auch mit den Tasten 1-9 und 0(=10) ktiviert werden.

Beispiel für bootmenu.data:

Standard<CR>                (1. Zeile)
No AGA<CR>                  (2. Zeile)
WB 1.3 Emulator<CR>         (3. Zeile)

Installation:

1.) bootmenu.data erstellen
2.) startup-sequence kopieren -> startup.1, startup.2, startup.3, sooft es nötig ist
    und mit <s> protecten. (Wenn bootmenu.data 3 Zeilen hat, sind startup.1 und
    startup.2 nötig)
3.) startup-sequence ändern:
    1 BootMenu >NIL: LINKS
    2 If NOT WARN
    3 ...
    4 ... original startup-sequence
    5 ...
    n EndIf
      (möglicherweise EndCLI, etc.)
4.) Kopien der startup-sequence entsprechend den eigenen Wünschen ändern
5.) Fertig
6.) Ausprobieren
7.) Freuen

*/

MODULE 'intuition/screens','intuition/intuition'
MODULE 'libraries/gadtools','gadtools'
MODULE 'graphics/text'
MODULE 'utility/tagitem'
MODULE 'exec/memory'

DEF anz,fh,str,strlist,rdargs,num,
    myarg: PTR TO LONG,
    fstr[80]:STRING

PROC color(col)     /* Fehler auch mit Farbe ausgeben (>NIL in startup-sequence) */
  DEF i
  FOR i:=1 TO 5000
      MOVE.W  col,$DFF180
      MOVE.B  $DFF006,D0
loop: MOVE.B  $DFF006,D1
      CMP.B   D0,D1
      BEQ     loop
  ENDFOR
ENDPROC

PROC readme()  /* Menü einlesen */
  DEF bo
  anz:=0
  str:=fstr
  IF (fh:=Open('S:bootmenu.data',OLDFILE))

    bo:=ReadStr(fh,str)
    WHILE bo<>-1
      INC anz
      str:=Next(str)
      IF anz<10
        bo:=ReadStr(fh,str)
      ELSE
        bo:=-1
      ENDIF
    ENDWHILE

    IF anz>0 THEN bo:=TRUE ELSE bo:=FALSE     /* mindestens eine Zeile */
    Close(fh)
  ELSE
    WriteF('Konnte "S:bootmenu.data" nicht öffnen!\n')
    color($f00) /* Fehler */
    bo:=FALSE
  ENDIF
ENDPROC bo

PROC gt_wait(up)    /* auf Gadget oder Taste warten und Zahl zurückgeben */
  DEF mes: intuimessage,id,addr: PTR TO gadget, cl, code
  mes:=Gt_GetIMsg(up)
  WHILE mes=NIL
    mes:=WaitPort(up)
    mes:=Gt_GetIMsg(up)
  ENDWHILE
  cl:=mes.class
  code:=mes.code
  IF cl=IDCMP_GADGETUP
    addr:=mes.iaddress
    id:=addr.gadgetid
  ELSE          /* IDCMP_VANILLAKEY */
    IF (code>="0") AND (code<="9")    /* 0=9, ... */
      id:=code-"1"
      IF id<0 THEN id:=9
    ENDIF
  ENDIF
  Gt_ReplyIMsg(mes)
ENDPROC id

PROC getnumfrommenu()
  DEF i,y,bo,ta,vi,g,glist,scr,win: PTR TO window, msgport, rp, chip, img
  bo:=TRUE
  ta:=['topaz.font',8,0,0]:textattr

  IF (chip:=AllocVec(80*100*2,MEMF_CHIP))   /* Logo ins Chip kopieren */
    CopyMem({logo},chip,80*100*2)
    IF (scr:=OpenScreenTagList(NIL,
      [SA_LEFT,0,SA_TOP,0,SA_WIDTH,640,SA_HEIGHT,255,SA_DEPTH,2,SA_TYPE,$f,
      SA_FONT,ta,SA_DISPLAYID,$8000,SA_PENS,[-1],TAG_DONE]))
      IF (vi:=GetVisualInfoA(scr,NIL))
        IF (g:=CreateContext({glist}))
          str:=fstr
          FOR i:=0 TO anz-1
            IF bo=TRUE
              y:=103+(i*15)
              IF (g:=CreateGadgetA(BUTTON_KIND,g,[6,y,628,14,str,ta,
                i,0,vi,NIL]:newgadget,NIL))=NIL THEN bo:=FALSE
              str:=Next(str)
            ENDIF
          ENDFOR
          IF (win:=OpenW(0,0,640,255,IDCMP_GADGETUP OR IDCMP_VANILLAKEY,$11c00,NIL,scr,$f,glist))
            msgport:=win.userport
            rp:=win.rport

            img:=[0,0,640,100,2,chip,%11,%00,NIL]:image
            DrawImage(rp,img,0,0)

            DrawBevelBoxA(rp,0,100,640,155,[GT_VISUALINFO,vi,TAG_DONE])
            DrawBevelBoxA(rp,2,101,636,153,[GT_VISUALINFO,vi,GTBB_RECESSED,TRUE,TAG_DONE])
            REPEAT
              num:=gt_wait(msgport)     /* Zahl holen */
            UNTIL (num>=0) AND (num<=(anz-1))
            CloseW(win)
          ELSE
            bo:=FALSE
          ENDIF
          FreeGadgets(glist)
        ELSE
          bo:=FALSE
        ENDIF
      ELSE
        bo:=FALSE
      ENDIF
      CloseScreen(scr)
    ELSE
      bo:=FALSE
    ENDIF
    FreeVec(chip)
  ELSE
    bo:=FALSE
  ENDIF
  IF bo=FALSE THEN WriteF('Konnte Menü nicht öffnen\n')
ENDPROC

PROC getfilenum()
  DEF button
  str:=myarg[0]
  UpperStr(str)
  button:=-1
  IF InStr(str,'LINKS',0)<>-1 THEN button:=1
  IF InStr(str,'RECHTS',0)<>-1 THEN button:=2
  IF InStr(str,'BEIDE',0)<>-1 THEN button:=3
  IF InStr(str,'KEINE',0)<>-1 THEN button:=0
  IF button<>-1
    IF (button=Mouse()) OR (button=0)
      getnumfrommenu()    /* Menü entsprechend den Tasten aufrufen */
    ELSE
      num:=0
    ENDIF
  ELSE
    WriteF('Bad Args!\n')
  ENDIF
ENDPROC

PROC main()
  DEF i,bo,bname[80]:STRING,rc
  WriteF('BootMenu V1.4 Copyright © 1994 by PRO/MANITOU\n')
  rc:=0
  myarg:=[0]
  IF rdargs:=ReadArgs('TASTE/A',myarg,NIL)
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',36))
      bo:=TRUE
      strlist:=fstr
      FOR i:=1 TO 10    /* Strings holen (dynamisch) */
        IF (str:=String(80))=NIL THEN bo:=FALSE
        IF bo=TRUE
          Link(strlist,str)
          IF Next(strlist)<>NIL THEN strlist:=Next(strlist)
        ENDIF
      ENDFOR
      IF bo=TRUE
        IF readme()=TRUE
          getfilenum()
          IF num>0       /* wenn x größer als 0, startup.x ausführen und RC=5 */
            RawDoFmt('s:startup.%ld',{num},{putchproc},bname)
            Execute(bname,NIL,stdout)
            rc:=5
          ELSE
            rc:=0
          ENDIF
        ENDIF
      ELSE
        WriteF('Nicht genug Speicher (!)\n')
        color($f00)
      ENDIF
      CloseLibrary(gadtoolsbase)
    ELSE
      WriteF('Benötige gadtools.library V36+\n')
      color($f00)
    ENDIF
    FreeArgs(rdargs)
  ELSE
    WriteF('Schlechtes Zeilenformat\n')
    color($f00)
  ENDIF
ENDPROC rc

putchproc:
  MOVE.B  D0,(A3)+
  MOVE.B  #0,(A3)
  RTS

logo: INCBIN 'E:Sources/Boot.logo'
