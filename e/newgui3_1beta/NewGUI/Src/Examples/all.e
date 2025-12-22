/*
 *  Angepasstes Beispiel (neues Window-Handling ect...!)
 *
 *
 *
 */

OPT     LARGE
OPT     OSVERSION = 37
OPT     PREPROCESS

MODULE  'graphics/gfxmacros'
MODULE  'graphics/rastport'
MODULE  'intuition/intuition'
MODULE  'libraries/gadtools'
MODULE  'newgui/pl_scrolltext'
MODULE  'newgui/ng_showerror'
MODULE  'newgui/ng_progress'
MODULE  'newgui/newgui'
MODULE  'utility/tagitem'

ENUM    GUI_MAIN = 1,
        GUI_FIRST,
        GUI_FONT,
        GUI_SCREENMODE,
        GUI_MULTI,
        GUI_GAUGE,
        GUI_ABOUT

DEF     gui:PTR TO guihandle,                   -> guihandle
        screen=NIL,
        menu=0,                                 -> GadTools-Menü
        tickon=FALSE,                           -> Intuiticks an das Unterprogramm weiterleiten?
        pw:PTR TO progresswin,                  -> NewGUI-Progress-Window...
        scroll:PTR TO scrolltext

PROC main()     HANDLE
 makemenus()
  opengui()

EXCEPT DO
   IF scroll THEN END scroll
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
        NM_ITEM,        0,      'Main - blockieren','1',0,0,{block},
        NM_ITEM,        0,      'Main - schließen','2', 0,0,{hide},
        NM_ITEM,        0,      'Main - öffnen','3',    0,0,{appear},
        0,              0,      0,              0,      0,0,0]:newmenu
ENDPROC

