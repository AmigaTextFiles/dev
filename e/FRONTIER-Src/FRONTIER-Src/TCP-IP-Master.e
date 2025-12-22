OPT OSVERSION=37
OPT LARGE

MODULE  'asl'                           /* Offsets der ASL.library              */
MODULE  'exec/memory'                   /* Memory-Funktionen ect...             */
MODULE  'graphics/rastport'             /* Für den RAST-PORT-Zeichenmodus       */
MODULE  'graphics/text'                 /* Für textattr-Objekt...               */
MODULE  'graphics/view'                 /* ViewPort ect...                      */
MODULE  'plugins/imgplug'               /* Image Plugin für EasyGUI...          */
MODULE  'icon'                          /* Für die einbindung der Icons...      */
MODULE  'intuition/intuition'           /* Objektdefinition >image< ect...      */
MODULE  'intuition/screens'             /* Für Bildschirmsachen ect...          */
MODULE  'libraries/asl'                 /* Globale Variablen ect. zur asl.lib.  */
MODULE  'libraries/gadtools'            /* Für die Menüs...                     */
MODULE  'libraries/locale'              /* Variablen, Objekte zur locale.lib    */
MODULE  'locale'                        /* Funktionen (OFFSETE) der "           */
-> MODULE  'tools/closewindowsafely'       /* Sicherer Fenster schließen...        */
MODULE  'easygui_lib'                   /* Für die Oberfläche (PREFS)           */
MODULE  'libraries/easygui_lib'         /* Für die Oberfläche (PREFS)           */
MODULE  'workbench/workbench'           /* Variablen ect. zur Workbench...      */

/* 
 *  TCP/IP-Master:
 * -==============-
 * 
 * 
 * 
 */

->      Fehlerquellen festlegen...

ENUM    ERR_NONE                /* Dummy...                                     */,
        ERR_MEM                 /* Nicht genug Speicher...                      */,
        ERR_WIN_OPEN            /* Fehler beim öffnen des Fensters...           */,
        ERR_WIN_CLOSE           /* Fehler beim schließen des Fensters...        */,
        ERR_LIB                 /* Library...                                   */

->      Exceptions im Vorraus festlegen...

RAISE   ERR_LIB IF      OpenLibrary()=NIL

->      Sprachvariablen festlegen...

ENUM    LOC_REQ_TITLE           /* Titel eines requesters...                    */,
        LOC_REQ_QUIT            /* BODY des "Wirklich Beenden"-Requesters...    */,
        LOC_REQ_SNET            /* BODY des "Netzwerk starten"-Requesters...    */,
        LOC_REQ_GADS            /* Gadgets des Requesters...                    */,
        MSC_ERR_PRE             /* Fehler:                                      */,
        MSC_ERR_SUF             /* !<return>                                    */,
        MSC_ERR_MEM             /* Nicht genug Speicher...                      */,
        MSC_ERR_WIN_OPEN        /* Konnte Fenster nicht öffnen                  */,
        MSC_ERR_WIN_CLOSE       /* Konnte Fenster nicht schließen...            */,
        GUI_TIT                 /* Titel des Prefs-Fensters...                  */,
        GUI_IRC                 /* Name des IRC-Clients...                      */,
        GUI_FTP                 /* Name des FTP-Clients...                      */,
        GUI_MOS                 /* Name des MOSAIC-Clients                      */,
        GUI_POP                 /* Name des POP-Clients                         */,
        GUI_SLP                 /* Name des SLIP-Dialers (oder Terminalprogramm)*/,
        GUI_TRM                 /* Ist der Dialler ein Terminalprogramm??       */,
        GUI_NET                 /* Netzwerk nach dem Dialler starten?           */,
        GUI_QUIT                /* Abbruch!                                     */,
        GUI_SAVE                /* Speichern                                    */,
        GUI_BAT1                /* Batch beim Starten                           */,
        GUI_BAT2                /* Batch beim Stoppen                           */,
        GUI_SRTNET              /* Netzstarten-Befehl...                        */,
        GUI_STPNET              /* Netz-Beenden-Befehl...                       */,
        GUI_SYSTEM              /* Systemeinstellungen...                       */,
        GUI_TOOL                /* Tools                                        */,
        GUI_ERR_LIB             /* Library...                                   */,
        GUI_USE                 /* Benutzen...                                  */,
        GUI_IMG1                /* Image 1                                      */,
        GUI_IMG2                /* Image 2                                      */,
        GUI_IMG3                /* Image 3                                      */,
        GUI_IMG4                /* Image 4                                      */,
        GUI_IMG5                /* Image 5                                      */,
        GUI_IMG6                /* Image 6                                      */,
        GUI_IMG7                /* Image 7                                      */,
        GUI_TOL_BUTTON          /* Programme für Tools                          */,
        GUI_TOL_CHOOSE          /* wählen                                       */,
        GUI_WEITER              /* Weiter-Button                                */,
        MEN_PROJECT             /* Projekt-Menü (titel)                         */,
        MEN_ABOUT               /* Über...                                      */,
        MEN_QUIT                /* Beenden...                                   */,
        MEN_NETWORK             /* Netzwerk                                     */,
        MEN_STARTNET            /* Netzwerk starten                             */,
        MEN_STOPNET             /* Netzwerk stoppen                             */,
        MEN_STOPBATCH           /* Stopbatch ausführen                          */

->      Main-Variablen festlegen

DEF     catalog=NIL             /* Später POINTER auf die Sprache/Katalog       */,
        wbxsize                 /* Breite des Workbench-Screens                 */,
        wbysize                 /* Höhe des Workbench-Screens                   */,
        wbdepth                 /* "Tiefe" des Workbench-Screens                */,
        wbtitleheight           /* Höhe der Wb-Titelleiste...                   */,
        reqtitle                /* Titel der TCP/IP-Requester...                */

->      Variablen für den Inhalt des Prefs-File und für die Einstellungen...

