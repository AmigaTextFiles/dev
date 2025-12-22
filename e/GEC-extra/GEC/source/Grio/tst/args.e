MODULE 'grio/arguments'
PROC main()
DEF args:PTR TO LONG,du,x

IF (args:=initArgs())
   IF argFind(args,'?',SWITCH)=NIL
      IF (du:=argFind(args,'AGLY',KEYWORD))=BADUSAGE
         PrintF('bad usage keyword "AGLY"\n')
      ELSE
         IF du THEN PrintF('AGLY arg = \s\n',du)
      ENDIF
      du:=getNumArgs(args)
      FOR x:=0 TO du-1 DO PrintF('args\d = "\s"\n',x+1,args[x])
   ELSE
      PrintF('usage : <[AGLY] string> <rest args...>\n')
   ENDIF
   endArgs(args)
ELSE
   PrintF('no args\n')
ENDIF

ENDPROC
