/* 
 *  All.e - Demonstration (fast) ALLER NewGUI - Features
 * -=====-
 * 
 * Anwendung von:
 * --------------
 *      - Multi-Window-Handling (+ Anwendung von setnewarrtsA())
 *      - ARexx-Port
 *      - Window-Backfill
 *      - Designspezifischen Elemente (Buttons, Stringgadgets... )
 *      - GadTools-Menüs
 *      - Window-Blocking
 *      - Window-Hiding
 *      - Verändern der Oberfläche (Gui-Changing)
 *      - Verwendung der Unterprozeduren ONTICK und ONCLOSE
 *      - Screen-Cloning/Benutzen eines PubScreens...
 *      - Error-handling mit ng_showerror()
 */

OPT     LARGE
OPT     OSVERSION = 37

MODULE  'libraries/gadtools'
MODULE  'newgui/ng_showerror'
MODULE  'newgui/ng_progress'
MODULE  'newgui/newgui'
MODULE  'utility/tagitem'

ENUM    GUI_MAIN,
        GUI_ABOUT,
        GUI_FONT,
        GUI_SCREENMODE,
        GUI_GAUGE,
        GUI_LAST

DEF     gui:PTR TO guihandle,                   -> guihandle
        screen=NIL,                             -> Screen-PTR (für PubScreen-handling...)
        menu=0,                                 -> GadTools-Menü
        tickon=FALSE,                           -> Intuiticks an das Unterprogramm weiterleiten?
        pubscreen=TRUE,                         -> Ist der Pubscreen schon offen? (dann müssen wir auch wieder den Lock entfernen!)
        id=0,
        pw:PTR TO progresswin                   -> NewGUI-Progress-Window...

PROC main()     HANDLE
 makemenus()
  opengui()

   handlegui()

EXCEPT DO
 closegui()
 IF pubscreen=TRUE THEN UnlockPubScreen('NEWGUI_2',screen)
  IF exception THEN ng_showerror(exception)     -> Fehlerbehandlung mittels einer Zusatz-Routine (in newgui/ng_showerror.m)
 CleanUp(exception)                             -> Mit exception als RETURN-Code (normalfall = 0) aufhören
ENDPROC

PROC makemenus()
 menu:=[
        NM_TITLE,       0,      'Projekt',      0,      0,0,0,
        NM_ITEM,        0,      'Neu ...',     'n',     0,0,{new},
        NM_ITEM,        0,      'Laden ...',   'l',     NM_ITEMDISABLED,0,{test1},
        NM_ITEM,        0,      'Sichern ...', 's',     NM_ITEMDISABLED,0,{test1},
        NM_BARLABEL,    0,      0,              0,      0,0,0,
        NM_ITEM,        0,      'Über ...',    'a',     0,0,{about},
        NM_ITEM,        0,      'Beenden ...', 'q',     0,0,0,
        NM_TITLE,       0,      'Hilfsmittel',  0,      0,0,0,
        NM_ITEM,        0,      'Main - blockieren','b',0,0,{block},
        NM_ITEM,        0,      'Main - verstecken','v',0,0,{hide},
        0,              0,      0,              0,      0,0,0]:newmenu
ENDPROC

