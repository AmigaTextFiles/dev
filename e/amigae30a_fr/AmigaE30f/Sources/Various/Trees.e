/* Un style différent de programmer en E:
   travailler et construire de grande structures de données dynamiques
   sans utiliser le mot PTR

        / \
       /   \
     /       \
   / \       / \
 /\   /\   /\   /\
1  2 3  4 5  6 7  8

*/

PROC main()
  DEF tree,a
  tree:=node(
          node(
            node(leaf(1),leaf(2)),
            node(leaf(3),leaf(4))
          ),
          node(
            node(leaf(5),leaf(6)),
            node(leaf(7),leaf(8))
          )
        )
  WriteF('sum = \d\n',sum(tree))
  FOR a:=1 TO 10
    tree:=node(leaf(100),tree)
    WriteF('sum = \d\n',sum(tree))
  ENDFOR
ENDPROC

PROC node(l,r) IS NEW ["node",l,r]
PROC leaf(n) IS NEW ["leaf",n]

PROC sum(t)
  DEF left,right,n
  IF t <=> ["node",left,right]
    RETURN sum(left)+sum(right)
  ELSEIF t <=> ["leaf",n]
    RETURN n
  ENDIF
ENDPROC
