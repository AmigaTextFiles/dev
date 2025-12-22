
MODULE 'dos/dos'


DEF buf , nfh , name[110]:STRING

PROC main()

DEF fh ,nr 


IF (arg[]=NIL) OR (arg[]="?")
   WriteF('USAGE: <text file>\n')
   RETURN
ENDIF

IF (fh:=Open(arg,OLDFILE))
   StringF(name,'\s.new',arg)
   IF (nfh:=Open(name,NEWFILE))
      IF (buf:=New(100002))
         REPEAT 
            nr:=Read(fh,buf,100000)
            buf[nr]:=NIL
            WriteF('reading: \d bytes from file "\s"\n',nr,arg)
            killspace()
            Seek(fh,100000,OFFSET_CURRENT)
         UNTIL nr<100000
         Dispose(buf)
      ELSE
         WriteF('unable to allocate work buffer\n')
      ENDIF
      Close(nfh)
   ELSE
      WriteF('can''t open file "\s" for output\n',name)
   ENDIF
   Close(fh)
ELSE
   WriteF('can''t open file "\s" for input\n',arg)
ENDIF


ENDPROC


PROC killspace()
DEF len

   len  :=  buf

   MOVEA.L  buf,A0
   MOVEA.L  A0,A1
   MOVEQ    #" ",D0
   MOVEQ    #0,D2
loop:
   MOVE.B   (A0)+,D1
   BEQ.S    exit
   CMP.B    D0,D1
   BEQ.S    space
   CMP.B    #"'",D1
   BEQ.S    comma
   CMP.B    #34,D1
   BEQ.S    comma
   MOVE.B   D1,(A1)+
   BRA.S    loop
space:
   ADDQ.L   #1,D2
   MOVE.B   (A0)+,D1
   BEQ.S    savetabs
   CMP.B    D0,D1
   BEQ.S    space
savetabs:
   SUBQ.W   #1,A0
   ADDQ.L   #8,D2
   ASR.L    #3,D2
tabs:
   MOVE.B   #9,(A1)+
   SUBQ.L   #1,D2
   BEQ.S    loop
   BRA.S    tabs
comma:
   MOVE.B   D1,D2
   MOVE.B   D1,(A1)+
   MOVEM.L  A0/A1,-(A7)
skip:
   MOVE.B   (A0)+,D1
   BEQ.S    nocomma
   CMP.B    #10,D1
   BNE.S    skipnext
nocomma:
   MOVEM.L  (A7)+,A0/A1
   BRA.S    backcomma
skipnext:
   MOVE.B   D1,(A1)+
   CMP.B    D2,D1
   BNE.S    skip
   ADDQ.W   #8,A7
backcomma:
   MOVEQ    #0,D2
   BRA.S    loop
exit:
   CLR.B    (A1)
   SUBA.L   len,A1
   MOVE.L   A1,len

   WriteF('writing: \d bytes to file "\s"\n',len,name)
   Write(nfh,buf,len)

ENDPROC