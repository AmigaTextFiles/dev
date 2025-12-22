/* 
 *  NewGUI Example 1 (new Functions)    © 1996/1997 THE DARK FRONTIER
 * -================================-          Grundler Mathias
 * 
 * Zeigt einige der neuen NewGUI-Features
 * 
 * (Multi-Window-Handling, ARexx-Port, GUI-Description, GUI-Blocking, GUI-Hiding)
 */

OPT     OSVERSION = 37

MODULE 'newgui/newgui'

ENUM    GUI_MAIN,
        GUI_CHILD

DEF     gui:PTR TO guihandle,                   -> guihandle
        id=0

PROC main()     HANDLE
 DEF    res=-1                                  -> Returncode!
   gui:=guiinitA([                              -> Oberflächeninit!
        NG_WINDOWTITLE, 'NewGUI-Example 2',     -> Titel des Fensters
        NG_REXXNAME,    'NEWGUI',               -> Name für einen ARexx-Port
        NG_REXXPROC,    {rexxmsg},              -> PTR der Prozedur die ARexx-Messages verarbeitet
        NG_BFPATTERN,   [$AAAA,$5555]:INT,      -> Backfillpattern (Muster)
        NG_BFEXP,       1,                      -> Exponent für den Pattern (siehe graphics/gfxmacros/SetAfPt)
        NG_BFBACKPEN,   3,                      -> Hintergrundstift (nummer) für den Pattern
        NG_BFFRONTPEN,  2,                      -> Zeichenstift (Nummer) für den Pattern
        NG_PATTERNEXP,  1,                      -> Exponent für den Pattern
        NG_PATTERN1,    [$AAAA,$5555]:INT,      -> Muster (Pattern) für FILLPATTERN1
        NG_P1BACKPEN,   0,                      -> Hintergrundstift für das Patternfilling (Muster)
        NG_P1FRONTPEN,  0,                      -> Zeichenstift für das Muster (Patternfilling)
        NG_GUIID,       GUI_MAIN,               -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                [ROWS,                          -> Alle folgenden Elemente untereinander anordnen!
                [DBEVELR,                       -> Und ein DoubleBevel (Recessed) darum zeichen
                [FILLPATTERN1,                  -> Außerdem mit dem FILLPATTERN1 hinterlegen!
                [ROWS,                          -> Alles untereinander (muß sein nach BEVEL, BEVELR,DBEVEL,DBEVELR,FILLPATTERNx !)
                        [TEXT,'Bevel-Features','Testing the new "NewGUI"',TRUE,3],      -> Text ausgeben
                [BARR],                         -> Neues BAR-Element (Heraustretendet Strich!)
                        [TEXT,'Patternfilling!','and the NEW"',TRUE,3]                  -> Text ausgeben
                ]]],                            -> Attribute aufheben (ROWS>DBEVELR)
                [BEVELR,                        -> Und einen Bevel (Recessed) darum zeichen
                [FILLPATTERN1,                  -> Außerdem mit dem FILLPATTERN1 hinterlegen!
                [EQCOLS,                        -> Und alle Elemente im Bevel nebeneinander, und ALLE gleich Breit (EQCOLS)
                        [SBUTTON,{test1},'_Test1',NIL,'t'],              -> Ein Button (SBUTTON = Variable Breite!)
                        [SBUTTON,{new},'_Neues Fenster',NIL,'n'],        -> Neues GUI öffnen!
                        [SBUTTON,{block},'_Blockieren',NIL,'b'],         -> Ein Button (SBUTTON = Variable Breite!) -> Fenster blockieren!
                        [SBUTTON,{hide},'_Verstecken',NIL,'v']]]]],      -> Ein Button mit variabler Breite, außerdem ALLE verbleibenden Attribute schließen
        NIL,NIL])                               -> TagListe abschließen (normalerweise mit TAG_END)

   id:=GUI_CHILD                                -> ID festlegen!

   new()                                        -> Ein Child-Window öffnen!

  WHILE res<0                                   -> Eventhandling-Loop
   Wait(gui.sig)                                -> Task schläft solange, bis Messages eintreffen
    res:=guimessage(gui)                        -> Messages dann auswerten (lassen)
  ENDWHILE

EXCEPT DO
 IF gui         THEN cleangui(gui,TRUE)         -> (TRUE bedeutet, daß ALLE Unterguis mit geschlossen werden!)
  IF exception                                  -> Wenn eine exception auftreten sollte
   WriteF('Exception: \d\n',exception)          -> Exceptioncode ausgaben (ZAHL)
  ENDIF
 CleanUp(exception)                             -> Mit exception als RETURN-Code (normalfall = 0) aufhören
ENDPROC

PROC test1()                                    -> Kleine Testprozedur! - Ohne Parameter!
 WriteF('\nTest1')
ENDPROC

PROC new()
 DEF    child:PTR TO guihandle                  -> guihandle
  child:=guiinitA([
        NG_WINDOWTITLE, 'NEW Child-Window',     -> Titel des Fensters
        NG_BFPATTERN,   [$AAAA,$5555]:INT,      -> Backfillpattern (Muster)
        NG_BFEXP,       1,                      -> Exponent für den Pattern (siehe graphics/gfxmacros/SetAfPt)
        NG_BFBACKPEN,   3,                      -> Hintergrundstift (nummer) für den Pattern
        NG_BFFRONTPEN,  2,                      -> Zeichenstift (Nummer) für den Pattern
        NG_PATTERNEXP,  1,                      -> Exponent für den Pattern
        NG_PATTERN1,    [$AAAA,$5555]:INT,      -> Muster (Pattern) für FILLPATTERN1
        NG_P1BACKPEN,   0,                      -> Hintergrundstift für das Patternfilling (Muster)
        NG_P1FRONTPEN,  0,                      -> Zeichenstift für das Muster (Patternfilling)
        NG_GUIID,       id,                     -> Gui-ID
        NG_GUI,                                 -> Oberflächenbeschreibung
                [ROWS,
                [BEVELR,
                [FILLPATTERN1,
                [ROWS,
                        [TEXT,'Example','Childwindow',TRUE,3]   -> Text ausgeben
                ]]],
                [BAR],
                [BEVELR,                        -> Einen Recessed Bevel um die Elemente
                [FILLPATTERN1,                  -> Außerdem mit dem FILLPATTERN1 hinterlegen!
                [EQCOLS,                        -> Und alle Elemente im Bevel nebeneinander, und ALLE gleich Breit (EQCOLS)
                        [SBUTTON,{test1},'Test1'],              -> Ein Button (SBUTTON = Variable Breite!)
                        [SBUTTON,{new},'Neues Fenster'],        -> Neues GUI öffnen!
                        [SBUTTON,{block},'Main - Blockieren'],  -> Ein Button (SBUTTON = Variable Breite!) -> Fenster blockieren!
                        [SBUTTON,{hide},'Main - Verstecken']]]]],-> Ein Button mit variabler Breite, außerdem ALLE verbleibenden Attribute schließen
        NIL,NIL])                               -> TagListe abschließen (normalerweise mit TAG_END)

    ng_setattrsA([NG_GUI,gui,                   -> GUI anhängen!
        NG_APPENDGUI,child,NIL,NIL])
  id++
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
 WriteF('\nRexx-Msg: "\s"',s)                   -> ARexx-String (s) ausgeben!

  mes:=NIL                                      -> Message auf NIL setzen
ENDPROC  StrCmp('QUIT',s),0,'Reply-Message'     -> Rückgabe! Format = BOOL,INT,STRING     (Beenden?,Returncode,Replystring)
