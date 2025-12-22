/* 
   BER für AMIGA geschrieben von Andreas Rehm ©1994

   BER kann Jahrestage in ein Monatsdaten umrechnen und umgekehrt.

   Copyright by HAWK ©1994
*/  


OPT OSVERSION=37 /* DOS 2.0+ erforderlich */

MODULE 'tools/EasyGui', 'reqtools', 'libraries/reqtools' /* MODULE holen */

DEF jtag, tag, monat, mon, titel, mocheck
DEF jahrcheck, woche, jt                  /* Definitionen */

PROC main()
 titel:='BER - © Andreas Rehm 1994-95' /* Requester Titel */
 IF reqtoolsbase:=OpenLibrary('reqtools.library',38) /* ReyTools © bei Nico François öffnen */
  mocheck:=
  jahrcheck:=0
  easygui(titel,
   [EQROWS,
    [BEVEL,
     [COLS,
      [BEVEL,
       [EQROWS,
        [BUTTON,{prozedura},'Jahrestag -> Datum'],
        [BUTTON,{prozedurb},'Datum -> Jahrestag']
        ]
       ],
       [BEVEL,
        [EQROWS,
         [BUTTON,{info},'Information'],
         [BUTTON,0,'Beenden']
        ]
       ]
      ]
     ],
    [BEVEL,
     [EQROWS,
      [CHECK,{monnam},'Monat als Namen anzeigen',FALSE,TRUE],
      [CHECK,{schaltjahr},'Berechnung für Schaltjahr',FALSE,TRUE]
     ]
    ]
   ])  /* Oberfläche struckturieren */
  CloseLibrary(reqtoolsbase)
 ELSE
  EasyRequestArgs(0,[20,0,0,titel,'Das Programm benötigt ReqTools V38 © Nico François!','OK'],0,NIL)
 ENDIF
ENDPROC

CHAR '\0$VER: \e[32mBER 1.58\e[0m (22.02.95)\0' /* Versionstring */

PROC info() IS RtEZRequestA('BER ©1994\n\nBER kann Jahrestage in Monatsdaten und\nMonatsdaten in Jahrestage umrechnen.\n\nBER verwendet die ReqTools V38+\n© bei Nico François\n\n______________________________________\n\nBER Version 1.58\n\nNetzadresse des Authors (Andreas Rehm)\n\nHAWK@FREEWAY.SHNET.ORG','                    OK                    ',[REQPOS_CENTERWIN,2],0,[RTEZ_REQTITLE,titel])

PROC monnam(x) /* MX Daten auswerten und Konfig erstellen */
 IF x=-1
  mocheck:=1
 ELSE
  mocheck:=0
 ENDIF
ENDPROC

PROC schaltjahr(x)
 IF x=-1
  jahrcheck:=1
 ELSE
  jahrcheck:=0
 ENDIF 
ENDPROC

PROC prozedura() /* Berechnung des Datums */
 programma:
 IF RtGetLongA({jtag},'Jahrestag eingeben',0,0)
  IF jtag<1
   erra('klein')
   JUMP programma
  ELSEIF jtag<=31
   tag:=jtag
   monat:=1
  ELSEIF jtag<=(59+jahrcheck)
   tag:=jtag-31
   monat:=2
  ELSEIF jtag<=(90+jahrcheck)
   tag:=jtag-59-jahrcheck
   monat:=3
  ELSEIF jtag<=(120+jahrcheck)
   tag:=jtag-90-jahrcheck 
   monat:=4
  ELSEIF jtag<=(151+jahrcheck)
   tag:=jtag-120-jahrcheck 
   monat:=5
  ELSEIF jtag<=(181+jahrcheck)
   tag:=jtag-151-jahrcheck 
   monat:=6
  ELSEIF jtag<=(212+jahrcheck)
   tag:=jtag-181-jahrcheck 
   monat:=7
  ELSEIF jtag<=(243+jahrcheck)
   tag:=jtag-212-jahrcheck 
   monat:=8
  ELSEIF jtag<=(273+jahrcheck)
   tag:=jtag-242-jahrcheck 
   monat:=9
  ELSEIF jtag<=(304+jahrcheck)
   tag:=jtag-273-jahrcheck 
   monat:=10
  ELSEIF jtag<=(334+jahrcheck)
   tag:=jtag-303-jahrcheck 
   monat:=11
  ELSEIF jtag<=(365+jahrcheck)
   tag:=jtag-334-jahrcheck 
   monat:=12
  ELSE
   erra('groß')
   JUMP programma
  ENDIF
  monatsname()
 ENDIF
ENDPROC

PROC monatsname() /* Ausgabe von prozedura() */
 wodat()
 IF mocheck=1
  mondat()
  RtEZRequestA('Zu dem \d. Jahrestag (\d.Woche) gehört der: \d. \s',' OK ',0,[jtag,woche,tag,mon],[RTEZ_REQTITLE,titel])
 ELSE
  RtEZRequestA('Zu dem \d. Jahrestag (\d.Woche) gehört der: \d.\d',' OK ',0,[jtag,woche,tag,monat],[RTEZ_REQTITLE,titel])
 ENDIF
ENDPROC    

