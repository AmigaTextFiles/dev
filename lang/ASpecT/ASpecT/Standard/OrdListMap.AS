{
 ==
 == Mappings (map, scan) on ordered lists
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC OrdListMap =

 FORMAL
 
  Comparison +


  SORTS from. to.
  OPNS  compare_from :: from -> from -> comparison.
        compare_to   :: to   -> to   -> comparison.


 GLOBAL

  OrdList ACTUAL SORTS data = from. ordlist = from_ordlist.
              OPNS compare :: data -> data -> comparison = compare_from. END +
  OrdList ACTUAL SORTS data = to.   ordlist = to_ordlist.
              OPNS compare :: data -> data -> comparison = compare_to.   END +


{ == map the elements of a list                                            }

  OPNS map :: (from->to) -> from_ordlist -> to_ordlist.
  EQNS map F S = if ismt S then empty else let A = hd S. X = tl S. in
                 F A : map F X.


END.
