OPT     OSVERSION = 37
OPT     MODULE

MODULE  'graphics/rastport'
MODULE  'graphics/text'
MODULE  'intuition/intuition'
MODULE  'newgui/newgui'

EXPORT PROC ng_performdnd(win:PTR TO window,self:PTR TO plugin)         -> Spätere Versionen haben evtl. GELs - Support...
 DEF    x=0:REG,
        y=0:REG,
        oldx=0:REG,
        oldy=0:REG,
        dndwin=NIL:PTR TO window                                        -> Für ein Drag'N'Drop mißbrauchtes Fenster :-) Ist im Moment schneller programmiert!

  IF (self.dis=FALSE)                                                   -> Nur ausführen, wenn die Box NICHT Disabled ist!
    IF Odd(self.dnd_info)                                               -> Wenn ein Image enthalten ist (egal ob auch ein String enthalten ist ect...)
     dndwin:=OpenWindowTagList(NIL,                                     -> Window, welches wir für unser Drag 'N' Drop mißbrauchen!
       [WA_FLAGS,       WFLG_BORDERLESS OR WFLG_RMBTRAP OR WFLG_NOCAREREFRESH,
        WA_LEFT,        win.leftedge+self.x,                            -> Normalerweise würde man hier GELS nehmen, aber zur veranschaulichung erfüllt
        WA_TOP,         win.topedge+self.y,                             -> diese Methode auch Ihren zweck! (ist außerdem kürzer und schneller zu programmieren...)
        WA_WIDTH,       self.dnd_selectimage.width,                     -> Ich hab` nämlich nicht so viel Zeit (wegen dem ABI... :-((
        WA_HEIGHT,      self.dnd_selectimage.height,
        WA_TITLE,       NIL,                                            -> Keine Titelzeile!
        WA_CUSTOMSCREEN,win.wscreen,                                    -> Evtl. unser Fenster auf dem Customscreen des Parent-Windows öffnen!
        NIL,            NIL])
     IF (dndwin<>NIL) THEN DrawImage(dndwin.rport,self.dnd_selectimage,0,0)     -> Image ins Window zeichen!
    ELSEIF Even(self.dnd_info)                                          -> Kein Image enthalten, aber Text/String...
     IF (dndwin:=OpenWindowTagList(NIL,                                 -> Window, welches wir für unser Drag 'N' Drop mißbrauchen!
       [WA_FLAGS,       WFLG_BORDERLESS OR WFLG_RMBTRAP OR WFLG_NOCAREREFRESH,
        WA_LEFT,        win.leftedge+self.x,                            -> Normalerweise würde man hier GELS nehmen, aber zur veranschaulichung erfüllt
        WA_TOP,         win.topedge+self.y,                             -> diese Methode auch Ihren zweck! (ist außerdem kürzer und schneller zu programmieren...)
        WA_WIDTH,       TextLength(win.rport,self.dnd_text,self.dnd_textlen),                                        -> Ich hab` nämlich nicht so viel Zeit (wegen dem ABI... :-((
        WA_HEIGHT,      self.gh.tattr.ysize,
        WA_TITLE,       NIL,                                            -> Keine Titelzeile!
        WA_CUSTOMSCREEN,win.wscreen,                                    -> Evtl. unser Fenster auf dem Customscreen des Parent-Windows öffnen!
        NIL,            NIL]))
       SetABPenDrMd(dndwin.rport,2,3,RP_JAM2)                           -> Hintergrundfarbe = 3 (Blau)
      Move(dndwin.rport,0,self.gh.tattr.ysize-3)                        -> Nur eine Zeile nach unten...
     Text(dndwin.rport,self.dnd_text,self.dnd_textlen)
     ENDIF
    ENDIF
    IF (dndwin<>NIL)
     WHILE Mouse()>0                                                    -> Schleife so lange durchlaufen wie die Maustaste gedrückt ist! (Unschöne Methode -> Mouse()!!!!!)
      oldx:=x                                                           -> Alte Mauskoordinaten speichern um später die Relative ...
       oldy:=y                                                          -> ... Bewegung zu errechnen!
        x:=win.mousex                                                   -> X-Coordinate der Maus aus dem Intuition-Window holen
        y:=win.mousey                                                   -> Y-Coordinate aus dem Window holen
       Delay(1)                                                         -> WICHTIG!!!!!! (IMPORTANT!) Weil wir UNBEDINGT sehr wenig Rechenzeit beanspruchen sollen!
      IF (oldx<>0) OR (oldy<>0) THEN MoveWindow(dndwin,(x-oldx),(y-oldy))       -> Window bewegen! ACHTUNG!!! MoveWindow() braucht RELATIVE Mauscoordinaten!)
     ENDWHILE
    CloseWindow(dndwin)                                                 -> Unser Window wieder schließen!
   ENDIF
  ENDIF
ENDPROC x,y                                                             -> !!! WICHTIG! Mauskoordinaten vom DROP-Down zurückgeben!!!!
