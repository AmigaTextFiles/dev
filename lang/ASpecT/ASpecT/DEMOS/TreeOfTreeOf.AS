{ ==
  == Demonstration of recursive instantiation (part 1)
  ==
  == (THIS ONE DOES NOT PARSE YET)

  This demonstrative example shows the use of recursive instantiations.
  We take the special datatype tree (refer to Tree.AS) and actualize
  its formal node portion recusively with tree itself resulting in a
  conventional binary tree with integers as leaf data.
  
  == }

SPEC TreeOfTreeOf =

  INTEGER +
  READWRITE +

  Tree ACTUAL SORTS data = integer.
                    node = tree.
              OPNS  (+) = (+).
       END +

  OPNS tree + tree :: tree.
  EQNS X + Y = sum X + sum Y.

  OPNS goal :: system -> system. 
  EQNS goal S = let Tree = bin (leaf 2) (bin (leaf 1) (leaf 3)).
                in system(write(sum Tree,S)).

 
END.
