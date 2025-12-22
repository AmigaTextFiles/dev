{
 ==
 == Mapping (map) on multiset
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC MultiSetMap =

 FORMAL

  Comparison +

 
  SORTS from. to.
  OPNS compare_from :: from -> from -> comparison.
       compare_to :: to -> to -> comparison.


 GLOBAL

  MultiSet ACTUAL SORTS data = from. multiset = from_multiset.
             OPNS compare :: data -> data -> comparison = compare_from. END +
  MultiSet ACTUAL SORTS data = to  . multiset = to_multiset  .
             OPNS compare :: data -> data -> comparison = compare_to.   END +


{ == map the elements of a multiset                                        }

  OPNS map :: (from->to) -> from_multiset -> to_multiset.
  EQNS map F S = if ismt S then empty else let (A,X) = get S. in
                 F A : map F X.


END.
