
MODULE 'grio/file'


PROC main()
DEF size,file

   file,size:=gReadFile(arg)
   IF file
      size:=sumFile(file,size)
      WriteF('sum of file = dec: \d = hex: $\h\n',size,size)
      gFreeFile(file)
   ELSE
      WriteF('can\at open file "\s"\n',arg)
   ENDIF

ENDPROC


PROC sumFile(buf,len)
DEF x,v=0

FOR x:=1 TO len
   v:=v+buf[x-1]
ENDFOR

ENDPROC v

