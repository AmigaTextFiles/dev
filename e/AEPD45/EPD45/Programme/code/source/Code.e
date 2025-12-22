/* HAWK CodeAbrage für Startup Sequence */

MODULE 'dos/datetime', 'dos/dos' /* MODULE holen */
 
DEF args, logbuf[240]:STRING, buf[200]:STRING, ubuf[200]:STRING, dts[60]:STRING,
    s[200]:STRING, a, len, hand=NIL

PROC main() /* Initialisierung und Argument Auswertung */
 DEF stbuf[80]:STRING
 IF arg
  IF StrCmp(arg,'1',1) THEN args:=1
  IF StrCmp(arg,'2',1) THEN args:=2
  IF StrCmp(arg,'3',1) THEN args:=3
 ENDIF
 zeit()
 WriteF('\ec\e[33m System gestartet \s.\n\n\e[0;32m           CodeAbfrage \e[0m©HAWK´1994-95 (Andreas Rehm) \e[33;42m1.01\e[0m\n',dts)
 IF hand:=Open('S:log',OLDFILE)
  StringF(stbuf,'\e[1mSystem gestartet \s\e[0m\n',dts)
  len:=StrLen(stbuf)
  Seek(hand,0,1)
  Write(hand,stbuf,len)
  Close(hand)
 ENDIF
 IF (FileLength('S:code.config'))>0
  code()
 ELSE
  WriteF('\n\e[32mFreier Zugriff\e[0m... (Code Datei ist leer oder existiert nicht!)\n')
 ENDIF
 CleanUp(0)
ENDPROC

CHAR '\0$VER:\e[1mCODE\e[32m 1.01\e[m (25.03.95) (©1994-1995 Andreas Rehm - 2.Release)\0' /* Version STRING */

PROC cd() /* Codes öffnen, wenn vorhanden, und richtig behandeln */
 /* Code.config */
 IF hand:=Open('S:code.config',OLDFILE)
  len:=FileLength('S:code.config')
  Read(hand,buf,len)
  FOR a:=1 TO len
   buf[a]:=Eor(buf[a],a)
  ENDFOR
  Close(hand)
 ELSE
  RETURN FALSE
 ENDIF
ENDPROC TRUE

PROC ucd()
 /* User.codeconfig */
 IF hand:=Open('S:usercode.config',OLDFILE)
  len:=FileLength('S:code.config')
  Read(hand,ubuf,len)
  FOR a:=1 TO len
   ubuf[a]:=Eor(ubuf[a],a)
  ENDFOR
  Close(hand)
 ELSE
  RETURN FALSE
 ENDIF
ENDPROC TRUE

PROC zeit() /* Systemzeit holen und konvertieren */
 DEF dt:datetime, ds:PTR TO datestamp, day[12]:ARRAY, date[12]:ARRAY, time[12]:ARRAY
 ds:=DateStamp(dt.stamp)
 dt.format:=FORMAT_DOS
 dt.flags:=DTF_FUTURE
 dt.strday:=day
 dt.strdate:=date 
 dt.strtime:=time
 DateToStr(dt)
 StringF(dts,'am \s den \s[9] um \s',day,date,time)
ENDPROC

PROC code()  /* Code vergleichen und Zugriffsrecht ermitteln */
 WriteF('\n Passwort: \e[42;32m')
 ReadStr(stdout,s) 
 WriteF('\e[0m\n')
 IF cd()
  IF StrCmp(s,buf,len)  /* Berechtigung ermitteln */
   StringF(logbuf,' \e[32mStandard System Zugriff durch den SYSOP\e[0m\n')
   logreport()
   WriteF('\ec\n\e[32m Berechtigung erteilt.\e[0m\n')
  ELSE
   StrCopy(buf,%00000000,ALL)
   IF ucd()
    IF StrCmp(s,ubuf,len)
     labuser()
     WriteF('\ec\n\e[0;33m OK! Sie können weitermachen!\e[0m\n\n')
    ELSE
     StrCopy(buf,%00000000,ALL)
     fail()
    ENDIF
   ELSE
    StrCopy(ubuf,%00000000,ALL)
    fail()
   ENDIF
  ENDIF
 ELSE
  WriteF('\n\e[32mFehler: Code Datei ist nicht lesbar!\e[0m\n)')
 ENDIF
ENDPROC

PROC labuser() /* Wenn ein User den Zugriff haben will ... */
 DEF username[200]:STRING
 lab:
 WriteF('\ec\n\e[32mBitte geben Sie ihren Namen ein:\e[0m ')
 ReadStr(stdout,username)
 IF StrCmp(username,'',1)
  JUMP lab
 ELSEIF StrCmp(username,' ',1)
  JUMP lab
 ELSEIF StrCmp(username,'  ',2)
  JUMP lab
 ELSE
  StringF(logbuf,' \e[33mUser Zugriff vom User: \e[0;32m\s\e[0m\n',username)
  logreport()
 ENDIF
ENDPROC

PROC fail() /* Wenn jemand etwas Falsches eingibt ... */
 DisplayBeep(0)
 WriteF('buf \s ubuf \s',buf,ubuf)
 StringF(logbuf,' \e[3mFremder Zugriff mit dem Code: >\s< versucht\e[0m\n',s)
 logreport() 
 IF args=1
  WriteF('\e[0m\ec\n              Fremder Zugriff auf das System ist untersagt!!!\n\e[0m\n Bitte warten...')
  Delay(500)
  WriteF('\ec\e[0m')
  code()
 ELSEIF args=2
  WriteF('\ec\e[0m')
  code()
 ELSEIF args=3
  WHILE TRUE
   WriteF('\ec\n\e[32;1m System gesperrt!\e[0m')
   ReadStr(stdout,s)
  ENDWHILE
 ELSE
  WriteF('\e[0m\ec\n              Fremder Zugriff auf das System ist untersagt!!!\n\e[0m')
  Delay(100) /* 2 Sekunden Pause, damit das Laufwerk validiert bleibt */
  ColdReboot()
 ENDIF
ENDPROC 

PROC logreport() /* Logfile Handling */
 DEF loghand=NIL
 IF loghand:=Open('S:log',OLDFILE)
  Seek(loghand,0,1) 
  len:=StrLen(logbuf)
  Write(loghand,logbuf,len)
  Close(loghand)
 ENDIF
ENDPROC
