OPT	NOHEAD,NOEXE,CPU='WUP'

MODULE	'dos','dos/dos'

PROC FileLength(name:PTR TO CHAR)
	DEF	lock:BPTR,fib:FileInfoBlock,l=-1
	IF lock:=Lock(name,ACCESS_READ)
		IF Examine(lock,fib)
			l:=fib.Size
		ENDIF
		UnLock(lock)
	ENDIF
ENDPROC l
