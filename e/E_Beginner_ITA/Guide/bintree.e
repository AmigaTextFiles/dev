OBJECT tree
  data
  left:PTR TO tree, right:PTR TO tree
ENDOBJECT

PROC new_set(int)
  DEF root:PTR TO tree
  NEW root
  root.data:=int
ENDPROC root

PROC add(i, set:PTR TO tree)
  IF set=NIL
    RETURN new_set(i)
  ELSE
    IF i<set.data
      set.left:=add(i, set.left)
    ELSEIF i>set.data
      set.right:=add(i, set.right)
    ENDIF
    RETURN set
  ENDIF
ENDPROC

PROC show(set:PTR TO tree)
  IF set<>NIL
    show(set.left)
    WriteF('\d ', set.data)
    show(set.right)
  ENDIF
ENDPROC

PROC main() HANDLE
  DEF s, i, j
  Rnd(-999999)    /* Inizializza il seme */
  s:=new_set(10)  /* Inizializza set s per contenere il numero 10 */
  WriteF('Input:\n')
  FOR i:=1 TO 50  /* Genera 50 numeri casuali e li aggiunge a set s */
    j:=Rnd(100)
    add(j, s)
    WriteF('\d ',j)
  ENDFOR
  WriteF('\nOutput:\n')
  show(s)         /* Mostra i contenuti dell'(ordinato) set s */
  WriteF('\n')
EXCEPT
  IF exception="NEW" THEN WriteF('Memoria finita\n')
ENDPROC
