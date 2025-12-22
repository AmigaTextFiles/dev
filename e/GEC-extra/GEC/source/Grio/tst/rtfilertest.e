MODULE 'grio/rtfiler'
MODULE 'libraries/reqtools'

PROC main()
DEF fr:PTR TO rtfiler,mp,mn:PTR TO rtfilermsg,name1[40]:ARRAY,name2[40]:ARRAY
name1[]:=0 ; name2[]:=0
IF (mp:=CreateMsgPort())
   NEW fr.new(mp)
   IF fr.add('rtFiler Demo1',name1)
      WriteF('success adding first req\n')
   ENDIF
   IF fr.add('rtFiler Demo2',name2)
      WriteF('success adding second req\n')
   ENDIF
   IF fr.open(1) THEN WriteF ('opened req 1\n')
   IF fr.open(2) THEN WriteF ('opened req 2\n')
   WHILE fr.isopen()
      WaitPort(mp)
      IF (mn:=GetMsg(mp))
         WriteF('Req \d are finished , with results :\n    dir = "\s" , file = "\s"\n',
                 mn.reqnum,mn.req.dir,mn.file)
         fr.freemsg(mn)
      ENDIF
   ENDWHILE
   IF fr.rem(2) THEN WriteF('removed req 2\n')
   IF fr.rem(1) THEN WriteF('removed req 1\n')
   END fr
   DeleteMsgPort(mp)
ENDIF
ENDPROC