PROC opengui()
 IF (screen:=LockPubScreen('NEWGUI_2'))=NIL THEN pubscreen:=FALSE
  gui:=guiinitA([
        NG_WINDOWTITLE, 'NewGUI - Demo',        -> Titel des Fensters
        IF (screen=NIL)  THEN NG_CLONESCREEN ELSE TAG_IGNORE,   TRUE,                   -> WB clonen (wenn weitere Angaben (z.B. NG_SCR_xxx) gemacht werden, werden diese bevorzugt behandelt!)
        IF (screen=NIL)  THEN NG_SCR_TITLE   ELSE TAG_IGNORE,   'NewGUI - ALL',
        IF (screen<>NIL) THEN NG_SCREEN      ELSE TAG_IGNORE,   screen,
        NG_SCR_PUBNAME, 'NEWGUI_2',
        NG_REXXNAME,    'NEWGUI',               -> Name für einen ARexx-Port
        NG_REXXPROC,    {rexxmsg},              -> PTR der Prozedur die ARexx-Messages verarbeitet
        NG_BFPATTERN,   [$AAAA,$5555]:INT,      -> Backfillpattern (Muster)
        NG_BFEXP,       1,                      -> Exponent für den Pattern (siehe graphics/gfxmacros/SetAfPt)
        NG_BFBACKPEN,   3,                      -> Hintergrundstift (nummer) für den Pattern
        NG_BFFRONTPEN,  0,                      -> Zeichenstift (Nummer) für den Pattern
        NG_PATTERNEXP,  1,                      -> Exponent für den Pattern
        NG_PATTERN1,    [$AAAA,$5555]:INT,      -> Muster (Pattern) für FILLPATTERN1
        NG_P1BACKPEN,   0,                      -> Hintergrundstift für das Patternfilling (Muster)
        NG_P1FRONTPEN,  0,                      -> Zeichenstift für das Muster (Patternfilling)
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_GUIID,       GUI_MAIN,               -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                [ROWS,                          -> Alles Untereinander
                [BEVEL,                         -> Einen Bevel um die folgenden Elemente
                [FILLPATTERN1,                  -> Alles im Bevel mit dem Pattern 1 füllen
                [ROWS,                          -> Im Bevel (und Fillpattern) alles untereinander
                        [TEXT,'Haupt-Fenster','NewGUI-Beispiel:',TRUE,3]        -> Text ausgeben
                ]]],                            -> Rows, Fillpattern1 und Bevelr - Schließen!
                [BEVELR,                        -> Einen Recessed Bevel um die Elemente
                [FILLPATTERN1,                  -> Außerdem mit dem FILLPATTERN1 hinterlegen!
                [ROWS,                          -> Alles untereinander
                        [SBUTTON,{font},'Font ...'],
                        [SBUTTON,{screenmode},'Screenmode ...'],
                        [SBUTTON,{ticker},'Ticker on/off'],
                        [SBUTTON,{gauge},'Gauge...'],
                        [SBUTTON,{about},'Über ...']
                ]]],                            -> Rows, Fillpattern1 und Bevelr schließen
                [BAR],                          -> Einen Trennstrich erzeugen
                [BEVELR,                        -> Einen Recessed Bevel um die Elemente
                [FILLPATTERN1,                  -> Außerdem mit dem FILLPATTERN1 hinterlegen!
                [EQCOLS,                        -> Und alle Elemente im Bevel nebeneinander, und ALLE gleich Breit (EQCOLS)
                        [SBUTTON,{closechilds},'Fenster schließen'],    -> Ein Button (SBUTTON = Variable Breite!)
                        [SBUTTON,{new},'Neues Fenster'],                -> Neues GUI öffnen!
                        [SBUTTON,{block},'Blockieren'],                 -> Ein Button (SBUTTON = Variable Breite!) -> Fenster blockieren!
                        [SBUTTON,{hide},'Verstecken']]]]],-> Ein Button mit variabler Breite, außerdem ALLE verbleibenden Attribute schließen
        NIL,NIL])                               -> TagListe abschließen (normalerweise mit TAG_END)
  screen:=ng_setattrsA([NG_GUI,  gui,
        NG_GETSCREEN,   TRUE,
        NIL,            NIL])
   id:=GUI_LAST                                 -> ID für die neuen Windows auf den größten Wert setzen
ENDPROC

PROC font()
 DEF    guihandle
  guihandle:=guiinitA([
        NG_WINDOWTITLE, 'Font-Demo',            -> Titel des Fensters
        NG_SCREEN,      screen,
        NG_BFPATTERN,   [$AAAA,$5555]:INT,      -> Backfillpattern (Muster)
        NG_BFEXP,       0,                      -> Exponent für den Pattern (siehe graphics/gfxmacros/SetAfPt)
        NG_BFBACKPEN,   0,                      -> Hintergrundstift (nummer) für den Pattern
        NG_BFFRONTPEN,  0,                      -> Zeichenstift (Nummer) für den Pattern
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_GUIID,       GUI_FONT,               -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                [EQROWS,
                        [TEXT,'Selected Fonts',NIL,FALSE,3],
                [BEVELR,
                [EQROWS,
                        [TEXT,'xentiny 8','Workbench Icon Text:',FALSE,3],
                        [TEXT,'end 10','System Default Text:',FALSE,3],
                        [TEXT,'except 12','Screen text:',FALSE,3]
                ]],
                        [SBUTTON,0,'Select Workbench Icon Text...'],
                        [SBUTTON,0,'Select System Default Text...'],
                        [SBUTTON,0,'Select Screen text...'],
                [BAR],
                [COLS,
                        [BUTTON,0,'Save'],
                [SPACEH],
                        [BUTTON,0,'Use'],
                [SPACEH],
                        [BUTTON,0,'Cancel']
                ]],
        NIL,NIL])                               -> TagListe abschließen (normalerweise mit TAG_END)

   ng_setattrsA([NG_GUI,gui,                    -> GUI anhängen!
        NG_APPENDGUI,guihandle,NIL,NIL])
