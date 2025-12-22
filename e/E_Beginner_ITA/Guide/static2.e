PROC main()
  DEF i, a[10]:ARRAY OF LONG, p:PTR TO LONG
  FOR i:=0 TO 9
    a[i]:=List(3)
    /* Si controlla la riuscita della allocazione prima di copiare */
    IF a[i]<>NIL THEN ListCopy(a[i], [1, i, i*i], ALL)
  ENDFOR
  FOR i:=0 TO 9
    p:=a[i]
    IF p=NIL
      WriteF('Non ho potuto allocare memoria per a[\d]\n', i)
    ELSE
      WriteF('a[\d] è una matrice all''indirizzo \d\n', i, p)
      WriteF('  e il secondo elemento è \d\n', p[1])
    ENDIF
  ENDFOR
ENDPROC
