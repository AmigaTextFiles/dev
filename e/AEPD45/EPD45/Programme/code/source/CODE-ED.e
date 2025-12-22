/*
  MUI CODE-ED © Andreas Rehm 1995

  Geschrieben auf Basis von der E-Muidemo
  mit den MUIdev2.3

  Dieses Programm ist fast zu 100% gleich mit dem Code-Editor,
  jedoch ist diese Version auf MUI umgeschrieben
*/

OPT OSVERSION=37 /* DOS 2.0+ erforderlich */
OPT PREPROCESS /* Preprozessor verwenden */

/* Library Zugriffs MODULE */
MODULE 'muimaster', 'libraries/mui'
MODULE 'utility/tagitem', 'utility/hooks'
MODULE 'intuition/classes', 'intuition/classusr'
MODULE 'libraries/gadtools', 'reqtools', 'libraries/reqtools'
MODULE 'dos/dos', 'dos/datetime'

/* GUI Exception IDs */
ENUM ER_NON, ER_MUILIB, ER_APP, ER_REQTOOLS
ENUM ID_ABOUT=1, ID_CED, ID_UED, ID_CDEL, ID_UDEL, ID_LOG, ID_ZEIG, ID_INFO


/* GUI- Definitionen */
DEF menu, ap_Code, wi_Master, wi_Mcode, wi_Ucode, bt_Quit, bt_Cae, bt_Cdel, bt_Mced, bt_Uced,
    bt_Ucae, bt_Udel, bt_Log, bt_Zeig, bt_Info, st_Code, st_Ucode

/* Programm Definitionen */
DEF titel[50]:STRING, len:LONG, hand=NIL, dts[80]:STRING, a  /* Definitionen */

PROC main() HANDLE /* Die GUI und das Handling */
 DEF signal, running, result, mbuf, ubuf
   IF (muimasterbase := OpenLibrary(MUIMASTER_NAME,MUIMASTER_VMIN))=NIL THEN Raise(ER_MUILIB)
   IF (reqtoolsbase := OpenLibrary('reqtools.library',37))=NIL THEN Raise(ER_REQTOOLS)
   StringF(titel,'CODE-ED ©1995 Andreas Rehm')
   sysop()

/* Menü Strucktur aufbauen */
menu := [ NM_TITLE,0, 'Projekt'  , 0 ,0,0,0,
          NM_ITEM ,0, 'Über...' ,'?',0,0,ID_ABOUT,
          NM_ITEM ,0, NM_BARLABEL, 0 ,0,0,0,
          NM_ITEM ,0, 'Ende'     ,'Q',0,0,MUIV_Application_ReturnID_Quit,
          NM_END  ,0, NIL        , 0 ,0,0,0]:newmenu

