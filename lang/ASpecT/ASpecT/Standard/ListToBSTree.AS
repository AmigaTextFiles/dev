{
 ==
 == Conversions list <-> binSearchTree
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC ListToBSTree = 

 FORMAL

  Comparison +


  SORTS data.
  OPNS compare :: data -> data -> comparison.


 GLOBAL

  BSTree ACTUAL SORTS data = data.
                OPNS compare :: data -> data -> comparison= compare. END +
  List   ACTUAL SORTS data = data. END +


{ == conversion binSearchTree --> list                                     }

  OPNS binSearchTree_list :: binSearchTree -> list.
  EQNS binSearchTree_list mt = [].
       binSearchTree_list (bin X L R) = binSearchTree_list L ++ [X] ++
                                        binSearchTree_list R.


{ == conversion list --> binSearchTree                                     }

  OPNS list_binSearchTree :: list -> binSearchTree.
  EQNS list_binSearchTree mt = [].
       list_binSearchTree (A:X) = A : list_binSearchTree X.


  OPNS list_binSearchTree_ :: list -> binSearchTree.
  EQNS list_binSearchTree_ mt = [].
       list_binSearchTree_ (A:X) = A :` list_binSearchTree X.


END.
