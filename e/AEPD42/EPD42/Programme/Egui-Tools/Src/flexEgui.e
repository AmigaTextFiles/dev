/*
 *      Demo eines Flexiblen GUI`s unter EasyGUI
 *    -========================================-
 *      © 1996 TurricaN from THE DARK FRONTIER
 */

OPT     OSVERSION       =       37      -> Erst ab OS 2.x

MODULE  'tools/easygui'                 -> EasyGUI-Modul einbinden
-> MODULE  'tools/guitools'                -> EasyGUI-Zusatz einbinden (Nur wenn die Routinen benutzt werden!)

DEF     rows,                           -> Wert f¸r ROWS vordefinieren
        cols,                           -> Wert f¸r COLS vordefinieren
        eqrows,                         -> Wert f¸r EQROWS vordefinieren
        eqcols,                         -> Wert f¸r EQCOLS vordefinieren
        bevel,                          -> Wert f¸r BEVEL vordefinieren
        bevelr,                         -> Wert f¸r BEVELR vordefinieren
        space,                          -> Wert f¸r den Space
        multibutton,                    -> Um Buttons zu Addn...
        text                            -> F¸r die titelzeile


PROC main()                             -> Main-Prozedur...

 DEF    title                           -> Variable f¸r den Fenstertitel

-> Routine um alles vorzudefinieren!

 rows:=  ROWS  
 cols:=  COLS  
 eqrows:=EQROWS
 eqcols:=EQCOLS
 bevel:= BEVEL 
 bevelr:=BEVELR

-> Routine ende

  title:='Flex-GUI-Demo'

   multibutton:=[BUTTON,0,'Weiter']     -> Standartbutton...

    text:=[TEXT,'Test 1 - Normale werte','',FALSE,3]    -> Text festlegen!

     test(title)                        -> Test!

-> Routine um alles zu invertieren

 IF rows=ROWS THEN rows:=COLS ELSE rows:=ROWS
 IF cols=COLS THEN cols:=ROWS ELSE cols:=COLS
 IF eqrows=EQROWS THEN eqrows:=EQCOLS ELSE eqrows:=EQROWS
 IF eqcols=EQCOLS THEN eqcols:=EQROWS ELSE eqcols:=EQCOLS
 IF space=SPACEH THEN space:=SPACEV ELSE space:=SPACEH
 IF bevel=BEVEL THEN bevel:=BEVELR ELSE bevel:=BEVEL
 IF bevelr=BEVELR THEN bevelr:=BEVEL ELSE bevelr:=BEVELR

-> Routine ende

     multibutton:=[SBUTTON,1,'OK']      -> S-Button mit anderem R¸ckgabewert + anderem Text!

    text:=[TEXT,'Test 2 - Inverse werte','',FALSE,3]    -> Text2 festlegen!

   test(title)                          -> Test!

ENDPROC

PROC test(title)                        -> ALLGEMEINE (!) Testprozedur

 easygui(title,                         -> Easygui-Fenster mit dem Titel >title< ˆffnen...
        [rows,                          -> Variable f¸r ROWS
        [bevel,                         -> Variable f¸r COLS
        [rows,                          -> Variable f¸r ROWS
        [bevelr,                        -> Variable f¸r BEVELR
                text],                  -> Einen Text ausgeben
        [cols,                          -> Variable f¸r COLS
                multibutton,            -> Multibutton
                multibutton             -> Multibutton
        ]]]])                           -> Brav alle Klammer wieder schlieﬂen...:-)

ENDPROC