/* MUI Oberfläche generieren */
ap_Code := ApplicationObject,
 MUIA_Application_UseRexx,     FALSE,
 MUIA_Application_Title,       'CODE-Editor',
 MUIA_Application_Version,     '$VER: CODE-Editor-II ©1994-95 1.01 (25.03.95) (© Andreas Rehm - 2.Release)',
 MUIA_Application_Copyright,   'Copyright ©1995, Andreas Rehm',
 MUIA_Application_Author,      'Andreas Rehm',
 MUIA_Application_Description, 'Hauptprogramm für CODE © Andreas Rehm',
 MUIA_Application_Base,        'CODE-ED',
 MUIA_Application_Menustrip,    Mui_MakeObjectA(MUIO_MenustripNM,[menu,0]),

 SubWindow,
  wi_Mcode := WindowObject,
   MUIA_Window_Title, 'Mastercode eingeben',
   MUIA_Window_ID, "MCOD",
   MUIA_Window_SizeGadget, FALSE,
   WindowContents, VGroup,
    MUIA_Frame, MUIV_Frame_ImageButton,
    Child, VGroup,
     MUIA_Background, MUII_FILLBACK,
     GroupFrame,
     Child, HGroup,
      Child, RectangleObject,
       MUIA_Rectangle_HBar, MUI_TRUE,
      End,
      Child, TextObject,
       MUIA_Weight, 0,
       MUIA_Background, MUII_TextBack,
       MUIA_Text_Contents, 'Bitte geben Sie den Mastercode ein:',
      End,
      Child, RectangleObject,
       MUIA_Rectangle_HBar, MUI_TRUE,
      End,
     End,
     Child, st_Code := StringObject,
      MUIA_ControlChar, "b",
      MUIA_String_MaxLen, 201,
      StringFrame,
     End,
     Child, bt_Mced := SimpleButton('_Mastercode annehmen'),
    End,
   End,
  End,
 SubWindow,
  wi_Ucode := WindowObject,
   MUIA_Window_Title, 'Usercode eingeben',
   MUIA_Window_ID, "UCOD",
   MUIA_Window_SizeGadget, FALSE,
   WindowContents, VGroup,
    MUIA_Frame, MUIV_Frame_ImageButton,
    Child, VGroup,
     MUIA_Background, MUII_FILLBACK,
     GroupFrame,
     Child, HGroup,
      Child, RectangleObject,
       MUIA_Rectangle_HBar, MUI_TRUE,
      End,
      Child, TextObject,
       MUIA_Weight, 0,
       MUIA_Background, MUII_TextBack,
       MUIA_Text_Contents, 'Bitte geben Sie den Usercode ein:',
      End,
      Child, RectangleObject,
       MUIA_Rectangle_HBar, MUI_TRUE,
      End,
     End,
     Child, st_Ucode := StringObject,
      MUIA_ControlChar, "b",
      MUIA_String_MaxLen, 201,
      StringFrame,
     End,
     Child, bt_Uced := SimpleButton('_Usercode annehmen'),
    End,
   End,
  End,
 SubWindow,
  wi_Master := WindowObject,
   MUIA_Window_Title, 'CODE-Editor - ©1995',
   MUIA_Window_ID,    "MAIN",
   MUIA_Window_SizeGadget, FALSE,
   WindowContents, VGroup,
    MUIA_Frame, MUIV_Frame_ImageButton,
    Child, TextObject,
     GroupFrame,
     MUIA_Background, MUII_SHADOWFILL,
     MUIA_Text_Contents, '\ec\e8\eb\euCODE-Editor\en\n\n©1995 von Andreas Rehm',
    End,
    Child, VGroup,
     GroupFrameT('Änderungen'),
     Child, VGroup,
      Child, VGroup,
       MUIA_Group_SameWidth, MUI_TRUE,
       Child, VGroup,
        MUIA_Group_Columns, 2,
        Child, bt_Cae  := SimpleButton('_Code ändern'),
        Child, bt_Cdel := SimpleButton('Code _löschen'),
       End,
       Child, RectangleObject,
        MUIA_Weight, 0,
        MUIA_Rectangle_HBar, MUI_TRUE,
       End,
       Child, VGroup,
        MUIA_Group_Columns, 2,
        Child, bt_Ucae := SimpleButton('_Usercode ändern'),
        Child, bt_Udel := SimpleButton('Use_rcode löschen'),
       End,
      End,
     End,
    End,
    Child, VGroup,
     GroupFrame,
     MUIA_Background, MUII_FILLBACK,
     Child, bt_Log := SimpleButton('L_og Modus'),
     Child, RectangleObject,
      MUIA_Weight , 0 ,
      MUIA_Rectangle_HBar, MUI_TRUE,
     End,
     Child, bt_Zeig := SimpleButton('Codes _zeigen'),
     Child, bt_Info := SimpleButton('_Information'),
    End,
    Child, VGroup,
     MUIA_Frame, MUIV_Frame_Text,
     MUIA_Background, MUII_FILL,
     Child, bt_Quit := SimpleButton('_Beenden'),
    End,
   End,
  End,
 End

 IF ap_Code=NIL THEN Raise(ER_APP)

 /* Verbindungen herstellen */
 doMethod(bt_Quit,[MUIM_Notify,MUIA_Pressed,FALSE,ap_Code,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])
 doMethod(bt_Cdel,[MUIM_Notify,MUIA_Pressed,FALSE,ap_Code,2,MUIM_Application_ReturnID,ID_CDEL])
 doMethod(bt_Udel,[MUIM_Notify,MUIA_Pressed,FALSE,ap_Code,2,MUIM_Application_ReturnID,ID_UDEL])
 doMethod(bt_Log,[MUIM_Notify,MUIA_Pressed,FALSE,ap_Code,2,MUIM_Application_ReturnID,ID_LOG])
 doMethod(bt_Zeig,[MUIM_Notify,MUIA_Pressed,FALSE,ap_Code,2,MUIM_Application_ReturnID,ID_ZEIG])
 doMethod(bt_Info,[MUIM_Notify,MUIA_Pressed,FALSE,ap_Code,2,MUIM_Application_ReturnID,ID_INFO])
 doMethod(bt_Mced,[MUIM_Notify,MUIA_Pressed,FALSE,ap_Code,2,MUIM_Application_ReturnID,ID_CED])
 doMethod(bt_Uced,[MUIM_Notify,MUIA_Pressed,FALSE,ap_Code,2,MUIM_Application_ReturnID,ID_UED])
 doMethod(wi_Master,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,ap_Code,2,MUIM_Application_ReturnID,MUIV_Application_ReturnID_Quit])

 /* Fenster mit den Knöpfen öffnen ... */
 doMethod(bt_Cae,[MUIM_Notify,MUIA_Pressed,FALSE,wi_Mcode,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])
 doMethod(bt_Ucae,[MUIM_Notify,MUIA_Pressed,FALSE,wi_Ucode,3,MUIM_Set,MUIA_Window_Open,MUI_TRUE])

 /* Fenster schließen */
 doMethod(wi_Mcode,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Mcode,3,MUIM_Set,MUIA_Window_Open,FALSE])
 doMethod(wi_Ucode,[MUIM_Notify,MUIA_Window_CloseRequest,MUI_TRUE,wi_Ucode,3,MUIM_Set,MUIA_Window_Open,FALSE])

 set(wi_Master,MUIA_Window_Open,MUI_TRUE);

 running := TRUE  /* Programm mit der Oberfläche verbinden und ansteuern */
 WHILE running
  result := doMethod(ap_Code, [MUIM_Application_Input, {signal} ])
  SELECT result
   CASE MUIV_Application_ReturnID_Quit
     running := FALSE
   CASE ID_ABOUT
     Mui_RequestA(ap_Code,wi_Master,0,NIL,'_OK','                CODE - Editor\n\n            ©1995 von Andreas Rehm\n\n            Version: 1.01 Release: 2\n\nDieses Programm verwendet MUI - © Stefan Stuntz',NIL)
   CASE ID_CED
    get(st_Code,MUIA_String_Contents,{mbuf})
    set(wi_Mcode,MUIA_Window_Open,FALSE)
    codeedit(mbuf)
    set(st_Code,MUIA_String_Contents,'')
   CASE ID_UED
    get(st_Ucode,MUIA_String_Contents,{ubuf})
    set(wi_Ucode,MUIA_Window_Open,FALSE)
    usercodeedit(ubuf)
    set(st_Ucode,MUIA_String_Contents,'')
   CASE ID_CDEL
    deletecode()
   CASE ID_UDEL
    deleteusercode()
   CASE ID_LOG
    logmode()
   CASE ID_ZEIG
    codezeigen()
   CASE ID_INFO
    information()
  ENDSELECT
  IF signal THEN Wait(signal)
 ENDWHILE
 IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
 Raise(ER_NON)