DEF     sliname[128]:STRING     /* Name des SLIP-Dialers...                     */,
        ircname[128]:STRING     /* Name des IRC-Clients...                      */,
        ftpname[128]:STRING     /* Name des FTP-Clients...                      */,
        mosname[128]:STRING     /* Name des Mosaic-Clients...                   */,
        popname[128]:STRING     /* Name des POP-Mailers...                      */
DEF     sliterm=FALSE           /* Ist der Dialer ein Terminalprogramm???       */,
        runnet=FALSE            /* StartNET NACH dem Einwählen aufrufen?        */
DEF     srtbatch  [128]:STRING  /* Batch beim Starten                           */,
        stpbatch  [128]:STRING  /* Batch beim Beenden                           */,
        srtnet    [128]:STRING  /* befehl zum starten des Netzes..              */,
        stpnet    [128]:STRING  /* Befehl zum beenden des Netzes...             */,
        icon01name[128]:STRING  /* Pfad + Name des Icons...                     */,
        icon02name[128]:STRING  /* Pfad + Name des Icons...                     */,
        icon03name[128]:STRING  /* Pfad + Name des Icons...                     */,
        icon04name[128]:STRING  /* Pfad + Name des Icons...                     */,
        icon05name[128]:STRING  /* Pfad + Name des Icons...                     */,
        icon06name[128]:STRING  /* Pfad + Name des Icons...                     */,
        icon07name[128]:STRING  /* Pfad + Name des Icons...                     */,
        tool1prg  [128]:STRING  /* Tool-Programm 1....                          */,
        tool2prg  [128]:STRING  /* Tool-Programm 2....                          */,
        tool3prg  [128]:STRING  /* Tool-Programm 3....                          */,
        tool4prg  [128]:STRING  /* Tool-Programm 4....                          */,
        tool5prg  [128]:STRING  /* Tool-Programm 5....                          */,
        tool6prg  [128]:STRING  /* Tool-Programm 6....                          */,
        tool7prg  [128]:STRING  /* Tool-Programm 7....                          */

->      Variable auf eine Speicheradresse des Icons + Variable für das Icon...

DEF     file01:PTR TO diskobject        /* Pointer aufs Diskobject...   */,
        file02:PTR TO diskobject        /* Pointer aufs Diskobject...   */,
        file03:PTR TO diskobject        /* Pointer aufs Diskobject...   */,
        file04:PTR TO diskobject        /* Pointer aufs Diskobject...   */,
        file05:PTR TO diskobject        /* Pointer aufs Diskobject...   */,
        file06:PTR TO diskobject        /* Pointer aufs Diskobject...   */,
        file07:PTR TO diskobject        /* Pointer aufs Diskobject...   */,
        task=NIL

->      Zustand des Buttons (TRUE oder FALSE)

DEF     but1=NIL:PTR TO imgplug         /* Button 1..                   */,
        but2=NIL:PTR TO imgplug         /* Button 2..                   */,
        but3=NIL:PTR TO imgplug         /* Button 3..                   */,
        but4=NIL:PTR TO imgplug         /* Button 4..                   */,
        but5=NIL:PTR TO imgplug         /* Button 5..                   */,
        but6=NIL:PTR TO imgplug         /* Button 6..                   */,
        but7=NIL:PTR TO imgplug         /* Button 7..                   */,
        tol1:PTR TO imgplug             /* Tool-Button 1...             */,
        tol2:PTR TO imgplug             /* Tool-Button 2...             */,
        tol3:PTR TO imgplug             /* Tool-Button 3...             */,
        tol4:PTR TO imgplug             /* Tool-Button 4...             */,
        tol5:PTR TO imgplug             /* Tool-Button 5...             */,
        tol6:PTR TO imgplug             /* Tool-Button 6...             */,
        tol7:PTR TO imgplug             /* Tool-Button 7...             */

PROC main()     HANDLE
DEF    result
       task:=FindTask(NIL)
       SetTaskPri(task,5)
IF (easyguibase:=OpenLibrary('easygui.library',0))
 iconbase:=OpenLibrary('icon.library',37)        /* Icon.library öffnen...               */
  IF (localebase:=OpenLibrary('locale.library',38)) THEN catalog:=OpenCatalogA(NIL,'TCPIP-Master.catalog',NIL)
   wbxsize,wbysize,wbdepth:=getscreeninfo(NIL)   /* Maße des WB-Screens holen...         */
    wbtitleheight:=13                            /* Höhe einer Titelleiste berechnen...  */
     reqtitle:=getcatstr(LOC_REQ_TITLE)
      loadprefs()
       Execute(srtbatch,NIL,NIL)
->      Speicher anfordern und belegen... (ENTFÄLLT!)
->      Sicherheitscheck, ob Speicher auch allokiert worden ist... (ENTFÄLLT!)
->      Icons öffnen, Gadget und dann daraus das Image holen...
       file01:=GetDiskObject(icon01name)
       file02:=GetDiskObject(icon02name)
       file03:=GetDiskObject(icon03name)
       file04:=GetDiskObject(icon04name)
       file05:=GetDiskObject(icon05name)
       file06:=GetDiskObject(icon06name)
       file07:=GetDiskObject(icon07name)
