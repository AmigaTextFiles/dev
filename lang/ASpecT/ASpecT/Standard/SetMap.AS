{
 ==
 == Mapping (map) on set
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC SetMap =

 FORMAL
 
  Comparison +


  SORTS from. to.
  OPNS compare_from :: from -> from -> comparison.
       compare_to :: to -> to -> comparison.


 GLOBAL

  Set ACTUAL SORTS data = from. set = from_set.
             OPNS compare :: data -> data -> comparison = compare_from. END +
  Set ACTUAL SORTS data = to  . set = to_set  .
             OPNS compare :: data -> data -> comparison = compare_to.   END +


{ == map the elements of a set                                             }

  OPNS map :: (from->to) -> from_set -> to_set.
  EQNS map F S = if ismt S then empty else let (A,X) = get S. in
                 F A : map F X.


END.
