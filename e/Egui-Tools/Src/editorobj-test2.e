/* 
 *  Editor-Klasse (editorobj.m) Test 1.0 (Version2)                                    (05.12.1996)
 * -=================)-(================-
 * 
 * © 1996 THE DARK FRONTIER Softwareentwicklungen (Grundler Mathias)
 *
 */


OPT     OSVERSION       = 37            /* Erst ab Kick 37 lauffähig...                         */


MODULE  'classes/editorobj'             /* Die Editor-Klasse                                    */
MODULE  'tools/easygui'                 /* Für die Oberfläche                                   */


ENUM    ERR_MEM=1                       /* Zu wenig Speicher!                                   */,
        ERR_FILE                        /* Falscher Filename angegeben                          */


DEF     editor:PTR TO editor            /* Variable die den Pointer auf die Klasse bekommt!     */


PROC main()     HANDLE                  /* Hauptprozedur mit Exception-Handlerdefinition        */
 openall()                              /* Alles öffnen                                         */
  loadtext()                            /* Text einladen                                        */
   modifytext()                         /* Eine Zeile einfügen :-)                              */
    printtext()                         /* Text ausgeben                                        */

EXCEPT DO                               /* Exceptionhandling... immer ausführen                 */
 closeall()                             /* Alles schließen                                      */
  IF exception                          /* Wenn eine Exception vorliegt                         */
   WriteF('Fehler: ')                   /* Fehlermeldung - HEAD (Kopfzeile, immer gleich!)      */
    SELECT exception                    /* Exception auswerten                                  */
     CASE  ERR_MEM                      /* Zu wenig Speicher vorhanden                          */
        WriteF('Zu wenig freier Speicher - INIT fehlgeschlagen!\n')     /* Errormeldung         */
     CASE  ERR_FILE                     /* Falscher/Kein Filename angegeben!                    */
        WriteF('Konnte das File "\s" nicht öffnen!\n',arg)              /* Errormeldung         */
    ENDSELECT                           /* Ende der Auswertung (exception)                      */
   VOID(' $VER: Editor-Class_Test 1.0 (03.12.1996) © THE DARK FRONTIER Softwareentwicklungen\n')
  ENDIF                                 /* Ende der Abfrage (exception)                         */
 CleanUp(exception)                     /* Mit exception als Returncode beenden!                */
ENDPROC                                 /* Ende des Programmes                                  */


PROC openall()                          /* Alles öffnen                                         */
 IF (NEW editor.init())=NIL THEN Raise(ERR_MEM) /* Editor-Klasse initialisieren (vorher speicher holen) */
ENDPROC                                 /* Ende der Prozedur (openall)                          */


PROC closeall()                         /* Alles wieder schließen                               */
 editor.exit()                          /* Die Klasse gibt nun den Zeilenspeicher frei....      */
  END editor                            /* Und den Speicher für die Klasse wieder freigeben!    */
ENDPROC                                 /* Ende der Prozedur (closeall)                         */


PROC loadtext()                         /* Text einladen                                        */
 DEF    file=NIL                        /* Filehandler...                                       */,
        buffer[255]:STRING              /* Buffer zum Einlesen des Strings                      */
  IF (file:=Open(arg,OLDFILE))=NIL THEN Raise(ERR_FILE) /* Fehlermeldung, wenn öffnen fehlgesch.*/
   WHILE (Fgets(file,buffer,256)<>NIL)  /* Solange bis das Fileende (EOF) erreicht ist lesen!   */
    editor.newline(buffer,StrLen(buffer))/* Zeile zur Editor-Klasse hinzufügen!                 */
   ENDWHILE                             /* Ende der Abfrage                                     */
  IF file THEN Close(file)              /* Handler wieder schließen!                            */
ENDPROC                                 /* Ende der Prozedur (loadtext)                         */


PROC modifytext()                       /* Eine Zeile einfügen...                               */
 DEF    num                             /* Zeilennummer wo die Zeile eingefügt werden soll      */,
        str[255]:STRING                 /* Zeile die eingefügt werden soll                      */
  num:=editor.num/2                     /* In die Mitte des Textes :-)                          */
   StringF(str,'EINGEFÜGTE ZEILE an Position \d\n',num)
    editor.insline(num,str,StrLen(str)) /* Zeile einfügen...                                    */
ENDPROC                                 /* Ende der Prozedur (modifytext)                       */


PROC printtext()                        /* Text ausgeben                                        */
easygui('Editor-Obj-Test_2',            /* EasyGUI-Oberfläche öffnen...                         */
        [ROWS,                          /* Alles untereinander...                               */
                [LISTV,{showline},'Text:',10,20,editor.getlist(),0,0,1] /* ListView zum anzeigen*/
        ])                              /* Und ende der Oberflächendefinition                   */
ENDPROC                                 /* Ende der Prozedur (printtext)                        */

PROC showline(a,b,c,linenum)            /* Zeigt die angeklickte Line an                        */
 DEF    buf[255]:STRING                 /* Buffer für den String                                */
  editor.getline(linenum,buf)           /* Zeile anhand der Zeilennummer holen                  */
   WriteF('\s\n',buf)                   /* Und ins CON: ausgeben                                */
ENDPROC                                 /* Ende der Prozedur (showline)                         */