->      Fenster öffnen...       (ENTFÄLLT!)
       SetTaskPri(task,-1)
        Eg_easygui('TCP/IP-Master',
        [COLS,
                [PLUGIN,{sli},NEW but1.create(file01.gadget,TRUE)],
                [PLUGIN,{irc},NEW but2.create(file02.gadget,TRUE)],
                [PLUGIN,{ftp},NEW but3.create(file03.gadget,TRUE)],
                [PLUGIN,{mos},NEW but4.create(file04.gadget,TRUE)],
                [PLUGIN,{pop},NEW but5.create(file05.gadget,TRUE)],
                [PLUGIN,{tol},NEW but6.create(file06.gadget,TRUE)],
                [PLUGIN,{prf},NEW but7.create(file07.gadget,TRUE)]],0,NIL,NIL,
       [1,0,getcatstr(MEN_PROJECT),      0      ,0,0,0,
        2,0,getcatstr(MEN_ABOUT),       'a'     ,0,0,{about},
        2,0,-1,                          0      ,0,0,0,
        2,0,getcatstr(MEN_QUIT),        'q'     ,0,0,0,
        1,0,getcatstr(MEN_NETWORK),      0      ,0,0,0,
        2,0,getcatstr(MEN_STARTNET),    's'     ,0,0,{startnet},
        2,0,getcatstr(MEN_STOPNET),     'c'     ,0,0,{stopnet},
        2,0,-1,                          0      ,0,0,0,
        2,0,getcatstr(MEN_STOPBATCH),   'b'     ,0,0,{stopbatch},
        0,0,0,0,0,0,0]:newmenu,0,0,0,wbysize)
->,0,0,0,0,0,0,-1,-1
       SetTaskPri(task,5)
->      RastPort zum zeichnen festlegen...      (ENTFÄLLT!)
->      Image/Icon in eine Speicherzelle kopieren... (ENTFÄLLT)
->      Images vorbereiten...                   (ENTFÄLLT)
->      Iconrahmen zeichnen...  (Vorgezogen!)   (ENTFÄLLT!)

->       ActivateWindow(but1.win)
->      Hauptteil...                            (ENTFÄLLT!)
->      Main-Fenster wieder schließen...        (ENTFÄLLT!)

->      Speicher wieder freigeben...            (ENTFÄLLT!)
->      Disk-Objecte wieder freigeben!
   END but1
   END but2
   END but3
   END but4
   END but5
   END but6
   END but7

    IF file01<>NIL THEN FreeDiskObject(file01)
    IF file02<>NIL THEN FreeDiskObject(file02)
    IF file03<>NIL THEN FreeDiskObject(file03)
    IF file04<>NIL THEN FreeDiskObject(file04)
    IF file05<>NIL THEN FreeDiskObject(file05)
    IF file06<>NIL THEN FreeDiskObject(file06)
    IF file07<>NIL THEN FreeDiskObject(file07)

     VOID(' $VER: TCP/IP-Master 1.95 (18.12.1996) © 1996 THE DARK FRONTIER - Softwareentwicklung')
    CloseCatalog(catalog)
   CloseLibrary(localebase)
  CloseLibrary(iconbase)
 CloseLibrary(easyguibase)
ENDIF
Execute(stpbatch,NIL,NIL)
CleanUp(0)
EXCEPT
 WriteF('\s',getcatstr(MSC_ERR_PRE))
  SELECT exception
     CASE       ERR_MEM
        WriteF('\s',getcatstr(MSC_ERR_MEM))
     CASE       ERR_WIN_OPEN
        WriteF('\s',getcatstr(MSC_ERR_WIN_OPEN))
     CASE       ERR_WIN_CLOSE
        WriteF('\s',getcatstr(MSC_ERR_WIN_CLOSE))
     CASE       ERR_LIB
        WriteF('\s',getcatstr(GUI_ERR_LIB))
     CASE       ERR_NONE
     DEFAULT
  LOOP
   result:=Eg_easygui(getcatstr(GUI_TIT),
        [ROWS,
        [BEVEL,
        [ROWS,
        [BEVELR,
        [ROWS,
        [COLS,
                [STR,{strirc},          getcatstr(GUI_IRC),ircname,128,20],
                [BUTTON,10,'*']],
        [COLS,
                [STR,{strftp},          getcatstr(GUI_FTP),ftpname,128,20],
                [BUTTON,11,'*']],
        [COLS,
                [STR,{strmos},          getcatstr(GUI_MOS),mosname,128,20],
                [BUTTON,12,'*']],
        [COLS,
                [STR,{strpop},          getcatstr(GUI_POP),popname,128,20],
                [BUTTON,13,'*']],
        [COLS,
                [STR,{strslp},          getcatstr(GUI_SLP),sliname,128,20],
                [BUTTON,14,'*']]]],
        [BAR],
        [BEVELR,
        [COLS,
                [SBUTTON,0,getcatstr(GUI_QUIT)],
                [SBUTTON,3,getcatstr(GUI_SYSTEM)],
                [SBUTTON,4,getcatstr(GUI_TOOL)],
                [SBUTTON,2,getcatstr(GUI_SAVE)]]]]]],0,NIL,NIL,0,0,0,0,wbysize)
    SELECT result
     CASE 0
      JUMP prfraus
     CASE 2
      saveprefs('envarc:tcpipmaster.conf')
       saveprefs('env:tcpipmaster.conf')
        JUMP prfraus
     CASE 3
      system()
     CASE 4
      toolprf()
     CASE 10
      StrCopy(ircname,filereq(getcatstr(GUI_IRC),'sys:'),ALL)
     CASE 11
      StrCopy(ftpname,filereq(getcatstr(GUI_FTP),'sys:'),ALL)
     CASE 12
      StrCopy(mosname,filereq(getcatstr(GUI_MOS),'sys:'),ALL)
     CASE 13
      StrCopy(popname,filereq(getcatstr(GUI_POP),'sys:'),ALL)
     CASE 14
      StrCopy(sliname,filereq(getcatstr(GUI_SLP),'sys:'),ALL)
    ENDSELECT
  ENDLOOP
 prfraus:
  ENDSELECT
 WriteF('\s\n',getcatstr(MSC_ERR_SUF))
 IF catalog THEN  CloseCatalog(catalog)
 IF localebase THEN CloseLibrary(localebase)
 IF easyguibase THEN CloseLibrary(easyguibase)
CleanUp(20)
ENDPROC

