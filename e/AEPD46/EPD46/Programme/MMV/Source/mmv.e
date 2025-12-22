
   /* 
   **  :Program.       MMV - MuskiModuleVerwaltung
   **  :Version.       1.01, 05.07.1996
   **
   **  :Contents.      Dateiverwaltung für Soundmodule
   **  :Author.        Sebastian Erbert
   **  :Address.       Grünstraße 11, 12555 Berlin, GERMANY
   **  :Phone.         +49 -(0)30 / 6561635
   **  :E-Mail.        SEBluebird@aol.com
   **  :Copyright.     FreeWare
   **
   **  :Compiler.      EC 3.2e
   **  :Ecdemo.        '#define' bemängelt,  Programm zu groß
   **  :Imports.       nichts besonderes
   **
   **  :Support.       - reqtools.library von Nico Francois
   **                  - crm.library von Thomas Schwarz
   **                  - EasyGUI von Wouter van Oortmerssen
   **                  - 'qickSort' aus TurboPascal (von Ian Lin),
   **                    umgesetzt nach E (bzw. Assembler) - PD
   **
   **  :Bugs.          keine, jedenfalls soweit ich es weiß
   **
   **  :History.       - frühere unveröffentliche MaxonPascal Version
   **                  ----------------------------------------------
   **                  - V1.00 erste fertige Programmversion
   **                  -------------------------------------
   **                  - V1.01 Fehlerbereinigung und kleinere Erweiterungen
   **                  - Fehler in Sortierroutine beseitigt
   **                  - Fehler Laderoutine für Modules beseitigt
   **                  - größere Auswahl beim sortieren
   **                  - erweiterte Prefixerkennung bei der Datenübernahme
   **                    vom Eagleplayer
   **
   **  :Remark.        - ab V37, besser V39
   **                  - gadtools.library und reqtools.library (V38) nötig
   **                  - rexxsys.library und crm.library (demo) nötig
   **                  - mindestens 640x256 Screen, 1MB Ram stark empfohlen
   */


->  der Versionsstring ist ganz unten
->  Datum in der PROC about() auch drin
->  der Zeiger 'aktfeld' muß immer (!) auf den angezeigten Datensatz zeigen

OPT   OSVERSION=37
OPT   PREPROCESS
OPT   LARGE
OPT   REG=5


#define VERSION       'MusikModuleVerwaltung V1.01'
#define AREXXPORTNAME 'MMV_REXX'
#define MMV_HEADER    'MMV_DATA'
#define STATUS_NODATA 'Noch kein Datensatz vorhanden.'

MODULE  'tools/EasyGUI','dos/dos',
        'gadtools','libraries/gadtools',
        'reqtools','libraries/reqtools',
        'intuition/intuition','intuition/screens',
        'exec/memory','exec/tasks','exec/nodes','exec/ports',
        'exec/tasks','exec/io','graphics/text','graphics/view',
        'crm','libraries/crm','utility/tagitem',
        'rexxsyslib','rexx/storage','support/rexxcsupport',
        'icon','wb','workbench/workbench','workbench/startup',
        'protracker','devices/audio','graphics/gfxbase'

RAISE   "MEM"  IF CreatePool()=NIL,
        "PORT" IF CreateMsgPort()=NIL

CONST   DATGR=424,                    /* Größe des Object 'datei' */
        SAVEDATGR=424-12,             /* Größe der zu speichernden Daten */
        MAXLONG=$7FFFFFFF,            /* größter ganzzaliger positiver Wert */
        PUDDLESIZE=102400,            /* 100KB pro alloziiertem Poolblock */
        THRESHOLD=102200,
        ERR_TEMPLATE= 20,             /* Error - Codes für Crm.library */
        ERR_NOLIB   = 19,
        ERR_STRUCT  = 18,
        ERR_LOCK   = 17,
        ERR_NOFIBMEM= 16,
        ERR_NOFMEM  = 15,
        ERR_READ   = 14,
        ERR_CRUNCHFAIL=13,
        ERR_WRITE    = 12,
        ERR_FILE   = 11

        OBJECT datei
          name[72]:     ARRAY OF CHAR;     /*  Offset:   0 */
          format[72]:   ARRAY OF CHAR;     /*  Offset:  72 */
          prefix[24]:   ARRAY OF CHAR;     /*  Offset: 144 */
          author[52]:   ARRAY OF CHAR;     /*  Offset: 168 */
          dauer[32]:    ARRAY OF CHAR;     /*  Offset: 220 */
          laenge:       LONG;              /*  Offset: 252 */
          songdatasize: LONG;              /*  Offset: 256 */
          samples:      LONG;              /*  Offset: 260 */
          samplessize:  LONG;              /*  Offset: 264 */
          pfad[72]:     ARRAY OF CHAR;     /*  Offset: 268 */
          bemerkung[72]:ARRAY OF CHAR;     /*  Offset: 340 */
          nummer:       LONG;              /*  Offset: 412 */
          links:        PTR TO datei;      /*  Offset: 416 */
          rechts:       PTR TO datei;      /*  Offset: 420 */
        ENDOBJECT;                         /*  Size: 424 */

DEF     aktfeld=NIL:  PTR TO datei,       /* Hauptzeiger des Datenfeldes */
        helpfeld=NIL: PTR TO datei,       /* Hilfszeiger des Datenfeldes */
        aport=NIL:    PTR TO mp,          /* unser ARexx-Port */
        uport=NIL:    PTR TO mp,          /* unser Userport */
        task:         PTR TO tc,          /* unser Task */
        appwin=NIL:   PTR TO appwindow,   /* unser AppWindow */
        guigads=NIL,                      /* List mit Argumenten für guiinit */
        guimenu=NIL,                      /* List mit Argumenten für guiinit */
        gh=NIL:       PTR TO guihandle,   /* Zeiger auf das EasyGuiHandle */
        result=-1,                        /* Ergebnis der Wait-Funktion */
        pubscreen=NIL:PTR TO screen,      /* möglich Screen für unser Window */
        info=0,                           /* info für GuiHandle */
        anzahl=0:     LONG,               /* aktuelle Datensatzanzahl */
        mask:         LONG,               /* Signalmaske für Wait */
        sig:          LONG,               /* Ergebnis der Funktion Wait */
        pool=NIL:     PTR TO LONG,        /* Zeiger auf den Poolheader */
        modbuffer=NIL:PTR TO LONG,        /* Zeiger auf den Speicher eines event. geladenen Mods */
        play=0,                           /* Spielstatus */
        saveok=TRUE,                      /* Verlust verändert Daten testen */
        datareading=FALSE,                /* Datenübernahme über EaglePlayer ausgeschaltet */
        savename[200]:STRING,             /* Name des Datenfiles */
        g_str[200]:   STRING,             /* globaler String */
        g_var=0,                          /* globale Variable */
        sgad_name[72]:STRING,             /* Zeiger für die Stringgadgets */
        sgad_format[72]:STRING,
        sgad_prefix[24]:STRING,
        sgad_author[52]:STRING,
        sgad_dauer[32]:STRING,
        sgad_pfad[72]:STRING,
        sgad_bemerkung[72]:STRING,
        destport[31]: STRING,             /* Zielport für ARexx */
        cmdstr[91]:   STRING,             /* ARexx Kommando */
        gad_anzahl,                       /* Quasizeiger auf die Gadgets */
        gad_name,
        gad_format,
        gad_prefix,
        gad_author,
        gad_dauer,
        gad_laenge,
        gad_slaenge,
        gad_samples,
        gad_ssize,
        gad_pfad,
        gad_bemerkung,
        gad_nummer,
        gad_status

PROC main() HANDLE

  IF (reqtoolsbase:=OpenLibrary('reqtools.library',38))=NIL THEN Raise("RT");
  IF (rexxsysbase:=OpenLibrary('rexxsyslib.library',36))=NIL THEN Raise("LIB");
  -> gadtoolsbase ist NIL, wird aber von EasyGUI geöffnet
  aport:=CreateMsgPort();
  aport.ln.name:=AREXXPORTNAME;
  uport:=CreateMsgPort();
  uport.ln.name:='MMV';
  AddPort(uport);
  AddPort(aport);
  task:=FindTask(NIL);
  IF task THEN task.ln.name:='MMV';
  ScreenToFront(pubscreen);
  StrCopy(savename,'SYS:Kein Name');
  StrCopy(destport,'rexx_EP');
  StrCopy(cmdstr,'NextModule');

  guigads:=[EQROWS,
     [COLS,
      [EQROWS,[SBUTTON,{quit},'Ende'],    [SBUTTON,{more},'Erweitern']],
      [EQROWS,[SBUTTON,{load},'Laden'],   [SBUTTON,{insert},'Einfügen']],
      [EQROWS,[SBUTTON,{save},'Sichern'], [SBUTTON,{delete},'Löschen']],
      [EQROWS,[SBUTTON,{grafik},'Grafik'],[SBUTTON,{compare},'Vergleich']],
      [EQROWS,[SBUTTON,{allsize},'Länge'],[SBUTTON,{search},'Suchen']],
      [EQROWS,[SBUTTON,{print},'Drucken'],[SBUTTON,{sort},'Sortieren']]
     ],
     [BAR],
     [COLS,
      [COLS,
       gad_anzahl:=[TEXT,'0','Anzahl:',TRUE,6]
      ],
      [EQCOLS,
       [BUTTON,{cursorMaxLeft},'|<'],
       [BUTTON,{cursorTLeft},'<<<'],
       [BUTTON,{cursorDLeft},'<<'],
       [BUTTON,{cursorLeft},'<'],
       [BUTTON,{cursorRight},'>'],
       [BUTTON,{cursorDRight},'>>'],
       [BUTTON,{cursorTRight},'>>>'],
       [BUTTON,{cursorMaxRight},'>|']
      ]
     ],
     [BAR],
     [COLS,
      [BUTTON,{nothing},'NAME:'],
      gad_name:=[STR,{newName},NIL,sgad_name,70,6],
      [BUTTON,{nothing},'FORMAT:'],
      gad_format:=[STR,{newFormat},NIL,sgad_format,70,4]
     ],
     [COLS,
      [BUTTON,{nothing},'PREFIX:'],
      gad_prefix:=[STR,{newPrefix},NIL,sgad_prefix,22,3],
      [BUTTON,{nothing},'AUTOR:'],
      gad_author:=[STR,{newAuthor},NIL,sgad_author,50,5],
      [BUTTON,{nothing},'DAUER:'],
      gad_dauer:=[STR,{newDauer},NIL,sgad_dauer,30,3]
     ],
     [COLS,
      [BUTTON,{nothing},'GRÖßE:'],
      gad_laenge:=[INTEGER,{newLaenge},NIL,0,4],
      [BUTTON,{nothing},'SONGGRÖßE:'],
      gad_slaenge:=[INTEGER,{newSLaenge},NIL,0,4],
      [BUTTON,{nothing},'SAMPLES:'],
      gad_samples:=[INTEGER,{newSamples},NIL,0,3]
     ],
     [COLS,
      [BUTTON,{nothing},'SAMPLESSIZE:'],
      gad_ssize:=[INTEGER,{newSSize},NIL,0,2],
      [BUTTON,{nothing},'PFAD:'],
      gad_pfad:=[STR,{newPfad},NIL,sgad_pfad,70,6]
     ],
     [COLS,
      [BUTTON,{nothing},'BEMERKUNG:'],
      gad_bemerkung:=[STR,{newBemerkung},NIL,sgad_bemerkung,70,9],
      [BUTTON,{nothing},'NUMMER:'],
      gad_nummer:=[INTEGER,{newNummer},NIL,0,2]
     ],
     [BAR],
     [COLS,
      gad_status:=[TEXT,'Willkommen zu MMV!','STATUS: ',TRUE,2]
     ]
   ];

   guimenu:=[1,0,'Projekt',   0,0,0,0,
    2,0,'Über',               'ü',0,0,{about},
    2,0,NM_BARLABEL,          0,0,0,0,
    2,0,'Laden...',           'l',0,0,{load},
    2,0,'Anladen...',         'n',0,0,{loadOn},
    2,0,'Sichern',            's',0,0,{save},
    2,0,'Sichern als...',     'a',0,0,{saveAs},
    2,0,'Sichern von bis...', 'v',0,0,{saveFromTo},
    2,0,'Gepackt sichern...', 'p',0,0,{savePacked},
    2,0,'Iconisieren',        'i',0,0,{doIconfy},
    2,0,NM_BARLABEL,          0,0,0,0,
    2,0,'Datei löschen...',   'd',0,0,{deleteFile},
    2,0,NM_BARLABEL,          0,0,0,0,
    2,0,'Beenden',            'q',0,0,{quit},
    1,0,'Spezial',            0,0,0,0,
    2,0,'Externer Vergleich', 'x',0,0,{xcompare},
    2,0,NM_BARLABEL,          0,0,0,0,
    2,0,'Farbpalette',        'f',0,0,{palette},
    2,0,'Taskpriorität',      0,0,0,{taskPri},
    2,0,NM_BARLABEL,          0,0,0,0,
    2,0,'autom. Datenübernahme',0,CHECKIT,0,{switch},
    2,0,'Eagleplayer auslesen','e',0,0,{getInfos},
    2,0,NM_BARLABEL,          0,0,0,0,
    2,0,'Kaltstart',          'k',0,0,{coldReboot},
    1,0,'Musik',              0,0,0,0,
    2,0,'Laden...',           0,0,0,{loadMod},
    2,0,'Auswerfen',          0,0,0,{ejectMod},
    2,0,'Abspielen',          0,0,0,{playMod},
    2,0,'Stoppen',            0,0,0,{stopMod},
    2,0,NM_BARLABEL,          0,0,0,0,
    2,0,'aus Pfad spielen',   0,0,0,{playPfad},
    1,0,'ARexx',              0,0,0,0,
    2,0,'Port/Kommando...',   0,0,0,{newAPort},
    2,0,'Ausführen',          0,0,0,{doARexx},
    2,0,NM_BARLABEL,          0,0,0,0,
    2,0,'Script ausführen...',0,0,0,{doScript},
    0,0,0,0,0,0,0]:newmenu;

    IF (gh:=guiinit(VERSION,guigads,info,pubscreen,NIL,guimenu))=NIL THEN Raise("WIN");

    SetWindowTitles(gh.wnd,TRUE,savename);
    ->IF (appwin:=AddAppWindowA(0,NIL,gh.wnd,uport,NIL))=NIL THEN showStatus('Konnte kein AppWindow bekommen.');
    about();

    WHILE result<0
      mask:=Shl(1,aport.sigbit)
      mask:=(mask) OR (gh.sig) OR (Shl(1,uport.sigbit));
      sig:=Wait(mask);
      IF (sig) AND (Shl(1,aport.sigbit))
        handleRexxMsg();
      ELSEIF (sig) AND (gh.sig)
        result:=guimessage(gh);
      ELSEIF (sig) AND (Shl(1,uport.sigbit))
        handleMsg();
      ENDIF
    ENDWHILE


