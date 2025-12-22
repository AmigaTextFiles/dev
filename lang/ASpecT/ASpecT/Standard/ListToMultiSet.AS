{
 ==
 == Conversions list <-> multiset
 == Version 1.0 (16.11.1992, JvH)
 ==
}

SPEC ListToMultiSet = 

 FORMAL

  Comparison +


  SORTS data.
  OPNS compare :: data -> data -> comparison.


 GLOBAL

  MultiSet ACTUAL SORTS data = data.
                  OPNS compare :: data -> data -> comparison = compare. END +
  List     ACTUAL SORTS data = data. END +


{ == conversion multiset --> list                                          }

  OPNS multiset_list :: multiset -> list.
  EQNS multiset_list S = if ismt S then []
                         else let (D,S) = get S. in D : multiset_list S.


{ == conversion list --> multiset                                          }

  OPNS list_multiset :: list -> multiset.
  EQNS list_multiset [] = [].
       list_multiset (A:X) = A : list_multiset X.


END.
