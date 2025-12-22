{
 ==
 == Reductions (foldl,foldr) and another divide, select on lists 
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC ListFold =

 FORMAL 

  SORTS from. to. list ::= [from].


 GLOBAL

{ == right reduction                                                       }

  OPNS foldr :: (from->to->to) -> to -> list -> to.
  EQNS foldr _ E [   ] = E.
       foldr F E [H|T] = F H (foldr F E T).


{ == left reduction                                                        }

  OPNS foldl :: (to->from->to) -> to -> list -> to.
  EQNS foldl _ E [   ] = E.
       foldl F E [H|T] = foldl F (F E H) T.


{ == divide the elements of a list into two disjunct lists by using        }
{ == a predicate with accumulator parameter (to)                           }

  OPNS divide :: (from->to->(boolean,to)) -> to -> list -> (to,list,list).
  EQNS divide _ D [] = (D,[],[]).
       divide P D [H|T] = let (Left,D) = P H D. (D,L,R) = divide P D T. in
                          if Left then (D,H:L,R) else (D,L,H:R).


{ == choose one of the elements via a selection function                  }

  OPNS select :: to -> (from -> (boolean,to)) -> list -> (boolean,to).
  EQNS select E _ []    = (false,E).
       select E F [H|T] = if boolean (F H) then F H else select E F T.


END.
