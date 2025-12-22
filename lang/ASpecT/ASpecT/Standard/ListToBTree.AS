{
 ==
 == Conversions list <-> binTree
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC ListToBTree = 

 FORMAL

  Comparison +


  SORTS data.


 GLOBAL

  BTree ACTUAL SORTS data = data. END +
  List  ACTUAL SORTS data = data. END +


{ == conversion binTree --> list                                           }

  OPNS binTree_list :: binTree -> list.
  EQNS binTree_list (tip A) = [A].
       binTree_list (bin L R) = binTree_list L ++ binTree_list R.


{ == conversion list --> binTree                                           }

  OPNS list_binTree :: list -> binTree.


 LOCAL

  Error +
 
 
{ OPNS list_binTree :: list -> binTree. }
  EQNS list_binTree [] = error "list_binTree []".
       list_binTree [A] = tip A.
       list_binTree (A:(B:X)) = A : list_binTree (B:X).


END.
