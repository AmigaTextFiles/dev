{
 ==
 == Binary trees
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC BTree =

 FORMAL

  SORTS data.


 GLOBAL

  Boolean +
  Integer +


{ == the datatype binTree                                                  }

  SORTS binTree ::= tip data | bin binTree binTree.


{ == insert an element such that the list style is applicable              }
  
  OPNS data : binTree :: binTree.
  EQNS D : T = bin (tip D) T.


{ == size of (number of datas) a binTree                                   }

  OPNS size :: binTree -> integer.
  EQNS size (tip _)   = 1.
       size (bin L R) = size L + size R.


{ == size of (number of nodes) a binTree                                   }

  OPNS nsize :: binTree -> integer.
  EQNS nsize (tip _)   = 0.
       nsize (bin L R) = 1 + nsize L + nsize R.


{ == depth of a binTree                                                    }

  OPNS depth :: binTree -> integer.
  EQNS depth (tip _)   = 0.
       depth (bin L R) = 1 + (depth L _max depth R).


{ == slope of a binTree                                                    }

  OPNS slope :: binTree -> integer.
  EQNS slope (tip _)   = 0.
       slope (bin L R) = depth L - depth R.


{ == the nth element of a binTree T [0..(size T-1)] (error on failure)     }
{ == elements are counted from left to right                               }

  OPNS binTree ! integer :: data.
  EQNS { see LOCAL }


{ == binTree concatenation                                                 }

  OPNS binTree ++ binTree :: binTree.
  EQNS (++) = bin.


{ == subtraction of binTree / element                                      }

  OPNS binTree -- binTree :: binTree.
  EQNS X -- (tip Y)   = X -- Y.
       X -- (bin L R) = X -- L -- R.


  OPNS binTree -- data :: binTree.
  EQNS { see LOCAL }


{ == first (far left) element of a binTree                                 }

  OPNS hd :: binTree -> data.
  EQNS hd (tip X) = X.
       hd (bin L _) = hd L.


{ == remove first (far left) element of a binTree                          }

  OPNS tl :: binTree -> binTree.
  EQNS { see LOCAL }


{ == remove last (far right) element of a binTree                          }

  OPNS init :: binTree -> binTree.
  EQNS { see LOCAL }


{ == last (far right) element of a binTree                                 }

  OPNS last :: binTree -> data.
  EQNS last (tip X) = X.
       last (bin _ R) = last R.


{ == take/drop 'first' n elements; fail if impossible                      }

  OPNS take :: integer -> binTree -> binTree.
  EQNS { see LOCAL }


  OPNS drop :: integer -> binTree -> binTree.
  EQNS { see LOCAL }


{ == take/drop while a predicate succeeds; fail if impossible             }

  OPNS takewhile :: (data -> boolean) -> binTree -> binTree.
  EQNS { see LOCAL }


  OPNS dropwhile :: (data -> boolean) -> binTree -> binTree.
  EQNS { see LOCAL }


{ == remove all double elements (very inefficient)                         }

  OPNS mkset :: binTree -> binTree.
  EQNS { see LOCAL }


{ == reverse a binTree                                                     }

  OPNS reverse :: binTree -> binTree.
  EQNS reverse (tip X) = tip X.
       reverse (bin L R) = bin (reverse R) (reverse L).


{ == append an element to a binTree                                        }

  OPNS postfix :: data -> binTree -> binTree.
  EQNS postfix A X = X ++ (tip A).


{ == repeat an element n times                                             }

  OPNS rep :: integer -> data -> binTree.
  EQNS rep N D = if N <= 1 then tip D
                 else let (Div,Mod) = divmod N 2.
                      in if Mod == 0 then bin (rep Div D)     (rep Div D)
                                     else bin (rep (Div+1) D) (rep Div D).


{ == is an element contained in a binTree                                  }

  OPNS member :: binTree -> data -> boolean.
  FORALL Y :: data.
  EQNS member (tip X) Y = X == Y.
       member (bin L R) Y = member L Y || member R Y.


{ == extension of 'member' to binTrees                                     }

  OPNS member :: binTree -> binTree -> boolean.
  EQNS member T (tip X) = member T X.
       member T (bin L R) = member T L && member T R.


{ == choose one of the elements of a binTree via a selection function      }
{ == which determines by its result whether the first (true) or            }
{ == the second (false) element is 'more correct'                          }

  OPNS select :: (data -> data -> boolean) -> binTree -> data.
  EQNS select _ (tip X) = X.
       select F (bin L R) = let L = select F L.
                                R = select F R.
                            in if F L R then L else R.


{ == sort merge-sorts a binTree with a given relation                      }
{ == merge applied to two 'sorted' binTrees merges them to produce a       }
{ == single sorted result.                                                 }

  OPNS sort :: (data -> data -> boolean) -> binTree -> binTree.
  EQNS sort _ (tip X) = tip X.
       sort F (bin L R) = merge F (sort F L) (sort F R).


  OPNS merge :: (data -> data -> boolean) -> binTree -> binTree -> binTree.
  EQNS merge F (tip L) (tip R) = if F L R then bin (tip L) (tip R)
                                          else bin (tip R) (tip L).
       merge F (tip L) (bin R1 R2) = merge F (bin R1 R2) (tip L).
       merge F (bin L1 L2) R = merge F (merge F L1 R) L2.


{ == puts an element in front of a binTree if its not already contained    }

  OPNS insert :: data -> binTree -> binTree.
  EQNS insert A X = if member X A then X else bin (tip A) X.


{ == extension of 'insert' to a binTree                                    }

  OPNS union :: binTree -> binTree -> binTree.
  EQNS union (tip A) Y = insert A Y.
       union (bin L R) Y = union R (union L Y).


{ == return all elements being in the first and in the second binTree      }

  OPNS intersect :: binTree -> binTree -> (boolean,binTree).
  EQNS intersect (tip X) Y = (member Y X,tip X).
       intersect (bin L R) Y = let (OkL,L) = intersect L Y.
                                   (OkR,R) = intersect R Y.
                               in if OkL
                                  then if OkR then (false,bin L R)
                                              else (false,L)
                                  else if OkR then (false,R)
                                              else (OkR,R).


{ == insert an element before the nth element in a binTree                 }
  
  OPNS insert_before :: binTree -> (integer,data) -> binTree.
  EQNS { see LOCAL }


{ == delete the nth element in a binTree; must remain at least one         }

  OPNS delete :: binTree -> integer -> binTree.
  EQNS { see LOCAL }


{ == evaluate the first position (index) of a given element in a binTree   }
{ == returns -1 if the element could not be found }

  OPNS idx :: binTree -> data -> integer.
  EQNS idx (tip X) D = if D == X then 0 else -1.
       idx (bin L R) D = if member L R then idx L D
                                       else size L + idx R D.


{ == updates/exchanges nth element of a binTree                            }

  OPNS exchange :: data -> integer -> binTree -> binTree.
  EQNS { see LOCAL }


  OPNS (binTree,integer) := data :: binTree.
  EQNS (L,N) := D = exchange D N L.


{ == updates/exchanges the first suitable element of a binTree using a     }
{ == select and map function                                               }

  OPNS exchange :: (data -> (boolean,data)) -> binTree -> binTree.
  EQNS { see LOCAL }


{ == test if a binTree is single-elemented                                 }

  OPNS single :: binTree -> boolean.
  EQNS single (tip _) = true.
      $single _ = false.


{ == test if a binTree is empty                                            }

  OPNS ismt :: binTree -> boolean.
  EQNS ismt _ = false.


{ == split binTree in two parts with first part containing n elements      }

  OPNS split :: integer -> binTree -> (binTree,binTree).
  EQNS { see LOCAL }


{ == same as above but use a predicate to find the split position          }

  OPNS split :: (data -> boolean) -> binTree -> (boolean,binTree,binTree).
  EQNS { see LOCAL }


{ == does a predicate hold for all (forall) or for some (exist) data?      }

  OPNS forall :: (data -> boolean) -> binTree -> boolean.
  EQNS forall P (tip X) = P X.
       forall P (bin L R) = forall P L && forall P R.


  OPNS exist :: (data -> boolean) -> binTree -> boolean.
  EQNS exist P (tip X) = P X.
       exist P (bin L R) = exist P L || exist P R.


{ == is a binTree depth-balanced                                           }

  OPNS depthbal :: binTree -> boolean.
  EQNS depthbal (tip _) = true.
       depthbal (bin L R) = abs (depth L - depth R) <= 1 &&
                            depthbal L && depthbal R.


{ == right-rotate a binTree                                                }

  OPNS rotr :: binTree -> binTree.
  EQNS rotr (bin (bin L1 L2) R) = bin L1 (bin L2 R).
      $rotr T = T.


{ == left-rotate a binTree                                                 }

  OPNS rotl :: binTree -> binTree.
  EQNS rotl (bin L (bin R1 R2)) = bin (bin L R1) R2.
      $rotl T = T.


{ == folding over a binTree                                                }

  OPNS fold :: (data -> data -> data) -> binTree -> data.
  EQNS fold _ (tip X)   = X.
       fold F (bin L R) = F (fold F L) (fold F R).


{ ======================================================================== }

 LOCAL

  Error +


{ OPNS binTree ! integer :: data. }
  EQNS (tip X) ! N = if N == 0 then X else error "subscript out of range".
       (bin L R) ! N = if size L > N
                       then L ! N
                       else R ! (N - size L).


{ OPNS binTree -- data :: binTree. }
  FORALL Y :: data.
  EQNS (tip X) -- Y = if X == Y
                      then error "(--) on a single elemented binTree"
                      else tip X.
       (bin (tip L) (tip R)) -- Y =
                      if L == Y
                      then tip R
                      elsif R == Y
                         then tip L
                         else bin (tip L) (tip R).
       (bin (bin L1 L2) (tip R)) -- Y =
                      if member (bin L1 L2) Y
                      then (bin (bin L1 L2 -- Y) (tip R))
                      elsif R == Y
                         then bin L1 L2
                         else bin (bin L1 L2) (tip R).
       (bin (tip L) (bin R1 R2)) -- Y =
                      if L == Y
                      then bin R1 R2
                      elsif member (bin R1 R2) Y
                         then bin (tip L) (bin R1 R2 -- Y)
                         else bin (tip L) (bin R1 R2).
       (bin (bin L1 L2) (bin R1 R2)) -- Y =
                      if member (bin L1 L2) Y
                      then bin (bin L1 L2 -- Y) (bin R1 R2)
                      else bin (bin L1 L2) (bin R1 R2 -- Y).


{ OPNS tl :: binTree -> binTree. }
  EQNS tl (tip _) = error "tl on a single elemented binTree".
       tl (bin (tip _) R) = R.
       tl (bin (bin L1 L2) R) = bin (tl (bin L1 L2)) R.


{ OPNS init :: binTree -> binTree. }
  EQNS init (tip _) = error "init on a single elemented binTree".
       init (bin L (tip _)) = L.
       init (bin L (bin R1 R2)) = bin L (init (bin R1 R2)).


{ OPNS take :: integer -> binTree -> binTree. }
  EQNS take N (tip X)   = if N <= 0 then error "improper usage of take"
                                    else tip X.
       take N (bin L R) =    if size L == N then L
                          elsif size L <  N then bin L (take (N-size L) R)
                                            else take N L.


{ OPNS drop :: integer -> binTree -> binTree. }
  EQNS drop N (tip X)   = if N >= 1 then error "improper usage of drop"
                                    else tip X.
       drop N (bin L R) =    if size L == N then R
                          elsif size L <  N then drop (N-size L) R
                                            else bin (drop N L) R.


{ OPNS takewhile :: (data -> boolean) -> binTree -> binTree. }
  EQNS takewhile F T = takewhile F T 0 (size T).


  OPNS takewhile :: (data -> boolean) -> binTree -> integer -> integer
                 -> binTree.
  EQNS takewhile F T N Max =
             if N >= Max then T
          elsif F (T!N)  then takewhile F T (N+1) Max
                         else take (N-1) T.


{ OPNS dropwhile :: (data -> boolean) -> binTree -> binTree. }
  EQNS dropwhile F T = dropwhile F T 0 (size T).


  OPNS dropwhile :: (data -> boolean) -> binTree -> integer -> integer
                 -> binTree.
  EQNS dropwhile F T N Max =
             if N >= Max then T
          elsif F (T!N)  then dropwhile F T (N+1) Max
                         else drop (N-1) T.


{ OPNS mkset :: binTree -> binTree. }
  EQNS mkset T = if size T == 1 then T else mkset T (size T).
  
  
  OPNS mkset :: binTree -> integer -> binTree.
  EQNS mkset T N = if N <= 1 then T else
             if member (T -- (T ! N)) (T ! N)
             then mkset T -- (T ! N)
             else mkset T (N-1).


{ OPNS insert_before :: binTree -> (integer,data) -> binTree. }
  EQNS insert_before (tip X) (N,D) =
          if N == 0 then bin (tip D) (tip X)
                    else error "wrong index in insert_before".
       insert_before (bin L R) (N,D) =
          let Sl = size L. in
          if N >= Sl
          then bin L (insert_before R (N-size L,D))
          else bin (insert_before L (N,D)) R.


{ OPNS delete :: binTree -> integer -> binTree. }
  EQNS delete (tip _) N = if N == 0 then error "wrong index in delete"
                                    else error "improper usage of delete".
       delete (bin (tip L) (tip R)) N =
          if N == 0 then tip R
       elsif N == 1 then tip L
                    else error "wrong index in delete".
       delete (bin (tip L) (bin R1 R2)) N =
          if N == 0 then bin R1 R2
                    else bin (tip L) (delete (bin R1 R2) (N-1)).
       delete (bin (bin L1 L2) (tip R)) N =
          let Sl = size (bin L1 L2). in
          if N == Sl then bin L1 L2
       elsif N >  Sl then error "wrong index in delete"
                     else bin (delete (bin L1 L2) N) (tip R).
       delete (bin (bin L1 L2) (bin R1 R2)) N =
          let Sl = size (bin L1 L2). in
          if N >= Sl then bin (bin L1 L2) (delete (bin R1 R2) (N-Sl))
                     else bin (delete (bin L1 L2) N) (bin R1 R2).


{ OPNS exchange :: data -> integer -> binTree -> binTree. }
  EQNS exchange D N (tip _) = if N == 0 then tip D
                                        else error "wrong index in exchange".
       exchange D N (bin L R) = let Sl = size L. in
         if N >= Sl
         then bin L (exchange D (N-Sl) R)
         else bin (exchange D N L) R.


{ OPNS exchange :: (data -> (boolean,data)) -> binTree -> binTree. }
  EQNS exchange F T = let (_,T) = exchange F T. in T.


  OPNS exchange :: (data -> (boolean,data)) -> binTree -> (boolean,binTree).
  EQNS exchange F (tip X) = let (Found,B) = F X. in
                            if Found then (Found,tip B)
                                     else (Found,tip X).
       exchange F (bin L R) = let (Found,L) = exchange F L. in
                              if Found then (Found,bin L R)
                                       else let (Found,R) = exchange F R. in
                                            (Found,bin L R).


{ OPNS split :: integer -> binTree -> (binTree,binTree). }
  EQNS split (_ :: integer) (tip _) = error "improper usage of split".
       split N (bin L R) = if size L == N then (L,R)
                        elsif size L >  N then let (A,B) = split N L.
                                               in (A,bin B R)
                                          else let (A,B) = split (N-size L) R.
                                               in (bin L A,B).


{ OPNS split :: (data -> boolean) -> binTree -> (boolean,binTree,binTree). }
  EQNS split F T = let (Ok,I) = split F T. in
                   if Ok && (size T < (I-1))
                   then (true,take (I+1) T,drop (I+1) T)
                   else (false,T,T).


  OPNS split :: (data -> boolean) -> binTree -> (boolean,integer).
  EQNS split F (tip X) = (F X,0).
       split F (bin L R) = let (InL,IL) = split F L. (InR,IR) = split F R. in
                           if InL then (InL,IL) else (InR,size L+IR).


END.
