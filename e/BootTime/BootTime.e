/* 
 *  BootTime - Bestimmt die Zeit die jedes einzelne Programm der
 *   StartUP-Sequence braucht...
 *
 *  © 1996 THE DARK FRONTIER Softwareentwicklungen (Grundler Mathias)
 *                      turrican@starbase.inka.de 
 * 
 */

MODULE  'exec/io'                               /* timerbase bestimmen...               */
MODULE  'devices/timer'                         /* Objekte...                           */
MODULE  'locale'                                /* Offsets der Locale.library           */
MODULE  'libraries/locale'                      /* Konstanten der locale.library        */
MODULE  'timer'                                 /* timer.device...                      */
MODULE  'tools/system'                          /* Systemkonfig...                      */
MODULE  'utility'                               /* Offsets der utility.library          */
MODULE  'utility/date'                          /* Konstanten und Objekte               */

ENUM    ERR_NONE                                /* es liegt KEIN fehler vor...          */,
        ERR_FILE                                /* Konnte File nicht öffnen...          */

RAISE   ERR_FILE IF Open()=NIL                  /* Wenn file nicht zu öffnen -> ERROR!  */

ENUM    LOC_ERR_PRE                             /* Error-Prefix                         */,
        LOC_ERR_SUF                             /* Error-Suffix...                      */,
        LOC_ERR_FILE                            /* Konnte file nicht öffnen!            */,
        LOC_COPYRIGHT                           /* Copyright ect...                     */,
        LOC_DATE                                /* Datum:                               */,
        LOC_CFG_CPU                             /* Prozessor    :                       */,
        LOC_CFG_FPU                             /* Co-Prozessor :                       */,
        LOC_CFG_KICK                            /* KickStart    :                       */,
        LOC_CFG_GFX                             /* Chipset      :                       */,
        LOC_CFG_ECS                             /* OCS/ECS                              */,
        LOC_CFG_AGA                             /* AGA                                  */,
        LOC_NO_SS                               /* Keine StartUP-Sequence ???           */

DEF     catalog=NIL                             /* PTR auf einen Locale-Catalog         */,
        file=NIL                                /* Filehandle des Protokolls...         */,
        clockdata:PTR TO clockdata              /* Für Amiga2Date (konvertierung!)      */,
        tr:PTR TO timerequest                   /* Aktuelles datum ect... des timer.dev */,
        tv:PTR TO timeval                       /* Aktuelle Systemzeit...               */

PROC main()     HANDLE                          /* Main-Prozedur                        */
 openall()                                      /* Alles öffnen...                      */
  openfile()                                    /* Filehandle öffnen...                 */
   calculatetime()                              /* Zeit berechnen und so..              */
EXCEPT DO                                       /* Exception-Handling                   */
 IF exception>0                                 /* Wenn eine Exception vorhanden ist... */
  writeC(LOC_ERR_PRE)                           /* Errorprefix ausgeben...              */
   SELECT exception                             /* Exception analysieren...             */
    CASE        ERR_FILE                        /* Konnte file nicht öffnen...          */
        writeC(LOC_ERR_FILE)                    /* Errormeldung ausgeben...             */
   ENDSELECT                                    /* Ende der Überprüfung... (exception)  */
  writeC(LOC_ERR_SUF)                           /* Errorsuffix ausgeben...              */
 ENDIF                                          /* Ende der Abfrage (exception>0)       */
  closeall()                                    /* Alles wieder schließen...            */
   closefile()                                  /* Filehandle wieder schließen...       */
    CleanUp(exception)                          /* Exception als Rückgabewert...        */
     VOID('$VER: BootTime 1.0 (27.09.1996) © 1996 THE DARK FRONTIER')   /*Versionsstring*/
ENDPROC                                         /* Ende des Programmes...               */

PROC openall()                                  /* Alles öffnen...                      */
 IF (localebase:=OpenLibrary('locale.library',37))=NIL  /* Localelibrary öffnen!        */
  catalog:=NIL                                  /* Catalogptr auf NIL setzen!           */
 ELSE                                           /* Falls nicht                          */
  IF (catalog:=OpenCatalogA(NIL,'boottime.catalog',
       [OC_BUILTINLANGUAGE,     'deutsch',
        OC_VERSION,             1]))            /* Catalog öffnen...                    */
  ELSE                                          /* Wenn catalog nicht da ist...         */
   CloseLibrary(localebase)                     /* Locale.library schließen...          */
    catalog:=NIL                                /* PTR auf NIL                          */
  ENDIF                                         /* Ende der Abfrage ((catalog:=OpenCat.)*/
 ENDIF                                          /* Ende der Abfrage ((localebase:=Open.)*/