EXCEPT
 IF ap_Code THEN Mui_DisposeObject(ap_Code)
 IF muimasterbase THEN CloseLibrary(muimasterbase)
 SELECT exception
  CASE ER_MUILIB
   WriteF('Konnte die >\s< V\d nicht öffnen.\n',MUIMASTER_NAME,MUIMASTER_VMIN)
   CleanUp(20)
  CASE ER_REQTOOLS
   EasyRequestArgs(0,[20,0,0,'CODE-Editor ©1995 Andreas Rehm','Sie benötigen die ReqTools © Nico François ab V37!','OK'],0,NIL)
  CASE ER_APP
   WriteF('Konnte die Applikation nicht starten.\n')
   CleanUp(20)
 ENDSELECT
ENDPROC 0

PROC doMethod( obj:PTR TO object, msg:PTR TO msg )
 DEF h:PTR TO hook, o:PTR TO object, dispatcher
 IF obj
  o := obj-SIZEOF object  /* instance data is to negative offset */
  h := o.class
  dispatcher := h.entry   /* get dispatcher from hook in iclass */
  MOVEA.L h,A0
  MOVEA.L msg,A1
  MOVEA.L obj,A2          /* probably should use CallHookPkt, but the */
  MOVEA.L dispatcher,A3   /*   original code (DoMethodA()) doesn't. */
  JSR (A3)                /* call classDispatcher() */
  MOVE.L D0,o
  RETURN o
 ENDIF
