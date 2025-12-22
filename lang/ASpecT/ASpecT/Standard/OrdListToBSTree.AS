{
 ==
 == Conversions ordlist <-> binSearchTree
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC OrdListToBSTree = 

 FORMAL

  Comparison +


  SORTS data.
  OPNS compare :: data -> data -> comparison.


 GLOBAL

  BSTree  ACTUAL SORTS data = data.
                 OPNS compare :: data -> data -> comparison= compare. END +
  OrdList ACTUAL SORTS data = data.
                 OPNS compare :: data -> data -> comparison= compare. END +


{ == conversion binSearchTree --> ordlist                                     }

  OPNS binSearchTree_ordlist :: binSearchTree -> ordlist.
  EQNS binSearchTree_ordlist mt = [].
       binSearchTree_ordlist (bin X L R) = binSearchTree_ordlist L ++ [X] ++
                                           binSearchTree_ordlist R.


{ == conversion ordlist --> binSearchTree                                     }

  OPNS ordlist_binSearchTree :: ordlist -> binSearchTree.
  EQNS ordlist_binSearchTree S = if ismt S
                                 then mt
                                 else let D = hd S. S = tl S. in 
                                      D : ordlist_binSearchTree S.


  OPNS ordlist_binSearchTree_ :: ordlist -> binSearchTree.
  EQNS ordlist_binSearchTree_ S = if ismt S
                                  then mt
                                  else let D = hd S. S = tl S. in 
                                       D :` ordlist_binSearchTree S.


END.