PROC about()            -> Über...:-)
 Eg_easygui(' TCP/IP-Master',
        [ROWS,
        [BEVEL,
        [ROWS,
        [BEVELR,
        [COLS,
        [SPACEH],
                [TEXT,'(18.12.1996)','        Version 1.95',FALSE,3],
        [SPACEH]]],
        [BEVELR,
        [ROWS,
                [TEXT,'wurde programmiert von','Der TCP/IP-Master',FALSE,3],
                [TEXT,'Softwareentwicklungen' ,' THE DARK FRONTIER',FALSE,3],
                [TEXT,' 06347/919072     '    ,'            ',FALSE,3],
                [TEXT,'  ','  ',FALSE,3],
                [TEXT,' Am Hofgraben 2','           ',FALSE,3],
                [TEXT,' 67378 Zeiskam','           ',FALSE,3],
                [TEXT,' Germany / Deutschland  ','        ',FALSE,3]]],
        [BAR],
        [BEVELR,
        [EQCOLS,
        [SPACEH],
                [BUTTON,0,getcatstr(GUI_WEITER)],
        [SPACEH]]]]]],0,0,0,0,0,0,-1,-1)

ENDPROC

PROC stopbatch()
 Execute(stpbatch,NIL,NIL)
ENDPROC

PROC getscreeninfo(screen:PTR TO screen)
 DEF di:PTR TO drawinfo, depth=0
  IF di:=GetScreenDrawInfo(screen)
    depth:=di.depth
    FreeScreenDrawInfo(screen,di)
  ENDIF
ENDPROC screen.width,screen.height,depth

PROC    sli()
 DEF executestr[256]:STRING, really
  IF runnet=FALSE
   StrCopy(executestr,'run >NIL: ',11)
  ENDIF
   StrAdd(executestr,sliname,StrLen(sliname))
    Execute(executestr,NIL,NIL)
    IF sliterm=TRUE     
     really:=EasyRequestArgs(0,[20,0,getcatstr(LOC_REQ_TITLE),getcatstr(LOC_REQ_SNET),getcatstr(LOC_REQ_GADS)],0,NIL)
      IF really=1
       runnet:=FALSE
        really:=runnet
         startnet()
      ENDIF
    ENDIF
     IF runnet=TRUE
      startnet()
     ENDIF
      runnet:=really
ENDPROC

PROC    irc()
 DEF executestr[256]:STRING
  StrCopy(executestr,'run >NIL: ',11)
   StrAdd(executestr,ircname,StrLen(ircname))
  Execute(executestr,NIL,NIL)
ENDPROC

PROC    ftp()
 DEF executestr[256]:STRING
  StrCopy(executestr,'run >NIL: ',11)
   StrAdd(executestr,ftpname,StrLen(ftpname))
  Execute(executestr,NIL,NIL)
ENDPROC

PROC    mos()
 DEF executestr[256]:STRING
  StrCopy(executestr,'run >NIL: ',11)
   StrAdd(executestr,mosname,StrLen(mosname))
  Execute(executestr,NIL,NIL)
ENDPROC

PROC    pop()
 DEF executestr[256]:STRING
  StrCopy(executestr,'run >NIL: ',11)
   StrAdd(executestr,popname,StrLen(popname))
  Execute(executestr,NIL,NIL)
ENDPROC

PROC    prf()
 DEF result
  LOOP
   result:=Eg_easygui(getcatstr(GUI_TIT),
        [BEVELR,
        [ROWS,
        [BEVELR,
        [ROWS,
        [COLS,
                [STR,{strirc},          getcatstr(GUI_IRC),ircname,128,20],
                [BUTTON,10,'*']],
        [COLS,
                [STR,{strftp},          getcatstr(GUI_FTP),ftpname,128,20],
                [BUTTON,11,'*']],
        [COLS,
                [STR,{strmos},          getcatstr(GUI_MOS),mosname,128,20],
                [BUTTON,12,'*']],
        [COLS,
                [STR,{strpop},          getcatstr(GUI_POP),popname,128,20],
                [BUTTON,13,'*']],
        [COLS,
                [STR,{strslp},          getcatstr(GUI_SLP),sliname,128,20],
                [BUTTON,14,'*']]]],
        [BAR],
        [BEVELR,
        [COLS,
                [SBUTTON,0,getcatstr(GUI_QUIT)],
                [SBUTTON,3,getcatstr(GUI_SYSTEM)],
                [SBUTTON,4,getcatstr(GUI_TOOL)],
                [SBUTTON,2,getcatstr(GUI_SAVE)]]]]],0,0,0,0,0,0,-1,-1)
    SELECT result
     CASE 0
      JUMP raus
     CASE 2
      saveprefs('envarc:tcpipmaster.conf')
       saveprefs('env:tcpipmaster.conf')
        JUMP raus
     CASE 3
      system()
     CASE 4
      toolprf()
     CASE 10
      StrCopy(ircname,filereq(getcatstr(GUI_IRC),'sys:'),ALL)
     CASE 11
      StrCopy(ftpname,filereq(getcatstr(GUI_FTP),'sys:'),ALL)
     CASE 12
      StrCopy(mosname,filereq(getcatstr(GUI_MOS),'sys:'),ALL)
     CASE 13
      StrCopy(popname,filereq(getcatstr(GUI_POP),'sys:'),ALL)
     CASE 14
      StrCopy(sliname,filereq(getcatstr(GUI_SLP),'sys:'),ALL)
    ENDSELECT
  ENDLOOP
 raus:
ENDPROC

