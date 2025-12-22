PROC main()
  DEF i, a[10]:ARRAY OF LONG, p:PTR TO LONG
  FOR i:=0 TO 9
    a[i]:=[1, i, i*i]
      /* Questa assegnazione probabilmente non è ciò che vogliamo! */
  ENDFOR
  FOR i:=0 TO 9
    p:=a[i]
    WriteF('a[\d] è una matrice all''indirizzo \d\n', i, p)
    WriteF('  e il secondo elemento è \d\n', p[1])
  ENDFOR
ENDPROC
