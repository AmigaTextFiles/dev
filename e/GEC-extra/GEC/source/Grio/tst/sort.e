
MODULE 'grio/qsort'
MODULE 'grio/file'


PROC main()
DEF size,file

   file,size:=gReadFile(arg)
   IF file
      qsort(file,0,size-1,{comp},{swap})
      gWriteFile('bla',file,size)
      gFreeFile(file)
   ENDIF

ENDPROC


PROC comp(file,p1,p2) IS file[p2]-file[p1]


PROC swap(file,p1,p2)
 DEF temp
 temp:=file[p1]
 file[p1]:=file[p2]
 file[p2]:=temp
ENDPROC