MODULE 'grio/uncomment'

PROC main()
DEF fh,buf,len

IF (len:=FileLength(arg))
   fh:=Open(arg,OLDFILE)
   Read(fh,buf:=New(len+4),len)
   Close(fh)
   len:=unComment(buf,UNCM_REMLF OR UNCM_REMSPACE OR UNCM_STAR)
   fh:=Open('ram:bla',NEWFILE)
   Write(fh,buf,len)
   Close(fh)
ENDIF

ENDPROC
