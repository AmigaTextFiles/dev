/*
*/
->OPT MODULE  -> Make a module of these classes
->OPT EXPORT  -> Export everything

/* ------------------------------- */
/* The (abstract) base class, tree */
/* ------------------------------- */

OBJECT tree PRIVATE  -> All data is private
  left:PTR TO tree, right:PTR TO tree
ENDOBJECT

/* Count nodes */
PROC nodes() OF tree
  DEF tot=1
  IF self.left  THEN tot := tot+self.left.nodes()
  IF self.right THEN tot := tot+self.right.nodes()
ENDPROC tot

/* Count leaves, and optionally show them */
PROC leaves(show=FALSE) OF tree
  DEF tot=0

  IF self.left
    tot := tot+self.left.leaves(show)
  ENDIF
  IF self.right
    tot := tot+self.right.leaves(show)
  ELSEIF self.left=NIL  -> Both NIL, so a leaf
    IF show THEN self.print_node()
    tot++
  ENDIF
ENDPROC tot

/* Abstract method, add */
PROC add(x) OF tree IS EMPTY

/* Abstract method, print_node */
PROC print_node() OF tree IS EMPTY

/* Print the tree in order, left to right */
PROC print() OF tree
  IF self.left  THEN self.left.print()
  self.print_node()
  IF self.right THEN self.right.print()
ENDPROC


/* ---------------------- */
/* The integer_tree class */
/* ---------------------- */

/* Inherit tree */
OBJECT integer_tree OF tree PRIVATE  -> All data is private
  int
ENDOBJECT

/* Constructor, start with one integer */
PROC create(i) OF integer_tree
  self.int := i
ENDPROC

/* Add an integer */
PROC add(i) OF integer_tree
  DEF p:PTR TO integer_tree
  IF i < self.int
    IF self.left
      self.left.add(i)
    ELSE
      self.left := NEW p.create(i)
    ENDIF
  ELSEIF i > self.int
    IF self.right
      self.right.add(i)
    ELSE
      self.right := NEW p.create(i)
    ENDIF
  ENDIF
ENDPROC

/* Print a node */
PROC print_node() OF integer_tree
  WriteF('\d ', self.int)
ENDPROC


PROC main() HANDLE
  DEF t:PTR TO integer_tree

  NEW t
  t.create(10)
  t.add(-10)
  t.add(3)
  t.add(5)
  t.add(-1)
  t.add(1)
  WriteF('t has \d nodes, with \d leaves: ',
         t.nodes(), t.leaves())
  t.leaves(TRUE)
  WriteF('\n')
  WriteF('Contents of t: ')
  t.print()
  WriteF('\n')
EXCEPT DO
  END t
ENDPROC