ENDPROC                                         /* Ende der Prozedur (openall)          */

PROC closeall()                                 /* Alles schließen...                   */
 IF (catalog<>NIL) THEN CloseCatalog(catalog)   /* Localecatalog schließen...           */
  IF (localebase<>NIL) THEN CloseLibrary(localebase)    /* Locale.library schließen...  */
ENDPROC                                         /* Ende der Prozedur (closeall)         */

PROC openfile()                                 /* Filehandle öffnen...                 */
 IF (file:=Open('ram:Boot-Protokoll.txt',NEWFILE))=NIL THEN Raise(ERR_FILE)     /* File öffnen mit Errorcheck           */
  writeP(getcatstr(LOC_COPYRIGHT))              /* Copyright ins file schreiben         */
ENDPROC                                         /* Ende der Prozedur (openfile)         */

PROC closefile()                                /* Filehandle schließen...              */
 IF (file<>NIL) THEN Close(file)                /* Filehandle schließen...              */
  file:=NIL                                     /* PTR auf NIL (Sicherheit!)            */
ENDPROC                                         /* Ende der Prozedur (closefile)        */

PROC calculatetime()                            /* Eigendliche Hauptroutine...          */
 DEF    bootfile=NIL                            /* Filehandle auf die StartUP-Sequence  */,
        buffer[128]:STRING                      /* Zwischenpuffer...                    */,
        time=0                                  /* Zeit in sekunden...                  */,
        timestr[6]:STRING                       /* Ausführungszeit...                   */,
        eof=$1                                  /* End of File...                       */
  IF (bootfile:=Open('s:StartUP-Sequence',OLDFILE))/* Wenn die StartUP-Sequence da ist..*/
   writedate()                                  /* datum ect... ins protokoll           */
    REPEAT                                      /* Wiederholen...                       */
     eof:=Fgets(bootfile,buffer,128)            /* Zeile holen, maximal 127 bytes+0-byte*/
      time:=gettime()                           /* Zeit holen...                        */
       IF eof>$00                               /* Wenn eof nocht nicht erreicht ist... */
        Execute(buffer,NIL,NIL)                 /* Zeile ausführen...                   */
         time:=gettime()-time                   /* Zeit zum ausführen berechnen...      */
          StringF(timestr,'\d[3]: ',time)       /* Zeit in einen String wandeln...      */
           writeP(timestr)                      /* String ins Protokoll...              */
            writeP(buffer)                      /* Zeile ins Protokoll...               */
       ENDIF                                    /* Ende der Abfrage (eof>$00)           */
    UNTIL eof=$00                               /* bis ende des Files...                */
   Close(bootfile)                              /* Filehandle wieder schließen!         */
  closedate()                                   /* Datum wieder schließen...            */
  ELSE                                          /* Keine StartUP-Sequence da????        */
   writeP(getcatstr(LOC_NO_SS))                 /* Meldung ins Protokoll schreiben      */
  ENDIF                                         /* File schließen...                    */
ENDPROC                                         /* Ende der Prozedur (calculatetime)    */

PROC gettime()                                  /* Zeit in sekunden...                  */
 DEF    time=0                                  /* Buffer für die Zeit in sekunden...   */
  GetSysTime(tv)                                /* zeit holen...                        */
   Amiga2Date(tv.secs,clockdata)                /* konvertieren...                      */
    time:=clockdata.min*60                      /* time = Minuten * 60 (in sekunden!)   */
     time:=time+clockdata.sec                   /* plus die sekunden...                 */
ENDPROC time                                    /* Ende der Prozedur (gettime)          */

PROC writeC(id)                                 /* Localisierte Zeile ausgeben...       */
 WriteF('\s',getcatstr(id))                     /* Localse-String holen und Ausgeben    */
ENDPROC                                         /* Ende der Prozedur (writeC)           */

PROC writeP(str)                                /* String ins Protokoll schreiben       */
 Write(file,str,StrLen(str))                    /* String schreiben, länge berechnen    */
ENDPROC                                         /* Ende der Prozedur (writeP)           */

