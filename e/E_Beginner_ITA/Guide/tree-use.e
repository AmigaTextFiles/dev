MODULE '*tree'

PROC main()
  DEF t:PTR TO integer_tree
  NEW t.create(10)
  t.add(-10)
  t.add(3)
  t.add(5)
  t.add(-1)
  t.add(1)
  WriteF('t ha \d nodi, con \d foglie: ',
         t.nodes(), t.leaves())
  t.leaves(TRUE)
  WriteF('\n')
  WriteF('Contenuto di t: ')
  t.print()
  WriteF('\n')
  END t
ENDPROC
