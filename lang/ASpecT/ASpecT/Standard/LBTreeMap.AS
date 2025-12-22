{
 ==
 == Mapping on labelled binary trees
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC LBTreeMap =

 FORMAL
 
  SORTS from. to. label.

 GLOBAL
  
  LBTree ACTUAL SORTS data= from. label= label. labBinTree= from_labBinTree.
         END +
  LBTree ACTUAL SORTS data= to.   label= label. labBinTree= to_labBinTree.
         END +


{ == map the elements of a labelled bintree                                }

  OPNS map :: (from -> to) -> from_labBinTree -> to_labBinTree.
  EQNS map F (tip X)       = tip (F X).
       map F (bin Lab L R) = bin Lab (map F L) (map F R).


END.
