OPT OSVERSION=37 /* Mindestens OS 2.0+ */

DEF fh=NIL,fl:LONG,buf[30000]:STRING, m, strs, a

PROC main()
 WriteF('\ec\e[32mViewLOG © 1994-95 Andreas Rehm\e[0m\n\n')
 IF fh:=Open('S:log',OLDFILE)      -> Wenn vorhanden, Log öffnen
  fl:=FileLength('S:log')
  IF fl>0
   m:=NewM(fl+8,0)
   FOR a:=0 TO 3      -> Handling für das LogFile
    m[a]:="\n"
    m[fl+4+a]:="\n"
   ENDFOR
   m:=m+4
   Read(fh,m,fl)
   Seek(fh,0,-1)
   strs:=ct(m,fl)
   Dispose(m-4)
  ENDIF
  IF arg
   IF StrCmp(arg,'kill',ALL)         -> Aufrufauswertung
    JUMP del
   ENDIF
  ENDIF
  IF Read(fh,buf,fl)               -> Inhalt in den Puffer lesen
   WriteF('\s\n\e[1mLänge: \e[0;33m\d Byte  -  \e[0;1mZeilen: \e[0;33m\d\e[0m\n',buf,fl,strs)                -> Inhalt ausgeben
   WriteF('\n\e[1;32mLogFile entleeren (j/n)? \e[0m') -> Entleeren?
   ReadStr(stdout,buf)             -> Eingabe auswerten
   IF StrCmp(buf,'j',1)
    del:
    IF fl<>0
     Write(fh,%00000000,fl)         -> Wenn erlaubt, Logfile entleeren
     SetFileSize(fh,0,-1)
     WriteF('Logfile wurde geleert!\n\n')
    ELSE
     WriteF('Logfile ist schon leer!\n\n')
    ENDIF
   ENDIF
  ELSE
   WriteF('Das LogFile scheint leer zu sein!\n\n')
  ENDIF
  Close(fh)
 ELSE
  EasyRequestArgs(0,[20,0,'CODE - Log File Anzeiger','Kann Log File nicht öffnen!','OK'],0,NIL)
 ENDIF
 CleanUp(0)
ENDPROC

CHAR '\0$VER: \e[32mViewLOG 1.01\e[0m (25.03.95) (© Andreas Rehm - 2.Release)\0' -> Versionsstring

PROC ct(mem,len)
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