ENDPROC NIL

PROC zeit() /* Systemzeit holen und konvertieren */
 DEF dt:datetime, ds:PTR TO datestamp, day[12]:ARRAY, date[12]:ARRAY, time[12]:ARRAY
 ds:=DateStamp(dt.stamp)
 dt.format:=FORMAT_DOS
 dt.flags:=DTF_FUTURE
 dt.strday:=day
 dt.strdate:=date 
 dt.strtime:=time
 DateToStr(dt)
 StringF(dts,'am \s den \sum \s',day,date,time)
ENDPROC 

PROC sysop() /* Zugriff auf den Editor nur mit dem Mastercode zulassen und Logfile mit Zugriffsdaten füllen */
 DEF buf[200]:STRING, enteredbuf[200]:STRING, logbuf[240]:STRING
 IF hand:=Open('S:code.config',OLDFILE)
  len:=FileLength('S:code.config')
  Read(hand,buf,len)
  /* De-Codierung des Codes */
  FOR a:= 1 TO len
   buf[a]:=Eor(buf[a],a)
  ENDFOR 
 ENDIF
 IF hand
  Close(hand)
  IF len
   IF rtgetstr(enteredbuf,'Nur dem SYSOP ist der Zugriff auf dieses Programm erlaubt!\n\nGeben Sie bitte den Master Code ein, Usercodes gelten nicht.')
    IF StrCmp(enteredbuf,buf,len)
     zeit()
     IF hand:=Open('S:log',OLDFILE)
      StringF(buf,'\e[1mCode Editor Zugriff \s\e[0m\n',dts)
      len:=StrLen(buf)
      Seek(hand,0,1)
      Write(hand,buf,len)
      Close(hand)
     ENDIF
    ELSE
     end(enteredbuf,logbuf)
    ENDIF
   ELSE
    end(enteredbuf,logbuf)
   ENDIF
  ELSE
   end(enteredbuf,logbuf)
  ENDIF
 ELSE
  request('Es existiert kein Codewort. -> Zugriff frei!','OK',0,0,0)
 ENDIF
ENDPROC

PROC end(a,b) /* Wenn ein unberechtigter Zugriff versucht wurde */
 request('Nur dem Systeminhaber ist der Zugriff erlaubt!\n\nNicht erlaubter Zugriff mit >\s< versucht.','OK',a,0,0)
 zeit()
 IF hand:=Open('S:log',OLDFILE)
  StringF(b,'\e[1mCode Editor Zugriff mit >\s< versucht \s\e[0m\n',a,dts)
  len:=StrLen(b)
  Seek(hand,0,1)
  Write(hand,b,len)
  Close(hand)
 ENDIF
 CleanUp(0)
ENDPROC

PROC codeedit(buf) /* Code ändern */
 IF request('Sie haben den Code: >\s< eingegeben.','OK|Abbruch',buf,0,0)
  /* Codierung des Codes */
  len:=StrLen(buf)
  FOR a:= 1 TO len
   buf[a]:=Eor(buf[a],a)
  ENDFOR 
 ELSE
  RETURN TRUE
 ENDIF
 IF hand:=Open('S:code.config',NEWFILE)
  Write(hand,buf,STRLEN)
  SetFileSize(hand,0,0)
 ELSE
  request('Der Code konnte nicht gesichert werden!','OK',0,0,0)
 ENDIF
 Close(hand)
