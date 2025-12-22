{
 ==
 == Conversions list <-> set
 == Version 1.0 (16.11.1992, JvH)
 ==
}

SPEC ListToSet = 

 FORMAL

  Comparison +


  SORTS data.
  OPNS compare :: data -> data -> comparison.


 GLOBAL

  Set  ACTUAL SORTS data = data.
              OPNS compare :: data -> data -> comparison = compare. END +
  List ACTUAL SORTS data = data. END +


{ == conversion set --> list                                               }

  OPNS set_list :: set -> list.
  EQNS set_list S = if ismt S then []
                              else let (D,S) = get S. in D : set_list S.


{ == conversion list --> set                                               }

  OPNS list_set :: list -> set.
  EQNS list_set [] = [].
       list_set (A:X) = A : list_set X.


END.
