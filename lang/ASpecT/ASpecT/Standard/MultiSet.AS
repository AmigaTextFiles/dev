{
 ==
 == MultiSet (Bag)
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC MultiSet =

{ == defines a multiset of some formal data with no more requirements      }

 FORMAL

  Comparison +


  SORTS data.
  OPNS compare :: data -> data -> comparison.


 GLOBAL

  Boolean +
  Integer +


{ == the 'multiset' sort is only accessible by the defined operations thus }
{ == all defining equations of the operations are LOCAL                    }

  SORTS multiset { !! never use the following constructors since they will }
                 { !! no more be available in the very near future         }
              ::= ins data multiset | empty.

  
{ == ... the usual list constructors are available to construct multisets  }
{ == as if it is a list but multiply inserted elements are stored only once}

  OPNS mt,
       data : multiset :: multiset.


{ == we define a bunch of useful operations for multisets (most of them    }
{ == are available with the same name on lists (ListOps) too               }

{ == number of elements in a multiset                                      }

  OPNS length :: multiset -> integer.


{ == multiset concatenation                                                }

  OPNS multiset ++ multiset :: multiset.


{ == subtraction of multiset / element                                     }

  OPNS multiset -- multiset  :: multiset.
  OPNS multiset -- data :: multiset.


{ == get 'some' element from multiset (rem: this is NOT nondeterministic)  }

  OPNS get :: multiset -> data.


{ == as above but it delivers a multiset not containing the element too    }

  OPNS get :: multiset -> (data,multiset).


{ == take/drop 'some' n elements if possible                               }

  OPNS take,
       drop :: integer -> multiset -> multiset.


{ == remove all double elements                                            }

  OPNS mkset :: multiset -> multiset.


{ == repeat an element n times                                             }

  OPNS rep :: integer -> data -> multiset.


{ == is an element contained in a multiset                                 }

  OPNS member :: multiset -> data -> boolean.


{ == extension of 'member' to multisets (subset)                           }

  OPNS member :: multiset -> multiset -> boolean.


{ == choose one of the elements of a multiset via a selection function     }
{ == which determines by its result whether the first (true) or            }
{ == the second (false) element is 'more correct'                          }

  OPNS select :: (data -> data -> boolean) -> multiset -> data.


{ == insert from ListOps for multisets is just (:)                         }

  OPNS insert :: data -> multiset -> multiset.
  EQNS insert = (:).


{ == the extension of 'insert' to a multiset is the same as (++)           }

  OPNS union :: multiset -> multiset -> multiset.
  EQNS union = (++).


{ == return all elements being in the first and in the second multiset     }

  OPNS intersect :: multiset -> multiset -> multiset.


{ == test if a multiset is single-elemented                                }

  OPNS single :: multiset -> boolean.


{ == test if a multiset is empty                                           }

  OPNS ismt :: multiset -> boolean.


{ == divide the elements of a multiset into two disjunct multisets         }

  OPNS divide :: (data -> boolean) -> multiset -> (multiset,multiset).


{ == inverse version of ':'                                                }

  OPNS multiset | data :: multiset.
  EQNS L | D = D : L.


{ == take (filter) or eliminate (remove) elements using a predicate        }

  OPNS filter,
       remove :: (data -> boolean) -> multiset -> multiset.


{ == specialized reduction                                                 }

  OPNS fold1 :: (data -> data -> data) -> multiset -> data.
  EQNS { see LOCAL }


{ == does a predicate hold for all (forall) or for some (exist) data?      }

  OPNS forall,
       exist :: (data -> boolean) -> multiset -> boolean.


{ == the comparisons between multisets and ...                             }

  OPNS multiset <  multiset,
       multiset <= multiset,
       multiset >  multiset,
       multiset >= multiset :: boolean.
  FORALL compare :: multiset -> multiset -> comparison.
  EQNS (L1 <  L2) = compare L1 L2 == less.
       (L1 <= L2) = (compare L1 L2 == less) || (compare L1 L2 == eq).
       (L1 >  L2) = compare L1 L2 == greater.
       (L1 >= L2) = (compare L1 L2 == greater) || (compare L1 L2 == eq).


{ == ... the operation all these comparisons are based on                  }

  OPNS compare :: multiset -> multiset -> comparison.


 LOCAL

  Error +


{ SORTS multiset ::= empty | ins data multiset. }

  
{ OPNS mt :: multiset. }
  EQNS [] = empty.


{ OPNS data : multiset :: multiset. }
  EQNS A : X = ins A X.


{ OPNS length :: multiset -> integer. }
  EQNS length empty = 0.
       length (ins _ X) = 1+length X.


{ OPNS multiset ++ multiset :: multiset. }
  EQNS empty     ++ Y = Y.
       (ins A X) ++ Y = ins A (X++Y).


{ OPNS multiset -- multiset :: multiset. }
  EQNS X -- empty     = X.
       X -- (ins B Y) = X -- B -- Y.


{ OPNS multiset -- data :: multiset. }
  EQNS empty -- (_::data) = empty.
       (ins A X) -- D = if compare A D == eq then X else ins A (X -- D).


{ OPNS get :: multiset -> data. }
  EQNS get empty = error "get of an empty multiset" :: data.
       get (ins A _) = A.


{ OPNS get :: multiset -> (data,multiset). }
  EQNS get empty = error "get of an empty multiset" :: (data,multiset).
       get (ins A X) = (A,X).


{ OPNS take :: integer -> multiset -> multiset. }
  EQNS take _ empty = empty.
       take N (ins A X) = if N>0 then ins A (take (N-1) X) else empty.


{ OPNS drop :: integer -> multiset -> multiset. }
  EQNS drop _ empty = empty.
       drop N (ins A X) = if N>0 then drop (N-1) X else ins A X.


{ OPNS mkset :: multiset -> multiset. }
  EQNS mkset empty = empty.
       mkset (ins A X) = if member X A then mkset (A : (X -- A)) 
                                       else ins A (mkset X).


{ OPNS rep :: integer -> data -> multiset. }
  EQNS rep N D = if N <= 0 then empty else ins D (rep (N-1) D).


{ OPNS member :: multiset -> data -> boolean. }
  EQNS member empty (_::data) = false.
       member (ins A X) B = compare A B == eq || member X B.


{ OPNS member :: multiset -> multiset -> boolean. }
  EQNS member _ empty = true.
       member Y (ins A X) = member Y A && member Y X.


{ OPNS select :: (data -> data -> boolean) -> multiset -> data. }
  EQNS select _ empty = error "incorrect use of select".
       select _ (ins A empty) = A.
       select F (ins A (ins B X)) = select F (ins (if F A B then A else B) X).


{ OPNS intersect :: multiset -> multiset -> multiset. }
  EQNS intersect empty _ = empty.
       intersect (ins A X) Y = if member Y A then ins A (intersect X Y)
                                             else        intersect X Y.


{ OPNS single :: multiset -> boolean. }
  EQNS single (ins _ empty) = true.
      $single _ = false.


{ OPNS ismt :: multiset -> boolean. }
  EQNS ismt = (==) empty.


{ OPNS divide :: (data -> boolean) -> multiset -> (multiset,multiset). }
  EQNS divide _ empty = (empty,empty).
       divide F (ins A X) = let (X1,X2) = divide F X. in
                            if F A then (ins A X1,X2)
                                   else (X1,ins A X2).


{ OPNS filter :: (data -> boolean) -> multiset -> multiset. }
  EQNS filter _ empty = empty.
       filter P (ins A X) = if P A then ins A (filter P X) else filter P X.


{ OPNS remove :: (data -> boolean) -> multiset -> multiset. }
  EQNS remove _ empty = empty.
       remove P (ins A X) = if P A then remove P X else ins A (remove P X).


{ OPNS fold1 :: (data -> data -> data) -> multiset -> data. }
  EQNS fold1 _ empty = error "fold1 applied to empty".
       fold1 _ (ins A empty) = A.
       fold1 F (ins A (ins B X)) = F A (fold1 F (ins B X)).


{ OPNS forall :: (data -> boolean) -> multiset -> boolean. }
  EQNS forall _ empty = true.
       forall P (ins A X) = P A && forall P X.


{ OPNS exist :: (data -> boolean) -> multiset -> boolean. }
  EQNS exist _ empty = false.
       exist P (ins A X)  = P A || exist P X.


{ OPNS compare :: multiset -> multiset -> comparison. }
  EQNS compare M1 M2 = compare2 (M1--M2) (M2--M1).


  OPNS compare2 :: multiset -> multiset -> comparison.
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