ENDPROC

PROC screenmode()
 DEF    guihandle
  guihandle:=guiinitA([
        NG_WINDOWTITLE, 'Screenmode-Demo',            -> Titel des Fensters
        NG_SCREEN,      screen,
        NG_BFPATTERN,   [$AAAA,$5555]:INT,      -> Backfillpattern (Muster)
        NG_BFEXP,       0,                      -> Exponent für den Pattern (siehe graphics/gfxmacros/SetAfPt)
        NG_BFBACKPEN,   0,                      -> Hintergrundstift (nummer) für den Pattern
        NG_BFFRONTPEN,  0,                      -> Zeichenstift (Nummer) für den Pattern
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_GUIID,       GUI_SCREENMODE,         -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                [EQROWS,
                [COLS,
                [EQROWS,
                        [LISTV,0,'Display Mode',10,4,NIL,TRUE,0,0],
                [COLS,
                [EQROWS,
                        [INTEGER,0,'Width:',640,5],
                        [INTEGER,0,'Height:',512,5]
                ],
                [ROWS,
                        [CHECK,0,'Default',TRUE,FALSE],
                        [CHECK,0,'Default',TRUE,FALSE]
                ]],
                        [SLIDE,0,'Colors:',FALSE,1,8,3,5,''],
                        [CHECK,0,'AutoScroll:',TRUE,TRUE]
                ],
                [BEVELR,
                [EQROWS,
                        [TEXT,'688x539','Visible Size:',FALSE,3],
                        [TEXT,'640x200','Minimum Size:',FALSE,3],
                        [TEXT,'16368x16384','Maximum Size:',FALSE,3],
                        [TEXT,'256','Maximum Colors:',FALSE,3],
                [SPACE]
                ]]],
                [BAR],
                [COLS,
                        [BUTTON,0,'Save'],
                [SPACEH],
                        [BUTTON,0,'Use'],
                [SPACEH],
                        [BUTTON,0,'Cancel']
                ]],
        NIL,NIL])                               -> TagListe abschließen (normalerweise mit TAG_END)

   ng_setattrsA([NG_GUI,gui,                    -> GUI anhängen!
        NG_APPENDGUI,guihandle,NIL,NIL])
ENDPROC

PROC handlegui()
 DEF    res=-1
  WHILE (res<0)
   Wait(gui.sig)
    res:=guimessage(gui)
  ENDWHILE
ENDPROC

PROC closegui()
  IF (pw<>NIL)  THEN END pw
 IF gui         THEN cleangui(gui,TRUE)         -> (TRUE bedeutet, daß ALLE Unterguis mit geschlossen werden!)
ENDPROC

PROC closechilds()
   ng_setattrsA([NG_GUI,gui,                    -> Child-Windows entfernen!
        NG_REMOVECHILDS,TRUE,NIL,NIL])
  id:=GUI_LAST
ENDPROC

