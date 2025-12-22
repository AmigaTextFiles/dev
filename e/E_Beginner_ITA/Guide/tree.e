OPT MODULE  -> Ottiene un modulo di queste classi
OPT EXPORT  -> Esporta tutto

/* ------------------------------- */
/* La (astratta) classe base, tree */
/* ------------------------------- */

OBJECT tree PRIVATE  -> Tutti i dati sono privati
  left:PTR TO tree, right:PTR TO tree
ENDOBJECT

/* Conta i nodi */
PROC nodes() OF tree
  DEF tot=1
  IF self.left  THEN tot:=tot+self.left.nodes()
  IF self.right THEN tot:=tot+self.right.nodes()
ENDPROC tot

/* Conta le foglie e opzionalmente le mostra */
PROC leaves(show=FALSE) OF tree
  DEF tot=0
  IF self.left
    tot:=tot+self.left.leaves(show)
  ENDIF
  IF self.right
    tot:=tot+self.right.leaves(show)
  ELSEIF self.left=NIL  -> Both NIL, so a leaf
    IF show THEN self.print_node()
    tot++
  ENDIF
ENDPROC tot

/* Metodo astratto, add */
PROC add(x) OF tree IS EMPTY

/* Metodo astratto, print_node */
PROC print_node() OF tree IS EMPTY

/* Stampa il tree in ordine da sinistra a destra */
PROC print() OF tree
  IF self.left  THEN self.left.print()
  self.print_node()
  IF self.right THEN self.right.print()
ENDPROC


/* ---------------------- */
/* La classe integer_tree */
/* ---------------------- */

/* Eredita tree */
OBJECT integer_tree OF tree PRIVATE  -> tutti i dati sono privati
  int
ENDOBJECT

/* Constructor, inizia con un intero */
PROC create(i) OF integer_tree
  self.int:=i
ENDPROC

/* Aggiunge un intero */
PROC add(i) OF integer_tree
  DEF p:PTR TO integer_tree
  IF i < self.int
    IF self.left
      self.left.add(i)
    ELSE
      self.left:=NEW p.create(i)
    ENDIF
  ELSEIF i > self.int
    IF self.right
      self.right.add(i)
    ELSE
      self.right:=NEW p.create(i)
    ENDIF
  ENDIF
ENDPROC

/* Stampa un nodo */
PROC print_node() OF integer_tree
  WriteF('\d ', self.int)
ENDPROC
