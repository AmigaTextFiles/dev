{
 ==
 == Reduction (fold) and another divide, select on set
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC SetFold =

 FORMAL 

  Comparison +


  SORTS from. to.
  OPNS compare :: from -> from -> comparison.


 GLOBAL

  Set ACTUAL SORTS data = from.
             OPNS compare :: data -> data -> comparison = compare. END +


{ == reduction                                                             }

  OPNS fold :: (to->from->to) -> to -> set -> to.
  EQNS fold F E S = if ismt S then E
                    else let (H,T) = get S. in fold F (F E H) T.


{ == divide the elements of a set into two disjunct sets                   }
{ ==  by using a predicate with accumulator parameter (to)                 }

  OPNS divide :: ((from,to) -> (boolean,to)) -> to -> set
              -> (set,set).
  EQNS divide P D S = if ismt S then ([],[])
                      else let (H,T) = get S.
                               (Left,D) = P (H,D). (L,R) = divide P D T. in
                           if Left then (H:L,R) else (L,H:R).


{ == choose one of the elements via a selection function                  }

  OPNS select :: to -> (from -> (boolean,to)) -> set -> (boolean,to).
  EQNS select E F S = if ismt S then (false,E) else let (H,T) = get S. in
                      if boolean (F H) then F H else select E F T.


END.