EXCEPT DO

  IF (wbmessage=NIL)  -> von der Shell gestartet
    SELECT exception
      CASE "RT";   PrintF('Konnte "reqtools.library" V38 nicht öffnen.\n');
      CASE "LIB";  PrintF('Konnte Library nicht öffnen.\n');
      CASE "MEM";  PrintF('Kein Speicher mehr.\n');
      CASE "WIN";  PrintF('Konnte kein Fenster öffnen.\n');
      CASE "PORT"; PrintF('Konnte keine MsgPort kreieren.\n');
      CASE "GT";   PrintF('Konnte "gadtools.library" nicht öffnen.\n');
      CASE "GUI";  PrintF('Eine Design-Funktion schlug fehl.\n');
      CASE "bigg"; PrintF('Der Screen ist zu klein.\n');
      CASE "Egui"; PrintF('Konnte das Design nicht erstellen.\n');
    ENDSELECT;
  ELSE
    SELECT exception  -> von der WB gestartet
      CASE "RT";   EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MMV- Meldung','Konnte "reqtools.library V38" nicht öffnen.','Okay'],0,NIL);
      CASE "LIB";  EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MMV- Meldung','Konnte Library nicht öffnen.','Okay'],0,NIL);
      CASE "MEM";  EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MMV- Meldung','Nicht genug Speicher frei.','Okay'],0,NIL);
      CASE "WIN";  EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MMV- Meldung','Konnte kein Fenster öffnen.','Okay'],0,NIL);
      CASE "PORT"; EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MMV- Meldung','Konnte keinen MsgPort kreieren.','Okay'],0,NIL);
      CASE "GT";   EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MMV- Meldung','Konnte "gadtools.library" nicht öffnen.','Okay'],0,NIL);
      CASE "GUI";  EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MMV- Meldung','Eine Design-Funktion schlug fehl.','Okay'],0,NIL);
      CASE "bigg"; EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MMV- Meldung','Der Screen ist zu klein.','Okay'],0,NIL);
      CASE "Egui"; EasyRequestArgs(NIL,[SIZEOF easystruct,0,'MMV- Meldung','Konnte das Design nicht erstellen.','Okay'],0,NIL);
    ENDSELECT;
  ENDIF

  IF appwin THEN RemoveAppWindow(appwin);
  IF gh THEN cleangui(gh);
  IF pool THEN DeletePool(pool);
  IF play THEN Mt_StopInt();
  IF modbuffer THEN FreeVec(modbuffer);
  IF uport
    RemPort(uport);
    DeleteMsgPort(uport);
  ENDIF
  IF aport
    RemPort(aport);
    DeleteMsgPort(aport);
  ENDIF
  IF ptbase THEN CloseLibrary(ptbase);
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase);
  IF rexxsysbase THEN CloseLibrary(rexxsysbase);
  ReThrow();

ENDPROC;