PROC new()
 DEF    guihandle
  guihandle:=guiinitA([
        NG_WINDOWTITLE, 'NewGUI - Demo',        -> Titel des Fensters
        NG_SCREEN,      screen,
        NG_ONCLOSE,     {onchildclose},         -> Prozedur die beim Schließen des Fensters aufgerufen wird
        NG_BFPATTERN,   [$AAAA,$5555]:INT,      -> Backfillpattern (Muster)
        NG_BFEXP,       1,                      -> Exponent für den Pattern (siehe graphics/gfxmacros/SetAfPt)
        NG_BFBACKPEN,   3,                      -> Hintergrundstift (nummer) für den Pattern
        NG_BFFRONTPEN,  0,                      -> Zeichenstift (Nummer) für den Pattern
        NG_PATTERNEXP,  1,                      -> Exponent für den Pattern
        NG_PATTERN1,    [$AAAA,$5555]:INT,      -> Muster (Pattern) für FILLPATTERN1
        NG_P1BACKPEN,   0,                      -> Hintergrundstift für das Patternfilling (Muster)
        NG_P1FRONTPEN,  0,                      -> Zeichenstift für das Muster (Patternfilling)
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_GUIID,       id,                     -> Gui-ID
        NG_DATA,        id,                     -> ID ist auch DATA!
        NG_GUI,                                 -> Oberflächenbeschreibung
                [ROWS,                          -> Alles Untereinander
                [DBEVELR,                       -> Einen Doppelten Recessed (Eingedrückten) Bevel um die folgenden Elemente
                [FILLPATTERN1,                  -> Alles im Bevel mit dem Pattern 1 füllen
                [ROWS,                          -> Im Bevel (und Fillpattern) alles untereinander
                        [TEXT,'Unter-Fenster','NewGUI-Beispiel:',TRUE,3]        -> Text ausgeben
                ]]],                            -> Rows, Fillpattern1 und Bevelr - Schließen!
                [BAR],                          -> Einen Trennstrich erzeugen
                [BEVELR,                        -> Einen Recessed Bevel um die Elemente
                [FILLPATTERN1,                  -> Außerdem mit dem FILLPATTERN1 hinterlegen!
                [EQCOLS,                        -> Und alle Elemente im Bevel nebeneinander, und ALLE gleich Breit (EQCOLS)
                        [SBUTTON,{change},'Wechseln'],          -> Ein Button (SBUTTON = Variable Breite!)
                        [SBUTTON,{block},'Main - Blockieren'],  -> Ein Button (SBUTTON = Variable Breite!) -> Fenster blockieren!
                        [SBUTTON,{hide},'Main - Verstecken']]]]],-> Ein Button mit variabler Breite, außerdem ALLE verbleibenden Attribute schließen

        NIL,NIL])                               -> TagListe abschließen (normalerweise mit TAG_END)

   ng_setattrsA([NG_GUI,gui,                    -> GUI anhängen!
        NG_APPENDGUI,guihandle,NIL,NIL])

    id++                                        -> ID um 1 erhöhen
ENDPROC

PROC closepw()  
 END pw
ENDPROC -2

PROC gauge()
 DEF    guihandle
  IF (guihandle:=ng_setattrsA([
        NG_GUI,         gui,
        NG_GETGUI,      TRUE,
        NG_GUIID,       GUI_GAUGE,
        NIL,            NIL]))
    ng_setattrsA([
        NG_GUI,         gui,
        NG_REMOVEGUI,   GUI_GAUGE,
        NIL,            NIL])
   END pw
  ELSE
   NEW pw.progresswin('NewGUI - ProgressWindow','Füllanzeige-Fenster','Anfangswert',3,2,1,50,screen,NIL)
    guihandle:=guiinitA([
        NG_WINDOWTITLE, 'NewGUI - Demo',        -> Titel des Fensters
        NG_SCREEN,      screen,
        NG_ONCLOSE,     {closepw},
        NG_BFPATTERN,   [$AAAA,$5555]:INT,      -> Backfillpattern (Muster)
        NG_BFEXP,       1,                      -> Exponent für den Pattern (siehe graphics/gfxmacros/SetAfPt)
        NG_BFBACKPEN,   3,                      -> Hintergrundstift (nummer) für den Pattern
        NG_BFFRONTPEN,  0,                      -> Zeichenstift (Nummer) für den Pattern
        NG_PATTERNEXP,  1,                      -> Exponent für den Pattern
        NG_PATTERN1,    [$AAAA,$5555]:INT,      -> Muster (Pattern) für FILLPATTERN1
        NG_P1BACKPEN,   0,                      -> Hintergrundstift für das Patternfilling (Muster)
        NG_P1FRONTPEN,  0,                      -> Zeichenstift für das Muster (Patternfilling)
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_GUIID,       GUI_GAUGE,              -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                [ROWS,
                [BEVELR,
                [FILLPATTERN1,
                [EQROWS,
                        [TEXT,'Slider!','Move the',FALSE,3],
                        [SLIDE,{setgauge},'     ',FALSE,0,100,50,2,'%3ld']
                ]]],
                [BEVELR,
                [FILLPATTERN1,
                [EQCOLS,
                        [SBUTTON,0,'Fenster schließen'],
                [SPACEH],
                        [SBUTTON,{hide},'Main verstecken']
                ]]]
                ],
        NIL,NIL])                               -> TagListe abschließen (normalerweise mit TAG_END)
   ng_setattrsA([NG_GUI,gui,                    -> GUI anhängen!
        NG_APPENDGUI,guihandle,NIL,NIL])
  ENDIF
