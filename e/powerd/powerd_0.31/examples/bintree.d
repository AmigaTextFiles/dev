OPT OPTIMIZE=3

OBJECT tree
  data,
  left:PTR TO tree, right:PTR TO tree

PROC new_set(int)(PTR TO tree)
  DEF root:PTR TO tree
  NEW root
  root.data:=int
ENDPROC root

PROC add(i, set:PTR TO tree)(PTR TO tree)
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

PROC main()
  DEF s, i, j
  Rnd(-999999)    /* Initialise seed */
  s:=new_set(10)  /* Initialise set s to contain the number 10 */
  WriteF('Input:\n')
  FOR i:=1 TO 50  /* Generate 50 random numbers and add them to set s */
    j:=Rnd(100)
    add(j, s)
    WriteF('\d ',j)
  ENDFOR
  WriteF('\nOutput:\n')
  show(s)         /* Show the contents of the (sorted) set s */
  WriteF('\n')
EXCEPT
  IF exception="NEW" THEN WriteF('Ran out of memory\n')
ENDPROC
