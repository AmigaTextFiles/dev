OPT	DOSARGONLY

MODULE	'dos/dos'

PROC main()
	DEF	info:FileInfoBlock,lock,c=0
	IF lock:=Lock(arg,-2)
		IF Examine(lock,info)
			IF info.DirEntryType>0
				PrintF('Directory of: \s\n',info.FileName)
				WHILE ExNext(lock,info)
					PrintF(IF info.DirEntryType>0 THEN ' \e[32m\l\s[27] Drawer\e[0m' ELSE ' \l\s[26] \r\d[7]',info.FileName,info.Size)
					IF ++c=2
						c:=0
						PrintF('\n')
					ELSE PrintF(' ')
				ENDWHILE
				IF c THEN PrintF('\n')
			ELSE PrintFault(IOErr(),'ddir')
		ELSE PrintFault(IOErr(),'ddir')
		UnLock(lock)
	ELSE PrintFault(IOErr(),'ddir')
ENDPROC
