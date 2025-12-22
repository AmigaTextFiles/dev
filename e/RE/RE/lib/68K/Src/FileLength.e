OPT	NOEXE,NOHEAD

MODULE	'dos','dos/dos'

PROC FileLength(name:PTR TO CHAR)
	DEF	lock:BPTR,fib:FileInfoBlock,l=TRUE
	IF lock:=Lock(name,ACCESS_READ)
		IF Examine(lock,fib)
			l:=fib.Size
		ENDIF
		UnLock(lock)
	ENDIF
ENDPROC l