PROC toolprf()
 DEF result
  LOOP
   result:=Eg_easygui(getcatstr(GUI_TOOL),
        [ROWS,
        [BEVEL,
        [ROWS,
        [BEVELR,
        [ROWS,
                [TEXT,getcatstr(GUI_TOL_CHOOSE),getcatstr(GUI_TOL_BUTTON),FALSE,3]]],
        [BEVELR,
        [COLS,
        [ROWS,
        [COLS,
                [STR,{tol01},           getcatstr(GUI_IMG1),tool1prg,128,10],
                [BUTTON,10,'*']],
        [COLS,
                [STR,{tol02},           getcatstr(GUI_IMG2),tool2prg,128,10],
                [BUTTON,11,'*']],
        [COLS,
                [STR,{tol03},           getcatstr(GUI_IMG3),tool3prg,128,10],
                [BUTTON,12,'*']],
        [COLS,
                [STR,{tol04},           getcatstr(GUI_IMG4),tool4prg,128,10],
                [BUTTON,13,'*']]],
        [ROWS,
        [COLS,
                [STR,{tol05},           getcatstr(GUI_IMG5),tool5prg,128,10],
                [BUTTON,14,'*']],
        [COLS,
                [STR,{tol06},           getcatstr(GUI_IMG6),tool6prg,128,10],
                [BUTTON,15,'*']],
        [COLS,
                [STR,{tol07},           getcatstr(GUI_IMG7),tool7prg,128,10],
                [BUTTON,16,'*']],
                [TEXT,'','',FALSE,3]]]],
        [BAR],
        [BEVELR,
        [COLS,
        [SPACEH],
                [BUTTON,0,getcatstr(GUI_QUIT)],
        [SPACEH]]]]]],0,0,0,0,0,0,-1,-1)
   SELECT result
    CASE 0
     JUMP wech
    CASE 10
     StrCopy(tool1prg,filereq(getcatstr(GUI_IMG1),'sys:'),ALL)
    CASE 11
     StrCopy(tool2prg,filereq(getcatstr(GUI_IMG2),'sys:'),ALL)
    CASE 12
     StrCopy(tool3prg,filereq(getcatstr(GUI_IMG3),'sys:'),ALL)
    CASE 13
     StrCopy(tool4prg,filereq(getcatstr(GUI_IMG4),'sys:'),ALL)
    CASE 14
     StrCopy(tool5prg,filereq(getcatstr(GUI_IMG5),'sys:'),ALL)
    CASE 15
     StrCopy(tool6prg,filereq(getcatstr(GUI_IMG6),'sys:'),ALL)
    CASE 16
     StrCopy(tool7prg,filereq(getcatstr(GUI_IMG7),'sys:'),ALL)
   ENDSELECT
  ENDLOOP
 wech:
ENDPROC

PROC tol01(x,y) IS      StrCopy(tool1prg,y,StrLen(y))
PROC tol02(x,y) IS      StrCopy(tool2prg,y,StrLen(y))
PROC tol03(x,y) IS      StrCopy(tool3prg,y,StrLen(y))
PROC tol04(x,y) IS      StrCopy(tool4prg,y,StrLen(y))
PROC tol05(x,y) IS      StrCopy(tool5prg,y,StrLen(y))
PROC tol06(x,y) IS      StrCopy(tool6prg,y,StrLen(y))
PROC tol07(x,y) IS      StrCopy(tool7prg,y,StrLen(y))

PROC system()
 DEF    result
  LOOP
   result:=Eg_easygui(getcatstr(GUI_SYSTEM),
        [BEVEL,
        [ROWS,
        [BEVELR,
        [ROWS,
        [COLS,
                [STR,{srtn},            getcatstr(GUI_SRTNET),srtnet,128,20],
                [BUTTON,10,'*']],
        [COLS,
                [STR,{stpn},            getcatstr(GUI_STPNET),stpnet,128,20],
                [BUTTON,11,'*']]]],
        [BEVELR,
        [ROWS,
        [COLS,
                [STR,{startbat},        getcatstr(GUI_BAT1),srtbatch,128,20],
                [BUTTON,12,'*']],
        [COLS,
                [STR,{stopbat},         getcatstr(GUI_BAT2),stpbatch,128,20],
                [BUTTON,13,'*']]]],
        [BEVELR,
        [COLS,
        [SPACEH],
                [CHECK,{checkterm},     getcatstr(GUI_TRM),sliterm,TRUE],
                [CHECK,{checknet},      getcatstr(GUI_NET),runnet, FALSE],
        [SPACEH]]],
        [BEVELR,
        [COLS,
        [ROWS,
        [COLS,
                [STR,{img01},           getcatstr(GUI_IMG1),icon01name,128,10],
                [BUTTON,20,'*']],
        [COLS,
                [STR,{img02},           getcatstr(GUI_IMG2),icon02name,128,10],
                [BUTTON,21,'*']],
        [COLS,
                [STR,{img03},           getcatstr(GUI_IMG3),icon03name,128,10],
                [BUTTON,22,'*']],
        [COLS,
                [STR,{img04},           getcatstr(GUI_IMG4),icon04name,128,10],
                [BUTTON,23,'*']]],
        [ROWS,
        [COLS,
                [STR,{img05},           getcatstr(GUI_IMG5),icon05name,128,10],
                [BUTTON,24,'*']],
        [COLS,
                [STR,{img06},           getcatstr(GUI_IMG6),icon06name,128,10],
                [BUTTON,25,'*']],
        [COLS,
                [STR,{img07},           getcatstr(GUI_IMG7),icon07name,128,10],
                [BUTTON,26,'*']],
                [TEXT,'','',FALSE,3]]]],
        [BAR],
        [BEVELR,
        [COLS,
        [SPACEH],
                [BUTTON,0,getcatstr(GUI_QUIT)],
        [SPACEH]]]]],0,0,0,0,0,0,-1,-1)
   SELECT       result
    CASE 0
     JUMP raus
    CASE 10
     StrCopy(srtnet,filereq(getcatstr(GUI_SRTNET),'sys:'),ALL)
    CASE 11
     StrCopy(stpnet,filereq(getcatstr(GUI_STPNET),'sys:'),ALL)
    CASE 12
     StrCopy(srtbatch,filereq(getcatstr(GUI_BAT1),'sys:'),ALL)
    CASE 13
     StrCopy(stpbatch,filereq(getcatstr(GUI_BAT2),'sys:'),ALL)
    CASE 20
     StrCopy(icon01name,filereq(getcatstr(GUI_IMG1),'sys:prefs/buttons'),ALL)
    CASE 21
     StrCopy(icon02name,filereq(getcatstr(GUI_IMG2),'sys:prefs/buttons'),ALL)
    CASE 22
     StrCopy(icon03name,filereq(getcatstr(GUI_IMG3),'sys:prefs/buttons'),ALL)
    CASE 23
     StrCopy(icon04name,filereq(getcatstr(GUI_IMG4),'sys:prefs/buttons'),ALL)
    CASE 24
     StrCopy(icon05name,filereq(getcatstr(GUI_IMG5),'sys:prefs/buttons'),ALL)
    CASE 25
     StrCopy(icon06name,filereq(getcatstr(GUI_IMG6),'sys:prefs/buttons'),ALL)
    CASE 26
     StrCopy(icon07name,filereq(getcatstr(GUI_IMG7),'sys:prefs/buttons'),ALL)
   ENDSELECT
  ENDLOOP
 raus:
