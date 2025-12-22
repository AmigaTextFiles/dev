ENUM NODISKFONT=0,NOSCREEN,NOWINDOW,NOSMALLFONT,NOBIGFONT

PROC initialise()
  IF (diskfontbase:=OpenLibrary('diskfont.library',37))=NIL THEN RETURN NODISKFONT
  IF (scr:=OpenScreenTagList(NIL,[SA_LEFT,0,SA_TOP,0,SA_WIDTH,640,SA_HEIGHT,512,SA_DEPTH,6,
      SA_DISPLAYID,$8004,SA_TITLE,'ShowAmiga',NIL]))=NIL THEN RETURN NOSCREEN
  IF (win:=OpenWindowTagList(NIL,[WA_LEFT,0,WA_TOP,0,WA_WIDTH,scr.width,WA_HEIGHT,scr.height,
      WA_FLAGS,$11800,WA_IDCMP,$200408 OR IDCMP_INTUITICKS,
      WA_CUSTOMSCREEN,scr,NIL]))=NIL THEN RETURN NOWINDOW
  IF pt:=AllocVec(4,$3)
    SetPointer(win,pt,0,0,0,0)
  ENDIF
  IF font:=OpenDiskFont(['CGTriumvirate.font',20,$80,0,[TA_DEVICEDPI,Shl(1,16)+1,NIL]]:ttextattr)
    SetFont(win.rport,font)
  ELSE
    RETURN NOSMALLFONT
  ENDIF
  IF (fontbig:=OpenDiskFont(['CGTriumvirate.font',50,$82,0,
      [TA_DEVICEDPI,Shl(1,16)+1,NIL]]:ttextattr))=NIL THEN RETURN NOBIGFONT
  cimage:=loadiff(NIL,NIL,0,0,'IFF/C=Logo.8',4)
  p1img:=loadiff(NIL,NIL,0,0,'IFF/PfeilLinks.64',4)
  p2img:=loadiff(NIL,NIL,0,0,'IFF/PfeilRechts.64',4)
  SetStdRast(win.rport)
  loadiff(NIL,scr+44,0,0,'IFF/Palette.64',2)
ENDPROC -1
PROC fehler(nr)
  IF nr<>-1
    WriteF('\s\n',ListItem(['Konnte diskfont.library nicht öffnen!',
                            'Konnte Bildschirm nicht öffnen!',
                            'Konnte Fenster nicht öffnen!',
                            'Konnte CGTirumvirate.font 20 nicht öffnen!',
                            'Konnte CGTriumvirate.font 50 nicht öffnen!'],nr))
  ENDIF
ENDPROC nr
PROC freeall()
  DEF i=0
  IF lang
    WHILE lang[i]<>0
      FreeVec(lang[i])
      i++
    ENDWHILE
    FreeVec(lang)
  ENDIF
  IF cimage THEN FreeVec(cimage)
  IF p1img THEN FreeVec(p1img)
  IF p2img THEN FreeVec(p2img)
  IF win THEN CloseWindow(win)
  IF pt THEN FreeVec(pt)
  IF font THEN CloseFont(font)
  IF fontbig THEN CloseFont(fontbig)
  IF scr THEN CloseScreen(scr)
  IF diskfontbase THEN CloseLibrary(diskfontbase)
ENDPROC

