
/*************************************************************
*                                                            *
*     LocalE - Copyright © 17-Nov-1994 by Maik Schreiber     *
*     ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯     *
*  Maik Schreiber                                            *
*  Ruschvitzstraße 19                                        *
*  D-18528 Bergen                                            *
*  FR Germany (Europe)                                       *
*                                                            *
*************************************************************/


/*
** Heute möchte ich einmal demonstrieren, wie man in E einen Locale-Support er-
** zeugt. Dies geschieht am Beispiel eines einfachen Testprogramms. ACHTUNG:
** das Beispiel geht davon aus, daß in das Programm bereits eine bestimmte
** Sprache eingebaut ist.
*/


/*** Einbinden der benötigten Modules ***/
MODULE 'locale','libraries/locale'


/*** Festlegen der String-IDs ***
**
** Das Festlegen der String-IDs ist insofern notwendig, daß man jeden lokali-
** sierten String über eine leicht merkbare Kennung aufrufen kann. Es wird
** empfohlen, jede ID mit dem Präfix »LOC_« zu versehen. Ich selbst benutze
** folgendes Schema für die Kennungen:
**
**   LOC_<Rubrik>_<eigentlicher Text in Kurzform>
**
** Rubrik ist dabei eins der folgenden (man kann auch neue erfinden; ist ja nur
** eine Gedankenstütze):
**
**   MISC      verschiedens
**   MENU      Menü-String
**   REQGAD    String für Requester-Gadgets
**   REQBODY   String für Requester-Inhalt
**   GUI       String für Benutzeroberfläche
**
** So kann ich aus der Kennung »LOC_MENU_ABOUT« entnehmen, daß es sich um Menü-
** String dreht, der den Text »About ..« enthält.
*/
ENUM LOC_MISC_THISISATEST,
     LOC_MISC_GOODBYE
     /* ... */


/*** Festlegen von Variablen ***
**
** Hierbei ist besonders wichtig, daß catalog sofort beim Start auf NIL gesetzt
** wird. Läßt man das »=NIL« weg, kann dies im weiteren Programmablauf zum
** Absturz: konnte die locale.library nicht geöffnet werden, enthält catalog
** einen Zufallswert, obwohl kein Catalog geöffnet werden konnte.
*/
DEF catalog=NIL                 /* enthält die Adresse des Catalogs */


PROC main()
  /*
  ** Zuerst wird versucht, die locale.library zu öffnen. Gelingt dies, wird
  ** versucht, den gewünschten Catalog zu öffnen. Hierfür muß man natürlich den
  ** eigenen Catalognamen einsetzen. Es wird immer versucht, den Catalog zu
  ** öffnen, der der vom Anwender voreingestellten Sprache entspricht.
  */
  IF (localebase:=OpenLibrary('locale.library',38)) THEN catalog:=OpenCatalogA(NIL,'LocalE.catalog',NIL)

  /*
  ** Nun kann man die Strings bspw. ausgeben.
  */
  WriteF('\s\n\s\n',getcatstr(LOC_MISC_THISISATEST),getcatstr(LOC_MISC_GOODBYE))

  /*
  ** Das Programm ist zu Ende, wir geben alles frei. Zuerst wird getestet, ob
  ** catalog<>NIL ist, d.h. ein Catalog geöffnet werden konnte. Ist dies der
  ** Fall, wird der Catalog freigegeben. Nun wird überprüft, ob die locale.lib
  ** geöffnet werden konnte. Wenn ja, wird auch sie freigegeben.
  */
  IF catalog THEN CloseCatalog(catalog) /* Schließen des Catalogs */
  IF localebase THEN CloseLibrary(localebase)   /* Schließen der locale.lib */
ENDPROC


/*
** Dies ist die Prozedur, mit der Strings aus dem Catalog geholt werden. Man
** übergibt ihr einfach die Kennung des gewünschten Strings (s.o.).
*/
PROC getcatstr(id)
  /*
  ** Festlegen der Variable, die den Default-String enthält.
  */
  DEF str


  /*
  ** In diesem SELECT-ENDSELECT-Block wird für die gewünschte Kennung der
  ** (englische) Default-String festgelegt.
  */
  SELECT id
    CASE LOC_MISC_THISISATEST;   str:='This is a test.'
    CASE LOC_MISC_GOODBYE;       str:='Good bye.'
    /* ... */
  ENDSELECT


  /*
  ** Nun wird getestet, ob ein Catalog geöffnet werden konnte. Wenn ja, wird
  ** versucht, den gewünschten String aus dem Catalog zu holen. Dabei übergibt
  ** man gleichzeitig die Adresse des Default-Strings. Ist der gewünschte
  ** String nicht im Catalog vorhanden, erhält man diese Adresse zurück.
  */
  IF catalog THEN str:=GetCatalogStr(catalog,id,str)


/*
** Schließlich und endlich übergibt man die Adresse des Strings.
*/
ENDPROC str