ENDPROC


PROC loadprefs()
 DEF file, buf[128]:STRING
  IF (file:=Open('env:tcpipmaster.conf',OLDFILE))=NIL THEN JUMP ende
   Read(file,buf,128)
   StrCopy(sliname,buf,128)     /* Name des SLIP-Dialers...                     */
   Read(file,buf,128)
   StrCopy(ircname,buf,128)     /* Name des IRC-Clients...                      */
   Read(file,buf,128)
   StrCopy(ftpname,buf,128)     /* Name des FTP-Clients...                      */
   Read(file,buf,128)
   StrCopy(mosname,buf,128)     /* Name des Mosaic-Clients...                   */
   Read(file,buf,128)
   StrCopy(popname,buf,128)     /* Name des POP-Mailers...                      */
   Read(file,buf,1)
    IF StrCmp(buf,'T',1)=FALSE
     sliterm:=FALSE             /* Ist der Dialer ein Terminalprogramm???       */
    ELSE
     sliterm:=TRUE
    ENDIF
   Read(file,buf,1)
    IF StrCmp(buf,'T',1)=FALSE
     runnet:=FALSE              /* StartNET NACH dem Einwählen aufrufen?        */
    ELSE
     runnet:=TRUE
    ENDIF
   Read(file,srtbatch,128)
   Read(file,stpbatch,128)
   Read(file,srtnet,128)
   Read(file,stpnet,128)
   Read(file,icon01name,128)
   Read(file,icon02name,128)
   Read(file,icon03name,128)
   Read(file,icon04name,128)
   Read(file,icon05name,128)
   Read(file,icon06name,128)
   Read(file,icon07name,128)
    IF StrLen(icon01name)<1 THEN StrCopy(icon01name,'sys:prefs/buttons/mstr_connect',)
    IF StrLen(icon02name)<1 THEN StrCopy(icon02name,'sys:prefs/buttons/mstr_irc',)
    IF StrLen(icon03name)<1 THEN StrCopy(icon03name,'sys:prefs/buttons/mstr_ftp',)
    IF StrLen(icon04name)<1 THEN StrCopy(icon04name,'sys:prefs/buttons/mstr_mos',)
    IF StrLen(icon05name)<1 THEN StrCopy(icon05name,'sys:prefs/buttons/mstr_pop',)
    IF StrLen(icon06name)<1 THEN StrCopy(icon06name,'sys:prefs/buttons/mstr_tool',)
    IF StrLen(icon07name)<1 THEN StrCopy(icon07name,'sys:prefs/buttons/mstr_pref',)
   Read(file,tool1prg,128)
   Read(file,tool2prg,128)
   Read(file,tool3prg,128)
   Read(file,tool4prg,128)
   Read(file,tool5prg,128)
   Read(file,tool6prg,128)
   Read(file,tool7prg,128)
  IF file THEN Close(file)
 ende:
ENDPROC

PROC saveprefs(prefname)        -> 'envarc:tcpipmaster.conf'
 DEF file
  IF (file:=Open(prefname,NEWFILE))=NIL THEN JUMP ende2
   Write(file,sliname,128)
   Write(file,ircname,128)
   Write(file,ftpname,128)
   Write(file,mosname,128)
   Write(file,popname,128)
    IF sliterm=FALSE
   Write(file,'F',1)
    ELSE
   Write(file,'T',1)
    ENDIF
    IF runnet=FALSE
   Write(file,'F',1)
    ELSE
   Write(file,'T',1)
    ENDIF
   Write(file,srtbatch,128)
   Write(file,stpbatch,128)
   Write(file,srtnet,128)
   Write(file,stpnet,128)
   Write(file,icon01name,128)
   Write(file,icon02name,128)
   Write(file,icon03name,128)
   Write(file,icon04name,128)
   Write(file,icon05name,128)
   Write(file,icon06name,128)
   Write(file,icon07name,128)
   Write(file,tool1prg,128)
   Write(file,tool2prg,128)
   Write(file,tool3prg,128)
   Write(file,tool4prg,128)
   Write(file,tool5prg,128)
   Write(file,tool6prg,128)
   Write(file,tool7prg,128)

  IF file THEN Close(file)
 ende2:
ENDPROC

