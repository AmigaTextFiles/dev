MODULE 'grio/file','grio/str/num2binstr','grio/skiparg'

PROC main()
DEF buf[34]:ARRAY,file:PTR TO INT,size,x,name,insert,column,y

IF arg[]=NIL
   WriteF('USAGE: <file> <insertstr> <column number>\n')
   RETURN
ENDIF

name:=arg
insert:=skiparg(arg)
skiparg(column:=skiparg(insert))
column:=Val(column)
IF column<=0 THEN column:=0 ELSE DEC column

file,size:=gReadFile(name)

IF file
   FOR x:=0 TO size/2
      num2BinStr(buf,file[x] AND $FFFF)
      WriteF('\s%\z\s[16]',insert,buf)
      FOR y:=1 TO column
         INC x
         num2BinStr(buf,file[x] AND $FFFF)
         WriteF(',%\z\s[16]',buf)
      ENDFOR
      WriteF('\n')
      EXIT CtrlC()=TRUE
   ENDFOR
   gFreeFile(file)
ELSE
   WriteF('can\at load file "\s"\n',name)
ENDIF

ENDPROC

