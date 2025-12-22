
MODULE 'grio/str/limstrcmp'
MODULE 'grio/qsort'
MODULE 'grio/file'


PROC main()

   DEF file,size,len,tab[1000]:LIST

   file,size:=gReadFile(arg)

   IF file

      len:=tablen(tab,file,size)

      WriteF('\nprzed sortowaniem (\d) \n------------------\n\s',len,file)

      qsort(tab,0,len-1,{comp},{swap})

      WriteF('\npo sortowaniem\n------------------\n')

      FOR size:=0 TO len
	  putline(tab[size])
      ENDFOR

      gFreeFile(file)

   ENDIF

   WriteF('\n')

ENDPROC len


PROC putline(buf)

 MOVEA.L   buf,A0
 MOVE.L    A0,D2
 MOVEQ     #10,D0
loop:
 CMP.B     (A0)+,D0
 BNE.S     loop
 SUB.L     D2,A0
 MOVEA.L   D3,A3
 MOVE.L    A0,D3
 MOVEA.L   dosbase,A6
 MOVE.L    stdout,D1
 JSR       Write(A6)
 MOVE.L    A3,D3

ENDPROC D0 




PROC tablen(tab:PTR TO LONG,file,size)

  DEF i

  SetList(tab,0)
  INC file
  FOR i:=1 TO size
      IF file[-1]=10
	 ListAdd(tab,[file])
      ENDIF
      INC file
  ENDFOR

ENDPROC ListLen(tab)



PROC comp(tab:PTR TO LONG,p1,p2) IS limStrCmp(tab[p1],tab[p2],"\n")


PROC swap(tab:PTR TO LONG,p1,p2)
DEF temp
temp:=tab[p1]
tab[p1]:=tab[p2]
tab[p2]:=temp
ENDPROC