PROC startbat(x,y)   IS      StrCopy(srtbatch,y,StrLen(y))
PROC stopbat(x,y)    IS      StrCopy(stpbatch,y,StrLen(y))
PROC strirc(x,y)     IS      StrCopy(ircname,y,StrLen(y))
PROC strftp(x,y)     IS      StrCopy(ftpname,y,StrLen(y))
PROC strmos(x,y)     IS      StrCopy(mosname,y,StrLen(y))
PROC strpop(x,y)     IS      StrCopy(popname,y,StrLen(y))
PROC strslp(x,y)     IS      StrCopy(sliname,y,StrLen(y))
PROC srtn(x,y)       IS      StrCopy(srtnet,y,StrLen(y))
PROC stpn(x,y)       IS      StrCopy(stpnet,y,StrLen(y))
PROC checkterm(x,y)  IS      sliterm:=y
PROC checknet(x,y)   IS      runnet:=y
PROC img01(x,y)      IS      StrCopy(icon01name,y,StrLen(y))
PROC img02(x,y)      IS      StrCopy(icon02name,y,StrLen(y))
PROC img03(x,y)      IS      StrCopy(icon03name,y,StrLen(y))
PROC img04(x,y)      IS      StrCopy(icon04name,y,StrLen(y))
PROC img05(x,y)      IS      StrCopy(icon05name,y,StrLen(y))
PROC img06(x,y)      IS      StrCopy(icon06name,y,StrLen(y))
PROC img07(x,y)      IS      StrCopy(icon07name,y,StrLen(y))

PROC getcatstr(id)
 DEF str
  SELECT id
     CASE LOC_REQ_TITLE         /* Titel eines requesters...                    */
      str:='TCP/IP-Master Meldung:'
     CASE LOC_REQ_QUIT          /* BODY des "Wirklich Beenden"-Requesters...    */
      str:='TCP/IP-Master wirklich beenden?'
     CASE LOC_REQ_SNET          /* BODY des "Netzwerk starten"-Requesters...    */
      str:='Netzwerk starten?'
     CASE LOC_REQ_GADS          /* Gadgets des Requesters...                    */
      str:='    OK    | Abrruch! '
     CASE MSC_ERR_PRE           /* Fehler:                                      */
      str:='Fehler '
     CASE MSC_ERR_SUF           /* !                                            */
      str:='!'
     CASE MSC_ERR_MEM           /* Nicht genug Speicher...                      */
      str:='Nicht genug Speicher vorhanden!?'
     CASE MSC_ERR_WIN_OPEN      /* Konnte Fenster nicht öffnen                  */
      str:='Konnte das MAIN-Fenster nicht öffnen'
     CASE MSC_ERR_WIN_CLOSE     /* Konnte Fenster nicht schließen...            */
      str:='Konnte das MAIN-Fenster nicht schließen'
     CASE GUI_TIT               /* Titel des Prefs-Fensters...                  */
      str:=' TCP/IP-Master Preferences '
     CASE GUI_IRC               /* Name des IRC-Clients...                      */
      str:='      IRC-Client: '
     CASE GUI_FTP               /* Name des FTP-Clients...                      */
      str:='      FTP-Client: '
     CASE GUI_MOS               /* Name des MOSAIC-Clients                      */
      str:='   Mosaic-Client: '
     CASE GUI_POP               /* Name des POP-Clients                         */
      str:='      POP-Client: '
     CASE GUI_SLP               /* Name des SLIP-Dialers (oder Terminalprogramm)*/
      str:='    SLIP-Dialler: '
     CASE GUI_TRM               /* Ist der Dialler ein Terminalprogramm??       */
      str:='Dial via Term'
     CASE GUI_NET               /* Netzwerk nach dem Dialler starten?           */
      str:='StartNET'
     CASE GUI_QUIT              /* Abbruch!                                     */
      str:='   Abbruch!  '
     CASE GUI_SAVE              /* Speichern                                    */
      str:='  Speichern  '
     CASE GUI_BAT1              /* Batch1                                       */
      str:='Batch beim Starten: '
     CASE GUI_BAT2              /* Batch2                                       */
      str:='Batch beim Stoppen: '
     CASE GUI_SRTNET            /* Netz starten                                 */
      str:='StartNET: '
     CASE GUI_STPNET            /* Netz stopen...                               */
      str:='StopNET : '
     CASE GUI_SYSTEM            /* System                                       */
      str:='   System   '
     CASE GUI_TOOL              /* Tools                                        */
      str:=' Tools '
     CASE GUI_ERR_LIB           /* Library...                                   */
      str:=' Konnte Library nicht öffnen... '
     CASE GUI_USE
      str:='  Benutzen  '
     CASE GUI_IMG1
      str:='Button 1:'
     CASE GUI_IMG2
      str:='Button 2:'
     CASE GUI_IMG3
      str:='Button 3:'
     CASE GUI_IMG4
      str:='Button 4:'
     CASE GUI_IMG5
      str:='Button 5:'
     CASE GUI_IMG6
      str:='Button 6:'
     CASE GUI_IMG7
      str:='Button 7:'
     CASE GUI_TOL_BUTTON
      str:='Programme für Tools'
     CASE GUI_TOL_CHOOSE
      str:='wählen'
     CASE GUI_WEITER
      str:='Weiter'
     CASE MEN_PROJECT 
      str:='Projekt'
     CASE MEN_ABOUT   
      str:='Über...'
     CASE MEN_QUIT    
      str:='Beenden'
     CASE MEN_NETWORK 
      str:='Netzwerk'
     CASE MEN_STARTNET
      str:='Starten'
     CASE MEN_STOPNET 
      str:='Herunterfahren'
     CASE MEN_STOPBATCH
      str:='Schlußbatch ausführen'
  ENDSELECT
 IF catalog THEN str:=GetCatalogStr(catalog,id,str)
ENDPROC str

PROC tol()              -> Wird neu gestaltet, so wie der Toolmanager :-)
 DEF    file11=NIL:PTR TO diskobject    /* Icon...              */,
        file12=NIL:PTR TO diskobject    /* Icon...              */,
        file13=NIL:PTR TO diskobject    /* Icon...              */,
        file14=NIL:PTR TO diskobject    /* Icon...              */,
        file15=NIL:PTR TO diskobject    /* Icon...              */,
        file16=NIL:PTR TO diskobject    /* Icon...              */,
        file17=NIL:PTR TO diskobject    /* Icon...              */

->      Tool-Icon wieder normal machen...

