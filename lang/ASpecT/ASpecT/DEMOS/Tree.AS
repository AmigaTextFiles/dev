{ ==
  == Special 'tree' datatype
  ==  used in the ListOfTreeOf demo
  ==
  
  We export a special binary tree alike datastructure which is formal
  in the leafs data and, which is the special feature, the datastructure
  node. In 'normal' trees node is actualized with tree itself.
  An operation sum does a kind of collection of all data in the tree. It
  uses a formal operation (+) to handle the nodes.
  
  == }

SPEC Tree =

 FORMAL SORTS node.
              data.
             
        OPNS  node + node :: data.
       
 GLOBAL SORTS tree ::= leaf data | bin node node.

        OPNS  sum :: tree -> data.
        EQNS  sum (leaf X)  = X. 
              sum (bin X Y) = X+Y.

END.
