{
 ==
 == Labelled binary trees
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC LBTree =

 FORMAL

  SORTS data. label.


 GLOBAL

  Integer +


{ == the datatype labBinTree                                               }

  SORTS labBinTree ::= tip data | bin label labBinTree labBinTree.


{ == size of (number of datas) a labBinTree                                }

  OPNS size :: labBinTree -> integer.
  EQNS size (tip _)   = 1.
       size (bin _ L R) = size L + size R.


{ == size of (number of nodes) a labBinTree                                }

  OPNS nsize :: labBinTree -> integer.
  EQNS nsize (tip _)   = 0.
       nsize (bin _ L R) = 1 + nsize L + nsize R.


{ == depth of a labBinTree                                                 }

  OPNS depth :: labBinTree -> integer.
  EQNS depth (tip _)   = 0.
       depth (bin _ L R) = 1 + (depth L _max depth R).


{ == slope of a labBinTree                                                 }

  OPNS slope :: labBinTree -> integer.
  EQNS slope (tip _)   = 0.
       slope (bin _ L R) = depth L - depth R.


{ == the nth element of a labBinTree T [0..(size T-1)] (error on failure)  }
{ == elements are counted from left to right                               }

  OPNS labBinTree ! integer :: data.
  EQNS { see LOCAL }


{ == labBinTree concatenation                                              }

  OPNS labBinTree ++ labBinTree :: label -> labBinTree.
  EQNS (L ++ R) Lab = bin Lab L R.


{ == subtraction of labBinTree / element                                   }

  OPNS labBinTree -- labBinTree :: labBinTree.
  EQNS X -- (tip Y)     = X -- Y.
       X -- (bin _ L R) = X -- L -- R.


  OPNS labBinTree -- data :: labBinTree.
  EQNS { see LOCAL }


{ == first (far left) element of a labBinTree                              }

  OPNS hd :: labBinTree -> data.
  EQNS hd (tip X) = X.
       hd (bin _ L _) = hd L.


{ == remove first (far left) element of a labBinTree                       }

  OPNS tl :: labBinTree -> labBinTree.
  EQNS { see LOCAL }


{ == remove last (far right) element of a labBinTree                       }

  OPNS init :: labBinTree -> labBinTree.
  EQNS { see LOCAL }


{ == last (far right) element of a labBinTree                              }

  OPNS last :: labBinTree -> data.
  EQNS last (tip X) = X.
       last (bin _ _ R) = last R.


{ == take/drop 'first' n elements; fail if impossible                      }

  OPNS take :: integer -> labBinTree -> labBinTree.
  EQNS { see LOCAL }


  OPNS drop :: integer -> labBinTree -> labBinTree.
  EQNS { see LOCAL }


{ == take/drop while a predicate succeeds; fail if impossible              }

  OPNS takewhile :: (data -> boolean) -> labBinTree -> labBinTree.
  EQNS { see LOCAL }


  OPNS dropwhile :: (data -> boolean) -> labBinTree -> labBinTree.
  EQNS { see LOCAL }


{ == remove all double elements (very inefficient)                         }

  OPNS mkset :: labBinTree -> labBinTree.
  EQNS { see LOCAL }


{ == reverse a labBinTree                                                  }

  OPNS reverse :: labBinTree -> labBinTree.
  EQNS reverse (tip X) = tip X.
       reverse (bin Lab L R) = bin Lab (reverse R) (reverse L).


{ == append an element to a labBinTree                                     }

  OPNS postfix :: label -> data -> labBinTree -> labBinTree.
  EQNS postfix L A X = (X ++ tip A) L.


{ == repeat an element n times                                             }

  OPNS rep :: label -> integer -> data -> labBinTree.
  EQNS rep L N D = if N <= 1 then tip D
                 else let (Div,Mod) = divmod N 2.
                      in if Mod == 0 then bin L (rep L Div D)     (rep L Div D)
                                     else bin L (rep L (Div+1) D) (rep L Div D).


{ == is an element contained in a labBinTree                               }

  OPNS member :: labBinTree -> data -> boolean.
  FORALL Y :: data.
  EQNS member (tip X) Y = X == Y.
       member (bin _ L R) Y = member L Y || member R Y.


{ == extension of 'member' to labBinTrees                                  }

  OPNS member :: labBinTree -> labBinTree -> boolean.
  EQNS member T (tip X) = member T X.
       member T (bin _ L R) = member T L && member T R.


{ == choose one of the elements of a labBinTree via a selection function   }
{ == which determines by its result whether the first (true) or            }
{ == the second (false) element is 'more correct'                          }

  OPNS select :: (data -> data -> boolean) -> labBinTree -> data.
  EQNS select _ (tip X) = X.
       select F (bin _ L R) = let L = select F L.
                                  R = select F R.
                              in if F L R then L else R.


{ == sort merge-sorts a labBinTree with a given relation                   }
{ == merge applied to two 'sorted' labBinTrees merges them to produce a    }
{ == single sorted result.                                                 }

  OPNS sort :: (data -> data -> boolean) -> labBinTree -> labBinTree.
  EQNS sort _ (tip X) = tip X.
       sort F (bin Lab L R) = merge F Lab (sort F L) (sort F R).


  OPNS merge :: (data -> data -> boolean) -> label -> labBinTree -> labBinTree
             -> labBinTree.
  EQNS merge F Lab (tip L) (tip R) = if F L R then bin Lab (tip L) (tip R)
                                              else bin Lab (tip R) (tip L).
       merge F Lab (tip L) (bin RL R1 R2) = merge F Lab (bin RL R1 R2) (tip L).
       merge F Lab (bin LL L1 L2) R = merge F LL (merge F Lab L1 R) L2.


{ == puts an element in front of a labBinTree if its not already contained }

  OPNS insert :: label -> data -> labBinTree -> labBinTree.
  EQNS insert L A X = if member X A then X else bin L (tip A) X.


{ == extension of 'insert' to a labBinTree                                 }

  OPNS union :: label -> labBinTree -> labBinTree -> labBinTree.
  EQNS union L (tip A) Y = insert L A Y.
       union La1 (bin La2 L R) Y = union La2 R (union La1 L Y).


{ == return all elements being in the first and in the second labBinTree   }

  OPNS intersect :: labBinTree -> labBinTree -> (boolean,labBinTree).
  EQNS intersect (tip X) Y = (member Y X,tip X).
       intersect (bin Lab L R) Y = let (OkL,L) = intersect L Y.
                                       (OkR,R) = intersect R Y.
                               in if OkL
                                  then if OkR then (false,bin Lab L R)
                                              else (false,L)
                                  else if OkR then (false,R)
                                              else (OkR,R).


{ == insert an element before the nth element in a labBinTree              }
  
  OPNS insert_before :: labBinTree -> (integer,label,data) -> labBinTree.
  EQNS { see LOCAL }


{ == delete the nth element in a labBinTree; must remain at least one      }

  OPNS delete :: labBinTree -> integer -> labBinTree.
  EQNS { see LOCAL }


{ == evaluate the first position (index) of a given element in a labBinTree}
{ == returns -1 if the element could not be found }

  OPNS idx :: labBinTree -> data -> integer.
  EQNS idx (tip X) D = if D == X then 0 else -1.
       idx (bin _ L R) D = if member L R then idx L D
                                       else size L + idx R D.


{ == updates/exchanges nth element of a labBinTree                        }

  OPNS exchange :: data -> integer -> labBinTree -> labBinTree.
  EQNS { see LOCAL }


  OPNS (labBinTree,integer) := data :: labBinTree.
  EQNS (L,N) := D = exchange D N L.


{ == updates/exchanges the first suitable element of a labBinTree using a  }
{ == select and map function                                               }

  OPNS exchange :: (data -> (boolean,data)) -> labBinTree -> labBinTree.
  EQNS { see LOCAL }


{ == test if a labBinTree is single-elemented                              }

  OPNS single :: labBinTree -> boolean.
  EQNS single (tip _) = true.
      $single _ = false.


{ == test if a labBinTree is empty                                         }

  OPNS ismt :: labBinTree -> boolean.
  EQNS ismt _ = false.


{ == split labBinTree in two parts with first part containing n elements   }

  OPNS split :: integer -> labBinTree -> (labBinTree,labBinTree).
  EQNS { see LOCAL }


{ == same as above but use a predicate to find the split position          }

  OPNS split :: (data -> boolean) -> labBinTree
             -> (boolean,labBinTree,labBinTree).
  EQNS { see LOCAL }


{ == does a predicate hold for all (forall) or for some (exist) data?      }

  OPNS forall :: (data -> boolean) -> labBinTree -> boolean.
  EQNS forall P (tip X) = P X.
       forall P (bin _ L R) = forall P L && forall P R.


  OPNS exist :: (data -> boolean) -> labBinTree -> boolean.
  EQNS exist P (tip X) = P X.
       exist P (bin _ L R) = exist P L || exist P R.


{ == is a labBinTree depth-balanced                                        }

  OPNS depthbal :: labBinTree -> boolean.
  EQNS depthbal (tip _) = true.
       depthbal (bin _ L R) = abs (depth L - depth R) <= 1 &&
                              depthbal L && depthbal R.


{ == right-rotate a labBinTree                                             }

  OPNS rotr :: labBinTree -> labBinTree.
  EQNS rotr (bin La1 (bin La2 L1 L2) R) = bin La1 L1 (bin La2 L2 R).
      $rotr T = T.


{ == left-rotate a labBinTree                                              }

  OPNS rotl :: labBinTree -> labBinTree.
  EQNS rotl (bin La1 L (bin La2 R1 R2)) = bin La1 (bin La2 L R1) R2.
      $rotl T = T.


{ == is a label contained in a labelled labBinTree                         }

  OPNS label :: labBinTree -> label -> boolean.
  EQNS label (tip _) (_ :: label) = false.
       label (bin Lab L R) Y = (Lab == Y) || label L Y || label R Y.


{ == get subtree with a specific label                                     }

  OPNS subtree :: labBinTree -> label -> (boolean,labBinTree).
  EQNS subtree (tip X) _ = (false,tip X).
       subtree (bin Lab L R) Y = if Lab == Y
                                 then (true,bin Lab L R)
                                 else let (InL,L) = subtree L Y.
                                          (InR,R) = subtree R Y.
                                   in if InL then (InL,L) else (InR,R).


{ == folding over a labBinTree                                             }

  OPNS fold :: (data -> data -> data) -> labBinTree -> data.
  EQNS fold _ (tip X)   = X.
       fold F (bin _ L R) = F (fold F L) (fold F R).


{ ======================================================================== }

 LOCAL

  Error +


{ OPNS labBinTree ! integer :: data. }
  EQNS (tip X) ! N = if N == 0 then X else error "subscript out of range".
       (bin _ L R) ! N = if size L > N
                         then L ! N
                         else R ! (N - size L).


{ OPNS labBinTree -- data :: labBinTree. }
  FORALL Y :: data.
  EQNS (tip X) -- Y = if X == Y
                      then error "(--) on a single elemented labBinTree"
                      else tip X.
       (bin La1 (tip L) (tip R)) -- Y =
                      if L == Y
                      then tip R
                      elsif R == Y
                         then tip L
                         else bin La1 (tip L) (tip R).
       (bin La1 (bin La2 L1 L2) (tip R)) -- Y =
                      if member (bin La2 L1 L2) Y
                      then (bin La1 (bin La2 L1 L2 -- Y) (tip R))
                      elsif R == Y
                         then bin La2 L1 L2
                         else bin La1 (bin La2 L1 L2) (tip R).
       (bin La1 (tip L) (bin La2 R1 R2)) -- Y =
                      if L == Y
                      then bin La2 R1 R2
                      elsif member (bin La2 R1 R2) Y
                         then bin La1 (tip L) (bin La2 R1 R2 -- Y)
                         else bin La1 (tip L) (bin La2 R1 R2).
       (bin La1 (bin La2 L1 L2) (bin La3 R1 R2)) -- Y =
                      if member (bin La2 L1 L2) Y
                      then bin La1 (bin La2 L1 L2 -- Y) (bin La3 R1 R2)
                      else bin La1 (bin La2 L1 L2) (bin La3 R1 R2 -- Y).


{ OPNS tl :: labBinTree -> labBinTree. }
  EQNS tl (tip _) = error "tl on a single elemented labBinTree".
       tl (bin _ (tip _) R) = R.
       tl (bin La1 (bin La2 L1 L2) R) = bin La1 (tl (bin La2 L1 L2)) R.


{ OPNS init :: labBinTree -> labBinTree. }
  EQNS init (tip _) = error "init on a single elemented labBinTree".
       init (bin _ L (tip _)) = L.
       init (bin La1 L (bin La2 R1 R2)) = bin La1 L (init (bin La2 R1 R2)).


{ OPNS take :: integer -> labBinTree -> labBinTree. }
  EQNS take N (tip X)   = if N <= 0 then error "improper usage of take"
                                    else tip X.
       take N (bin La L R) =    if size L == N then L
                             elsif size L <  N then bin La L (take (N-size L) R)
                                               else take N L.


{ OPNS drop :: integer -> labBinTree -> labBinTree. }
  EQNS drop N (tip X)   = if N >= 1 then error "improper usage of drop"
                                    else tip X.
       drop N (bin La L R) = if size L == N then R
                          elsif size L <  N then drop (N-size L) R
                                            else bin La (drop N L) R.


{ OPNS takewhile :: (data -> boolean) -> labBinTree -> labBinTree. }
  EQNS takewhile F T = takewhile F T 0 (size T).


  OPNS takewhile :: (data -> boolean) -> labBinTree -> integer -> integer
                 -> labBinTree.
  EQNS takewhile F T N Max =
             if N >= Max then T
          elsif F (T!N)  then takewhile F T (N+1) Max
                         else take (N-1) T.


{ OPNS dropwhile :: (data -> boolean) -> labBinTree -> labBinTree. }
  EQNS dropwhile F T = dropwhile F T 0 (size T).


  OPNS dropwhile :: (data -> boolean) -> labBinTree -> integer -> integer
                 -> labBinTree.
  EQNS dropwhile F T N Max =
             if N >= Max then T
          elsif F (T!N)  then dropwhile F T (N+1) Max
                         else drop (N-1) T.


{ OPNS mkset :: labBinTree -> labBinTree. }
  EQNS mkset T = if size T == 1 then T else mkset T (size T).
  
  
  OPNS mkset :: labBinTree -> integer -> labBinTree.
  EQNS mkset T N = if N <= 1 then T else
             if member (T -- (T ! N)) (T ! N)
             then mkset T -- (T ! N)
             else mkset T (N-1).


{ OPNS insert_before :: labBinTree -> (integer,label,data) -> labBinTree. }
  EQNS insert_before (tip X) (N,L,D) =
          if N == 0 then bin L (tip D) (tip X)
                    else error "wrong index in insert_before".
       insert_before (bin La L R) (N,Lb,D) =
          let Sl = size L. in
          if N >= Sl
          then bin La L (insert_before R (N-size L,Lb,D))
          else bin La (insert_before L (N,Lb,D)) R.


{ OPNS delete :: labBinTree -> integer -> labBinTree. }
  EQNS delete (tip _) N = if N == 0 then error "wrong index in delete"
                                    else error "improper usage of delete".
       delete (bin _ (tip L) (tip R)) N =
          if N == 0 then tip R
       elsif N == 1 then tip L
                    else error "wrong index in delete".
       delete (bin La1 (tip L) (bin La2 R1 R2)) N =
          if N == 0 then bin La2 R1 R2
                    else bin La1 (tip L) (delete (bin La2 R1 R2) (N-1)).
       delete (bin La1 (bin La2 L1 L2) (tip R)) N =
          let Sl = size (bin La2 L1 L2). in
          if N == Sl then bin La2 L1 L2
       elsif N >  Sl then error "wrong index in delete"
                     else bin La1 (delete (bin La2 L1 L2) N) (tip R).
       delete (bin La1 (bin La2 L1 L2) (bin La3 R1 R2)) N =
          let Sl = size (bin La2 L1 L2). in
          if N >= Sl
          then bin La1 (bin La2 L1 L2) (delete (bin La3 R1 R2) (N-Sl))
          else bin La1 (delete (bin La2 L1 L2) N) (bin La3 R1 R2).


{ OPNS exchange :: data -> integer -> labBinTree -> labBinTree. }
  EQNS exchange D N (tip _) = if N == 0 then tip D
                                        else error "wrong index in exchange".
       exchange D N (bin La L R) = let Sl = size L. in
         if N >= Sl
         then bin La L (exchange D (N-Sl) R)
         else bin La (exchange D N L) R.


{ OPNS exchange :: (data -> (boolean,data)) -> labBinTree -> labBinTree. }
  EQNS exchange F T = let (_,T) = exchange F T. in T.


  OPNS exchange :: (data -> (boolean,data)) -> labBinTree -> (boolean,labBinTree).
  EQNS exchange F (tip X) = let (Found,B) = F X. in
                            if Found then (Found,tip B)
                                     else (Found,tip X).
       exchange F (bin La L R) = let (Found,L) = exchange F L. in
                                 if Found then (Found,bin La L R)
                                          else let (Found,R) = exchange F R. in
                                               (Found,bin La L R).


{ OPNS split :: integer -> labBinTree -> (labBinTree,labBinTree). }
  EQNS split (_ :: integer) (tip _) = error "improper usage of split".
       split N (bin La L R) = if size L == N then (L,R)
                           elsif size L >  N then let (A,B)= split N L.
                                                  in (A,bin La B R)
                                             else let (A,B)= split (N-size L) R.
                                                  in (bin La L A,B).


{ OPNS split :: (data -> boolean) -> labBinTree
             -> (boolean,labBinTree,labBinTree). }
  EQNS split F T = let (Ok,I) = split F T. in
                   if Ok && (size T < (I-1))
                   then (true,take (I+1) T,drop (I+1) T)
                   else (false,T,T).


  OPNS split :: (data -> boolean) -> labBinTree -> (boolean,integer).
  EQNS split F (tip X) = (F X,0).
       split F (bin _ L R) = let (InL,IL) = split F L. (InR,IR) = split F R. in
                           if InL then (InL,IL) else (InR,size L+IR).


END.
