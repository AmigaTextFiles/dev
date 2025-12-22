{
 ==
 == Mapping on binary trees
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC BTreeMap =

 FORMAL
 
  SORTS from. to.

 GLOBAL
  
  BTree ACTUAL SORTS data = from. binTree = from_binTree. END +
  BTree ACTUAL SORTS data = to.   binTree = to_binTree.   END +


{ == map the elements of a binTree                                         }

  OPNS map :: (from -> to) -> from_binTree -> to_binTree.
  EQNS map F (tip X)   = tip (F X).
       map F (bin L R) = bin (map F L) (map F R).


END.