/*----- Beendet das Program nach vorheriger Abfrage  ----------------*/
PROC quit();
 DEF wahl

  IF saveok
    IF RtEZRequestA('Wirklich beenden ?',' JA |NEIN', NIL, NIL,
                    [RTEZ_FLAGS,EZREQF_CENTERTEXT,
                     RTEZ_REQTITLE,'MMV - Ende',
                     RTEZ_DEFAULTRESPONSE,1,
                     RT_WINDOW,gh.wnd,
                     RT_WAITPOINTER,TRUE,
                     RT_LOCKWINDOW,TRUE,
                     RT_SCREEN,pubscreen,
                     RT_REQPOS,REQPOS_POINTER,
                     TAG_DONE])=REQ_OK THEN Raise('quit');
  ELSE
    wahl:=RtEZRequestA('Daten noch nicht gesichert.\n'+
                       'Wollen Sie erst speichern unter\n'+
                       '''%s'' ?',' JA |Zurück|NEIN', NIL, [savename],
                       [RTEZ_FLAGS,EZREQF_CENTERTEXT,
                        RTEZ_REQTITLE,'MMV - Ende',
                        RTEZ_DEFAULTRESPONSE,1,
                        RT_WINDOW,gh.wnd,
                        RT_WAITPOINTER,TRUE,
                        RT_LOCKWINDOW,TRUE,
                        RT_SCREEN,pubscreen,
                        RT_REQPOS,REQPOS_POINTER,
                        TAG_DONE]);
    SELECT wahl
      CASE REQ_OK;  save();
                    Raise('quit');

      CASE 2;       showStatus('Willkommen zurück.');

      CASE 0;       Raise('quit');
    ENDSELECT
  ENDIF
ENDPROC
/*-------------------------------------------------------------------*/

/*-----  Speicher für Element anfordern  ----------------------------*/
PROC fNewFeld() IS AllocPooled(pool,DATGR);
/*-------------------------------------------------------------------*/

/*-----  Speicher für Element freigeben -----------------------------*/
PROC fDisposeFeld(memptr) IS FreePooled(pool,memptr,DATGR);
/*-------------------------------------------------------------------*/

/*-----  Text im Statusfeld anzeeigen  ------------------------------*/
PROC showStatus(s) IS settext(gh,gad_status,s);
/*-------------------------------------------------------------------*/

/*-----  das erste Feldelement finden  ----------------------------  */
PROC findFirstNode(datenfeld: PTR TO datei);

  IF datenfeld<>NIL THEN WHILE datenfeld.links<>NIL DO datenfeld:=datenfeld.links;
ENDPROC datenfeld;
/*-------------------------------------------------------------------*/

/*-----  ein Feldelement mit einer bestimmten Nummer suchen  --------*/
PROC setDataPointer(zahl: LONG, datenfeld: PTR TO datei);
 DEF dummy: PTR TO datei;

   dummy:=datenfeld;
   IF datenfeld.rechts<>NIL
    REPEAT
     IF datenfeld.nummer<>zahl THEN datenfeld:=datenfeld.rechts;
    UNTIL (datenfeld.rechts=NIL) OR (datenfeld.nummer=zahl);
   ENDIF
   IF datenfeld.nummer<>zahl
    datenfeld:=dummy.links;
    REPEAT
     IF datenfeld.nummer<>zahl THEN datenfeld:=datenfeld.links;
    UNTIL (datenfeld.links=NIL) OR (datenfeld.nummer=zahl);
   ENDIF
ENDPROC datenfeld;

/*-----  zeigt ein kleines Inforequester  --------------------------*/
PROC about();
  RtEZRequestA(VERSION+'\n© Copyright 1996 Sebastian Erbert\n'+
              '-------------------------\n'+
              'Geschrieben mit Amiga-E V3.2e\n'+
              'GUI erstellt mit EasyGUI © W. v. Oortmerssen\n'+
              'reqtools.library © Nico Francois\n'+
              'crm.library © Thomas Schwarz\n'+
              'protracker.library © Psilocybe Software\n'+
              'Compiliert: 05.07.1996\n'+
              '-------------------------\n'+
              'ARexx:  '+AREXXPORTNAME,
              '  OK  ', NIL, NIL, [RTEZ_FLAGS,EZREQF_CENTERTEXT,
                                   RTEZ_REQTITLE,'MMV - About',
                                   RTEZ_DEFAULTRESPONSE,1,
                                   RT_WINDOW,gh.wnd,
                                   RT_WAITPOINTER,TRUE,
                                   RT_LOCKWINDOW,TRUE,
                                   RT_SCREEN,pubscreen,
                                   RT_REQPOS,REQPOS_POINTER,
                                   TAG_DONE]);
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  zeigt die aktuelle Datenanzahl an  -------------------------*/
PROC showAnzahl(wert) IS settext(gh,gad_anzahl,longToStr(wert));
/*-------------------------------------------------------------------*/

/*----- zeigt das gewünschte Element an  ----------------------------*/
PROC showElement(nummer);

  IF checkData()
    IF nummer>anzahl THEN nummer:=anzahl;
    IF nummer<=0 THEN nummer:=1;
    IF aktfeld.nummer<>nummer THEN aktfeld:=setDataPointer(nummer,aktfeld);
    setstr(gh,gad_name,aktfeld.name);
    setstr(gh,gad_format,aktfeld.format);
    setstr(gh,gad_prefix,aktfeld.prefix);
    setstr(gh,gad_author,aktfeld.author);
    setstr(gh,gad_dauer,aktfeld.dauer);
    setinteger(gh,gad_laenge,aktfeld.laenge);
    setinteger(gh,gad_slaenge,aktfeld.songdatasize);
    setinteger(gh,gad_samples,aktfeld.samples);
    setinteger(gh,gad_ssize,aktfeld.samplessize);
    setstr(gh,gad_pfad,aktfeld.pfad);
    setstr(gh,gad_bemerkung,aktfeld.bemerkung);
    setinteger(gh,gad_nummer,aktfeld.nummer);
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*----- bewirkt einen Kaltstart des Rechners  -----------------------*/
PROC coldReboot();

  IF RtEZRequestA('Rechner wirklich neu starten ?','  JA  |NEIN',NIL,NIL,
                  [RTEZ_REQTITLE,'MMV - Neustart',
                   RT_WINDOW,gh.wnd,
                   RT_WAITPOINTER,TRUE,
                   RT_LOCKWINDOW,TRUE,
                   TAG_DONE]) THEN ColdReboot();

ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  lädt neu Daten dazu  ---------------------------------------*/
PROC loadOn();
 DEF oldstatus

  oldstatus:=saveok;
  saveok:=TRUE;
  load(1);      -> alte Daten nicht löschen
  saveok:=oldstatus;
ENDPROC
/*-------------------------------------------------------------------*/

/*-----  entpackt die Daten  ----------------------------------------*/
PROC depackfile();    -> MMV-Header steht nach Entpacken am Ende
 DEF addr=NIL,filehandle=0,oldsize=0,newsize=0,pdata=NIL,unpdata=NIL,
     datenkopf=NIL:PTR TO dataheader

 IF (crmbase:=OpenLibrary('CrM.library',CRMVERSION))
  RtSetWaitPointer(gh.wnd);
  oldsize:=FileLength(savename);
  IF (pdata:=AllocVec(oldsize,MEMF_CLEAR))<>NIL
    IF (filehandle:=Open(savename,MODE_OLDFILE))
      Read(filehandle,pdata,oldsize);
      Close(filehandle);
      datenkopf:=pdata;
      newsize:=datenkopf.originallen+datenkopf.minsecdist;
      IF (unpdata:=AllocVec(newsize,MEMF_CLEAR))
        showStatus('Entpacke die Datei...');
        addr:=CmDecrunch((pdata+14),unpdata,datenkopf);
        IF addr
          IF StrCmp(unpdata+newsize-8,'MMV',3)
            makeData(addr,Div((newsize-8),SAVEDATGR));
            FreeVec(addr);
            showStatus('Fertig.');
            showElement(anzahl);
          ELSE
            showStatus('Keine MMV-Datei.');
          ENDIF
        ELSE
          showStatus('Fehler beim Entpacken.');
        ENDIF
      ELSE
        showStatus('Zu wenig Speicher frei.');
      ENDIF
    ELSE
      showStatus('Fehler beim Öffnen der Datei');
    ENDIF
    FreeVec(pdata);
  ELSE
    showStatus('Zu wenig Speicher.');
  ENDIF
  CloseLibrary(crmbase);
  ClearPointer(gh.wnd);
 ELSE
  showStatus('Konnte "CrM.library V2" nicht öffnen.');
 ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  ermittelt einen neuen Datennamen ---------------------------*/
PROC getFilename(titel,check=TRUE);
 DEF ss[200]:STRING,es,s[80]:STRING,erg=TRUE,ret,ts[200]:STRING,
     filereq:PTR TO rtfilerequester,filehandle,wahl

  StrCopy(ts,savename);
  IF titel=NIL
    titel:=String(25);
    StrCopy(titel,'MMV - Filerequester');
  ENDIF
  filereq:=RtAllocRequestA(RT_FILEREQ,NIL);
  IF filereq
    es:=PathPart(ts);
    StrCopy(s,ts,EstrLen(savename)-StrLen(es));
    RtChangeReqAttrA(filereq,[RTFI_DIR,s,TAG_DONE]);
    StrCopy(s,FilePart(ts));
    ret:=RtFileRequestA(filereq,s,titel,
                       [RT_WINDOW,gh.wnd,
                        RT_WAITPOINTER,TRUE,
                        RT_LOCKWINDOW,TRUE,
                        TAG_DONE]);
    IF ret
      StrCopy(ss,filereq.dir);
      AddPart(ss,s,200)   -> ss ist kein E-String mehr
      StrCopy(ts,ss);
      IF check
        filehandle:=Lock(ts,SHARED_LOCK);
        IF filehandle<>0
          wahl:=RtEZRequestA('Datei ''%s'' existiert schon.\n'+
                                  'Wollen Sie ersetzen ?',
                                  '  JA  |Neuer Name...| NEIN ',NIL,[ts],
                                  [RTEZ_REQTITLE,'MMV - Achtung',
                                   RTEZ_FLAGS,EZREQF_NORETURNKEY OR EZREQF_CENTERTEXT,
                                   RT_WINDOW,gh.wnd,
                                   RT_WAITPOINTER,TRUE,
                                   RT_LOCKWINDOW,TRUE,
                                   TAG_DONE]);
          UnLock(filehandle);
          IF wahl=0 THEN erg:=FALSE;
          IF wahl=1 THEN StrCopy(savename,ts);
          IF wahl=2 THEN getFilename(titel);
        ENDIF
      ENDIF
    StrCopy(savename,ts);
    ELSE
      erg:=FALSE;
    ENDIF
  ELSE
    erg:=FALSE;
  ENDIF
ENDPROC erg;
/*-------------------------------------------------------------------*/

/*-----  erstellt die doppelt verkettete Liste  ---------------------*/
PROC makeData(wo:PTR TO LONG,wieviel);
 DEF x

  IF pool=NIL THEN pool:=CreatePool(MEMF_CLEAR,PUDDLESIZE,THRESHOLD);
  helpfeld:=fNewFeld();
  IF helpfeld
    CopyMemQuick(wo,helpfeld,SAVEDATGR);
    INC anzahl;
    helpfeld.nummer:=anzahl;
    helpfeld.rechts:=NIL;
    helpfeld.links:=aktfeld;
    IF aktfeld<>NIL THEN aktfeld.rechts:=helpfeld;
    aktfeld:=helpfeld;
  ELSE
    DisplayBeep(NIL);
    showStatus('Kein Speicher mehr.');
  ENDIF
  IF helpfeld
    FOR x:=2 TO wieviel
      helpfeld:=fNewFeld();
      IF helpfeld
        CopyMemQuick(wo:=wo+SAVEDATGR,helpfeld,SAVEDATGR);
        INC anzahl;
        helpfeld.nummer:=anzahl;
        helpfeld.rechts:=NIL;
        helpfeld.links:=aktfeld;
        aktfeld.rechts:=helpfeld;
        aktfeld:=helpfeld;
      ELSE
        showStatus('Kein Speicher mehr.');
      ENDIF
    ENDFOR
    IF aktfeld<>NIL
      showAnzahl(anzahl);
      saveok:=TRUE;
    ENDIF
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  lädt neue Daten  -------------------------------------------*/
PROC load(info);
 DEF ret,filereq: PTR TO rtfilerequester, x=0, filehandle,
      ss[200]: STRING, s[80]:STRING, es, oldname[200]: STRING,
      header[6]:STRING, buffer, y, z

  IF saveok=FALSE
    x:=RtEZRequestA('Achtung, die vorhandenen Daten gehen verloren.\n'+
                    'Wollen Sie erst speichern unter\n ''%s'' ?',
                    ' JA |Zurück|NEIN', NIL, [savename],
                    [RTEZ_REQTITLE,'MMV - Laden',
                     RTEZ_FLAGS,EZREQF_CENTERTEXT,
                     RT_WINDOW,gh.wnd,
                     RT_WAITPOINTER,TRUE,
                     RT_LOCKWINDOW,TRUE,
                     TAG_DONE]);
    IF x=1 THEN save();
  ENDIF

  IF (saveok) OR (x=0)
    filereq:=RtAllocRequestA(RT_FILEREQ,NIL);
    IF filereq
      StrCopy(oldname,savename);
      es:=PathPart(savename);
      StrCopy(s,savename,EstrLen(savename)-StrLen(es));
      RtChangeReqAttrA(filereq,[RTFI_DIR,s,TAG_DONE]);
      StrCopy(s,FilePart(savename));
      ret:=RtFileRequestA(filereq,s,'MMV - Laden',
                         [RT_WINDOW,gh.wnd,
                          RT_WAITPOINTER,TRUE,
                          RT_LOCKWINDOW,TRUE,
                          TAG_DONE]);
      IF ret
        StrCopy(ss,filereq.dir);
        AddPart(ss,s,200)   -> ss ist kein E-String mehr
        StrCopy(savename,ss);
        filehandle:=Open(savename,MODE_OLDFILE);
        IF filehandle
          Fgets(filehandle,header,5);
          Close(filehandle);
          IF StrCmp(header,'CrM2',4)
            IF (aktfeld) AND (info=0)
              showStatus('Lösche alte Daten...');
              DeletePool(pool);
              pool:=NIL;  -> ce la very importante (zu deutsch: oberwichtig)
              anzahl:=0;
              aktfeld:=NIL;
            ENDIF
            depackfile();
          ELSEIF StrCmp(header,'MMV',3)
            IF (aktfeld) AND (info=0)
              showStatus('Lösche alte Daten...');
              DeletePool(pool);
                pool:=NIL;  -> ce la very importante (zu deutsch: oberwichtig)
                anzahl:=0;
                aktfeld:=NIL;
            ENDIF
            x:=FileLength(savename);
            IF (buffer:=AllocVec(x+x+(((x-8)/412)*12),MEMF_CLEAR))
              FreeVec(buffer);
              buffer:=AllocVec(x-8,MEMF_CLEAR);
              filehandle:=Open(savename,MODE_OLDFILE);
              showStatus('Lese Daten...');
              Seek(filehandle,8,OFFSET_BEGINNING);  -> nicht den Header mitlesen
              Read(filehandle,buffer,x-8);
              RtSetWaitPointer(gh.wnd);
              showStatus('Bereite Daten auf...');
              makeData(buffer,Div((x-8),SAVEDATGR));
              showElement(aktfeld.nummer);
              showStatus('Fertig.');
              ClearPointer(gh.wnd);
              FreeVec(buffer);
            ELSEIF (buffer:=AllocVec(10300,MEMF_CLEAR))
              RtSetWaitPointer(gh.wnd);
              filehandle:=Open(savename,MODE_OLDFILE);
              showStatus('Lese Daten...');
              Seek(filehandle,8,OFFSET_BEGINNING);  -> nicht den Header mitlesen
              x:=Div(x-8,SAVEDATGR);
              showStatus('Bereite Daten auf...');
              FOR z:=1 TO Div(x,25)
                Read(filehandle,buffer,10300);
                makeData(buffer,25);
              ENDFOR
              showElement(aktfeld.nummer);
              showStatus('Fertig.');
              IF Mod(x,25)<>0
                y:=Div(x,25)*25;
                x:=x-y;
                Read(filehandle,buffer,x*SAVEDATGR);
                makeData(buffer,x);
              ENDIF
              ClearPointer(gh.wnd);
            ELSE
              showStatus('Zu wenig Speicher zum Laden und Aufbereiten.');
            ENDIF
            Close(filehandle);
          ELSE
            showStatus('Keine MMV-Datei.');
          ENDIF
        ELSE
          showStatus('Konnte Datei nicht öffnen.');
          StrCopy(savename,oldname);
        ENDIF
      ELSE
        showStatus('Laden abgebrochen.');
      ENDIF
      RtFreeRequest(filereq);
    ELSE
      showStatus('Kein Speicher für Filerequester.');
    ENDIF
  ENDIF
  SetWindowTitles(gh.wnd,TRUE,savename);
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  sichert die Daten in dem in 'savename' enthaltenden Namen ab*/
PROC save();
 DEF erg=DOSTRUE,size,buffer=NIL: PTR TO LONG,x,y,filehandle

  IF (aktfeld) AND (anzahl>0)
    helpfeld:=aktfeld;
    showStatus('Aufbereitung der Daten...');
    aktfeld:=findFirstNode(aktfeld);
    size:=Mul(anzahl,SAVEDATGR);  -> nur die wichtigen Daten
    IF (buffer:=AllocVec(size,MEMF_CLEAR))
      FOR x:=0 TO anzahl-1
        CopyMemQuick(aktfeld,x*SAVEDATGR+buffer,SAVEDATGR);
        aktfeld:=aktfeld.rechts;
      ENDFOR
      aktfeld:=helpfeld;
      -> die Nummern und Verkettungszeiger brauchen nicht abgespeichert werden

      filehandle:=Open(savename,MODE_NEWFILE);
      erg:=IoErr();   -> wenn Null, dann kein Fehler
      IF (erg=ERROR_OBJECT_EXISTS) OR (erg=0) THEN erg:=DOSTRUE;   -> überschreiben einfach machen
      IF filehandle
        Fputs(filehandle,MMV_HEADER);
        Seek(filehandle,0,OFFSET_END);
        IF Write(filehandle,buffer,size)<>size THEN showStatus('Fehler beim Schreiben der Daten.');
        Close(filehandle);
        saveok:=TRUE;
        showStatus('Datei abgespeichert.');
      ELSE
        erg:=DOSFALSE;
      ENDIF
    ELSEIF (buffer:=AllocVec(10300,MEMF_CLEAR))
      showStatus('Aufbereitung und Speicherung...');
      size:=Div(anzahl,25);
      filehandle:=Open(savename,MODE_NEWFILE);
      erg:=IoErr();
      IF (erg=ERROR_OBJECT_EXISTS) OR (erg=0) THEN erg:=DOSTRUE;
      IF filehandle
        Fputs(filehandle,MMV_HEADER);
        Seek(filehandle,0,OFFSET_END);
        FOR x:=1 TO size
          FOR y:=0 TO 24
            CopyMemQuick(aktfeld,buffer+(y*SAVEDATGR),SAVEDATGR);
            aktfeld:=aktfeld.rechts;
          ENDFOR
          IF Write(filehandle,buffer,10300)<>10300 THEN showStatus('Fehler beim Schreiben der Daten.');
        ENDFOR
        x:=-1;
        IF Mod(anzahl,25)<>0
          REPEAT
            INC x;
            CopyMemQuick(aktfeld,buffer+(x*SAVEDATGR),SAVEDATGR);
            IF Write(filehandle,buffer,SAVEDATGR)<>SAVEDATGR THEN showStatus('Fehler beim Schreiben der Daten.');
            aktfeld:=aktfeld.rechts;
          UNTIL aktfeld=NIL;
        ENDIF
        Close(filehandle);
        saveok:=TRUE;
        showStatus('Datei abgespeichert.');
      ELSE
        erg:=DOSFALSE;
      ENDIF
    ELSE
      erg:=DOSFALSE;
    ENDIF
    FreeVec(buffer);
    aktfeld:=helpfeld;
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC erg;
/*-------------------------------------------------------------------*/

/*-----  fragt nach einem Namen und ruft 'save()' auf  --------------*/
PROC saveAs();
  IF checkData()
    IF getFilename('MMV - Speichern')
      save();
      SetWindowTitles(gh.wnd,TRUE,savename);
    ELSE
      showStatus('Filerequester abgebrochen.');
    ENDIF
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  speichert nur bestimmte Daten ab  --------------------------*/
PROC saveFromTo();
 DEF von=1,bis,x,filehandle,buffer,menge

  IF (checkData()) AND (anzahl>2)
    IF getFilename('MMV - Speichern')

      IF RtGetLongA({von},'MMV - Speichern', NIL,[RT_WINDOW,gh.wnd,
                                           RT_WAITPOINTER,TRUE,
                                         RT_LOCKWINDOW,TRUE,
                                         RTGL_FLAGS,GSREQF_CENTERTEXT,
                                         RTGL_MIN, 1,
                                         RTGL_MAX, anzahl-1,
                                         TAG_DONE])
        bis:=anzahl;
        IF RtGetLongA({bis},'MMV - Speichern', NIL,[RT_WINDOW,gh.wnd,
                                         RT_WAITPOINTER,TRUE,
                                         RT_LOCKWINDOW,TRUE,
                                         RTGL_FLAGS,GSREQF_CENTERTEXT,
                                         RTGL_MIN, von,
                                         RTGL_MAX, anzahl,
                                         TAG_DONE])
          IF (buffer:=AllocVec(menge:=Mul(bis-von+1,SAVEDATGR),MEMF_CLEAR))<>NIL
            helpfeld:=aktfeld;
            aktfeld:=setDataPointer(von,aktfeld);
            FOR x:=von TO bis
              CopyMemQuick(aktfeld,(x-von)*SAVEDATGR+buffer,SAVEDATGR);
              aktfeld:=aktfeld.rechts;
            ENDFOR
            aktfeld:=helpfeld;
            filehandle:=Open(savename,MODE_NEWFILE);
            IF filehandle
              Fputs(filehandle,MMV_HEADER);
              Seek(filehandle,0,OFFSET_END);
              IF Write(filehandle,buffer,menge)<>menge THEN showStatus('Fehler beim Schreiben der Daten.');
              Close(filehandle);
              showStatus('Datei abgespeichert.');
            ELSE
              showStatus('Fehler beim Speichern.');
            ENDIF
            FreeVec(buffer);
          ELSE
            showStatus('Nicht genug Speicher für Datensicherung.');
          ENDIF
        ELSE
          showStatus('Abgebrochen.');
        ENDIF
      ELSE
        showStatus('Abgebrochen.');
      ENDIF
    ELSE
      showStatus('Abgebrochen.');
    ENDIF
  ELSE
    showStatus('Zu wenig Daten vorhanden.');
  ENDIF
  SetWindowTitles(gh.wnd,TRUE,savename);
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  speichert die Daten gepackt ab  ----------------------------*/
PROC savePacked();
 DEF size,buffer,x,cinfo:PTR TO crunchstruct,datenkopf,crunlen,
     filehandle

 IF (crmbase:=OpenLibrary('CrM.library',CRMVERSION))
  IF checkData()
    IF getFilename('MMV - Speichern')
      SetWindowTitles(gh.wnd,TRUE,savename);
      helpfeld:=aktfeld;
      RtSetWaitPointer(gh.wnd);
      size:=Mul(anzahl,SAVEDATGR);
      size:=size+8;   -> Platz für den MMV-Header
      IF (buffer:=AllocVec(size,MEMF_CLEAR))
        aktfeld:=findFirstNode(aktfeld);
        FOR x:=0 TO anzahl-1
          CopyMemQuick(aktfeld,x*SAVEDATGR+buffer,SAVEDATGR);
          aktfeld:=aktfeld.rechts;
        ENDFOR
        CopyMemQuick(MMV_HEADER,buffer+size-8,8);
        aktfeld:=helpfeld;
        cinfo:=CmProcessCrunchStructA(NIL,CM_ALLOCSTRUCT,
                                     [CMCS_ALGO,CM_LZH OR CMF_LEDFLASH,
                                      CMCS_OFFSET,$7FFE,
                                      CMCS_HUFFSIZE,16,
                                      TAG_DONE]);

        IF (cinfo<>NIL) AND (datenkopf:=AllocPooled(pool,SIZEOF dataheader))
          datenkopf:=AllocPooled(pool,SIZEOF dataheader);
          cinfo.src:=buffer;
          cinfo.srclen:=size;
          cinfo.dest:=buffer;
          cinfo.destlen:=size;
          cinfo.datahdr:=datenkopf;
          showStatus('Packe die Daten...');
          crunlen:=CmCrunchData(cinfo);
          SELECT crunlen
            CASE ERR_TEMPLATE;   showStatus('Wrong Arguments !');
            CASE ERR_NOLIB;      showStatus('Could not open Library !');
            CASE ERR_STRUCT;     showStatus('Could not allocate Struct !');
            CASE ERR_LOCK;       showStatus('File not found !');
            CASE ERR_NOFIBMEM;   showStatus('Zu wenig Speicher!');
            CASE ERR_NOFMEM;     showStatus('Zu wenig Speicher!');
            CASE ERR_READ;       showStatus('Error while Reading !');
            CASE ERR_CRUNCHFAIL; showStatus('Fehler. Packen abgebrochen!');
            CASE ERR_WRITE;      showStatus('Error while Writing !');
            CASE ERR_FILE;       showStatus('Dest File open Failed !');
            DEFAULT;             showStatus('Packen beendet.');
          ENDSELECT
          IF filehandle:=Open(savename,MODE_NEWFILE);
            IF Write(filehandle,datenkopf,SIZEOF dataheader)<>(SIZEOF dataheader) THEN showStatus('Fehler beim Schreiben der Daten.');
            IF Write(filehandle,buffer,crunlen)<>crunlen THEN showStatus('Fehler beim Schreiben der Daten.');
            Close(filehandle);
            showStatus('Datei abgespeichert.');
          ELSE
            showStatus('Fehler beim Schreiben des Datenkopfes.');
          ENDIF
          FreePooled(pool,datenkopf,SIZEOF dataheader);
          CmProcessCrunchStructA(cinfo,CM_FREESTRUCT,NIL);
        ELSE
          showStatus('Speichermangel beim Vorbereiten für das Packen.');
        ENDIF
        FreeVec(buffer);
      ELSE
        showStatus('Nicht genügend Speicher vorhanden.');
      ENDIF
      ClearPointer(gh.wnd);
    ELSE
      showStatus('Filerequester abgebrochen.');
    ENDIF
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
  CloseLibrary(crmbase);
 ELSE
  showStatus('Konnte "CrM.library V2" nicht öffnen.');
 ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  löscht eine ausgewählte Datei  -----------------------------*/
PROC deleteFile();
 DEF ret, filereq: PTR TO rtfilerequester,
     s[80]: STRING, ss[200]: STRING, es

  filereq:=RtAllocRequestA(RT_FILEREQ,NIL);
  IF filereq
    es:=PathPart(savename);
    StrCopy(s,savename,EstrLen(savename)-StrLen(es));
    RtChangeReqAttrA(filereq,[RTFI_DIR,s,TAG_DONE]);
    StrCopy(s,FilePart(savename));
    ret:=RtFileRequestA(filereq,s,'MMV - Datei löschen',
                       [RT_WINDOW,gh.wnd,
                        RT_WAITPOINTER,TRUE,
                        RT_LOCKWINDOW,TRUE,
                        RTFI_FLAGS,FREQF_SAVE,
                        TAG_DONE]);
    IF ret
      StrCopy(ss,filereq.dir);
      AddPart(ss,s,200);
      DeleteFile(ss);
      es:=IoErr();
      IF es<>0 THEN showStatus('Fehler beim löschen der Datei.') ELSE showStatus('Datei gelöscht.');
    ELSE
      showStatus('Abgebrochen.');
    ENDIF
  ELSE
    showStatus('Kein Speicher für Filerequester.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  lädt ein Module  -------------------------------------------*/
PROC loadMod();
 DEF ret, filereq: PTR TO rtfilerequester,
     s[80]: STRING, ss[200]: STRING, es,
     size,handle

 IF checkAudio()
  IF (play) OR (modbuffer) THEN ejectMod();
  filereq:=RtAllocRequestA(RT_FILEREQ,NIL);
  IF filereq
    es:=PathPart(savename);
    StrCopy(s,savename,EstrLen(savename)-StrLen(es));
    RtChangeReqAttrA(filereq,[RTFI_DIR,s,TAG_DONE]);
    StrCopy(s,FilePart(savename));
    ret:=RtFileRequestA(filereq,s,'MMV - MOD abspielen',
                       [RT_WINDOW,gh.wnd,
                        RT_WAITPOINTER,TRUE,
                        RT_LOCKWINDOW,TRUE,
                        TAG_DONE]);
    IF ret
      StrCopy(ss,filereq.dir);
      AddPart(ss,s,200);
      size:=FileLength(ss);
      IF (modbuffer:=AllocVec(size,MEMF_CHIP))
        handle:=Open(ss,MODE_OLDFILE);
        Read(handle,modbuffer,size);
        Close(handle);
        IF (Long(modbuffer+$438)=$4D2E4B2E)
          showStatus('ProTracker-Module geladen und abgespielt.');
          playMod();
        ELSE
          showStatus('Kein ProTrackermodule.');
        ENDIF
      ELSE
        showStatus('Konnte kein ChipRam für das Module bekommen.');
      ENDIF
    ELSE
      showStatus('Abgebrochen.');
    ENDIF
  ELSE
    showStatus('Kein Speicher für Filerequester.');
  ENDIF
 ELSE
  showStatus('Audio-Kanäle sind schon belegt.');
 ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  Module aus Speicher entfernen  -----------------------------*/
PROC ejectMod();

  IF play THEN stopMod();
  IF modbuffer
    FreeVec(modbuffer);
    modbuffer:=NIL;
    IF ptbase THEN CloseLibrary(ptbase);
    ptbase:=NIL;
    showStatus('Module aus dem Speicher entfernt.');
  ELSE
    showStatus('Kein Module geladen.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  stop den Sound  --------------------------------------------*/
PROC stopMod()

  IF play
    Mt_StopInt();
    play:=FALSE;
    showStatus('Module abspielen gestoppt.');
  ELSE
    showStatus('Kein Module abgespielt.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  spielt ein Module  -----------------------------------------*/
PROC playMod();

  IF play=FALSE
    IF modbuffer
      IF ptbase
        play:=Mt_StartInt(modbuffer);
      ELSE
        IF (ptbase:=OpenLibrary('protracker.library',1))
          IF Not(play:=Mt_StartInt(modbuffer))
            CloseLibrary(ptbase);
            ptbase:=NIL;
          ENDIF
        ELSE
          showStatus('Konnte "protracker.library" nicht öffnen.');
          ejectMod();
        ENDIF
      ENDIF
    ELSE
      showStatus('Kein Module gleaden.');
    ENDIF
  ELSE
    showStatus('Module wird schon abgespielt.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  lädt das Module dem Datenpfad  -----------------------------*/
PROC playPfad();
 DEF ss[200]: STRING,size,handle

  IF (checkData())
    IF (play) OR (modbuffer) THEN ejectMod();
    IF checkAudio()
      StrCopy(ss,aktfeld.pfad);
      size:=FileLength(ss);
      IF (modbuffer:=AllocVec(size,MEMF_CHIP))
        handle:=Open(ss,MODE_OLDFILE);
        IF handle
          Read(handle,modbuffer,size);
          Close(handle);
          IF (Long(modbuffer+$438)=$4D2E4B2E)   ->Kennng: 'M.K.'
            showStatus('ProTracker-Module geladen und abgespielt.');
            playMod();
          ELSE
            showStatus('Kein ProTrackermodule.');
          ENDIF
        ELSE
          showStatus('Konnte nichts laden.');
        ENDIF
      ELSE
        showStatus('Konnte kein ChipRam für das Module bekommen.');
      ENDIF
    ELSE
      showStatus('Audio-Kanäle sind schon belegt.');
    ENDIF
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  vergleicht interne mir externen Daten  ---------------------*/
PROC xcompare();
 DEF oldanz,oldname[200]:STRING,first,actual,abort=FALSE,found=FALSE

  IF checkData()
    oldanz:=anzahl;
    actual:=aktfeld;
    StrCopy(oldname,savename);
    loadOn();
    anzahl:=oldanz;
    StrCopy(savename,oldname);
    SetWindowTitles(gh.wnd,TRUE,savename);
    showAnzahl(anzahl);
    showElement(actual);
    RtSetWaitPointer(gh.wnd);
    aktfeld:=findFirstNode(aktfeld)
    first:=aktfeld;
    helpfeld:=aktfeld;
    WHILE (helpfeld<>NIL) AND (abort=FALSE)
      REPEAT
        aktfeld:=aktfeld.rechts;
        IF (helpfeld.laenge=aktfeld.laenge) AND (helpfeld.nummer<aktfeld.nummer)
          IF RtEZRequestA('Es wurden gleiche Modulelängen gefunden !\n'+
                          '%s - %s\n%s - %s\n%s - %s\n%s - %s\n%s - %s\n'+
                          '%ld - %ld\n%ld - %ld\n%ld - %ld\n%ld - %ld\n'+
                          '%s - %s\n%s - %s\n%ld - ?\n',
                          'Weitersuchen|Abbrechen',NIL,
                          [helpfeld.name,aktfeld.name,
                           helpfeld.format,aktfeld.format,
                           helpfeld.prefix,aktfeld.prefix,
                           helpfeld.author,aktfeld.author,
                           helpfeld.dauer,aktfeld.dauer,
                           helpfeld.laenge,aktfeld.laenge,
                           helpfeld.songdatasize,aktfeld.songdatasize,
                           helpfeld.samples,aktfeld.samples,
                           helpfeld.samplessize,aktfeld.samplessize,
                           helpfeld.pfad,aktfeld.pfad,
                           helpfeld.bemerkung,aktfeld.bemerkung,
                           helpfeld.nummer],
                          [RTEZ_REQTITLE,'MMV - Vergleich',
                           RTEZ_FLAGS,EZREQF_CENTERTEXT,
                           RT_WINDOW,gh.wnd,
                           RT_WAITPOINTER,TRUE,
                           RT_LOCKWINDOW,TRUE,
                           TAG_DONE])=1 THEN abort:=FALSE ELSE abort:=TRUE;
          found:=TRUE;
          RtSetWaitPointer(gh.wnd);
        ENDIF
      UNTIL (aktfeld.rechts=NIL) OR (abort);
      helpfeld:=helpfeld.rechts;
      aktfeld:=first;
    ENDWHILE
    aktfeld:=actual;
    IF (found) AND (abort=FALSE)
      showStatus('Nichts mehr gefunden.');
    ELSEIF (found) AND (abort)
      showStatus('Abgebrochen.');
    ELSE
      showStatus('Keine doppelten Modulelängen gefunden.');
    ENDIF
    ClearPointer(gh.wnd);
    helpfeld:=setDataPointer(anzahl,aktfeld);
    helpfeld:=helpfeld.rechts;
    helpfeld.links.rechts:=NIL;
    WHILE helpfeld<>NIL
      actual:=helpfeld.rechts;
      fDisposeFeld(helpfeld);
      helpfeld:=actual;
    ENDWHILE
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  zeigt die Modulelängen grafisch an  ------------------------*/
PROC grafik();
 DEF gwin: PTR TO window,count=0,ys1,ys2,k,l=0,i,pen=1,
     gbase: PTR TO gfxbase

  IF checkData()
    helpfeld:=aktfeld;
    IF pubscreen
      ys1:=pubscreen.font.ysize;
    ELSE
      pubscreen:=gh.wnd.wscreen;
      ys1:=pubscreen.font.ysize;
    ENDIF
    gbase:=gfxbase;
    ys2:=gbase.defaultfont.ysize;
    gwin:=OpenWindowTagList(NIL,
                           [WA_LEFT,0,
                            WA_TOP,ys1+3,
                            WA_WIDTH,640,
                            WA_HEIGHT,Div(ys1,2)+Mul(3,ys2)+200+1+ys1+3,
                            WA_FLAGS,WFLG_ACTIVATE OR WFLG_GIMMEZEROZERO OR WFLG_CLOSEGADGET OR WFLG_DRAGBAR,
                            WA_TITLE,'Grafische Moduledarstellung',
                            WA_PUBSCREEN,pubscreen,
                            WA_IDCMP,IDCMP_CLOSEWINDOW OR IDCMP_VANILLAKEY,
                            TAG_DONE]);
    IF gwin
      RtSetWaitPointer(gh.wnd);
      stdrast:=gwin.rport;
      IF KickVersion(39)
        pen:=ObtainBestPenA(pubscreen.viewport.colormap,0,0,0,
                           [OBP_PRECISION,PRECISION_GUI,TAG_DONE]);
        IF pen=l THEN l:=1;
        Colour(pen,l)
      ELSE
        Colour(1,0)
      ENDIF
      FOR i:=1 TO 8
        SELECT i
          CASE 1; k:=0;       l:=10000;   TextF(015,200+ys2,'\s','0-10k');
          CASE 2; k:=10000;   l:=50000;   TextF(095,200+ys2,'\s','10-50k');
          CASE 3; k:=50000;   l:=100000;  TextF(175,200+ys2,'\s','50-100k');
          CASE 4; k:=100000;  l:=200000;  TextF(255,200+ys2,'\s','100-200k');
          CASE 5; k:=200000;  l:=400000;  TextF(335,200+ys2,'\s','200-400k');
          CASE 6; k:=400000;  l:=700000;  TextF(415,200+ys2,'\s','400-700k');
          CASE 7; k:=700000;  l:=1000000; TextF(495,200+ys2,'\s','700-1000k');
          CASE 8; k:=1000000; l:=MAXLONG; TextF(575,200+ys2,'\s','>1000k');
        ENDSELECT;
        aktfeld:=findFirstNode(aktfeld);
        count:=0;
        REPEAT
          IF (aktfeld.laenge>k) AND (aktfeld.laenge<=l) THEN count++;
          IF aktfeld.rechts<>NIL THEN aktfeld:=aktfeld.rechts;
        UNTIL aktfeld.rechts=NIL;
        IF (anzahl>1) AND (aktfeld.laenge>k) AND (aktfeld.laenge<=l) THEN count++;
        TextF((i-1)*80+15,200+ys2+ys2,'\d',count);
        TextF((i-1)*80+15,200+ys2+ys2+ys2,'\d%',Div(Mul(count,100),anzahl));
        RectFill(stdrast,(i-1)*80+15,200-(2*Div(Mul(count,100),anzahl)),(i-1)*80+65,200);
      ENDFOR
      WaitPort(gwin.userport);
      WHILE (i:=GetMsg(gwin.userport)) DO ReplyMsg(i);
      ClearPointer(gh.wnd);
      stdrast:=gh.wnd.rport;
      CloseWindow(gwin);
      IF KickVersion(39) THEN ReleasePen(pubscreen.viewport.colormap,pen);
      aktfeld:=helpfeld;
    ELSE
      showStatus('Konnte kein Fenster öffnen.');
    ENDIF
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  schaut ob die Audiokanäle frei sind  -----------------------*/
PROC checkAudio();
 DEF status=FALSE,io: PTR TO ioaudio,ior: PTR TO io

  IF play=FALSE
    IF (io:=CreateIORequest(uport,SIZEOF ioaudio))
      io.length:=4;
      io.data:=[1,2,3,4]:CHAR;
      ior:=io;
      ior.command:=ADCMD_ALLOCATE;
      IF (OpenDevice('audio.device',0,io,0))=0
        status:=TRUE;
        CloseDevice(io);
      ENDIF
      IF io THEN DeleteIORequest(io);
    ELSE
      showStatus('Konnte keine IO-Struktur initialisieren.');
    ENDIF
  ELSE
    status:=TRUE;
  ENDIF
ENDPROC status;
/*-------------------------------------------------------------------*/

/*-----  druckt die Daten aus  --------------------------------------*/
PROC print();
 DEF kind, wahl, printerIO: PTR TO iostd, von=-1, bis=-1, x

  IF checkData()
    kind:=RtEZRequestA('Tabellarisch der Standard ?','Tabelle|Standard|Abbruch',
                        NIL,NIL,[RTEZ_REQTITLE,'MMV - Drucken',
                                 RTEZ_FLAGS,EZREQF_CENTERTEXT,
                                 RT_WINDOW,gh.wnd,
                                 RT_WAITPOINTER,TRUE,
                                 RT_LOCKWINDOW,TRUE,
                                 TAG_DONE]);
    IF kind<>0
      wahl:=RtEZRequestA('Element Nr.%ld drucken?','JA|Alles drucken|Von - bis drucken|Abbruch',
                         NIL,[aktfeld.nummer],[RTEZ_REQTITLE,'MMV - Drucken',
                              RTEZ_FLAGS,EZREQF_CENTERTEXT,
                              RT_WINDOW,gh.wnd,
                              RT_WAITPOINTER,TRUE,
                              RT_LOCKWINDOW,TRUE,
                              TAG_DONE]);
      IF wahl<>0
        IF (printerIO:=CreateIORequest(uport,SIZEOF iostd))
          IF (OpenDevice('printer.device',0,printerIO,0))=0
            printerIO.command:=CMD_WRITE;
            printerIO.length:=-1;
            SELECT 4 OF wahl
              CASE 1
                printIt(printerIO,aktfeld,kind,TRUE);
                showStatus('Fertig.');
              CASE 2
                helpfeld:=setDataPointer(1,aktfeld);
                printIt(printerIO,helpfeld,kind,TRUE)
                helpfeld:=helpfeld.rechts;
                WHILE helpfeld<>NIL
                  printIt(printerIO,helpfeld,kind)
                  helpfeld:=helpfeld.rechts;
                ENDWHILE
                showStatus('Fertig.');
              CASE 3
                von:=1;
                IF RtGetLongA({von},'MMV - Drucken', NIL,[RT_WINDOW,gh.wnd,
                                           RT_WAITPOINTER,TRUE,
                                           RT_LOCKWINDOW,TRUE,
                                           RTGL_FLAGS,GSREQF_CENTERTEXT,
                                           RTGL_MIN, 1,
                                           RTGL_MAX, anzahl-1,
                                           TAG_DONE])
                  bis:=anzahl;
                  IF RtGetLongA({bis},'MMV - Drucken',NIL,[RT_WINDOW,gh.wnd,
                                           RT_WAITPOINTER,TRUE,
                                           RT_LOCKWINDOW,TRUE,
                                           RTGL_FLAGS,GSREQF_CENTERTEXT,
                                           RTGL_MIN, von,
                                           RTGL_MAX, anzahl,
                                           TAG_DONE])
                    helpfeld:=setDataPointer(von,aktfeld);
                    printIt(printerIO,helpfeld,kind,TRUE);
                    helpfeld:=helpfeld.rechts;
                    FOR x:=von+1 TO bis
                      printIt(printerIO,helpfeld,kind);
                      helpfeld:=helpfeld.rechts;
                    ENDFOR
                    showStatus('Fertig.');
                  ELSE
                    showStatus('Abgebrochen.');
                  ENDIF
                ELSE
                  showStatus('Abgebrochen.');
                ENDIF
            ENDSELECT
          ELSE
            showStatus('Konnte "printer.device" nicht öffnen.');
            DeleteIORequest(printerIO);
            printerIO:=NIL;
          ENDIF
          IF printerIO<>NIL THEN CloseDevice(printerIO);
          IF printerIO<>NIL THEN DeleteIORequest(printerIO);
        ELSE
          showStatus('Konnte kein IO-Struktur alloziieren.');
        ENDIF
      ELSE
        showStatus('Abgebrochen.');
      ENDIF
    ELSE
      showStatus('Abgebrochen.');
    ENDIF
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  druckt ein Element direkt  ---------------------------------*/
PROC printIt(output:PTR TO iostd,help:PTR TO datei,art,tabheader=FALSE);
 DEF s[220]: STRING, t[85]:STRING

  IF art=2
    output.data:=s;
    StrCopy(s,'\n   ',);
    StrAdd(s,help.name);
    StrAdd(s,'\n   ');
    StrAdd(s,help.format);
    StrAdd(s,'\n   ');
    StrAdd(s,help.prefix);
    StrAdd(s,'\n   ');
    StrAdd(s,help.author);
    StrAdd(s,'\n   ');
    DoIO(output);
    StrCopy(s,help.dauer);
    StrAdd(s,'\n   ');
    StrAdd(s,longToStr(help.laenge));
    StrAdd(s,'\n   ');
    StrAdd(s,longToStr(help.songdatasize));
    StrAdd(s,'\n   ');
    StrAdd(s,longToStr(help.samples));
    StrAdd(s,'\n   ');
    StrAdd(s,longToStr(help.samplessize));
    StrAdd(s,'\n   ');
    StrAdd(s,help.pfad);
    StrAdd(s,'\n   ');
    StrAdd(s,help.bemerkung);
    StrAdd(s,'\n   ');
    StrAdd(s,longToStr(help.nummer));
    StrAdd(s,'\n');
    DoIO(output);
   ELSE
    IF tabheader
      output.data:=t;
      StrCopy(t,'\nName                           Format               Prefix Länge   Smp Nr.');
      DoIO(output);
      StrCopy(t,'\n----------------------------------------------------------------------------\n');
      DoIO(output);
    ENDIF
    StrCopy(t,help.name,29);
    StrAdd(t,' ',1);
    IF EstrLen(t)<30 THEN addSpaces(t,30);
    StrAdd(t,help.format,20);
    StrAdd(t,' ',1);
    IF EstrLen(t)<51 THEN addSpaces(t,51);
    StrAdd(t,help.prefix,6);
    StrAdd(t,' ',1);
    IF EstrLen(t)<58 THEN addSpaces(t,58);
    StrAdd(t,longToStr(help.laenge),7);
    StrAdd(t,' ',1);
    IF EstrLen(t)<67 THEN addSpaces(t,66);
    StrAdd(t,longToStr(help.samples),3);
    StrAdd(t,' ',1);
    IF EstrLen(t)<72 THEN addSpaces(t,70);
    StrAdd(t,longToStr(help.nummer),5);
    StrAdd(t,'\n');
    DoIO(output);
   ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  fügt Spaces in einen E-String ein  -------------------------*/
PROC addSpaces(s,num);
 DEF x

  FOR x:=EstrLen(s) TO num DO StrAdd(s,' ',1);
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  ermittelt die Gesamtgröße aller Modulelängen  --------------*/
PROC allsize();
 DEF alles=0

  IF checkData()
    RtSetWaitPointer(gh.wnd);
    helpfeld:=aktfeld;
    aktfeld:=findFirstNode(aktfeld);
    alles:=aktfeld.laenge;
    WHILE aktfeld.rechts<>NIL
      aktfeld:=aktfeld.rechts;
      alles:=alles+aktfeld.laenge;
    ENDWHILE
    RtEZRequestA('Die Gesamtlänge alles Modules\nbeträgt %ld Bytes.',
                 'OKAY',NIL,[alles],
                 [RTEZ_REQTITLE,'MMV - Gesamtgröße',
                  RTEZ_FLAGS,EZREQF_CENTERTEXT,
                  RT_WINDOW,gh.wnd,
                  RT_WAITPOINTER,TRUE,
                  RT_LOCKWINDOW,TRUE,
                  TAG_DONE]);
    aktfeld:=helpfeld;
    ClearPointer(gh.wnd);
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  sucht einen bestimmten Name oder eine best. Länge heraus  --*/
PROC search();
 DEF goon=TRUE, actual, wahl, name[80]:STRING, zahl=0

  IF (aktfeld) AND (anzahl>1)
    RtSetWaitPointer(gh.wnd);
    showStatus(' ');
    wahl:=RtEZRequestA('Wonach suchen?','Name|Länge|Abbruch',NIL,NIL,
                       [RTEZ_REQTITLE,'MMV - Suchen',
                       RT_WINDOW,gh.wnd,
                       RT_WAITPOINTER,TRUE,
                       RT_LOCKWINDOW,TRUE,
                       TAG_DONE]);
    actual:=aktfeld;
    IF wahl=2
      IF RtGetLongA({zahl},'MMV - Suchlänge',NIL,[RT_WINDOW,gh.wnd,
                                                  RT_WAITPOINTER,TRUE,
                                                  RT_LOCKWINDOW,TRUE,
                                                  TAG_DONE])

        RtSetWaitPointer(gh.wnd);
        aktfeld:=findFirstNode(aktfeld);
        helpfeld:=aktfeld;
        WHILE (aktfeld<>NIL) AND (goon)
          IF aktfeld.laenge=zahl
            IF RtEZRequestA('Es wurde eine solche  Länge gefunden:\n'+
                            '%s\n%s\n%s\n%s\n%s\n%ld\n%ld\n%ld\n%ld\n'+
                            '%s\n%s\n%ld\n',
                            'Weitersuchen|Abbrechen',NIL,
                            [aktfeld.name,aktfeld.format,
                             aktfeld.prefix,aktfeld.author,
                             aktfeld.dauer,aktfeld.laenge,
                             aktfeld.songdatasize,aktfeld.samples,
                             aktfeld.samplessize,aktfeld.pfad,
                             aktfeld.bemerkung,aktfeld.nummer],
                            [RTEZ_REQTITLE,'MMV - Suchen',
                             RTEZ_FLAGS,EZREQF_CENTERTEXT,
                             RT_WINDOW,gh.wnd,
                             RT_WAITPOINTER,TRUE,
                             RT_LOCKWINDOW,TRUE,
                             TAG_DONE])=1 THEN goon:=TRUE ELSE goon:=FALSE;
          ENDIF
          aktfeld:=aktfeld.rechts;
        ENDWHILE
        IF goon=FALSE THEN showStatus('Abgebrochen.');
      ELSE
        showStatus('Abgebrochen.');
      ENDIF
    ELSEIF wahl=1
      StrCopy(name,'');
      IF RtGetStringA(name,70,'MMV - Suchstring',NIL,[RT_WINDOW,gh.wnd,
                                                      RT_WAITPOINTER,TRUE,
                                                      RT_LOCKWINDOW,TRUE,
                                                      TAG_DONE])

        RtSetWaitPointer(gh.wnd);
        aktfeld:=findFirstNode(aktfeld);
        helpfeld:=aktfeld;
        WHILE (aktfeld<>NIL) AND (goon)
          IF InStr(aktfeld.name,name)<>-1
            IF RtEZRequestA('Es wurde ein solcher Name gefunden:\n'+
                            '%s\n%s\n%s\n%s\n%s\n%ld\n%ld\n%ld\n%ld\n'+
                            '%s\n%s\n%ld\n',
                            'Weitersuchen|Abbrechen',NIL,
                            [aktfeld.name,aktfeld.format,
                             aktfeld.prefix,aktfeld.author,
                             aktfeld.dauer,aktfeld.laenge,
                             aktfeld.songdatasize,aktfeld.samples,
                             aktfeld.samplessize,aktfeld.pfad,
                             aktfeld.bemerkung,aktfeld.nummer],
                            [RTEZ_REQTITLE,'MMV - Suchen',
                             RTEZ_FLAGS,EZREQF_CENTERTEXT,
                             RT_WINDOW,gh.wnd,
                             RT_WAITPOINTER,TRUE,
                             RT_LOCKWINDOW,TRUE,
                             TAG_DONE])=1 THEN goon:=TRUE ELSE goon:=FALSE;
          ENDIF
          aktfeld:=aktfeld.rechts;
        ENDWHILE
        IF goon=FALSE THEN showStatus('Abgebrochen.');
      ELSE
        showStatus('Abgebrochen.');
      ENDIF
    ELSE
      showStatus('Abgebrochen.');
    ENDIF
    aktfeld:=actual;
    ClearPointer(gh.wnd);
  ELSE
    showStatus('Nicht genügend Daten vorhanden.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  fügt dem Datenfeld ein neues Element hinzu  ----------------*/
PROC more();

  IF anzahl>1 THEN aktfeld:=setDataPointer(anzahl,aktfeld);
  IF pool=NIL THEN pool:=CreatePool(MEMF_CLEAR,PUDDLESIZE,THRESHOLD);
  helpfeld:=fNewFeld();
  IF helpfeld
    showStatus('Leeres Element erzeugt. Bitte neue Daten eintragen.');
    IF aktfeld<>NIL THEN aktfeld:=setDataPointer(anzahl,aktfeld);
    helpfeld.links:=aktfeld;
    helpfeld.rechts:=NIL;
    IF helpfeld.links<>NIL THEN helpfeld.links.rechts:=helpfeld;
    INC anzahl;
    helpfeld.nummer:=anzahl;
    aktfeld:=helpfeld;
    helpfeld:=NIL;
    showAnzahl(anzahl);
    showElement(anzahl);
    saveok:=FALSE;
    ActivateGadget(findgadget(gh,gad_name),gh.wnd,NIL);
  ELSE
    showStatus('Konnte kein leeres Element erzeugen.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  fügt ein neues Element an einer bestimmten Stelle ein  -----*/
PROC insert();

  IF checkData()
    IF pool=NIL THEN pool:=CreatePool(MEMF_CLEAR,PUDDLESIZE,THRESHOLD);
    helpfeld:=fNewFeld();
    IF helpfeld
      showStatus('Leeres Element erzeugt. Bitte neue Daten eintragen.');
      helpfeld.nummer:=aktfeld.nummer;
      helpfeld.links:=aktfeld.links;
      IF helpfeld.links<>NIL THEN helpfeld.links.rechts:=helpfeld;
      helpfeld.rechts:=aktfeld;
      aktfeld.links:=helpfeld;
      WHILE aktfeld.rechts<>NIL
        aktfeld.nummer:=aktfeld.nummer+1;;
        aktfeld:=aktfeld.rechts;
      ENDWHILE;
      aktfeld.nummer:=aktfeld.nummer+1;
      INC anzahl;
      aktfeld:=helpfeld;
      helpfeld:=NIL;
      showAnzahl(anzahl);
      showElement(aktfeld.nummer);
      saveok:=FALSE;
    ELSE
      showStatus('Konnte kein leeres Element erzeugen.');
    ENDIF
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  löscht ein oder alle Datenelemente  ------------------------*/
PROC delete();
 DEF wahl

  IF checkData()
    wahl:=RtEZRequestA('Element Nr. %ld löschen ?','  JA  |Alles Löschen|NEIN',
                        NIL,[aktfeld.nummer],
                       [RTEZ_REQTITLE,'MMV - Löschen',
                        RT_WINDOW,gh.wnd,
                        RT_WAITPOINTER,TRUE,
                        RT_LOCKWINDOW,TRUE,
                        TAG_DONE]);
    IF wahl=2
      IF RtEZRequestA('Wirklich alles Löschen ?','  JA  |NEIN',NIL,NIL,
                      [RTEZ_REQTITLE,'MMV - Alles Löschen',
                       RT_WINDOW,gh.wnd,
                       RT_WAITPOINTER,TRUE,
                       RT_LOCKWINDOW,TRUE,
                       TAG_DONE])
        DeletePool(pool)
        pool:=NIL;
        aktfeld:=NIL;
        anzahl:=0;
        showAnzahl(0);
        showAnzahl(anzahl);
        saveok:=TRUE;
        setstr(gh,gad_name,'');
        setstr(gh,gad_format,'');
        setstr(gh,gad_prefix,'');
        setstr(gh,gad_author,'');
        setstr(gh,gad_dauer,'');
        setinteger(gh,gad_laenge,0);
        setinteger(gh,gad_slaenge,0);
        setinteger(gh,gad_samples,0);
        setinteger(gh,gad_ssize,0);
        setstr(gh,gad_pfad,'');
        setstr(gh,gad_bemerkung,'');
        setinteger(gh,gad_nummer,0);
        showStatus('Alle Daten wurden gelöscht.');
      ELSE
        showStatus('Abgebrochen.');
      ENDIF
    ELSEIF wahl=1
      IF aktfeld.rechts=NIL
        IF aktfeld.links<>NIL
          helpfeld:=aktfeld.links;
          helpfeld.rechts:=NIL;
          fDisposeFeld(aktfeld);
          aktfeld:=helpfeld;
          anzahl--;
          showAnzahl(anzahl);
          showElement(aktfeld.nummer);
        ELSE        -> nur ein einziges Element zum löschen
          fDisposeFeld(aktfeld);
          anzahl:=0;
          showAnzahl(0);
          setstr(gh,gad_name,'');
          setstr(gh,gad_format,'');
          setstr(gh,gad_prefix,'');
          setstr(gh,gad_author,'');
          setstr(gh,gad_dauer,'');
          setinteger(gh,gad_laenge,0);
          setinteger(gh,gad_slaenge,0);
          setinteger(gh,gad_samples,0);
          setinteger(gh,gad_ssize,0);
          setstr(gh,gad_pfad,'');
          setstr(gh,gad_bemerkung,'');
          setinteger(gh,gad_nummer,0);
          showStatus('Alle Daten wurden gelöscht.');
        ENDIF
      ELSEIF aktfeld.links<>NIL
        helpfeld:=aktfeld.links;
        helpfeld.rechts:=aktfeld.rechts;
        aktfeld.rechts.links:=helpfeld;
        fDisposeFeld(aktfeld);
        aktfeld:=helpfeld.rechts;
        aktfeld.nummer:=aktfeld.nummer-1;
        WHILE aktfeld.rechts<>NIL
          aktfeld:=aktfeld.rechts;
          aktfeld.nummer:=aktfeld.nummer-1;
        ENDWHILE
        anzahl--;
        showAnzahl(anzahl);
        aktfeld:=helpfeld.rechts;
        showElement(aktfeld.nummer);
      ELSE
        helpfeld:=aktfeld.rechts;
        helpfeld.links:=NIL;
        fDisposeFeld(aktfeld);
        aktfeld.nummer:=aktfeld.nummer-1;
        WHILE aktfeld.rechts<>NIL
          aktfeld:=aktfeld.rechts;
          aktfeld.nummer:=aktfeld.nummer-1;
        ENDWHILE
        anzahl--;
        showAnzahl(anzahl);
        aktfeld:=helpfeld;
        showElement(aktfeld.nummer);
      ENDIF
      saveok:=FALSE;
    ELSE
      showStatus('Abgebrochen.');
    ENDIF
  ELSE
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  vergleicht alle Daten miteinander (Element Länge)  ---------*/
PROC compare();
 DEF first,actual, found=FALSE, abort=FALSE

  IF (aktfeld) AND (anzahl>1)
    RtSetWaitPointer(gh.wnd);
    actual:=aktfeld;
    aktfeld:=findFirstNode(aktfeld)
    first:=aktfeld;
    helpfeld:=aktfeld;
    showStatus(' ');
    WHILE (helpfeld<>NIL) AND (abort=FALSE)
      REPEAT
        aktfeld:=aktfeld.rechts;
        IF (helpfeld.laenge=aktfeld.laenge) AND (helpfeld.nummer<aktfeld.nummer)
          IF RtEZRequestA('Es wurden gleiche Modulelängen gefunden !\n'+
                          '%s <-> %s\n%s <-> %s\n%s <-> %s\n%s <-> %s\n%s <-> %s\n'+
                          '%ld <-> %ld\n%ld <-> %ld\n%ld <-> %ld\n%ld <-> %ld\n'+
                          '%s <-> %s\n%s <-> %s\n%ld <-> %ld\n',
                          'Weitersuchen|Abbrechen',NIL,
                          [helpfeld.name,aktfeld.name,
                           helpfeld.format,aktfeld.format,
                           helpfeld.prefix,aktfeld.prefix,
                           helpfeld.author,aktfeld.author,
                           helpfeld.dauer,aktfeld.dauer,
                           helpfeld.laenge,aktfeld.laenge,
                           helpfeld.songdatasize,aktfeld.songdatasize,
                           helpfeld.samples,aktfeld.samples,
                           helpfeld.samplessize,aktfeld.samplessize,
                           helpfeld.pfad,aktfeld.pfad,
                           helpfeld.bemerkung,aktfeld.bemerkung,
                           helpfeld.nummer,aktfeld.nummer],
                          [RTEZ_REQTITLE,'MMV - Vergleich',
                           RTEZ_FLAGS,EZREQF_CENTERTEXT,
                           RT_WINDOW,gh.wnd,
                           RT_WAITPOINTER,TRUE,
                           RT_LOCKWINDOW,TRUE,
                           TAG_DONE])=1 THEN abort:=FALSE ELSE abort:=TRUE;
          found:=TRUE;
          RtSetWaitPointer(gh.wnd);
        ENDIF
      UNTIL (aktfeld.rechts=NIL) OR (abort);
      helpfeld:=helpfeld.rechts;
      aktfeld:=first;
    ENDWHILE
    aktfeld:=actual;
    IF (found) AND (abort=FALSE)
      showStatus('Nichts mehr gefunden.');
    ELSEIF (found) AND (abort)
      showStatus('Abgebrochen.');
    ELSE
      showStatus('Keine doppelten Modulelängen gefunden.');
    ENDIF
    ClearPointer(gh.wnd);
  ELSE
    showStatus('Nicht genügend Daten vorhanden.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  sortieren der Daten nach 'Name' oder 'Länge'  --------------*/
PROC sort();
 DEF wahl,i,old

  IF (aktfeld) AND (anzahl>1)
    wahl:=RtEZRequestA('Wonach sortieren ?','Name|Format|Prefix|Größe|Samples|Abbruch',NIL,NIL,
                       [RTEZ_REQTITLE,'MMV - Sortieren',
                        RT_WINDOW,gh.wnd,
                        RT_WAITPOINTER,TRUE,
                        RT_LOCKWINDOW,TRUE,
                        TAG_DONE]);
    helpfeld:=aktfeld;
    old:=aktfeld.nummer;
    IF wahl=1
      aktfeld:=findFirstNode(aktfeld);
      RtSetWaitPointer(gh.wnd);
      aktfeld:=quicksort(aktfeld,0);
      IF aktfeld<>NIL
        aktfeld.links:=NIL;
        FOR i:=1 TO anzahl-1  -> Wiederherstellung des rückwärtigen Verket-
          aktfeld.rechts.links:=aktfeld;  -> tungszeiger und des Element Nummer
          aktfeld.nummer:=i;
          aktfeld:=aktfeld.rechts;
        ENDFOR
        aktfeld.nummer:=anzahl;
      ENDIF
    ELSEIF wahl=2
      aktfeld:=findFirstNode(aktfeld);
      RtSetWaitPointer(gh.wnd);
      aktfeld:=quicksort(aktfeld,72);
      IF aktfeld<>NIL
        aktfeld.links:=NIL;   -> siehe oben
        FOR i:=1 TO anzahl-1
          aktfeld.rechts.links:=aktfeld;
          aktfeld.nummer:=i;
          aktfeld:=aktfeld.rechts;
        ENDFOR
        aktfeld.nummer:=anzahl;
      ENDIF
    ELSEIF wahl=3
      aktfeld:=findFirstNode(aktfeld);
      RtSetWaitPointer(gh.wnd);
      aktfeld:=quicksort(aktfeld,144);
      IF aktfeld<>NIL
        aktfeld.links:=NIL;   -> siehe oben
        FOR i:=1 TO anzahl-1
          aktfeld.rechts.links:=aktfeld;
          aktfeld.nummer:=i;
          aktfeld:=aktfeld.rechts;
        ENDFOR
        aktfeld.nummer:=anzahl;
      ENDIF
    ELSEIF wahl=4
      aktfeld:=findFirstNode(aktfeld);
      RtSetWaitPointer(gh.wnd);
      aktfeld:=quicksort(aktfeld,252);
      IF aktfeld<>NIL
        aktfeld.links:=NIL;   -> siehe oben
        FOR i:=1 TO anzahl-1
          aktfeld.rechts.links:=aktfeld;
          aktfeld.nummer:=i;
          aktfeld:=aktfeld.rechts;
        ENDFOR
        aktfeld.nummer:=anzahl;
      ENDIF
    ELSEIF wahl=5
      aktfeld:=findFirstNode(aktfeld);
      RtSetWaitPointer(gh.wnd);
      aktfeld:=quicksort(aktfeld,260);
      IF aktfeld<>NIL
        aktfeld.links:=NIL;   -> siehe oben
        FOR i:=1 TO anzahl-1
          aktfeld.rechts.links:=aktfeld;
          aktfeld.nummer:=i;
          aktfeld:=aktfeld.rechts;
        ENDFOR
        aktfeld.nummer:=anzahl;
      ENDIF
      showStatus('Fertig.');
    ELSE
      showStatus('Abgebrochen.');
    ENDIF
    ClearPointer(gh.wnd);
    aktfeld:=helpfeld;
    showElement(old);
  ELSE
    showStatus('Nicht genügend Daten vorhanden.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  eigentliche Sortierroutine  --------------------------------*/
PROC quicksort(p,wonach);
 DEF l1:PTR TO datei,l2:PTR TO datei,n1:PTR TO datei,n2:PTR TO datei

  l1:=p;
  l2:=fNewFeld();
  l2.rechts:=l1;
  l1:=l1.rechts;
  l2.rechts.rechts:=NIL;
  WHILE l1<>NIL
    n1:=l1;
    l1:=l1.rechts;
    n2:=l2;
    SELECT wonach
      CASE 0    -> nach Name sortieren, Offset Null
        loop1:
          MOVE.L  n2,A3     ->  n2 nach A3
          TST.L   420(A3)   ->  ist n2.rechts=NIL
          BEQ.B   exit1     ->  wenn ja, dann raus
          MOVE.L  420(A3),A3->  n2.rechts nach A3
          MOVE.L  n1,A0     ->  n1 nach A0
          MOVE.L  0(A3),D3  ->  n2.rechts.länge nach D3
          MOVE.L  0(A0),D0  ->  n1.länge nach D0
          CMP.L   D3,D0     ->  n1.länge mit n2.rechts.länge vergleichen
          BLE.B   exit1     ->  wenn n1.länge<=n2.rechts.länge dann raus
          MOVE.L  A3,n2     ->  n2:=n2.rechts
          BRA.B   loop1     ->  wieder in Schleife springen
        exit1:
      CASE 72    -> nach Format sortieren
        loop2:
          MOVE.L  n2,A3     ->  n2 nach A3
          TST.L   420(A3)   ->  ist n2.rechts=NIL
          BEQ.B   exit2     ->  wenn ja, dann raus
          MOVE.L  420(A3),A3->  n2.rechts nach A3
          MOVE.L  n1,A0     ->  n1 nach A0
          MOVE.L  72(A3),D3 ->  n2.rechts.länge nach D3
          MOVE.L  72(A0),D0 ->  n1.länge nach D0
          CMP.L   D3,D0     ->  n1.länge mit n2.rechts.länge vergleichen
          BLE.B   exit2     ->  wenn n1.länge<=n2.rechts.länge dann raus
          MOVE.L  A3,n2     ->  n2:=n2.rechts
          BRA.B   loop2     ->  wieder in Schleife springen
        exit2:
      CASE 144    -> nach Prefix sortieren
        loop3:
          MOVE.L  n2,A3     ->  n2 nach A3
          TST.L   420(A3)   ->  ist n2.rechts=NIL
          BEQ.B   exit3     ->  wenn ja, dann raus
          MOVE.L  420(A3),A3->  n2.rechts nach A3
          MOVE.L  n1,A0     ->  n1 nach A0
          MOVE.L  144(A3),D3->  n2.rechts.länge nach D3
          MOVE.L  144(A0),D0->  n1.länge nach D0
          CMP.L   D3,D0     ->  n1.länge mit n2.rechts.länge vergleichen
          BLE.B   exit3     ->  wenn n1.länge<=n2.rechts.länge dann raus
          MOVE.L  A3,n2     ->  n2:=n2.rechts
          BRA.B   loop3     ->  wieder in Schleife springen
        exit3:
      CASE 252  -> nach Länge sortieren
        loop4:
          MOVE.L  n2,A3     ->  n2 nach A3
          TST.L   420(A3)   ->  ist n2.rechts=NIL
          BEQ.B   exit4     ->  wenn ja, dann raus
          MOVE.L  420(A3),A3->  n2.rechts nach A3
          MOVE.L  n1,A0     ->  n1 nach A0
          MOVE.L  252(A3),D3->  n2.rechts.länge nach D3
          MOVE.L  252(A0),D0->  n1.länge nach D0
          CMP.L   D3,D0     ->  n1.länge mit n2.rechts.länge vergleichen
          BLE.B   exit4     ->  wenn n1.länge<=n2.rechts.länge dann raus
          MOVE.L  A3,n2     ->  n2:=n2.rechts
          BRA.B   loop4     ->  wieder in Schleife springen
        exit4:
      CASE 260    -> nach Samples sortieren
        loop5:
          MOVE.L  n2,A3     ->  n2 nach A3
          TST.L   420(A3)   ->  ist n2.rechts=NIL
          BEQ.B   exit5     ->  wenn ja, dann raus
          MOVE.L  420(A3),A3->  n2.rechts nach A3
          MOVE.L  n1,A0     ->  n1 nach A0
          MOVE.L  260(A3),D3->  n2.rechts.länge nach D3
          MOVE.L  260(A0),D0->  n1.länge nach D0
          CMP.L   D3,D0     ->  n1.länge mit n2.rechts.länge vergleichen
          BLE.B   exit5     ->  wenn n1.länge<=n2.rechts.länge dann raus
          MOVE.L  A3,n2     ->  n2:=n2.rechts
          BRA.B   loop5     ->  wieder in Schleife springen
        exit5:
    ENDSELECT;
    n1.rechts:=n2.rechts;
    n2.rechts:=n1;
  ENDWHILE
  l1:=l2.rechts;
  Dispose(l2);
  p:=l1;
ENDPROC p;
/*-------------------------------------------------------------------*/

/*----- testet ab Daten vorhanden sind  -----------------------------*/
PROC checkData();

  IF (aktfeld) AND (anzahl>0) THEN RETURN TRUE ELSE RETURN FALSE;
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  Anzeige des ausgewählten Datensatzes  ----------------------*/
PROC cursorMaxLeft() IS showElement(1);
PROC cursorTLeft() IS IF checkData() THEN showElement(aktfeld.nummer-100) ELSE showStatus(STATUS_NODATA);
PROC cursorDLeft() IS IF checkData() THEN showElement(aktfeld.nummer-10) ELSE showStatus(STATUS_NODATA);
PROC cursorLeft() IS IF checkData() THEN showElement(aktfeld.nummer-1) ELSE showStatus(STATUS_NODATA);
PROC cursorRight() IS IF checkData() THEN showElement(aktfeld.nummer+1) ELSE showStatus(STATUS_NODATA);
PROC cursorDRight() IS IF checkData() THEN showElement(aktfeld.nummer+10) ELSE showStatus(STATUS_NODATA);
PROC cursorTRight() IS IF checkData() THEN showElement(aktfeld.nummer+100) ELSE showStatus(STATUS_NODATA);
PROC cursorMaxRight() IS showElement(anzahl);
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC nothing();


ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newName();

  IF checkData()
    CopyMemQuick(sgad_name,aktfeld.name,72);
    ActivateGadget(findgadget(gh,gad_format),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newFormat();

  IF (aktfeld) AND (anzahl>0)
    CopyMemQuick(sgad_format,aktfeld.format,72);
    ActivateGadget(findgadget(gh,gad_prefix),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newPrefix();

  IF (aktfeld) AND (anzahl>0)
    CopyMemQuick(sgad_prefix,aktfeld.prefix,24);
    ActivateGadget(findgadget(gh,gad_author),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newAuthor();

  IF (aktfeld) AND (anzahl>0)
    CopyMemQuick(sgad_author,aktfeld.author,52);
    ActivateGadget(findgadget(gh,gad_dauer),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newDauer();

  IF (aktfeld) AND (anzahl>0)
    CopyMemQuick(sgad_dauer,aktfeld.dauer,32);
    ActivateGadget(findgadget(gh,gad_laenge),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newLaenge(info,value);

  IF (aktfeld) AND (anzahl>0)
    aktfeld.laenge:=value;
    ActivateGadget(findgadget(gh,gad_slaenge),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newSLaenge(info,value);

  IF (aktfeld) AND (anzahl>0)
    aktfeld.songdatasize:=value;
    ActivateGadget(findgadget(gh,gad_samples),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newSamples(info,value);

  IF (aktfeld) AND (anzahl>0)
    aktfeld.samples:=value;
    ActivateGadget(findgadget(gh,gad_ssize),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newSSize(info,value);

  IF (aktfeld) AND (anzahl>0)
    aktfeld.samplessize:=value;
    ActivateGadget(findgadget(gh,gad_pfad),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newPfad();

  IF (aktfeld) AND (anzahl>0)
    CopyMemQuick(sgad_pfad,aktfeld.pfad,72);
    ActivateGadget(findgadget(gh,gad_bemerkung),gh.wnd,NIL);
    saveok:=FALSE;
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newBemerkung();

  IF (aktfeld) AND (anzahl>0)
    CopyMemQuick(sgad_bemerkung,aktfeld.bemerkung,72);
    showStatus(' ');
    saveok:=FALSE;
    IF aktfeld.rechts<>NIL
      aktfeld:=aktfeld.rechts;
      showElement(aktfeld.nummer);
      ActivateGadget(findgadget(gh,gad_name),gh.wnd,NIL);
    ENDIF
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-------------------------------------------------------------------*/
PROC newNummer(info,value);

  IF (aktfeld) AND (anzahl>0)
    showElement(value);
  ELSE
    DisplayBeep(NIL);
    showStatus(STATUS_NODATA);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  stellt ein Farbauswahlrequester zur Verfügung  -------------*/
PROC palette() IS RtPaletteRequestA('MMV - Palette',NIL,[RT_WINDOW,gh.wnd,
                                     RT_WAITPOINTER,TRUE,
                                     RT_LOCKWINDOW,TRUE,
                                     RT_REQPOS,REQPOS_POINTER,
                                     TAG_DONE]);
/*-------------------------------------------------------------------*/

/*-----  setzt eine neue Taskpriorität  -----------------------------*/
PROC taskPri();
 DEF mytask:tc,pri

  mytask:=FindTask(NIL);
  pri:=mytask.ln.pri;
  IF pri>200 THEN pri:=pri-256;
  IF RtGetLongA({pri},'MMV - Task', NIL,[RT_WINDOW,gh.wnd,
                                         RT_WAITPOINTER,TRUE,
                                         RT_LOCKWINDOW,TRUE,
                                         RTGL_FLAGS,GSREQF_CENTERTEXT,
                                         RTGL_MIN,-15,
                                         RTGL_MAX,15,
                                         TAG_DONE]);
    SetTaskPri(mytask,pri);
   ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  führt einen ARexx-Script aus  ------------------------------*/
PROC doScript();
 DEF ret, filereq: PTR TO rtfilerequester,
     s[200]: STRING, ss[200]: STRING, es

  filereq:=RtAllocRequestA(RT_FILEREQ,NIL);
  IF filereq
    es:=PathPart(savename);
    StrCopy(s,savename,EstrLen(savename)-StrLen(es));
    RtChangeReqAttrA(filereq,[RTFI_DIR,s,TAG_DONE]);
    StrCopy(s,FilePart(savename));
    ret:=RtFileRequestA(filereq,s,'MMV - ARexx',
                       [RT_WINDOW,gh.wnd,
                        RT_WAITPOINTER,TRUE,
                        RT_LOCKWINDOW,TRUE,
                        RTFI_FLAGS,FREQF_SAVE,
                        TAG_DONE,0]);
    IF ret
      StrCopy(ss,filereq.dir);
      AddPart(ss,s,200);
      StrCopy(s,'c:rx ');
      StrAdd(s,ss);
      IF Execute(s,0,0)=DOSFALSE
        StrCopy(s,'SYS:Rexxc/rx ');
        StrAdd(s,ss);
        IF Execute(s,0,0)=DOSFALSE
          StrCopy(s,'Rexxc:rx ');
          StrAdd(s,ss);
        ENDIF
      ENDIF
    ELSE
      showStatus('Abgebrochen.');
    ENDIF
  ELSE
    showStatus('Kein Speicher für Filerequester.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  ermittelt den neuen ARexx-Port  ----------------------------*/
PROC newAPort();

  IF RtGetStringA(destport,30,'MMV - ARexx',NIL,[RT_WINDOW,gh.wnd,
                                                 RT_WAITPOINTER,TRUE,
                                                 RT_LOCKWINDOW,TRUE,
                                                 RTGS_WIDTH,100,
                                                 RTGS_FLAGS,GSREQF_CENTERTEXT,
                                                 TAG_DONE]);
    RtGetStringA(cmdstr,90,'MMV - ARexx',NIL,[RT_WINDOW,gh.wnd,
                                              RT_WAITPOINTER,TRUE,
                                              RT_LOCKWINDOW,TRUE,
                                              RTGS_WIDTH,100,
                                              RTGS_FLAGS,GSREQF_CENTERTEXT,
                                              TAG_DONE]);
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  führt ARexx-Cmd aus  ---------------------------------------*/
PROC doARexx() IS sendRexxMsg(destport,cmdstr,Shl(1,RXFB_NOIO));
/*-------------------------------------------------------------------*/

/*-----  sendet eine RexxMsg  ---------------------------------------*/
PROC sendRexxMsg(hostname,command,flags=0);
 DEF xport=NIL, rexxmsg=NIL:PTR TO rexxmsg, argstr=NIL

  IF (rexxmsg:=CreateRexxMsg(aport,'rexx',aport.ln.name))
    IF (argstr:=CreateArgstring(command,StrLen(command)))
      rexxmsg.mn.ln.type:=NT_MESSAGE;
      rexxmsg.args[0]:=argstr;
      rexxmsg.args[1]:=0;
      rexxmsg.action:=RXCOMM OR flags;
      IF (xport:=FindPort(hostname)) THEN PutMsg(xport,rexxmsg);
      IF xport=NIL
        DeleteArgstring(argstr);
        DeleteRexxMsg(rexxmsg);
        showStatus('Konnte Zielport nicht finden.');
      ENDIF
    ELSE
      showStatus('Konnte ArgString nicht alloziieren.');
      DeleteRexxMsg(rexxmsg);
    ENDIF
  ELSE
    showStatus('Konnte RexxMsg-Struktur nicht alloziieren.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  wertet die ARexx-Messages aus  -----------------------------*/
PROC handleRexxMsg();
 DEF rexxmsg:PTR TO rexxmsg,cmd:PTR TO CHAR

  WHILE rexxmsg:=GetMsg(aport)
    IF rexxmsg.mn.ln.type=NT_REPLYMSG
      IF rexxmsg.result1=0
        IF (g_var<>-1)
          g_var:=rexxmsg.result2;
        ELSE
          StrCopy(g_str,rexxmsg.result2);
        ENDIF
      ENDIF
      DeleteArgstring(rexxmsg.args[0]);
      DeleteRexxMsg(rexxmsg);
    ELSE
      cmd:=TrimStr(rexxmsg.args[0]);
      rexxmsg.result1:=0;
      rexxmsg.result2:=0;
      IF StrCmp(cmd,'ENDE')
        ReplyMsg(rexxmsg);
        showStatus('ARexx-Kommando erhalten.');
        quit();
      ELSEIF StrCmp(cmd,'ENDE!')
        ReplyMsg(rexxmsg);
        showStatus('ARexx-Kommando erhalten.');
        Raise('quit');
      ELSEIF StrCmp(cmd,'ICONFY')
        ReplyMsg(rexxmsg);
        iconfy();
      ELSEIF StrCmp(cmd,'SPEICHERN')
        ReplyMsg(rexxmsg);
        save();
      ELSEIF StrCmp(cmd,'ÜBER')
        ReplyMsg(rexxmsg);
        about();
      ELSE
        ReplyMsg(rexxmsg);
        showStatus('Unbekanntes ARexx-Kommando erhalten.');
      ENDIF
    ENDIF
  ENDWHILE
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  wertet die 'normalen'-Messages aus  ------------------------*/
PROC handleMsg();
 DEF msg:PTR TO mn

  WHILE (msg:=GetMsg(uport))
    IF msg.ln.type=NT_REPLYMSG
      FreeMem(msg,msg.length);
      showStatus('Antwort erhalten.');
    ELSE
      showStatus('Message erhalten.');
      ReplyMsg(msg);
    ENDIF
  ENDWHILE
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  liest Daten über den Eagleplayer aus  ----------------------*/
PROC getInfos();
 DEF portstr[80]: STRING, comstr[80]:STRING, x, y

    StrCopy(portstr,'rexx_EP');
    IF FindPort(portstr)
      IF (datareading=FALSE) AND (checkData()=FALSE) THEN more();
      IF datareading THEN more();

      g_var:=-1;
      sendRexxMsg(portstr,'status m son',RXFF_RESULT);
      WaitPort(aport);
      handleRexxMsg();
      IF g_var=-1 THEN StrCopy(sgad_name,g_str);
      newName();

      g_var:=0;
      sendRexxMsg(portstr,'status m pnr',RXFF_RESULT);
      WaitPort(aport);
      handleRexxMsg();

      StrCopy(comstr,'status p ');
      StrAdd(comstr,g_var);
      StrAdd(comstr,' nam');
      g_var:=-1;
      sendRexxMsg(portstr,comstr,RXFF_RESULT);
      WaitPort(aport);
      handleRexxMsg();
      IF g_var=-1 THEN StrCopy(sgad_format,g_str);
      LowerStr(g_str);
      IF StrCmp(g_str,'protracker')
        StrCopy(sgad_prefix,'MOD')
      ELSEIF  StrCmp(g_str,'med')
        StrCopy(sgad_prefix,'MED')
      ELSEIF  StrCmp(g_str,'oktalyzer')
        StrCopy(sgad_prefix,'Ok')
      ELSEIF  StrCmp(g_str,'tfmx',4)
        StrCopy(sgad_prefix,'MDAT')
      ELSEIF  StrCmp(g_str,'prorunner',9)
        StrCopy(sgad_prefix,'PRU')
      ENDIF
      newPrefix();
      newFormat();

      sendRexxMsg(portstr,'status m aut',RXFF_RESULT);
      WaitPort(aport);
      handleRexxMsg();
      IF g_var=-1 THEN StrCopy(sgad_author,g_str);
      newAuthor();

      sendRexxMsg(portstr,'status m dur',RXFF_RESULT);
      WaitPort(aport);
      handleRexxMsg();
      x:=Val(g_str);
      y:=Div(x,60);
      StrCopy(comstr,longToStr(y));
      StrAdd(comstr,' : ');
      y:=Mod(x,60);
      IF y<10 THEN StrAdd(comstr,'0');
      StrAdd(comstr,longToStr(y));
      IF g_var=-1 THEN StrCopy(sgad_dauer,comstr);
      newDauer();

      sendRexxMsg(portstr,'status m siz',RXFF_RESULT);
      WaitPort(aport);
      handleRexxMsg();
      newLaenge(0,Val(g_str));

      sendRexxMsg(portstr,'status m sam',RXFF_RESULT);
      WaitPort(aport);
      handleRexxMsg();
      newSamples(0,Val(g_str));

      sendRexxMsg(portstr,'status m pat',RXFF_RESULT);
      WaitPort(aport);
      handleRexxMsg();
      IF g_var=-1 THEN StrCopy(sgad_pfad,g_str);
      newPfad();



      showElement(aktfeld.nummer);
      saveok:=FALSE;
      IF datareading THEN doARexx();
      g_var:=0;
    ELSE
      showStatus('Eagleplayer nicht aktiv.');
    ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/

/*-----  merkt sich ob der Menüpunkt abgehakt ist  ------------------*/
PROC switch() IS IF datareading THEN datareading:=FALSE ELSE datareading:=TRUE;
/*-------------------------------------------------------------------*/

/*-----  veranlasst das Iconfizieren --------------------------------*/
PROC doIconfy() IS sendRexxMsg('MMV_REXX','ICONFY');
/*-------------------------------------------------------------------*/

/*-----  wandelt das Fenster in ein AppIcon -------------------------*/
PROC iconfy();
 DEF stmess: PTR TO wbstartup, do=NIL:PTR TO diskobject,
     appicon=NIL, appmsg: PTR TO appmessage, quit=FALSE

  IF (iconbase:=OpenLibrary('icon.library',37))
    IF (workbenchbase:=OpenLibrary('workbench.library',37))
      IF (stmess:=wbmessage)
        CurrentDir(stmess.arglist.lock);
        do:=GetDiskObjectNew(stmess.arglist.name);
      ELSE
        do:=GetDefDiskObject(WBTOOL);
      ENDIF
      IF do
        appicon:=AddAppIconA(0,0,'MMV',uport,NIL,do,NIL)
        IF appicon
          cleangui(gh);
          REPEAT
            WaitPort(uport);
            WHILE appmsg:=GetMsg(uport);
              IF (appmsg.numargs=0) THEN quit:=TRUE;
              ReplyMsg(appmsg);
            ENDWHILE
          UNTIL quit;
          RemoveAppIcon(appicon);
          IF (gh:=guiinit(VERSION,guigads,info,pubscreen,NIL,guimenu))=NIL THEN Raise("WIN");
        ELSE
          showStatus('Konnte kein AppIcon bekommen.');
        ENDIF
        FreeDiskObject(do);
      ELSE
        showStatus('Konnte kein DiskObject bekommen.');
      ENDIF
      CloseLibrary(workbenchbase);
    ELSE
      showStatus('Konnte "workbench.library" V37 nicht öffnen.');
    ENDIF
    CloseLibrary(iconbase);
  ELSE
    showStatus('Konnte "icon.library" V37 nicht öffnen.');
  ENDIF
ENDPROC;
/*-------------------------------------------------------------------*/


CHAR    '$VER: MMV - Version 1.01 05.07.1996 ',0