PROC prozedurb() /* Berechnung des Jahrestages */
 programmb:
 IF RtGetLongA({tag},'Tag eingeben',0,0)
  IF tag<1
   errbb('klein')
   JUMP programmb
  ELSEIF tag>31
   errbb('groß')
   JUMP programmb
  ENDIF
  pgbmonat:
  IF RtGetLongA({monat},'Monat eingeben',0,0)
   IF monat<1
    errba('klein')
    JUMP pgbmonat
   ELSEIF monat>12
    errba('groß')
    JUMP pgbmonat
   ENDIF

   IF monat=1
    jtag:= tag
   ELSEIF monat=2
    IF tag>28+jahrcheck
     IF errbfeb()
     ELSE
      JUMP endb
     ENDIF
    ENDIF
    jtag:=31+tag
   ELSEIF monat=3
    jtag:=59+tag+jahrcheck
   ELSEIF monat=4
    IF tag>30
     IF errb()
     ELSE
      JUMP endb
     ENDIF
    ENDIF
    jtag:=90+tag+jahrcheck
   ELSEIF monat=5
    jtag:=120+tag+jahrcheck
   ELSEIF monat=6
    IF tag>30
     IF errb()
     ELSE
      JUMP endb
     ENDIF
    ENDIF
    jtag:=151+tag+jahrcheck
   ELSEIF monat=7
    jtag:=181+tag+jahrcheck
   ELSEIF monat=8
    jtag:=212+tag+jahrcheck
   ELSEIF monat=9
    IF tag>30
     IF errb()
     ELSE
      JUMP endb
     ENDIF
    ENDIF
    jtag:=243+tag+jahrcheck
   ELSEIF monat=10
    jtag:=273+tag+jahrcheck
   ELSEIF monat=11
    IF tag>30
     IF errb()
     ELSE
      JUMP endb
     ENDIF
    ENDIF
    jtag:= 304+tag+jahrcheck
   ELSEIF monat=12
    jtag:=334+tag+jahrcheck
   ENDIF
   tagesname()
  ENDIF
 ENDIF
 endb:
ENDPROC

PROC tagesname() /* Ausgabe von prozedurb() */
 wodat()
 IF mocheck=1
  mondat()
  RtEZRequestA('Der Jahrestag zu dem \d. \s (\d. Woche) ist der: \d',' OK ',0,[tag,mon,woche,jtag],[RTEZ_REQTITLE,titel])
 ELSE
  RtEZRequestA('Der Jahrestag zu dem \d.\d (\d. Woche) ist der: \d',' OK ',0,[tag,monat,woche,jtag],[RTEZ_REQTITLE,titel])
 ENDIF
ENDPROC

PROC mondat() /* Definition der Monatsnamen */
 IF monat=1 THEN mon:='Januar'
 IF monat=2 THEN mon:='Februar'
 IF monat=3 THEN mon:='März'
 IF monat=4 THEN mon:='April'
 IF monat=5 THEN mon:='Mai'
 IF monat=6 THEN mon:='Juni'
 IF monat=7 THEN mon:='Juli'
 IF monat=8 THEN mon:='August'
 IF monat=9 THEN mon:='September'
 IF monat=10 THEN mon:='Oktober'
 IF monat=11 THEN mon:='November'
 IF monat=12 THEN mon:='Dezember'
ENDPROC

PROC wodat() /* Berchnung der Woche */
 woche:=0
 jt:=jtag-1
 label:
 IF jt<7
  woche:=woche+1
 ELSE
  jt:=jt-7
  woche:=woche+1
  JUMP label
 ENDIF
ENDPROC

/* Fehlerausgaben */
PROC erra(txt) IS RtEZRequestA('Jahrestag zu \s! Nur Jahrestage von 1 bis 365 sind möglich.\nBeim Modus >Schaltjahr< 1 bis 366.','OK',0,[txt],[RTEZ_REQTITLE,titel])
PROC errba(txt) IS RtEZRequestA('Der Monat ist zu \s! Nur Monate von 1 bis 12 sind möglich!','OK',0,[txt],[RTEZ_REQTITLE,titel])
PROC errbb(txt) IS RtEZRequestA('Der Tag ist zu \s! Nur Tage von 1 bis 31 sind möglich!','OK',0,[txt],[RTEZ_REQTITLE,titel])

PROC errb() /* Fehlerausgabe von der Monatsberchnung */
 DEF an
 IF mocheck=1
  mondat()
  era:
  IF an:=RtGetLongA({tag},'Tag eingeben',0,[RTGL_TEXTFMT,'Der Monat \s hat nur 1 bis 30 Tage.',RTGL_TEXTFMTARGS,[mon]])
   IF tag>30 THEN JUMP era
   IF tag<1 THEN JUMP era
  ENDIF
 ELSE
  erb:
  IF an:=RtGetLongA({tag},'Tag eingeben',0,[RTGL_TEXTFMT,'Der \d. Monat hat nur 1 bis 30 Tage.',RTGL_TEXTFMTARGS,[monat]])
   IF tag>30 THEN JUMP erb
   IF tag<1 THEN JUMP erb
  ENDIF
 ENDIF
ENDPROC an

PROC errbfeb() /* Monat Februar, Feherlmeldung */
 DEF ab
 IF mocheck=1
  era:
  IF ab:=RtGetLongA({tag},'Tag eingeben',0,[RTGL_TEXTFMT,'Der Monat Februar hat nur 1 bis 28 (29 Stjhr.) Tage.'])
   IF tag>28+jahrcheck  THEN JUMP era
   IF tag<1 THEN JUMP era
  ENDIF
 ELSE
  erb:
  IF ab:=RtGetLongA({tag},'Tag eingeben',0,[RTGL_TEXTFMT,'Der 2. Monat hat nur 1 bis 28 (29 Stjhr.) Tage.'])
   IF tag>28+jahrcheck  THEN JUMP erb
   IF tag<1 THEN JUMP erb
  ENDIF
 ENDIF
ENDPROC ab
