/*

 Codes erneuern

 UpdateCodes -> Von CodeX.XX < 2.62a nach V2.62a coded

*/

OPT OSVERSION=37

PROC main()
 DEF hand=NIL, len, a, buf
 PrintF('\n\e[32mWollen Sie die Codes updaten, dann warten Sie bitte, wenn nicht bitte\nCTRL-C für Abbruch drücken!\e[0m\n\n')
 Delay(150)
 IF CtrlC() THEN CleanUp(0)
 IF hand:=Open('s:code.config',OLDFILE)
  len:=FileLength('s:code.config')
  Read(hand,buf,len)
  FOR a:= 1 TO len
   buf[a]:=Eor(buf[a],a)
  ENDFOR
  Write(hand,buf,len)
  PrintF('Masterode verschlüsselt!\n')
  Close(hand)
 ELSE
  PrintF('Kein Mastercode vorhanden!\n')
 ENDIF
 IF hand:=Open('s:usercode.config',OLDFILE)
  len:=FileLength('s:usercode.config')
  Read(hand,buf,len)
  FOR a:= 1 TO len
   buf[a]:=Eor(buf[a],a)
  ENDFOR
  Write(hand,buf,len)
  PrintF('Userode verschlüsselt!\n')
  Close(hand)
 ELSE
  PrintF('Kein Usercode vorhanden!\n')
 ENDIF
 PrintF('UpdateCodes beendet!\n\n')
ENDPROC
