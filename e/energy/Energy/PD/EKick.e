/* EKICK  Copy Kickstart ROM into a file
   AMIGA E v3.1a:     20-06-95
   Author:   Marco Talamelli
   E-Mail:   marco_talamelli@amp.flashnet.it
*/

MODULE 'workbench/startup'

DEF msg:PTR TO CHAR

PROC main()

DEF startup:PTR TO wbstartup

msg:='\n\e[1m EKick V1.7 - 1995 by Marco Talamelli, Roma, Italy.\e[0m\n'

	IF(startup:=wbmessage)=NIL
		IF (StrCmp(arg,'')=-1) OR (StrCmp(arg,'?')=-1)
		 WriteF(msg)
		 WriteF('\e[2m Usage: EKick [<destination file name>]\e[0m\n\n')
		ELSE
		 ext(arg)
		ENDIF
	ELSE
		/* Start from WorkBench */
		ext('ram:Kick')
	ENDIF

ENDPROC

PROC ext(kick:PTR TO CHAR)

DEF fh=NIL,romstart,romend=$00FFFFFF,len=$00FFFFEC

	fh:=Open(kick,NEWFILE)

romstart:=romend-^len+1

WriteF(msg)
WriteF('\nROMstart:\e[33m \h\n\e[31mROMend  :\e[33m \h\n',romstart,romend)
WriteF('\e[31mKickstart Version\e[33m \d.\d\n',Int(romstart+$0c),Int(romstart+$0e))
WriteF('\e[31mExec Version\e[33m \d.\d',Int(romstart+$10),Int(romstart+$12))
WriteF('\n\e[31mWriting to file "\e[33m\s\e[31m"...',kick)

		Write(fh,romstart,^len)

		Close(fh)
		WriteF(' \d Bytes (\d KB).\n\n',^len,^len/1024)
ENDPROC
