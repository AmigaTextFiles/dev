MODULE 'shark/shkfiles'

PROC main()
DEF fh,txtload[500]:STRING,x

/* Save file */
WriteF('Saving RAM:filetest...\n')
fh:=mSaveF('RAM:filetest')
IF fh=0 ; WriteF('Error!\n') ; CleanUp(0) ; ENDIF
mWriteLine(fh,'test test test test 0123456789\n')
WriteF('Write to RAM:filetest and Close.\n')
mCloseF(fh)

/* Append file */
WriteF('Append file...\n')
fh:=mAppendF('RAM:filetest')
IF fh=0 ; WriteF('Error nr.2\n') ; CleanUp(0) ; ENDIF
mWriteLine(fh,'APPEND!\n')
mCloseF(fh)

/* Load file */
WriteF('Load file RAM:filetest\n')
fh:=mLoadF('RAM:filetest')
IF fh=0 ; WriteF('Error nr.3\n') ; CleanUp(0) ; ENDIF
ReadStr(fh,txtload) ; WriteF('TEXT 1:\s\n',txtload)
ReadStr(fh,txtload) ; WriteF('TEXT 2:\s\n',txtload)
mCloseF(fh)

/* File Copy */
x:=mFileCopy('RAM:filetest','RAM:filetest.2')
IF x=-1 THEN WriteF('Error: Can''t read file!\n')
IF x=-2 THEN WriteF('Error: Can''t write file!\n')

ENDPROC
