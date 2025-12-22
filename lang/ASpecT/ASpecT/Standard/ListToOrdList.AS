{
 ==
 == Conversions list <-> ordlist
 == Version 1.0 (16.11.1992, JvH)
 ==
}

SPEC ListToOrdList = 

 FORMAL

  Comparison +


  SORTS data.
  OPNS  compare :: data -> data  -> comparison.


 GLOBAL

  OrdList ACTUAL SORTS data = data.
                 OPNS compare :: data -> data -> comparison = compare. END +
  List    ACTUAL SORTS data = data. END +


{ == conversion ordlist --> list                                           }

  OPNS ordlist_list :: ordlist -> list.
  EQNS ordlist_list S = if ismt S
                        then []
                        else let D = hd S. S = tl S. in D : ordlist_list S.


{ == conversion list --> ordlist                                           }

  OPNS list_ordlist :: list -> ordlist.
  EQNS list_ordlist [] = [].
       list_ordlist (A:X) = A : list_ordlist X.


END.
