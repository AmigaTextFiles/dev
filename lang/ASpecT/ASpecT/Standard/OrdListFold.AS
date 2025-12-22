{
 ==
 == Reductions (foldl,foldr) and another divide, select on ordered lists
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC OrdListFold =

 FORMAL 

  Comparison +


  SORTS from. to.
  OPNS compare :: from -> from -> comparison.


 GLOBAL

  OrdList ACTUAL SORTS data = from.
                 OPNS compare :: data -> data -> comparison = compare. END +

 
{ == right reduction                                                       }

  OPNS foldr :: (from->to->to) -> to -> ordlist -> to.
  EQNS foldr F E L = if ismt L then E
                     else let H = hd L. T = tl L. in F H (foldr F E T).


{ == left reduction                                                        }

  OPNS foldl :: (to->from->to) -> to -> ordlist -> to.
  EQNS foldl F E L = if ismt L then E
                     else let H = hd L. T = tl L. in foldl F (F E H) T.

  
{ == divide the elements of an ordered list into two disjunct ordered      }
{ == lists by using a predicate with accumulator parameter (to)            }

  OPNS divide :: ((from,to) -> (boolean,to)) -> to -> ordlist
              -> (to,ordlist,ordlist).
  EQNS divide P D L = if ismt L then (D,[],[])
                      else let H = hd L. T = tl L.
                               (Left,D) = P (H,D). (D,L,R) = divide P D T. in
                           if Left then (D,H:L,R) else (D,L,H:R).


{ == choose one of the elements via a selection function                  }

  OPNS select :: to -> (from -> (boolean,to)) -> ordlist -> (boolean,to).
  EQNS select E F L = if ismt L then (false,E) else let H = hd L. T = tl L. in
                      if boolean (F H) then F H else select E F T.


END.
