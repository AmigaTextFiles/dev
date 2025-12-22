MODULE 'grio/file','grio/segtool'
MODULE 'dos/rdargs'
MODULE 'grio/uncomment'

PROC main()
DEF file,sg:PTR TO segtool,s[512]:STRING,cmd,cs:csource
DEF pcmd,buf[512]:ARRAY
IF (arg[]=NIL) OR (arg[]="?")
   PrintF('USAGE: <script name>\n')
   RETURN 5
ENDIF
NEW sg
IF (file:=gReadFile(arg))
   pcmd:=cmd:=file
   unComment(file,UNCM_REMLF OR UNCM_REMSPACE)
   WHILE (cmd:=getline(pcmd))
       cs.buffer:=pcmd
       cs.length:=StrLen(pcmd)
       cs.curchr:=0
       ReadItem(buf,512,cs)
       IF sg.find(buf)
          StringF(s,'\s\n',pcmd+cs.curchr)
          sg.run(s)
          sg.free()
       ENDIF
       pcmd:=cmd
   ENDWHILE
   gFreeFile(file)
ENDIF
END sg
ENDPROC

PROC getline(buf)
  MOVEQ    #NIL,D0
  MOVEA.L  buf,A0
  TST.B    (A0)
  BEQ.S    quit
  CMPI.B   #10,(A0)
  BEQ.S    quit
  loop:
    ADDQ.W   #1,A0
    TST.B    (A0)
    BEQ.S    stop
    CMPI.B   #10,(A0)
    BNE.S    loop
  stop:
  CLR.B    (A0)+
  MOVE.L   A0,D0
  quit:
ENDPROC D0