ENDPROC

PROC usercodeedit(ubuf)  /* User Code ändern */
 IF request('Sie haben den User Code: >\s< eingegeben.','OK|Falscher Code (Ändern)',ubuf,0,0)
  /* Codierung des Codes */
  len:=StrLen(ubuf)
  FOR a:= 1 TO len
   ubuf[a]:=Eor(ubuf[a],a)
  ENDFOR
 ELSE
  RETURN TRUE
 ENDIF
 IF hand:=Open('S:usercode.config',NEWFILE)
  Write(hand,ubuf,STRLEN)
  SetFileSize(hand,0,0)
 ELSE
  request('Der User Code konnte nicht gesichert werden!','OK',0,0,0)
 ENDIF
 Close(hand)
ENDPROC  

PROC codezeigen()  /* Codes anzeigen */
 DEF buf[200]:STRING,ubuf[200]:STRING
 IF hand:=Open('S:code.config',OLDFILE)
  len:=FileLength('S:code.config')
  Read(hand,buf,len)
   /* Codierung des Codes */
   FOR a:= 1 TO len
    buf[a]:=Eor(buf[a],a)
   ENDFOR
  Close(hand)
 ELSE
  StrCopy(buf,' ',ALL)
 ENDIF
 IF hand:=Open('S:usercode.config',OLDFILE)
  len:=FileLength('S:usercode.config')
  Read(hand,ubuf,len)
  /* Codierung des Codes */
  FOR a:= 1 TO len
   ubuf[a]:=Eor(ubuf[a],a)
  ENDFOR
  Close(hand)
 ELSE
  StrCopy(ubuf,' ',ALL)
 ENDIF
 request('Der Standard Code ist: \s\n\nDer User Code ist: \s','OK',buf,ubuf,0)
ENDPROC

PROC deletecode()   /* Mastercode löschen */
 IF DeleteFile('S:code.config')
  request('Code.config Datei gelöscht!','OK',0,0,0)
 ELSE
  request('Code.config Datei existiert noch gar nicht!','OK',0,0,0)
 ENDIF
ENDPROC

PROC deleteusercode()  /* Usercode löschen */
 IF DeleteFile('S:usercode.config')
  request('UserCode.config Datei gelöscht!','OK',0,0,0)
 ELSE
  request('UserCode.config Datei existiert noch gar nicht!','OK',0,0,0)
 ENDIF 
ENDPROC

PROC information() /* Daten über den Status und das Programm */
 DEF a[100]:STRING, b[100]:STRING, log[20]:STRING
 IF hand:=Open('S:code.config',OLDFILE)
  StrCopy(a,'vorhanden.\n\nEr kann gelöscht werden, indem man im Hauptfenster\n>Codewort löschen< wählt',ALL)
 ELSE
  StrCopy(a,'nicht vorhanden',ALL)
 ENDIF
 Close(hand)
 IF hand:=Open('S:usercode.config',OLDFILE)
  StrCopy(b,'vorhanden.\n\nEr kann gelöscht werden, indem man im Hauptfenster\n>User Code löschen< wählt',ALL)
 ELSE
  StrCopy(b,'nicht vorhanden',ALL)
 ENDIF 
 Close(hand)
 IF hand:=Open('S:log',OLDFILE)
  StrCopy(log,'aktiv',ALL)
 ELSE
  StrCopy(log,'nicht aktiv',ALL)
 ENDIF
 Close(hand)
 request('Code Editor ©HAWK 1994-95\n\nDieses Programm kann das Codewort für die Codeabfrage\nändern. Wählen Sie dazu den Taster: Code ändern.\nDieses Programm verwendet die ReqTools © Nico François\nUnd es verwendet MUI © bei Stefan Stuntz\n\nNetzadresse des Authors:\n\nHAWK@Andromeda.Rhein-Main.de\n\n______________________________________________________\n\nDer Standard Code ist \s.\n\nDer User Code ist \s.\n\nDer LOG Modus ist \s.','OK',a,b,log)
