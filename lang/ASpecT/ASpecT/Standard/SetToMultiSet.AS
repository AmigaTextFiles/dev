{
 ==
 == Conversions set <-> multiset
 == Version 1.0 (16.11.1992, JvH)
 ==
}

SPEC SetToMultiSet = 

 FORMAL

  Comparison +


  SORTS data.
  OPNS compare :: data -> data -> comparison.


 GLOBAL

  Set      ACTUAL SORTS data = data.
                  OPNS compare :: data -> data -> comparison = compare. END +
  MultiSet ACTUAL SORTS data = data.
                  OPNS compare :: data -> data -> comparison = compare. END +


{ == conversion set --> multiset                                           }

  OPNS set_multiset :: set -> multiset.
  EQNS set_multiset S = if ismt S then []
                        else let (D,S) = get S. in D : set_multiset S.


{ == conversion multiset --> set                                           }

  OPNS multiset_set :: multiset -> set.
  EQNS multiset_set S = if ismt S then []
                        else let (D,S) = get S. in D : multiset_set S.


END.