ENDPROC

PROC setgauge(x,y)
 DEF    oldval=0,
        status[20]:STRING
  oldval:=pw.get()
   IF (oldval<y) AND (y<>50)
    StrCopy(status,'Zunahme')
   ELSEIF (oldval>y) AND (y<>50)
    StrCopy(status,'Abnahme')
   ELSEIF y=50
    StrCopy(status,'Anfangswert')
   ENDIF
  pw.set(y,status,NIL)
ENDPROC

PROC change(id)
 DEF    guihandle
   IF (guihandle:=ng_setattrsA([NG_GUI,gui,
        NG_GETGUI,      TRUE,
        NG_GUIID,       id,NIL,NIL]))
    ng_setattrsA([NG_GUI,gui,
        NG_CHANGEGUI,   NG_NEWGUI,
        NG_GUIVAR,      guihandle,
        NG_NEWDATA,
                [ROWS,                          -> Alles Untereinander
                [BEVELR,                        -> Einen Recessed Bevel um die Elemente
                [FILLPATTERN1,                  -> Außerdem mit dem FILLPATTERN1 hinterlegen!
                [EQCOLS,                        -> Und alle Elemente im Bevel nebeneinander, und ALLE gleich Breit (EQCOLS)
                        [SBUTTON,{change},'Wechseln'],       -> Ein Button (SBUTTON = Variable Breite!)
                        [SBUTTON,{block},'Main - Blockieren'],  -> Ein Button (SBUTTON = Variable Breite!) -> Fenster blockieren!
                        [SBUTTON,{hide},'Main - Verstecken']]]],
                [DBEVELR,                       -> Einen Doppelten Recessed (Eingedrückten) Bevel um die folgenden Elemente
                [FILLPATTERN1,                  -> Alles im Bevel mit dem Pattern 1 füllen
                [ROWS,                          -> Im Bevel (und Fillpattern) alles untereinander
                        [TEXT,'Unter-Fenster (gewechselt)','NewGUI-Beispiel:',TRUE,3]        -> Text ausgeben
                ]]],                            -> Rows, Fillpattern1 und Bevelr - Schließen!
                [BAR]                           -> Einen Trennstrich erzeugen
                ]                               -> Ein Button mit variabler Breite, außerdem ALLE verbleibenden Attribute schließen
         ,NIL,NIL])
   ENDIF
ENDPROC

