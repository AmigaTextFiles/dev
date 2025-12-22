MODULE  'dos/dos'

DEF myargs[2]:LIST, str[30]:STRING

PROC main()
	DEF lock, info:infodata
	DEF rdargs
	IF (rdargs:=ReadArgs('DEVICE=DRIVE/A,GUI/S',myargs,NIL))
		IF (lock:=Lock(myargs[0],-2))
			Info(lock,info)
			IF (info.numblocks-info.numblocksused<2)
				StringF(str,'\d ', ((info.numblocks-info.numblocksused)*info.bytesperblock))
			ELSEIF (info.numblocks-info.numblocksused<20480)
				StringF(str,'\d kilo', ((info.numblocks-info.numblocksused)/2))
			ELSE
				StringF(str,'\d mega', ((info.numblocks-info.numblocksused)/2048))
			ENDIF
			output()
			UnLock(lock)
		ENDIF
		FreeArgs(rdargs)
	ENDIF
ENDPROC

PROC output()
	StringF(str,'There are \sbytes free', str)
	IF myargs[1]<>-1 
		WriteF('\s\n', str)
	ELSE
		EasyRequestArgs(0,[20,0,0,str,'OK'],0,0)
	ENDIF
ENDPROC