->      Icons öffnen, Gadget holen... daraus später die beiden Images holen...

       file11:=GetDiskObject(tool1prg)  /* Icon 1 öffnen...     */
       file12:=GetDiskObject(tool2prg)  /* Icon 2 öffnen...     */
       file13:=GetDiskObject(tool3prg)  /* Icon 3 öffnen...     */
       file14:=GetDiskObject(tool4prg)  /* Icon 4 öffnen...     */
       file15:=GetDiskObject(tool5prg)  /* Icon 5 öffnen...     */
       file16:=GetDiskObject(tool6prg)  /* Icon 6 öffnen...     */
       file17:=GetDiskObject(tool7prg)  /* Icon 7 öffnen...     */

        Eg_easygui('TCP/IP-Master',        /* EasyGUI-Init...      */
        [COLS,
        [BEVEL,
        [COLS,                          /* Alles nebeneinander. */
                [PLUGIN,{prg1},NEW tol1.create(file11.gadget,TRUE)],
                [PLUGIN,{prg2},NEW tol2.create(file12.gadget,TRUE)],
                [PLUGIN,{prg3},NEW tol3.create(file13.gadget,TRUE)],
                [PLUGIN,{prg4},NEW tol4.create(file14.gadget,TRUE)],
                [PLUGIN,{prg5},NEW tol5.create(file15.gadget,TRUE)],
                [PLUGIN,{prg6},NEW tol6.create(file16.gadget,TRUE)],
                [PLUGIN,{prg7},NEW tol7.create(file17.gadget,TRUE)]]]],0,0,0,0,0,0,-1,-1)
        END tol1
        END tol2
        END tol3
        END tol4
        END tol5
        END tol6
        END tol7
    IF file11<>NIL THEN FreeDiskObject(file11)
    IF file12<>NIL THEN FreeDiskObject(file12)
    IF file13<>NIL THEN FreeDiskObject(file13)
    IF file14<>NIL THEN FreeDiskObject(file14)
    IF file15<>NIL THEN FreeDiskObject(file15)
    IF file16<>NIL THEN FreeDiskObject(file16)
    IF file17<>NIL THEN FreeDiskObject(file17)
ENDPROC

PROC prg1()
 DEF    execstr[180]:STRING             /* String...            */
   StrCopy(execstr,'c:run >NIL ',12)     /* NICHT Blockieren!    */
    StrAdd(execstr,tool1prg,StrLen(tool1prg))
     Execute(execstr,NIL,NIL)       /* Ausgabe UMLEITEN!    */
ENDPROC

PROC prg2()
 DEF    execstr[180]:STRING             /* String...            */
   StrCopy(execstr,'c:run >NIL ',12)     /* NICHT Blockieren!    */
    StrAdd(execstr,tool2prg,StrLen(tool2prg))
     Execute(execstr,NIL,NIL)       /* Ausgabe UMLEITEN!    */
ENDPROC

PROC prg3()
 DEF    execstr[180]:STRING             /* String...            */
   StrCopy(execstr,'c:run >NIL ',12)     /* NICHT Blockieren!    */
    StrAdd(execstr,tool3prg,StrLen(tool3prg))
     Execute(execstr,NIL,NIL)       /* Ausgabe UMLEITEN!    */
ENDPROC

PROC prg4()
 DEF    execstr[180]:STRING             /* String...            */
   StrCopy(execstr,'c:run >NIL ',12)     /* NICHT Blockieren!    */
    StrAdd(execstr,tool4prg,StrLen(tool4prg))
     Execute(execstr,NIL,NIL)       /* Ausgabe UMLEITEN!    */
ENDPROC

PROC prg5()
 DEF    execstr[180]:STRING             /* String...            */
   StrCopy(execstr,'c:run >NIL ',12)     /* NICHT Blockieren!    */
    StrAdd(execstr,tool5prg,StrLen(tool5prg))
     Execute(execstr,NIL,NIL)       /* Ausgabe UMLEITEN!    */
ENDPROC

PROC prg6()
 DEF    execstr[180]:STRING             /* String...            */
   StrCopy(execstr,'c:run >NIL ',12)     /* NICHT Blockieren!    */
    StrAdd(execstr,tool6prg,StrLen(tool6prg))
     Execute(execstr,NIL,NIL)       /* Ausgabe UMLEITEN!    */
ENDPROC

PROC prg7()
 DEF    execstr[180]:STRING             /* String...            */
   StrCopy(execstr,'c:run >NIL ',12)     /* NICHT Blockieren!    */
    StrAdd(execstr,tool7prg,StrLen(tool7prg))
     Execute(execstr,NIL,NIL)       /* Ausgabe UMLEITEN!    */
ENDPROC

PROC startnet()
 Execute(srtnet,NIL,NIL)
ENDPROC

PROC stopnet()
 Execute(stpnet,NIL,NIL)
ENDPROC

PROC filereq(title,dir)
 DEF    fr:PTR TO filerequester         /* Asl-Filerequester-Object...          */,
        filename[128]:STRING            /* Filename...                          */,
        stripstr[1]:STRING              /* Letztes Zeichen...                   */
  IF (aslbase:=OpenLibrary('asl.library',37))=NIL THEN Raise(ERR_LIB)
   fr:=AllocAslRequest(ASL_FILEREQUEST,
                     [ASL_HAIL,       title,
                      ASL_OKTEXT,     getcatstr(GUI_USE),
                      ASL_CANCELTEXT, getcatstr(GUI_QUIT),
                      ASL_DIR,        dir,
                      NIL])
    IF AslRequest(fr, NIL)
     StrCopy(filename,fr.drawer,StrLen(fr.drawer))
      RightStr(stripstr,filename,1)
       IF StrCmp(stripstr,':',1)=FALSE AND StrCmp(stripstr,'/',1)=FALSE
        StrAdd(filename,'/',1)
       ENDIF
      StrAdd(filename,fr.file,StrLen(fr.file))
    ENDIF
   IF fr THEN FreeAslRequest(fr)
  CloseLibrary(aslbase)
ENDPROC filename
