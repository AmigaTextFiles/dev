MODULE 'workbench/startup'

DEF gd,wb:PTR TO wbstartup,num
DEF ar,args:PTR TO wbarg,ii

PROC main()
gd:='                               Weiter geht\as                               '
IF wbmessage=NIL
	  ar:=arg ;testCLIArgs()
	ELSE
	  wb:=wbmessage
	  args:=wb.arglist
	  num:=wb.numargs-1 ; testWBArgs()
ENDIF
ENDPROC

PROC testWBArgs()
  IF num<=0
	req('WB-Afruf : 1. Waehlen Sie das Icon \ahelp\a.\n           2. Halten Sie die Umschalttaste gedrueckt und\n           doppelklicken Sie uaf das Piktogramm der gewunschter Datei.',ar)
  ELSE
	FOR ii:=1 TO num
	 ar:=args[ii].name
	 bef()
	ENDFOR
  ENDIF
ENDPROC

PROC testCLIArgs()
  IF StrCmp(ar,'',ALL)<=TRUE
	  req('CLI-Aufruf : help {Befehlesname} bzw. {Option}\n             OPTIONS:\n             -i  Information ueber das Program und Autor\n             -h bzw. -?  Aufruf-Syntax ',ar)
  ELSE
	  bef()
  ENDIF
ENDPROC

PROC bef()
LowerStr(ar)
  IF such('assign')

	req('Assign :\n\nSteuert die Zuordnung von logischen Geraetenamen \nund Dateisystemverzeichnissen\n\nASSIGN LIBS: paint:librarys',0)
	ELSEIF (such('-?')) OR (such('-h'))
	req('CLI-Aufruf : help {Befehlsname} bzw. {OPTION}\n\nWB-Aufruf : 1. W‰hlen Sie das Icon \ahelp\a.\n            2. Halten Sie die Umschalttaste gedr¸ckt und\n            doppelklicken Sie auf das Piktogramm der gewunschter Datei.',0)
	ELSEIF such('addbuffers')
	  req('Addbuffers :\n\nBefiehlt dem Dateisystem ,Cache-Puffer hinzuzufuegen\n\nADDBUFFERS DF0: \nnZeigt die Grˆﬂe des Puffers an\n\n  ADDBUFFERS DF0: 20 \n\nF¸gt 20 Puffer hinzu\n',0)
	ELSEIF such('avail')
	  req('Avail :\n\nMeldet die verf¸gbaren Chip -und Fast-Speicher\n        [CHIP|FAST|TOTAL]\n\nAVAIL TOTAL',0)
	ELSEIF such ('binddrivers')
	  req('Binddrivers :\n\nVerkn¸pft Ger‰tetreiber mit Hardware\n\n BINDDRIVERS',0)
	ELSEIF such('-i')
	  req('AmigaDOS-Helfer V0.4 (21-2-1995) by Juri Kern \n\n Anschrifft:\n\n Juri Kern \n Up\an Aeckern 6 \n 29331 Lachendorf \n GERMANY',0)
	ELSEIF such('ed')
	  req('ED :\n\nist ein Texteditor ,der mit der Betriebssystem ausgeliefert wird.\n\nAufruf : ED <datei name>',0)
	ELSEIF such('conclip')
	  req('Conclip :\n\nErlaubt Kopieren und Einfuegen eines Textes \nvon einem Konsolenfenster in ein anderes\n\nCONCLIP',0)
	ELSEIF such('cpu')
	  req('CPU :\n\nSetzt verschiedene Optionen des Mikroprozessor in Ihrem Amiga an',0)
	ELSEIF such('date')
	  req('Date :\n\nZeiget die Systemzeit und/oder -datum an oder stellt sie ein\n\n<Tag>|<Monat>|<Jahr> <Zeit>\n\nDATE 25-jan-95 13:00\n\nStellt das Datum auf den 25.Januar 1995 ein und die Zeit auf 13 Uhr',0)
	ELSEIF such('diskchange')
	  req('Diskchange :\n\nInformiert die Amiga ,daﬂ Sie eine Diskette im Laufwerk gewechselt haben\n(wird nur bei 5"-Diskettenlaufwerken benoetigt\n\nDISKCHANGE DF3:',0)
	ELSEIF such('info')
	  req('Info :\n\nZeigt Informationen ueber das System an.\n\nINFO DF0:',0)
	ELSEIF such('ec')
			 req('EC :\n\nist ein E-Compiler ,mit dem das Programm \ahelp\a compiliert wurde\n\nAufruf : EC <ec datei> \n\nEndung \a.e\a muss weggelassen werden',0)
	ELSE
		req('Die Befehl \a\s\a ist mir nicht bekannt !!!',ar)
  ENDIF
ENDPROC

PROC req(body,argss)
DEF name
/*stringF(name,'%s \a%s\a',['AmigaDOS-Helfer V0.4 by Juri Kern',ar],STRLEN)*/
ENDPROC EasyRequestArgs(0,[40,0,'AmigaDOS-Helfer V0.4 by Juri Kern "\s"',body,gd],0,[argss])

PROC such(argum)
ENDPROC StrCmp(ar,argum,StrLen(argum))<=TRUE

PROC stringF(ziel,fstr,data,maxlen)
 MOVEM.L D2-D3,-(A7)
 MOVE.L	ziel,A3
 MOVE.L	maxlen,D3
 MOVEQ	#0,D2
 RawDoFmt(fstr,data,{put_format},ziel)
 MOVEM.L (A7)+,D2-D3
ENDPROC

put_format:
 ADDQ.L #1,D2
 CMP.L  D2,D3
 BGE	  put_end

 MOVE.B D0,(A3)+
 RTS

put_end:
 MOVE.B #0,(A3)
 RTS


