{ ==
  == Demonstration of recursive instantiation (part 2)
  ==

  This demonstrative example shows the use of recursive instantiations.
  We take the special datatype tree (refer to Tree.AS) and actualize
  its formal node portion with a list of the new tree which we will call
  tree_of_lists (renaming). To create this list we use the normal datatype
  list (refer to LIST.AS) and actualize it with tree_of_lists calling it
  list_of_trees (renaming).
  The actualization of the formal (+) operation is a bit more complicated
  as in part 1 because we cannot map directly to the (from Tree) exported
  sum operation.
  
  == }

SPEC ListOfTreeOf =

  INTEGER +
  READWRITE +

  Tree ACTUAL SORTS data = integer.
                    node = list_of_trees.
                    tree = tree_of_lists.
              OPNS  (+) = (+).
       END +

  LIST ACTUAL SORTS data = tree_of_lists.
                    list = list_of_trees.
       END +

  OPNS list_of_trees + list_of_trees :: integer.
  EQNS X + Y = sum X + sum Y.
  
       OPNS sum :: list_of_trees -> integer.
       EQNS sum [] = 0.
            sum [T|Ts] = sum T + sum Ts.
       
  OPNS goal :: system -> system. 
  EQNS goal S = let Tree = bin [leaf 2] [leaf 1,leaf 3].
                in system(write(sum Tree,S)).

END.
