/*
 * A small example about exec lists.
 */

OPT PREPROCESS

MODULE  'exec/lists',         -> list header (lh)
        'exec/nodes',         -> list node (ln)
        'tools/constructors'  -> newlist(), newnode()

PROC main() HANDLE
DEF listpointer=NIL:PTR TO lh,-> the list we are about to build
    a_node:PTR TO ln

  listpointer := newlist()

  IF listpointer.head::ln.succ = NIL THEN WriteF('The list is empty!\n--\n')


  AddHead(listpointer, newnode(NIL, 'second node'))
  AddHead(listpointer, newnode(NIL, 'first node'))
  AddTail(listpointer, newnode(NIL, 'third node'))
  AddTail(listpointer, newnode(NIL, 'fourth node'))

  a_node := listpointer.head  -> get at the first node
  a_node := a_node.succ       ->            second node
  a_node := a_node.succ       ->            third node

  Insert(listpointer, newnode(NIL, 'surprise node'), a_node) -> insert after 3rd

  print_nodenames(listpointer)

EXCEPT
  WriteF('an error ocurred.\n')
ENDPROC

/*
 * print_nodenames(list) - takes an exec list and prints its nodes names. If
 *                         list equals NIL the PROC is left.
 *                         needs modules exec/lists and exec/nodes
 */

PROC print_nodenames(list:PTR TO lh)
DEF listnode:PTR TO ln

  IF list=NIL THEN RETURN           -> exit the PROC if list isn't valid

  listnode := list.head

  WHILE listnode                    -> the list may be empty, so WHILE is
                                    -> used instead of REPEAT
    IF listnode.succ                -> if not at the end of the list
      WriteF('\s\n', listnode.name) -> print name
    ENDIF
    listnode := listnode.succ       -> move to next node

  ENDWHILE                          -> if listnode is NIL we'll leave here

  WriteF('--\nEnd of list reached.\n')
ENDPROC