PROC opengui()
  newguiA([
        NG_WINDOWTITLE, 'NewGUI - Demo',        -> Titel des Fensters
        NG_PREFSPROC,   {saveprefs},
        NG_CLONESCREEN, TRUE,                   -> WB clonen (wenn weitere Angaben (z.B. NG_SCR_xxx) gemacht werden, werden diese bevorzugt behandelt!)
        NG_SCR_TITLE,   'NewGUI - ALL',
        NG_SCR_PUBNAME, 'NEWGUI',
        NG_OPENPUBSCREEN,       TRUE,
        NG_REXXNAME,    'NEWGUI',               -> Name für einen ARexx-Port
        NG_REXXPROC,    {rexxmsg},              -> PTR der Prozedur die ARexx-Messages verarbeitet
        NG_FILLHOOK,    {fillrect},             -> Prozedur zum Füllen einer Gruppe/Fensterhintergrund!
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_ONCLOSE,     {closepw},
        NG_GUIID,       GUI_MAIN,               -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                        NG_DUMMY,
        NG_NEXTGUI,     
-> eigendliches Main-Fenster
       [NG_WINDOWTITLE, 'NewGUI - Demo',        -> Titel des Fensters
        NG_FILLHOOK,    {fillrect},             -> Prozedur zum Füllen einer Gruppe/Fensterhintergrund!
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_ONCLOSE,     {closeall},
        NG_AUTOOPEN,    TRUE,                   -> Gleich zu beginn offen!
        NG_USEMAINSCREEN, TRUE,
        NG_USEMAINFONT, TRUE,
        NG_GUIID,       GUI_FIRST,              -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung

                [ROWS,                          -> Alles Untereinander
                [BEVEL,                         -> Einen Bevel um die folgenden Elemente
                [FILLGROUP1,                  -> Alles im Bevel mit dem Pattern 1 füllen
                [ROWS,                          -> Im Bevel (und FILLGROUP) alles untereinander
                        [TEXT,'Haupt-Fenster','NewGUI-Beispiel:',TRUE,3]        -> Text ausgeben
                ]]],                            -> Rows, FILLGROUP1 und Bevelr - Schließen!
                [BEVELR,                        -> Einen Recessed Bevel um die Elemente
                [FILLGROUP1,                  -> Außerdem mit dem FILLGROUP1 hinterlegen!
                [ROWS,                          -> Alles untereinander
                        [SBUTTON,{font},'Font ...'],
                        [SBUTTON,{screenmode},'Screenmode ...'],
                        [SBUTTON,{ticker},'Ticker on/off'],
                        [SBUTTON,{gauge},'Gauge...'],
                        [SBUTTON,{about},'Über ...']
                ]]],                            -> Rows, FILLGROUP1 und Bevelr schließen
                [BAR],                          -> Einen Trennstrich erzeugen
                [BEVELR,                        -> Einen Recessed Bevel um die Elemente
                [FILLGROUP1,                  -> Außerdem mit dem FILLGROUP1 hinterlegen!
                [EQCOLS,                        -> Und alle Elemente im Bevel nebeneinander, und ALLE gleich Breit (EQCOLS)
                        [SBUTTON,{closechilds},'Fenster schließen'],    -> Ein Button (SBUTTON = Variable Breite!)
                        [SBUTTON,{new},'Neues Fenster'],                -> Neues GUI öffnen!
                        [SBUTTON,{prefs},'Einstellungen'],              -> Preferences
                        [SBUTTON,{block},'Blockieren'],                 -> Ein Button (SBUTTON = Variable Breite!) -> Fenster blockieren!
                        [SBUTTON,{hide},'Verstecken']]]]],-> Ein Button mit variabler Breite, außerdem ALLE verbleibenden Attribute schließen
        NG_NEXTGUI,     
-> FONT-Window
       [NG_WINDOWTITLE, 'Font-Demo',            -> Titel des Fensters
        NG_FILLHOOK,    {fillrect},             -> Prozedur zum Füllen einer Gruppe/Fensterhintergrund!
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_USEMAINFONT, TRUE,
        NG_USEMAINSCREEN,TRUE,
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
        NG_NEXTGUI,     
-> Screenmode-Window
       [NG_WINDOWTITLE, 'Screenmode-Demo',            -> Titel des Fensters
        NG_USEMAINSCREEN,TRUE,
        NG_USEMAINFONT, TRUE,
        NG_FILLHOOK,    {fillrect},             -> Prozedur zum Füllen einer Gruppe/Fensterhintergrund!
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
        NG_NEXTGUI,     
->
       [NG_WINDOWTITLE, 'NewGUI - Demo',        -> Titel des Fensters
        NG_USEMAINSCREEN,TRUE,
        NG_USEMAINFONT, TRUE,
        NG_FILLHOOK,    {fillrect},             -> Prozedur zum Füllen einer Gruppe/Fensterhintergrund!
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_GUIID,       GUI_MULTI,              -> Gui-ID
        NG_DOUBLEGUI,   TRUE,                   -> GUI kann mehrfach offen sein!
        NG_GUI,                                 -> Oberflächenbeschreibung
                [ROWS,                          -> Alles Untereinander
                [DBEVELR,                       -> Einen Doppelten Recessed (Eingedrückten) Bevel um die folgenden Elemente
                [FILLGROUP1,                  -> Alles im Bevel mit dem Pattern 1 füllen
                [ROWS,                          -> Im Bevel (und FILLGROUP) alles untereinander
                        [TEXT,'Unter-Fenster','NewGUI-Beispiel:',TRUE,3]        -> Text ausgeben
                ]]],                            -> Rows, FILLGROUP1 und Bevelr - Schließen!
                [BAR],                          -> Einen Trennstrich erzeugen
                [BEVELR,                        -> Einen Recessed Bevel um die Elemente
                [FILLGROUP1,                  -> Außerdem mit dem FILLGROUP1 hinterlegen!
                [EQCOLS,                        -> Und alle Elemente im Bevel nebeneinander, und ALLE gleich Breit (EQCOLS)
                        [SBUTTON,{change},'Wechseln'],          -> Ein Button (SBUTTON = Variable Breite!)
                        [SBUTTON,{block},'Main - Blockieren'],  -> Ein Button (SBUTTON = Variable Breite!) -> Fenster blockieren!
                        [SBUTTON,{hide},'Main - Verstecken']]]]],-> Ein Button mit variabler Breite, außerdem ALLE verbleibenden Attribute schließen
        NG_NEXTGUI,     
->
       [NG_WINDOWTITLE, 'NewGUI - Demo',        -> Titel des Fensters
        NG_USEMAINSCREEN,TRUE,
        NG_USEMAINFONT, TRUE,
        NG_ONCLOSE,     {closepw},
        NG_FILLHOOK,    {fillrect},             -> Prozedur zum Füllen einer Gruppe/Fensterhintergrund!
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_GUIID,       GUI_GAUGE,              -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                [ROWS,
                [BEVELR,
                [FILLGROUP1,
                [EQROWS,
                        [TEXT,'Slider!','Move the',FALSE,3],
                        [SLIDE,{setgauge},'     ',FALSE,0,100,50,2,'%3ld']
                ]]],
                [BEVELR,
                [FILLGROUP1,
                [EQCOLS,
                [SPACEH],
                        [SBUTTON,{hide},'Main verstecken'],
                [SPACEH]
                ]]]
                ],
        NG_NEXTGUI,     
->
       [NG_WINDOWTITLE, 'Über NewGUI',        -> Titel des Fensters
        NG_USEMAINSCREEN,TRUE,
        NG_FONT_NAME,   'Webhead.font',
        NG_FONT_SIZE,   21,
        NG_FILLHOOK,    {fillrect},             -> Prozedur zum Füllen einer Gruppe/Fensterhintergrund!
        NG_MENU,        menu,                   -> Menü-Beschreibung
        NG_GUIID,       GUI_ABOUT,              -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                [ROWS,                          -> Alles Untereinander
                [DBEVELR,                       -> Einen Doppelten Recessed (Eingedrückten) Bevel um die folgenden Elemente
                [FILLGROUP2,                  -> Alles im Bevel mit dem Pattern 1 füllen
                [EQROWS,                        -> Im Bevel (und FILLGROUP) alles untereinander
                        [TEXT,'NewGUI','Über',FALSE,3],  -> Text ausgeben
                        [TEXT,' ',' ',FALSE,3]
                ]]],                            -> Rows, FILLGROUP1 und Bevelr - Schließen!
                [BEVELR,
                [FILLGROUP1,
                [EQROWS,
                        [SCROLLTEXT,0,NEW scroll.scrolltext([
        1,SCRTXT_BAR,' ',
        2,SCRTXT_CENTER,'NewGUI',
        1,SCRTXT_CENTER,'wurde entwickelt von',
        2,SCRTXT_CENTER,'THE DARK FRONTIER Softwareentwicklungen',
        1,SCRTXT_CENTER,'(© 1994-98)',
        1,SCRTXT_BAR,' ',
        1,SCRTXT_LEFT,'Adresse:',
        1,SCRTXT_CENTER,'Am Hofgraben 2',
        1,SCRTXT_CENTER,'67378 Zeiskam',
        1,SCRTXT_LEFT,'FAX:++49(0)7274-8774',
        2,SCRTXT_LEFT,'Email: frontier@starbase.inka.de',
        2,SCRTXT_LEFT,'WWW  : In Vorbereitung...',
        1,SCRTXT_BAR,' ',
        0,NIL],2,100,2)]
                ]]],
                [BAR],
                [BEVELR,
                [FILLGROUP1,
                [EQCOLS,
                        [SBUTTON,0,'OK']]]]],
        NG_NEXTGUI,     
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL],
->
        NIL,NIL],{getdata})                               -> TagListe abschließen (normalerweise mit TAG_END)
ENDPROC

PROC fillrect(rp,x,y,width,height,type)
 DEF    oldbpen=0,
        oldapen=1
  SELECT        type
        CASE    NG_FILL_WINDOW                          -> Window-Filling (Back)
         oldbpen:=SetBPen(rp,0)                         -> Hintergrund = schwarz
          oldapen:=SetAPen(rp,3)                        -> Vordergrund = blau
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> Füllmuster setzen (ACHTUNG! Makrodefinition in "gfxmacros", PREPROCESS wird benötigt!)
            RectFill(rp,x,y,width,height)               -> Füllen ...
           SetBPen(rp,oldbpen)                          -> Hintergrundfarbe wieder auf alten Stand
          SetAPen(rp,oldapen)                           -> Vordergrundfarbe wieder auf alten Stand
        CASE    FILLGROUP1                              -> Füllgruppe 1
         oldbpen:=SetBPen(rp,0)                         -> Hintergrund = schwarz
          oldapen:=SetAPen(rp,0)                        -> Vordergrund = blau
           SetAfPt(rp,[$FFFF,$FFFF]:INT,1)              -> Füllmuster setzen (ACHTUNG! Makrodefinition in "gfxmacros", PREPROCESS wird benötigt!)
            RectFill(rp,x,y,width,height)               -> Füllen ...
           SetBPen(rp,oldbpen)                          -> Hintergrundfarbe wieder auf alten Stand
          SetAPen(rp,oldapen)                           -> Vordergrundfarbe wieder auf alten Stand
        CASE    FILLGROUP2                              -> Füllgruppe 2
         oldbpen:=SetBPen(rp,3)                         -> Hintergrund = schwarz
          oldapen:=SetAPen(rp,2)                        -> Vordergrund = blau
           SetAfPt(rp,[$AAAA,$5555]:INT,1)              -> Füllmuster setzen (ACHTUNG! Makrodefinition in "gfxmacros", PREPROCESS wird benötigt!)
            RectFill(rp,x,y,width,height)               -> Füllen ...
           SetBPen(rp,oldbpen)                          -> Hintergrundfarbe wieder auf alten Stand
          SetAPen(rp,oldapen)                           -> Vordergrundfarbe wieder auf alten Stand
   ENDSELECT
ENDPROC

PROC saveprefs(screen,id,x,y,width,height,open)
 IF open=WIN_OPEN
  WriteF('Guiid = \d -/ x = \d - y = \d - width = \d - height = \d \\- GEÖFFNET\n',id,x,y,width,height)
 ELSEIF open=WIN_BACKDROP
  WriteF('Guiid = \d -/ x = \d - y = \d - width = \d - height = \d \\- BACKDROP\n',id,x,y,width,height)
 ELSE
  WriteF('Guiid = \d -/ x = \d - y = \d - width = \d - height = \d \\- GESCHLOSSEN\n',id,x,y,width,height)
 ENDIF
ENDPROC

PROC getdata(gh,s)
 gui:=gh
 screen:=s
ENDPROC

PROC prefs()
 ng_setattrsA([
        NG_GUI,         gui,
        NG_SAVEPREFS,   TRUE,
        NIL,            NIL])
ENDPROC

PROC font()
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_FONT,
        NIL,            NIL])
ENDPROC

PROC screenmode()
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_SCREENMODE,
        NIL,            NIL])
ENDPROC

PROC closechilds()
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_CLOSECHILDS,
        NIL,            NIL])
