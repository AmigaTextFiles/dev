/* 
 *  Editor-Klasse (editorobj.m) Test 1.0                                              (03.12.1996)
 * -=================)-(================-
 * 
 * © 1996 THE DARK FRONTIER Softwareentwicklungen (Grundler Mathias)
 *
 */


OPT     OSVERSION       = 37            /* Erst ab Kick 37 lauffähig...                         */


MODULE  'classes/editorobj'             /* Die Editor-Klasse                                    */


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
 DEF    linecounter                     /* Zähler bis zur letzten Zeile durchlaufen lassen!     */,
        buffer[255]:STRING              /* Buffer für den Zeileninhalt                          */
  WriteF('File: "\s"\n\n',arg)          /* Filename ausgeben                                    */
   FOR linecounter:=0 TO editor.num-1   /* Bis die maximale Linienanzahl erreicht ist...        */
    editor.getline(linecounter,buffer)  /* Zeile holen...                                       */
     WriteF('\d[3]: \s\n',linecounter+1,buffer) /* Zeile (+Nummer) im CON:-Window ausgeben!     */
   ENDFOR                               /* Ende der Schleife (linecounter:=1 TO editor.num)     */
  WriteF('\n Total-Lines: \d Line insertet at: \d\n',linecounter,editor.num/2)  /* Anzahl der gesamten Zeilen ausgeben! */
ENDPROC                                 /* Ende der Prozedur (printtext)                        */