PROC about()
 DEF    guihandle
  guihandle:=guiinitA([
        NG_WINDOWTITLE, 'Über NewGUI',        -> Titel des Fensters
        NG_SCREEN,      screen,
        NG_BFPATTERN,   [$AAAA,$5555]:INT,      -> Backfillpattern (Muster)
        NG_BFEXP,       1,                      -> Exponent für den Pattern (siehe graphics/gfxmacros/SetAfPt)
        NG_BFBACKPEN,   3,                      -> Hintergrundstift (nummer) für den Pattern
        NG_BFFRONTPEN,  0,                      -> Zeichenstift (Nummer) für den Pattern
        NG_PATTERNEXP,  1,                      -> Exponent für den Pattern
        NG_PATTERN1,    [$AAAA,$5555]:INT,      -> Muster (Pattern) für FILLPATTERN1
        NG_P1BACKPEN,   0,                      -> Hintergrundstift für das Patternfilling (Muster)
        NG_P1FRONTPEN,  0,                      -> Zeichenstift für das Muster (Patternfilling)
        NG_PATTERN2,    [$AAAA,$5555]:INT,      -> Muster (Pattern) für FILLPATTERN2
        NG_P2BACKPEN,   3,                      -> Hintergrundstift für das Patternfilling (Muster)
        NG_P2FRONTPEN,  2,                      -> Zeichenstift für das Muster (Patternfilling)
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_GUIID,       GUI_ABOUT,              -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                [ROWS,                          -> Alles Untereinander
                [DBEVELR,                       -> Einen Doppelten Recessed (Eingedrückten) Bevel um die folgenden Elemente
                [FILLPATTERN2,                  -> Alles im Bevel mit dem Pattern 1 füllen
                [EQROWS,                        -> Im Bevel (und Fillpattern) alles untereinander
                        [TEXT,'NewGUI','Über',FALSE,3],  -> Text ausgeben
                        [TEXT,' ',' ',FALSE,3]
                ]]],                            -> Rows, Fillpattern1 und Bevelr - Schließen!
                [BEVELR,
                [FILLPATTERN1,
                [EQROWS,
                        [TEXT,'© 1997/98 by','NewGUI ist',FALSE,3],
                        [TEXT,'Softwareentwicklungen','THE DARK FRONTIER',FALSE,3],
                        [TEXT,' ','Adresse:',FALSE,3],
                        [TEXT,'Am Hofgraben 2','  ',FALSE,3],
                        [TEXT,'67378 Zeiskam','  ',FALSE,3],
                        [TEXT,'frontier@starbase.inka.de','Email:',FALSE,3],
                        [TEXT,'+49(0)7274 - 8774','Fax:',FALSE,3]
                ]]],
                [BAR],
                [BEVELR,
                [FILLPATTERN1,
                [EQCOLS,
                        [SBUTTON,0,'OK']]]]],
        NIL,NIL])                               -> TagListe abschließen (normalerweise mit TAG_END)

   ng_setattrsA([NG_GUI,gui,                    -> GUI anhängen!
        NG_APPENDGUI,guihandle,NIL,NIL])
ENDPROC

PROC test1()
 WriteF('Test!\n')
ENDPROC

PROC block()
 DEF    a
  WriteF('\nBlockiere Fenster :')
   ng_setattrsA([NG_GUI,gui,
        NG_CHANGEGUI,NG_BLOCKGUI,NIL,NIL])
    FOR a:=0 TO 50                              -> Eine Schleife ist eigendlich eine etwas unsaubere
     Delay(1)                                   -> Methode, sie dient hier nur zur veranschaulichung
      WriteF('.')                               -> in einem "richtigen" Programm würden an dieser
     guimessage(gui)                            -> Stelle rechenintensive Sachen etc. stehen, WICHTIG
    ENDFOR                                      -> ist, daß guimessage() manchmal zwischendurch aufgerufen wird!
   ng_setattrsA([NG_GUI,gui,
        NG_CHANGEGUI,NG_UNBLOCKGUI,NIL,NIL])
ENDPROC

PROC hide()
 DEF    a
  WriteF('\nVerstecke Fenster :')
   ng_setattrsA([NG_GUI,gui,
        NG_CHANGEGUI,NG_HIDE,NIL,NIL])
    FOR a:=0 TO 50
     Delay(1)
      WriteF('.')
     guimessage(gui)
    ENDFOR
   ng_setattrsA([NG_GUI,gui,
        NG_CHANGEGUI,NG_APPEAR,NIL,NIL])
ENDPROC

PROC rexxmsg(s,mes=NIL)                         -> Programm zum parsen von ARexx-Messages
 WriteF('Rexx-Msg: "\s"\n',s)                   -> ARexx-String (s) ausgeben!

  mes:=NIL                                      -> Message auf NIL setzen
ENDPROC  StrCmp('QUIT',s),0,'Reply-Message'     -> Rückgabe! Format = BOOL,INT,STRING     (Beenden?,Returncode,Replystring)

PROC ticker()
 IF tickon=TRUE
   ng_setattrsA([NG_GUI,gui,
        NG_CHANGETICKER,TRUE,NIL,NIL])
  tickon:=FALSE
 ELSE
   ng_setattrsA([NG_GUI,gui,
        NG_CHANGETICKER,{tickmsg},NIL,NIL])
  tickon:=TRUE
 ENDIF
ENDPROC

PROC tickmsg()                  IS      WriteF('Tick für das Main-Fenster!\n')

PROC onchildclose()
 id--
ENDPROC -2