ENDPROC

PROC new()
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_MULTI,
        NIL,            NIL])
ENDPROC

PROC closepw()  
 END pw
ENDPROC -2

PROC closeall() IS 0

PROC gauge()
 IF pw=NIL THEN NEW pw.progresswin('NewGUI - ProgressWindow','Füllanzeige-Fenster','Anfangswert',3,2,1,50,screen,NIL)
  ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_GAUGE,
        NIL,            NIL])
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

PROC change()
 DEF    guihandle
  ng_setattrsA([NG_GUI,gui,
        NG_GUIID,       GUI_MULTI,
        NG_CHANGEGUI,   NG_NEWGUI,
        NG_NEWDATA,
                [ROWS,                          -> Alles Untereinander
                [BEVELR,                        -> Einen Recessed Bevel um die Elemente
                [FILLGROUP1,                  -> Außerdem mit dem FILLGROUP1 hinterlegen!
                [EQCOLS,                        -> Und alle Elemente im Bevel nebeneinander, und ALLE gleich Breit (EQCOLS)
                        [SBUTTON,{change},'Wechseln'],       -> Ein Button (SBUTTON = Variable Breite!)
                        [SBUTTON,{block},'Main - Blockieren'],  -> Ein Button (SBUTTON = Variable Breite!) -> Fenster blockieren!
                        [SBUTTON,{hide},'Main - Verstecken']]]],
                [DBEVELR,                       -> Einen Doppelten Recessed (Eingedrückten) Bevel um die folgenden Elemente
                [FILLGROUP1,                  -> Alles im Bevel mit dem Pattern 1 füllen
                [ROWS,                          -> Im Bevel (und FILLGROUP) alles untereinander
                        [TEXT,'Unter-Fenster (gewechselt)','NewGUI-Beispiel:',TRUE,3]        -> Text ausgeben
                ]]],                            -> Rows, FILLGROUP1 und Bevelr - Schließen!
                [BAR]                           -> Einen Trennstrich erzeugen
                ]                               -> Ein Button mit variabler Breite, außerdem ALLE verbleibenden Attribute schließen
         ,NIL,NIL])
