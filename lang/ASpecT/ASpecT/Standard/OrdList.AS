{
 ==
 == Ordered lists
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC OrdList =

{ == defines a ordered list of some formal data and a given order          }

 FORMAL

  Comparison +


  SORTS data.
  OPNS compare :: data -> data -> comparison.


 GLOBAL

  Boolean +
  Integer +

  SORTS ordlist { !! never use the following constructors since they will  }
                { !! no more be available in the very near future          }
                ::= ins data ordlist | empty.

{ == ... the usual list constructors are available to construct sets as if }
{ ==   it is a list but multiply inserted elements are stored only once    }

  OPNS mt,
       data : ordlist :: ordlist.


{ == we define a bunch of useful operations for ordlists which are ...     }


{ == number of elements in a ordlist                                       }

  OPNS length :: ordlist -> integer.


{ == the nth element of ordlist L [0..(length L-1)] (error on failure)     }

  OPNS ordlist ! integer :: data.


{ == ordlist concatenation                                                 }

  OPNS ordlist ++ ordlist :: ordlist.


{ == subtraction of ordlist / element                                      }

  OPNS ordlist -- ordlist,
       ordlist -- data    :: ordlist.


{ == head and tail of a ordlist                                               }

  OPNS hd :: ordlist -> data.
  OPNS tl :: ordlist -> ordlist.


{ == but-last and last (error on failure)                                  }

  OPNS init :: ordlist -> ordlist.
  OPNS last :: ordlist -> data.


{ == take/drop first n elements if possible                                }

  OPNS take,
       drop :: integer -> ordlist -> ordlist.


{ == take/drop while a predicate succeeds as long its possible             }

  OPNS takewhile,
       dropwhile :: (data -> boolean) -> ordlist -> ordlist.


{ == remove all double elements                                            }

  OPNS mkset :: ordlist -> ordlist.


{ == repeat an element n times                                             }

  OPNS rep :: integer -> data -> ordlist.


{ == is an element contained in a ordlist                                  }

  OPNS member :: ordlist -> data -> boolean.


{ == extension of 'member' to ordlists                                     }

  OPNS member :: ordlist -> ordlist -> boolean.


{ == choose one of the elements of a ordlist via a selection function      }
{ == which determines by its result whether the first (true) or            }
{ == the second (false) element is 'more correct'                          }

  OPNS select :: (data -> data -> boolean) -> ordlist -> data.


{ == puts an element in an ordlist if its not already contained            }

  OPNS insert :: data -> ordlist -> ordlist.
  EQNS insert A X = if member X A then X else A:X.


{ == extension of 'insert' to an ordlist                                   }

  OPNS union :: ordlist -> ordlist -> ordlist.


{ == return all elements being in the first and in the second ordlist      }

  OPNS intersect :: ordlist -> ordlist -> ordlist.


{ == delete the nth element in a ordlist }

  OPNS delete :: ordlist -> integer -> ordlist.


{ == evaluate the first position (index) of a given element in a ordlist   }
{ == returns -1 if the element could not be found }

  OPNS idx :: ordlist -> data -> integer.


{ == test if one ordlist is the head of another one                        }

  OPNS head_of :: ordlist -> ordlist -> boolean.


{ == test if a ordlist is single-elemented                                 }

  OPNS single :: ordlist -> boolean.


{ == test if a ordlist is empty                                            }

  OPNS ismt :: ordlist -> boolean.


{ == split ordlist in two parts with first part containing n elements      }

  OPNS split :: integer -> ordlist -> (ordlist,ordlist).


{ == same as above but use a predicate to find the split position          }

  OPNS split :: (data -> boolean) -> ordlist -> (ordlist,ordlist).


{ == divide the elements of a ordlist into two disjunct ordlist            }

  OPNS divide :: (data -> boolean) -> ordlist -> (ordlist,ordlist).


{ == inverse version of ':'                                                }

  OPNS ordlist | data :: ordlist.
  EQNS L | D = D : L.


{ == take (filter) or eliminate (remove) elements using a predicate        }

  OPNS filter,
       remove :: (data -> boolean) -> ordlist -> ordlist.


{ == specialized right reduction                                           }

  OPNS foldr1 :: (data -> data -> data) -> ordlist -> data.
  EQNS { see LOCAL }


{ == specialized left reduction                                            }

  OPNS foldl1 :: (data -> data -> data) -> ordlist -> data.
  EQNS { see LOCAL }


{ == does a predicate hold for all (forall) or for some (exist) data?      }

  OPNS forall,
       exist :: (data -> boolean) -> ordlist -> boolean.



{ == the comparisons between ordlists based on lexical order and ...       }

  OPNS ordlist <  ordlist,
       ordlist <= ordlist,
       ordlist >  ordlist,
       ordlist >= ordlist :: boolean.
  FORALL compare :: ordlist -> ordlist -> comparison.
  EQNS (L1 <  L2) = compare L1 L2 == less.
       (L1 <= L2) = (compare L1 L2 == less) || (compare L1 L2 == eq).
       (L1 >  L2) = compare L1 L2 == greater.
       (L1 >= L2) = (compare L1 L2 == greater) || (compare L1 L2 == eq).


{ == ... the operation all these comparisons are based on                  }

  OPNS compare :: ordlist -> ordlist -> comparison.



 LOCAL

  Error +


{ SORTS ordlist ::= empty | ins data ordlist. }


{ OPNS mt :: ordlist. }
  EQNS [] = empty.


{ OPNS data : ordlist :: ordlist. }
  EQNS A : empty = ins A empty.
       A : ins B Y = if compare A B == less
                     then ins A (ins B Y)
                     else ins B (A:Y).


{ OPNS length :: ordlist -> integer. }
  EQNS length empty = 0.
       length (ins _ X) = 1+length X.


{ OPNS ordlist ! integer :: data. }
  EQNS empty ! _ = error "subscript out of range".
       (ins A X) ! N = if N==0 then A else X ! (N-1).


{ OPNS ordlist ++ ordlist :: ordlist. }
  EQNS empty     ++ Y = Y.
       (ins A X) ++ Y = A:(X++Y).


{ OPNS ordlist -- ordlist :: ordlist. }
  EQNS X -- empty     = X.
       X -- (ins B Y) = X -- B -- Y.


{ OPNS ordlist -- data :: ordlist. }
  EQNS empty     -- (_::data) = empty.
       (ins A X) -- D         = if compare A D == eq   then X
                             elsif compare A D == less then ins A X
                                                       else ins A (X -- D).


{ OPNS hd :: ordlist -> data. }
  EQNS hd (ins A _) = A.
       hd empty = error "hd of empty ordlist".


{ OPNS tl :: ordlist -> ordlist. }
  EQNS tl (ins _ X) = X.
       tl empty = error "tl of empty ordlist".


{ OPNS init :: ordlist -> ordlist. }
  EQNS init empty = error "init of empty ordlist".
       init (ins A X) = if X==empty then empty else ins A (init X).


{ OPNS last :: ordlist -> data. }
  EQNS last empty = error "last of empty ordlist".
       last (ins A X) = if X==empty then A else last X.


{ OPNS take :: integer -> ordlist -> ordlist. }
  EQNS take _ empty = empty.
       take N (ins A X) = if N>0 then ins A (take (N-1) X) else empty.


{ OPNS drop :: integer -> ordlist -> ordlist. }
  EQNS drop _ empty = empty.
       drop N (ins A X) = if N>0 then drop (N-1) X else ins A X.


{ OPNS takewhile :: (data -> boolean) -> ordlist -> ordlist. }
  EQNS takewhile _ empty = empty.
       takewhile F (ins A X) = if F A then ins A (takewhile F X) else empty.


{ OPNS dropwhile :: (data -> boolean) -> ordlist -> ordlist. }
  EQNS dropwhile _ empty = empty.
       dropwhile F (ins A X) = if F A then dropwhile F X else ins A X.


{ OPNS mkset :: ordlist -> ordlist. }
  EQNS mkset empty = empty.
       mkset (ins A empty) = ins A empty.
       mkset (ins A (ins B X)) = if compare A B == eq
                                 then mkset (ins B X)
                                 else ins A (mkset (ins B X)).


{ OPNS rep :: integer -> data -> ordlist. }
  EQNS rep N D = if N <= 0 then empty else ins D (rep (N-1) D).


{ OPNS member :: ordlist -> data -> boolean. }
  EQNS member empty (_::data) = false.
       member (ins A X) B = if compare A B == eq   then true
                         elsif compare A B == less then false 
                                                   else member X B.


{ OPNS member :: ordlist -> ordlist -> boolean. }
  EQNS member _ empty     = true.
       member Y (ins A X) = member Y A && member Y X.


{ OPNS select :: (data -> data -> boolean) -> ordlist -> data. }
  EQNS select _ empty = error "incorrect use of select".
       select _ (ins A empty) = A.
       select F (ins A (ins B X)) = select F (ins (if F A B then A else B) X).


{ OPNS delete :: ordlist -> integer -> ordlist. }
  EQNS delete empty    _ = empty.
       delete (ins A X) N =    if N < 0  then error "wrong index in delete"
                            elsif N == 0 then X
                                         else ins A (delete X (N-1)).


{ OPNS union :: ordlist -> ordlist -> ordlist. }
  EQNS union empty     Y = Y.
       union (ins A X) Y = if member Y A then   union X Y 
                                         else A:union X Y.


{ OPNS intersect :: ordlist -> ordlist -> ordlist. }
  EQNS intersect empty     _ = empty.
       intersect (ins A X) Y = if member Y A then ins A (intersect X Y) 
                                             else        intersect X Y.


{ OPNS idx :: ordlist -> data -> integer. }
  EQNS idx empty     _ = -1.
       idx (ins A X) D =    if compare A D == eq then 0 
                         elsif idx X D < 0       then -1 
                                                 else 1+idx X D.


{ OPNS head_of :: ordlist -> ordlist -> boolean. }
  EQNS head_of empty     (ins _ _) = false.
       head_of _         empty     = true.
       head_of (ins B Y) (ins A X) = compare A B == eq && head_of Y X.


{ OPNS single :: ordlist -> boolean. }
  EQNS single (ins _ empty) = true.
      $single _ = false.


{ OPNS ismt :: ordlist -> boolean. }
  EQNS ismt = (==) empty.


{ OPNS split :: integer -> ordlist -> (ordlist,ordlist). }
  EQNS split N (ins A X) =
         if N==0 then (empty,ins A X)
                 else let (L,R) = split(N-1) X. in (ins A L,R).
       split (_::integer) empty = (empty,empty).


{ OPNS split :: (data -> boolean) -> ordlist -> (ordlist,ordlist). }
  EQNS split (_::(data -> boolean)) empty = (empty,empty).
       split F (ins A X) = if F A then let (X1,X2) = split F X. in
                                       (ins A X1,X2)
                                  else (empty,ins A X).


{ OPNS divide :: (data -> boolean) -> ordlist -> (ordlist,ordlist). }
  EQNS divide _ empty = (empty,empty).
       divide F (ins A X) = let (X1,X2) = divide F X. in
                            if F A then (ins A X1,X2)
                                   else (X1,ins A X2).


{ OPNS filter :: (data -> boolean) -> ordlist -> ordlist. }
  EQNS filter _ empty = empty.
       filter P (ins A X) = if P A then ins A (filter P X) else filter P X.


{ OPNS remove :: (data -> boolean) -> ordlist -> ordlist. }
  EQNS remove _ empty = empty.
       remove P (ins A X) = if P A then remove P X else ins A (remove P X).


{ OPNS foldr1 :: (data -> data -> data) -> ordlist -> data. }
  EQNS foldr1 _ empty = error "foldr1 applied to empty".
       foldr1 _ (ins A empty) = A.
       foldr1 F (ins A (ins B X)) = F A (foldr1 F (ins B X)).


{ OPNS foldl1 :: (data -> data -> data) -> ordlist -> data. }
  EQNS foldl1 _ empty = error "foldl1 applied to empty".
       foldl1 F (ins A X) = foldl2 F A X.


  OPNS foldl2 :: (data  -> data -> data) -> data -> ordlist -> data.
  EQNS foldl2 _ E empty = E.
       foldl2 F E (ins A X) = foldl2 F (F E A) X.


{ OPNS forall :: (data -> boolean) -> ordlist -> boolean. }
  EQNS forall _ empty = true.
       forall P (ins A X) = P A && forall P X.


{ OPNS exist :: (data -> boolean) -> ordlist -> boolean. }
  EQNS exist _ empty = false.
       exist P (ins A X)  = P A || exist P X.


{ OPNS compare :: ordlist -> ordlist -> comparison. }
  EQNS compare empty     empty     = eq.
       compare (ins _ _) empty     = greater.
       compare empty     (ins _ _) = less.
       compare (ins A X) (ins B Y) = let Compare = compare A B. in
         if Compare == eq then compare X Y else Compare.


END.
