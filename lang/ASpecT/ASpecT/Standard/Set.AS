{
 ==
 == Set
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC Set =

{ == defines a set of some formal data with no more requirements           }

 FORMAL

  Comparison +


  SORTS data.
  OPNS compare :: data -> data -> comparison.


 GLOBAL

  Boolean +
  Integer +


{ == the 'set' sort is only accessible by the defined operations thus all  }
{ == defining equations of the operations are LOCAL                        }

  SORTS set { !! never use the following constructors since they will no   }
            { !! more be available in the very near future                 }
              ::= ins data set | empty.

  
{ == ... the usual list constructors are available to construct sets as if }
{ ==   it is a list but multiply inserted elements are stored only once    }

  OPNS mt,
       data : set :: set.


{ == we define a bunch of useful operations for sets (most of them are     }
{ == available with the same name on lists (ListOps) too                   }

{ == number of elements in a set                                           }

  OPNS length :: set -> integer.


{ == set concatenation                                                     }

  OPNS set ++ set :: set.


{ == subtraction of set / element                                          }

  OPNS set -- set  :: set.
  OPNS set -- data :: set.


{ == get 'some' element from set (remark: this is NOT nondeterministic)    }

  OPNS get :: set -> data.


{ == as above but it delivers a set not containing the element too         }

  OPNS get :: set -> (data,set).


{ == take/drop 'some' n elements if possible                               }

  OPNS take,
       drop :: integer -> set -> set.


{ == is an element contained in a set                                      }

  OPNS member :: set -> data -> boolean.


{ == extension of 'member' to sets (subset)                                }

  OPNS member :: set -> set -> boolean.


{ == choose one of the elements of a set via a selection function          }
{ == which determines by its result whether the first (true) or            }
{ == the second (false) element is 'more correct'                          }

  OPNS select :: (data -> data -> boolean) -> set -> data.


{ == insert from ListOps for sets is just (:)                              }

  OPNS insert :: data -> set -> set.
  EQNS insert = (:).


{ == the extension of 'insert' to a set is the same as (++)                }

  OPNS union :: set -> set -> set.
  EQNS union = (++).


{ == return all elements being in the first and in the second set          }

  OPNS intersect :: set -> set -> set.


{ == test if a set is single-elemented                                     }

  OPNS single :: set -> boolean.


{ == test if a set is empty                                                }

  OPNS ismt :: set -> boolean.


{ == divide the elements of a set into two disjunct sets                   }

  OPNS divide :: (data -> boolean) -> set -> (set,set).


{ == inverse version of ':'                                                }

  OPNS set | data :: set.
  EQNS L | D = D : L.


{ == take (filter) or eliminate (remove) elements using a predicate        }

  OPNS filter,
       remove :: (data -> boolean) -> set -> set.


{ == specialized reduction                                                 }

  OPNS fold1 :: (data -> data -> data) -> set -> data.
  EQNS { see LOCAL }


{ == does a predicate hold for all (forall) or for some (exist) data?      }

  OPNS forall,
       exist :: (data -> boolean) -> set -> boolean.


{ == repeatedly apply a function to elements of a set and the elements of  }
{ == such applications, until no further elements are generated            }

  OPNS closure :: (data -> set) -> set -> set.


{ == the comparisons between sets and ...                                  }

  OPNS set <  set,
       set <= set,
       set >  set,
       set >= set :: boolean.
  FORALL compare :: set -> set -> comparison.
  EQNS (S1 <  S2) = compare S1 S2 == less.
       (S1 <= S2) = (compare S1 S2 == less) || (compare S1 S2 == eq).
       (S1 >  S2) = compare S1 S2 == greater.
       (S1 >= S2) = (compare S1 S2 == greater) || (compare S1 S2 == eq).


{ == ... the operation all these comparisons are based on                  }

  OPNS compare :: set -> set -> comparison.



 LOCAL

  Error +

{ SORTS set ::= empty | ins data set. }

  
{ OPNS mt :: set. }
  EQNS [] = empty.


{ OPNS data : set :: set. }
  EQNS A : X = if member X A then X else ins A X.


{ OPNS length :: set -> integer. }
  EQNS length empty = 0.
       length (ins _ X) = 1+length X.


{ OPNS set ++ set :: set. }
  EQNS empty     ++ Y = Y.
       (ins A X) ++ Y = A:(X++Y).


{ OPNS set -- set :: set. }
  EQNS X -- empty     = X.
       X -- (ins B Y) = X -- B -- Y.


{ OPNS set -- data :: set. }
  EQNS empty -- (_::data) = empty.
       (ins A X) -- D = if compare A D == eq then X else ins A (X -- D).


{ OPNS get :: set -> data. }
  EQNS get empty = error "get of an empty set" :: data.
       get (ins A _) = A.


{ OPNS get :: set -> (data,set). }
  EQNS get empty = error "get of an empty set" :: (data,set).
       get (ins A X) = (A,X).


{ OPNS take :: integer -> set -> set. }
  EQNS take _ empty = empty.
       take N (ins A X) = if N>0 then ins A (take (N-1) X) else empty.


{ OPNS drop :: integer -> set -> set. }
  EQNS drop _ empty = empty.
       drop N (ins A X) = if N>0 then drop (N-1) X else ins A X.


{ OPNS member :: set -> data -> boolean. }
  EQNS member empty (_::data) = false.
       member (ins A X) B = compare A B == eq || member X B.


{ OPNS member :: set -> set -> boolean. }
  EQNS member _ empty = true.
       member Y (ins A X) = member Y A && member Y X.


{ OPNS select :: (data -> data -> boolean) -> set -> data. }
  EQNS select _ empty = error "incorrect use of select".
       select _ (ins A empty) = A.
       select F (ins A (ins B X)) = select F (ins (if F A B then A else B) X).


{ OPNS intersect :: set -> set -> set. }
  EQNS intersect empty _ = empty.
       intersect (ins A X) Y = if member Y A then ins A (intersect X Y)
                                             else        intersect X Y.


{ OPNS single :: set -> boolean. }
  EQNS single (ins _ empty) = true.
      $single _ = false.


{ OPNS ismt :: set -> boolean. }
  EQNS ismt = (==) empty.


{ OPNS divide :: (data -> boolean) -> set -> (set,set). }
  EQNS divide _ empty = (empty,empty).
       divide F (ins A X) = let (X1,X2) = divide F X. in
                            if F A then (ins A X1,X2)
                                   else (X1,ins A X2).


{ OPNS filter :: (data -> boolean) -> set -> set. }
  EQNS filter _ empty = empty.
       filter P (ins A X) = if P A then ins A (filter P X) else filter P X.


{ OPNS remove :: (data -> boolean) -> set -> set. }
  EQNS remove _ empty = empty.
       remove P (ins A X) = if P A then remove P X else ins A (remove P X).


{ OPNS fold1 :: (data -> data -> data) -> set -> data. }
  EQNS fold1 _ empty = error "fold1 applied to empty".
       fold1 _ (ins A empty) = A.
       fold1 F (ins A (ins B X)) = F A (fold1 F (ins B X)).


{ OPNS forall :: (data -> boolean) -> set -> boolean. }
  EQNS forall _ empty = true.
       forall P (ins A X) = P A && forall P X.


{ OPNS exist :: (data -> boolean) -> set -> boolean. }
  EQNS exist _ empty = false.
       exist P (ins A X)  = P A || exist P X.


{ OPNS closure :: (data -> set) -> set -> set. }
  EQNS closure F S = closure S F S.


  OPNS closure :: set -> (data -> set) -> set -> set.
  EQNS closure (ins A X) F R =
         let New = (F A) -- R.
         in closure (X++New) F (R++New).
       closure empty _ R = R.


{ OPNS compare :: set -> set -> comparison. }
  EQNS compare M1 M2 = compare2 (M1--M2) (M2--M1).


  OPNS compare2 :: set -> set -> comparison.
  EQNS compare2 empty     empty     = eq.
       compare2 (ins _ _) empty     = greater.
       compare2 empty     (ins _ _) = less.
       compare2 (ins A X) (ins B Y) =
          let BY = remove (greater A) (ins B Y).
              AX = remove (greater B) (ins A X).
          in if (BY == ins B Y) && (AX == ins A X)
             then incomparable
             else compare2 AX BY.


  OPNS greater :: data -> data -> boolean.
  EQNS greater A B = compare A B == greater.


END.