ENDPROC

PROC about()
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_ABOUT,
        NIL,            NIL])
ENDPROC

PROC test1()
 WriteF('Test!\n')
ENDPROC

PROC block()
 DEF    a
  WriteF('\nBlockiere Fenster: ')
   ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_BLOCKGUI,
        NG_GUIID,       GUI_FIRST,
        NIL,    NIL])
    FOR a:=0 TO 50                              -> Eine Schleife ist eigendlich eine etwas unsaubere
     Delay(1)                                   -> Methode, sie dient hier nur zur veranschaulichung
      WriteF('.')
     guimessage(gui)                            -> Stelle rechenintensive Sachen etc. stehen, WICHTIG
    ENDFOR                                      -> ist, daß guimessage() manchmal zwischendurch aufgerufen wird!
   ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_UNBLOCKGUI,
        NG_GUIID,       GUI_FIRST,
        NIL,    NIL])
ENDPROC

PROC hide()
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_CLOSEGUI,
        NG_GUIID,       GUI_FIRST,
        NIL,    NIL])
ENDPROC

PROC appear()
 ng_setattrsA([
        NG_GUI,         gui,
        NG_CHANGEGUI,   NG_OPENGUI,
        NG_GUIID,       GUI_FIRST,
        NIL,    NIL])
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