ENDPROC

PROC logmode() /* Log Modus Einstellungen */
 DEF login=NIL,log=NIL,answer,reqinput[140]:STRING,strs:LONG, a, m
 IF log:=Open('S:log',OLDFILE)
  len:=FileLength('S:log')
  m:=NewM(len+8,0)
  FOR a:=0 TO 3
    m[a]:="\n"
    m[len+4+a]:="\n"
  ENDFOR
  m:=m+4
  Read(log,m,len)
  strs:=ct(m,len)
  Close(log)
  Dispose(m-4)
 ENDIF
 IF len>0 THEN StringF(reqinput,'aktiv und das Logfile ist\n \d Byte(s) und \d Zeile(n) lang.',len,strs,0) ELSE StringF(reqinput,'aktiv und das Logfile ist leer.')
 IF log
  answer:=request('Der Log Modus verursacht, daß ein Log File mit dem Namen\nS:log erstellt und geführt wird.\n\nDer Log Modus ist \s','Weiter|Log File entleeren|Status ändern',reqinput,0,0)
 ELSE
  answer:=request('Der Log Modus verursacht, daß ein Log File mit dem Namen\nS:log erstellt und geführt wird.\n\nDer Log Modus ist nicht aktiv.','Weiter|Status ändern',0,0,0)
 ENDIF
 IF answer=0
  IF log
   IF request('Log Modus desaktivieren?','Desaktivieren|Abbruch',0,0,0)
    IF DeleteFile('S:log')=FALSE THEN request('Der Log Modus konnte nicht desaktiviert werden.','OK',0,0,0)
   ENDIF
  ELSE
   IF request('Log Modus aktivieren?','Aktivieren|Abbruch',0,0,0)
    IF login:=Open('S:log',NEWFILE)
     Close(login)
    ELSE
     request('Der Log Modus konnte nicht aktiviert werden.','OK',0,0,0)
    ENDIF
   ENDIF
  ENDIF
 ELSEIF answer=2
  IF log
   IF len
    IF request('Wollen Sie wirklich das Log File >S:log<, das eine Länge von\n\d Byte(s) und \d Zeile(n) hat, entleeren?','Log File leeren|Abbruch',len,strs,0)
     IF log:=Open('S:log',OLDFILE)
      IF Write(log,%00000000,len)=FALSE THEN request('Konnte Log nicht überschreiben!','OK',0,0,0)
      IF SetFileSize(log,0,-1)=-1 THEN request('Konnte die Loggröße nicht auf null setzen!','OK',0,0,0)
      Close(log)
     ELSE
      request('Das Logfile ist nicht ansprechbar.','OK',0,0,0)
     ENDIF
    ENDIF
   ELSE
    request('Das Log File ist bereits geleert!','OK',0,0,0)
   ENDIF
  ELSE
   request('Kein Log File vorhanden!','OK',0,0,0)
  ENDIF  
 ELSEIF answer=1
  RETURN TRUE
 ENDIF
ENDPROC

PROC request(txt,knopf,aabuf,bbbuf,ccbuf) IS RtEZRequestA(txt,knopf,[REQPOS_CENTERWIN,2,REQ_OK,0],[aabuf,bbbuf,ccbuf],[RTEZ_REQTITLE,titel])

PROC rtgetstr(defstr,txt) IS RtGetStringA(defstr,200,'Code eingeben...',[REQPOS_CENTERWIN,2,0,0],[RTGS_TEXTFMT,txt])

PROC ct(mem,len) /* Logfilelänge herausfinden */
 MOVE.L mem,A0
 MOVE.L A0,D1
 ADD.L  len,D1
 MOVEQ  #0,D0
 MOVEQ  #10,D2
strings:
 ADDQ.L #1,D0
findstring:
 CMP.B  (A0)+,D2
 BNE.S  findstring
 CMPA.L D1,A0
 BMI.S  strings
ENDPROC D0