PROC writedate()                                /* datum, Konfig ect. ins Protokoll     */
 DEF    date[11]:STRING                         /* Datum...                             */,
        config:PTR TO syskonfig                 /* systemkonfig...                      */
  IF (utilitybase:=OpenLibrary('utility.library',37))   /* Utility.library öffnen...    */
   NEW tr, tv, clockdata                        /* Objekte initialisieren...            */
    OpenDevice('timer.device',UNIT_VBLANK,tr,0) /* timer.device öffnen...       */
     timerbase:=tr.io.device                    /* Timebase bestimmen...                */
      GetSysTime(tv)                            /* Sytemzeit holen...                   */
      Amiga2Date(tv.secs, clockdata)            /* Umrechnen (konvertieren              */
     StringF(date,'\d[2].\d[2].\d[4]\n',clockdata.mday,clockdata.month,clockdata.year)  /* Datumsstr generieren */
  ENDIF                                         /* Ende der Abfrage ((utilitybase:=Ope.)*/
   writeP(getcatstr(LOC_DATE))                  /* Datum:                               */
    writeP(date)                                /* Datum ins Protokoll schreiben        */
     NEW config.check()                         /* Konfig checken lassen...             */
      writeP(getcatstr(LOC_CFG_CPU))            /* Prozessor    :                       */
       StringF(date,'\d\n',config.cpu)          /* Prozessor in den String kopieren...  */
        writeP(date)                            /* String ins File schreiben            */
      writeP(getcatstr(LOC_CFG_FPU))            /* Co-Prozessor :                       */
       StringF(date,'\d\n',config.fpu)          /* Co-Prozessor in den String kopieren. */
        writeP(date)                            /* String ins File schreiben            */
      writeP(getcatstr(LOC_CFG_KICK))           /* Kickstart    :                       */
       StringF(date,'\d\n',config.kick)         /* Kick-Version in den String kopieren. */
        writeP(date)                            /* String ins File schreiben            */
      writeP(getcatstr(LOC_CFG_GFX))            /* Chipset      :                       */
       IF config.gfx=TRUE                       /* ECS                                  */
        writeP(getcatstr(LOC_CFG_ECS))          /* ECS                                  */
       ELSE                                     /* Wenn net...                          */
        writeP(getcatstr(LOC_CFG_AGA))          /* AGA                                  */
       ENDIF                                    /* Ende der Abfrage (config.gfx=TRUE)   */
     END config                                 /* Speicher für das Objekt freigeben    */
ENDPROC                                         /* Ende der Prozedur (writedate)        */

PROC closedate()                                /* Devices/Libs wieder schließen...     */
    CloseDevice(tr)                             /* time.device schließen...             */
   END clockdata, tv, tr                        /* Speicher de Objekte wieder freigeben */
  IF utilitybase THEN CloseLibrary(utilitybase) /* utility.library schließen...         */
ENDPROC                                         /* Ende der Prozedur (closedate)        */

PROC getcatstr(id)                              /* Lokalisierten String holen...        */
 DEF    str                                     /* String zur Ablage...                 */
  IF (catalog=NIL)                              /* Wenn der Catalog nicht offen ist!    */
   SELECT id                                    /* id auswerten                         */
    CASE        LOC_ERR_PRE                     /* Error-Prefix                         */
        str:='Fehler: '
    CASE        LOC_ERR_SUF                     /* Error-Suffix...                      */
        str:='!\n'
    CASE        LOC_ERR_FILE                    /* Konnte file nicht öffnen!            */
        str:='Konnte das Protokollfile nicht öffnen'
    CASE        LOC_COPYRIGHT                   /* Das Copyright...                     */
        str:='                BootTime 1.0\n (c) 1996 THE DARK FRONTIER Softwareentwicklung\n              Grundler Mathias\n\n'
    CASE        LOC_DATE                        /* Datum:                               */
        str:='Datum        : '
    CASE        LOC_CFG_CPU                     /* Prozessor    :                       */
        str:='Prozessor    : '
    CASE        LOC_CFG_FPU                     /* Co-Prozessor :                       */
        str:='Co-Prozessor : '
    CASE        LOC_CFG_KICK                    /* KickStart    :                       */
        str:='KickStart    : '
    CASE        LOC_CFG_GFX                     /* Chipset      :                       */
        str:='Chipset      : '
    CASE        LOC_CFG_ECS                     /* OCS/ECS                              */
        str:='OCS/ECS\n'
    CASE        LOC_CFG_AGA                     /* AGA                                  */
        str:='AGA\n'
    CASE        LOC_NO_SS                       /* Keine StartUP-Sequence               */
        str:='Konnte die StartUP-Sequence nicht einlesen!\n'
   ENDSELECT                                    /* Ende der Auswertung (id)             */
  ELSE                                          /* Falls der Catalog offen ist!         */
   str:=GetCatalogStr(catalog,id,str)           /* String holen...                      */
  ENDIF                                         /* Ende der Abfrage ((catalog=NIL))     */
ENDPROC str                                     /* Ende der Prozedur (getcatstr)        */
