{
 ==
 == Mapping on binary search trees
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC BSTreeMap =

 FORMAL

  Comparison +
 
  SORTS from. to.
  OPNS  compare_from :: from -> from -> comparison.
        compare_to   :: to   -> to   -> comparison.


 GLOBAL
  
  BSTree ACTUAL SORTS data = from. binSearchTree = from_binSearchTree. 
                OPNS compare :: data -> data -> comparison = compare_from. END +
  BSTree ACTUAL SORTS data = to.   binSearchTree = to_binSearchTree.
                OPNS compare :: data -> data -> comparison = compare_to.   END +


{ == map the elements of a binSearchTree                                     }

  OPNS map :: (from -> to) -> from_binSearchTree -> to_binSearchTree.
  EQNS map _ mt = mt.
       map F (bin X L R) = F X : (map F L) ++ (map F R).


  OPNS map_ :: (from -> to) -> from_binSearchTree -> to_binSearchTree.
  EQNS map_ _ mt = mt.
       map_ F (bin X L R) = F X :` (map_ F L) ++ (map_ F R).


END.
