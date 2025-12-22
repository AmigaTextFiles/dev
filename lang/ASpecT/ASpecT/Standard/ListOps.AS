{
 ==
 == List basic operations
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC ListOps =

{ == the 'list' sort is formal as well as the contained data such that it  }
{ == can be used polymophically.                                           }

 FORMAL

  SORTS data.
        list ::= [data].

 GLOBAL

  Boolean +
  Integer +
  Comparison +


{ == number of elements in a list                                          }

  OPNS length :: list -> integer.
  EQNS length [] = 0.
       length (_:X) = 1+length X.


{ == the nth element of list L [0..(length L-1)] (error on failure)        }

  OPNS list ! integer :: data.
  EQNS { see LOCAL }


{ == list concatenation                                                    }

  OPNS list  ++ list :: list.
  EQNS []    ++ Y     = Y.
       (A:X) ++ Y     = A:(X++Y).


{ == subtraction of list / element                                         }

  OPNS list -- list :: list.
  EQNS X    -- []    = X.
       X    -- (B:Y) = (X -- B -- Y) :: list.


  OPNS list  -- data     :: list.
  EQNS []    -- (_::data) = [].
       (A:X) -- D         = if A == D then X else A : (X -- D).


{ == as above but with compare-functional                                  }

  OPNS list -- list :: (data -> data -> boolean) -> list.
  EQNS (X    -- []   ) _ = X.
       (X    -- (B:Y)) F = ((X -- B) F -- Y) F.


  OPNS list  -- data     :: (data -> data -> boolean) -> list.
  EQNS ([]    -- (_::data)) _ = [].
       ((A:X) -- D)         F = if F A D then X else A : ((X -- D) F).


{ == head and tail of a list                                               }

  OPNS hd :: list -> data.
  EQNS { see LOCAL }


  OPNS tl :: list -> list.
  EQNS { see LOCAL }


{ == but-last and last (error on failure)                                  }

  OPNS init :: list -> list.
  EQNS { see LOCAL }


  OPNS last :: list -> data.
  EQNS { see LOCAL }


{ == take/drop first n elements if possible                                }

  OPNS take :: integer -> list -> list.
  EQNS take _ [] = [].
       take N (A:X) = if N>0 then A:take (N-1) X else [].


  OPNS drop :: integer -> list -> list.
  EQNS drop _ [] = [].
       drop N (A:X) = if N>0 then drop (N-1) X else A:X.


{ == take/drop while a predicate succeeds as long its possible             }

  OPNS takewhile :: (data -> boolean) -> list -> list.
  EQNS takewhile _ [] = [].
       takewhile F (A:X) = if F A then A:takewhile F X else [].


  OPNS dropwhile :: (data -> boolean) -> list -> list.
  EQNS dropwhile _ [] = [].
       dropwhile F (A:X) = if F A then dropwhile F X else A:X.


{ == remove all double elements                                            }

  OPNS mkset :: list -> list.
  EQNS mkset [] = [].
       mkset (A:X) = if member X A then mkset (A : (X -- A)) 
                                   else A : mkset X.


{ == as above but with compare-functional                                  }

  OPNS mkset :: (data -> data -> boolean) -> list -> list.
  EQNS mkset _ [] = [].
       mkset F (A:X) = if member F X A then mkset F (A : (X -- A) F)
                                       else A : mkset F X.


{ == reverse a list                                                        }

  OPNS reverse :: list -> list.
  EQNS { see LOCAL }


{ == append an element to a list                                           }

  OPNS postfix :: data -> list -> list.
  EQNS postfix A X = X ++ [A].


{ == repeat an element n times                                             }

  OPNS rep :: integer -> data -> list.
  EQNS rep N D = if N <= 0 then [] else D : rep (N-1) D.


{ == is an element contained in a list                                     }

  OPNS member :: list -> data -> boolean.
  EQNS member [   ] (_::data) = false.
       member (A:X) B = if A==B then true else member X B.


{ == as above but with compare-functional                                  }

  OPNS member :: (data -> data -> boolean) -> list -> data -> boolean.
  EQNS member _ [   ] (_::data) = false.
       member F (A:X) B = if F A B then true else member F X B.


{ == extension of 'member' to lists                                        }

  OPNS member :: list -> list -> boolean.
  EQNS member _ [   ] = true.
       member Y (A:X) = member Y A && member Y X.


{ == as above but with compare-functional                                  }

  OPNS member :: (data -> data -> boolean) -> list -> list -> boolean.
  EQNS member _ _ [   ] = true.
       member F Y (A:X) = member F Y A && member F Y X.


{ == choose one of the elements of a list via a selection function         }
{ == which determines by its result whether the first (true) or            }
{ == the second (false) element is 'more correct'                          }

  OPNS select :: (data -> data -> boolean) -> list -> data.
  EQNS { see LOCAL }


{ == sort merge-sorts a list with a given relation                         }
{ == merge applied to two 'sorted' lists merges them to produce a single   }
{ == sorted result.                                                        }

  OPNS sort :: (data -> data -> boolean) -> list -> list.
  EQNS sort F S = let N = length S.
                        N2 = N / 2.
                  in if N <= 1
                     then S
                     else let (First,Second) = split N2 S. in
                          merge F (sort F First) (sort F Second).


  OPNS merge :: (data -> data -> boolean) -> list -> list -> list.
  EQNS merge _ []    []    = [].
       merge _ []    (B:Y) = B:Y.
       merge _ (A:X) []    = A:X.
       merge F (A:X) (B:Y) = if F A B then A:merge F X (B:Y)
                                      else B:merge F (A:X) Y.


{ == qsort quick-sorts a list with a given relation                        }

  OPNS qsort :: (data -> data -> boolean) -> list -> list.
  EQNS { see LOCAL }


{ == isort insert-sorts a list with a given relation                       }

  OPNS isort :: (data -> data -> boolean) -> list -> list.
  EQNS { see LOCAL }


{ == puts an element in front of a list if its not already contained       }

  OPNS insert :: data -> list -> list.
  EQNS insert A X = if member X A then X else A:X.


{ == as above but with compare-functional                                  }

  OPNS insert :: (data -> data -> boolean) -> data -> list -> list.
  EQNS insert F A X = if member F X A then X else A:X.


{ == extension of 'insert' to a list                                       }

  OPNS union :: list -> list -> list.
  EQNS union [] Y = Y.
       union (A:X) Y = if member Y A then   union X Y 
                                     else A:union X Y.


{ == as above but with compare-functional                                  }

  OPNS union :: (data -> data -> boolean) -> list -> list -> list.
  EQNS union _ [] Y = Y.
       union F (A:X) Y = if member F Y A then   union F X Y 
                                         else A:union F X Y.


{ == return all elements being in the first and in the second list         }

  OPNS intersect :: list -> list -> list.
  EQNS intersect [] _ = [].
       intersect (A:X) Y = if member Y A then A:intersect X Y 
                                         else   intersect X Y.


{ == as above but with compare-functional                                  }

  OPNS intersect :: (data -> data -> boolean) -> list -> list -> list.
  EQNS intersect _ [] _ = [].
       intersect F (A:X) Y = if member F Y A then A:intersect F X Y 
                                             else   intersect F X Y.


{ == insert an element before the nth element in a list                    }
  
  OPNS insert_before :: list -> (integer,data) -> list.
  EQNS { see LOCAL }


{ == delete the nth element in a list }

  OPNS delete :: list -> integer -> list.
  EQNS { see LOCAL }


{ == evaluate the first position (index) of a given element in a list      }
{ == returns -1 if the element could not be found                          }

  OPNS idx :: list -> data -> integer.
  EQNS idx []    _ = -1.
       idx (A:X) D =    if A == D      then  0 
                     elsif idx X D < 0 then -1 
                                       else 1+idx X D.


{ == as above but with compare-functional                                  }

  OPNS idx :: (data -> data -> boolean) -> list -> data -> integer.
  EQNS idx _ []    _ = -1.
       idx F (A:X) D =    if F A D       then  0 
                       elsif idx X D < 0 then -1 
                                         else 1+idx F X D.


{ == test if one list is the head of another one                           }

  OPNS head_of :: list -> list -> boolean.
  EQNS head_of []    (_:_) = false.
       head_of _     [   ] = true.
       head_of (B:Y) (A:X) = A == B && head_of Y X.


{ == as above but with compare-functional                                  }

  OPNS head_of :: (data -> data -> boolean) -> list -> list -> boolean.
  EQNS head_of _ []    (_:_) = false.
       head_of _ _     [   ] = true.
       head_of F (B:Y) (A:X) = F A B && head_of F Y X.


{ == replace head of list by another one                                   }
{ ==  the resulting list remains of the same length                        }

  OPNS replace_head_of :: list -> list -> list.
  EQNS replace_head_of [   ] (_:_) = [].
       replace_head_of Y     [   ] = Y.
       replace_head_of (_:Y) (A:X) = A:replace_head_of Y X.


{ == updates/exchanges nth element of a list                               }

  OPNS exchange :: data -> integer -> list -> list.
  EQNS { see LOCAL }


  OPNS (list,integer) := data :: list.
  EQNS (L,N) := D = exchange D N L.


{ == updates/exchanges the first suitable (nth) element of a list using a  }
{ == select and map function                                               }

  OPNS exchange :: (data -> data) -> integer -> list -> list.
  EQNS { see LOCAL }


  OPNS exchange :: (data -> (boolean,data)) -> list -> list.
  EQNS exchange _ [   ] = [].
       exchange F (A:X) = let (Found,B) = F A. in
                          if Found then B:X else A:exchange F X.


{ == test if a list is single-elemented                                    }

  OPNS single :: list -> boolean.
  EQNS single [_] = true.
      $single _ = false.


{ == test if a list is empty                                               }

  OPNS ismt :: list -> boolean.
  EQNS ismt = (==) [].


{ == split list in two parts with first part containing n elements         }

  OPNS split :: integer -> list -> (list,list).
  EQNS split N (A:X) =
         if N==0 then ([],A:X)
                 else let (L,R) = split(N-1) X. in (A:L,R).
       split (_::integer) [] = ([],[]).


{ == same as above but use a predicate to find the split position          }

  OPNS split :: (data -> boolean) -> list -> (list,list).
  EQNS split (_::(data -> boolean)) [] = ([],[]).
       split F (A:X) = if F A then let (X1,X2) = split F X. in
                                   (A:X1,X2)
                              else ([],A:X).


{ == divide the elements of a list into two disjunct list                  }

  OPNS divide :: (data -> boolean) -> list -> (list,list).
  EQNS divide _ [] = ([],[]).
       divide F (A:X) = let (X1,X2) = divide F X. in
                        if F A then (A:X1,X2)
                               else (X1,A:X2).


{ == inverse version of ':'                                                }

  OPNS list | data :: list.
  EQNS L | D = D : L.


{ == take (filter) or eliminate (remove) elements using a predicate        }

  OPNS filter :: (data -> boolean) -> list -> list.
  EQNS filter _ [   ] = [].
       filter P (A:X) = if P A then A : filter P X else filter P X.


  OPNS remove :: (data -> boolean) -> list -> list.
  EQNS remove _ [   ] = [].
       remove P (A:X) = if P A then remove P X else A : remove P X.


{ == specialized right reduction                                           }

  OPNS foldr1 :: (data -> data -> data) -> list -> data.
  EQNS { see LOCAL }


{ == specialized left reduction                                            }

  OPNS foldl1 :: (data -> data -> data) -> list -> data.
  EQNS { see LOCAL }


{ == does a predicate hold for all (forall) or for some (exist) data?      }

  OPNS forall :: (data -> boolean) -> list -> boolean.
  EQNS forall _ [   ] = true.
       forall P (A:X) = P A && forall P X.


  OPNS exist :: (data -> boolean) -> list -> boolean.
  EQNS exist _ [   ] = false.
       exist P (A:X)  = P A || exist P X.


{ == the comparisons between lists based on lexical order and ...          }

  OPNS list <  list,
       list <= list,
       list >  list,
       list >= list :: (data -> data -> comparison) -> boolean.
  EQNS (L1 <  L2) Ord = compare Ord L1 L2 == less.
       (L1 <= L2) Ord = (compare Ord L1 L2 == less)
                     || (compare Ord L1 L2 == eq).
       (L1 >  L2) Ord = compare Ord L1 L2 == greater.
       (L1 >= L2) Ord = (compare Ord L1 L2 == greater)
                     || (compare Ord L1 L2 == eq).


{ == ... the operation all these comparisons are based on                 }

  OPNS compare :: (data -> data -> comparison) -> list -> list -> comparison.
  EQNS compare _ []    []    = eq.
       compare _ (_:_) []    = greater.
       compare _ []    (_:_) = less.
       compare Ord (A:X) (B:Y) = let Compare = Ord A B. in
         if Compare == eq then compare Ord X Y else Compare.


LOCAL

  Error +


{ OPNS list ! integer :: data. }
  EQNS []    ! _ = error "subscript out of range".
       (A:X) ! N = if N==0 then A else X ! (N-1).


{ OPNS hd :: list -> data. }
  EQNS hd (A:_) = A.
       hd [] = error "hd []".


{ OPNS tl :: list -> list. }
  EQNS tl (_:X) = X.
       tl [] = error "tl []".


{ OPNS init :: list -> list. }
  EQNS init [] = error "init []".
       init (A:X) = if X==[] then [] else A:init X.


{ OPNS last :: list -> data. }
  EQNS last [] = error "last []".
       last (A:X) = if X==[] then A else last X.


{ OPNS reverse :: list -> list. }
  EQNS reverse = reverse [].


  OPNS reverse :: list -> list -> list.
  EQNS reverse Y [] = Y.
       reverse Y (A:X) = reverse (A:Y) X.


{ OPNS qsort :: (data -> data -> boolean) -> list -> list. }
  EQNS qsort F L = qsort F L [].


  OPNS qsort :: (data -> data -> boolean) -> list -> list -> list.
  EQNS qsort _ []        Y = Y.
       qsort _ [A]       Y = A:Y.
       qsort F (A:(B:X)) Y = let (First,Second) = qsplit F A (B:X). in
                             qsort F First (A:qsort F Second Y).


  OPNS qsplit :: (data -> data -> boolean) -> data -> list -> (list,list).
  EQNS qsplit _ _ [] = ([],[]).
       qsplit F A (B:Y) = let (First,Second) = qsplit F A Y. in
                          if F A B then (B:First,Second)
                                   else (First,B:Second).


{ OPNS isort :: (data -> data -> boolean) -> list -> list. }
  EQNS isort F L = isort F L [].
  
  
  OPNS isort :: (data -> data -> boolean) -> list -> list -> list.
  EQNS isort _ [] Y = Y.
       isort F (A:X) Y = isort F X (isort_ins F A Y).


  OPNS isort_ins :: (data -> data -> boolean) -> data -> list -> list.
  EQNS isort_ins _ A [] = [A].
       isort_ins F A (B:Y) = if F A B then B:isort_ins F A Y else A:(B:Y). 


{ OPNS select :: (data -> data -> boolean) -> list -> data. }
  EQNS select _ [] = error "incorrect use of select".
       select _ [A] = A.
       select F (A:(B:X)) = select F ((if F A B then A else B):X).


{ OPNS insert_before :: list -> (integer,data) -> list. }
  EQNS insert_before [] (N,D) =
         if N == 0 then [D] 
                   else error "wrong index in insert_before".
       insert_before (A:X) (N,D) = 
            if N <  0 then error "wrong index in insert_before" 
         elsif N == 0 then D:(A:X)
                      else A:insert_before X (N-1,D).


{ OPNS delete :: list -> integer -> list. }
  EQNS delete []    _ = [].
       delete (A:X) N =    if N < 0  then error "wrong index in delete"
                        elsif N == 0 then X
                                     else A : delete X (N-1).


{ OPNS exchange :: data -> integer -> list -> list. }
  FORALL exchange :: data -> integer -> list -> list.
  EQNS exchange _ _ [   ] = error "wrong index in exchange".
       exchange D N (A:X) = if N == 0 then D : X
                                      else A : exchange D (N-1) X.


{ OPNS exchange :: (data -> data) -> integer -> list -> list. }
  FORALL exchange :: (data -> data) -> integer -> list -> list.
  EQNS exchange _ _ [   ] = error "wrong index in exchange".
       exchange F N (A:X) = if N == 0 then F A : X
                                      else A   : exchange F (N-1) X.


{ OPNS foldr1 :: (data -> data -> data) -> list -> data. }
  EQNS foldr1 _ [] = error "foldr1 applied to []".
       foldr1 _ [A] = A.
       foldr1 F (A:(B:X)) = F A (foldr1 F (B:X)).


{ OPNS foldl1 :: (data -> data -> data) -> list -> data. }
  EQNS foldl1 _ [] = error "foldl1 applied to []".
       foldl1 F (A:X) = foldl2 F A X.


  OPNS foldl2 :: (data  -> data -> data) -> data -> list -> data.
  EQNS foldl2 _ E [] = E.
       foldl2 F E (A:X) = foldl2 F (F E A) X.


END.
