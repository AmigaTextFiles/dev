MODULE 'grio/file','*ahxreplay'
PROC main()
DEF file,size

file,size:=gReadFile(arg)
IF file
   ahxPlay(file)
   WHILE CtrlC()=FALSE DO Delay(50)
   ahxStop()
   gFreeFile(file)
ENDIF
ENDPROC

