{
 ==
 == Binary search trees
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC BSTree =

 FORMAL

  Comparison +


  SORTS data.
  OPNS compare :: data -> data -> comparison.


 GLOBAL

  Boolean +
  Integer +


{ == the datatype binSearchTree                                            }
{ ==  do not use the constructor 'bin' for construction if you want the    }
{ ==  tree to be/stay balanced. Use the marked versions of the supported   }
{ ==  functions to keep the tree balanced. (Infix functions are marked     }
{ ==  with ` - e.g. :` or ++` - others are marked with _ - e.g. tl_)       }


  SORTS binSearchTree ::= mt | bin data binSearchTree binSearchTree.


{ == insert an element such that the list style is applicable              }
  
  OPNS data : binSearchTree :: binSearchTree.
  EQNS X : mt = bin X mt mt.
       X : (bin Y L R) =
         if compare X Y == less then bin Y (X:L) R
      elsif compare X Y == eq   then bin Y L R
                                else bin Y L (X:R).


  OPNS data :` binSearchTree :: binSearchTree.
  EQNS X :` mt = bin X mt mt.
       X :` (bin Y L R) =
         if compare X Y == less then rebal (bin Y (X:`L) R)
      elsif compare X Y == eq   then bin Y L R
                                else rebal (bin Y L (X:`R)).


{ == size of (number of datas) a binSearchTree                             }

  OPNS size :: binSearchTree -> integer.
  EQNS size mt = 0.
       size (bin _ L R) = 1 + size L + size R.


{ == size of (number of nodes) a binSearchTree                             }

  OPNS nsize :: binSearchTree -> integer.
  EQNS nsize mt = 1.
       nsize (bin _ L R) = nsize L + nsize R.


{ == depth of a binSearchTree                                              }

  OPNS depth :: binSearchTree -> integer.
  EQNS depth mt   = 0.
       depth (bin _ L R) = 1 + (depth L _max depth R).


{ == slope of a binSearchTree                                              }

  OPNS slope :: binSearchTree -> integer.
  EQNS slope mt   = 0.
       slope (bin _ L R) = depth L - depth R.


{ == the nth element of a binSearchTree T [0..(size T-1)] (error on fail)  }
{ == elements are counted from left to right                               }

  OPNS binSearchTree ! integer :: data.
  EQNS { see LOCAL }


{ == binSearchTree concatenation                                           }

  OPNS binSearchTree ++ binSearchTree :: binSearchTree.
  EQNS mt ++ T = T.
       (bin X L R) ++ T = L ++ (R ++ (X : T)).


  OPNS binSearchTree ++` binSearchTree :: binSearchTree.
  EQNS mt ++` T = T.
       (bin X L R) ++` T = L ++` (R ++` (X :` T)).


{ == subtraction of binSearchTree / element                                }

  OPNS binSearchTree -- binSearchTree :: binSearchTree.
  EQNS X -- mt = X.
       X -- (bin D L R) = X -- D -- L -- R.


  OPNS binSearchTree --` binSearchTree :: binSearchTree.
  EQNS X --` mt = X.
       X --` (bin D L R) = X --` D --` L --` R.


  OPNS binSearchTree -- data :: binSearchTree.
  EQNS { see LOCAL }


  OPNS binSearchTree --` data :: binSearchTree.
  EQNS { see LOCAL }


{ == first (far left) element of a binSearchTree                           }

  OPNS hd :: binSearchTree -> data.
  EQNS { see LOCAL }


{ == remove first (far left) element of a binSearchTree                    }

  OPNS tl :: binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS tl_ :: binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


{ == remove last (far right) element of a binSearchTree                    }

  OPNS init :: binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS init_ :: binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


{ == last (far right) element of a binSearchTree                           }

  OPNS last :: binSearchTree -> data.
  EQNS { see LOCAL }


{ == take/drop 'first' n elements if possible                              }

  OPNS take :: integer -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS drop :: integer -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS take_ :: integer -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS drop_ :: integer -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


{ == take/drop while a predicate succeeds; fail if impossible             }

  OPNS takewhile :: (data -> boolean) -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS dropwhile :: (data -> boolean) -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS takewhile_ :: (data -> boolean) -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS dropwhile_ :: (data -> boolean) -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


{ == append an element to a binSearchTree                                  }

  OPNS postfix :: data -> binSearchTree -> binSearchTree.
  EQNS postfix = (:).


  OPNS postfix_ :: data -> binSearchTree -> binSearchTree.
  EQNS postfix_ = (:`).


{ == is an element contained in a binSearchTree                            }

  OPNS member :: binSearchTree -> data -> boolean.
  EQNS member mt (_::data) = false.
       member (bin D L R) Y = if compare D Y == eq   then true
                           elsif compare D Y == less then member L Y
                                                     else member R Y.


{ == extension of 'member' to binSearchTrees                               }

  OPNS member :: binSearchTree -> binSearchTree -> boolean.
  EQNS member _ mt = true.
       member T (bin D L R) = member T D && member T L && member T R.


{ == choose one of the elements of a binSearchTree via a selection function}
{ == which determines by its result whether the first (true) or            }
{ == the second (false) element is 'more correct'                          }

  OPNS select :: (data -> data -> boolean) -> binSearchTree -> data.


{ == puts an element in front of a binSearchTree if its not already        }
{ == contained (just for convenience)                                      }

  OPNS insert :: data -> binSearchTree -> binSearchTree.
  EQNS insert = (:).


  OPNS insert_ :: data -> binSearchTree -> binSearchTree.
  EQNS insert_ = (:`).


{ == extension of 'insert' to a binSearchTree                              }

  OPNS union :: binSearchTree -> binSearchTree -> binSearchTree.
  EQNS union = (++).


  OPNS union_ :: binSearchTree -> binSearchTree -> binSearchTree.
  EQNS union_ = (++`).


{ == return all elements being in the first and in the second              }

  OPNS intersect :: binSearchTree -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS intersect_ :: binSearchTree -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


{ == delete the nth element in a binSearchTree                             }

  OPNS delete :: binSearchTree -> integer -> binSearchTree.
  EQNS { see LOCAL }


  OPNS delete_ :: binSearchTree -> integer -> binSearchTree.
  EQNS { see LOCAL }


{ == evaluate the first position (index) of a given element in a           }
{ == binSearchTree returns -1 if the element could not be found            }

  OPNS idx :: binSearchTree -> data -> integer.
  EQNS idx mt _ = -1.
       idx (bin X L R) Y = if compare Y X == eq   then size L
                        elsif compare Y X == less then idx L Y
                                                  else 1 + size L + idx R Y.


{ == updates/exchanges nth element of a binSearchTree                      }

  OPNS exchange :: data -> integer -> binSearchTree -> binSearchTree.
  EQNS exchange D N T = D : delete T N.


  OPNS (binSearchTree,integer) := data :: binSearchTree.
  EQNS (L,N) := D = exchange D N L.


  OPNS exchange_ :: data -> integer -> binSearchTree -> binSearchTree.
  EQNS exchange_ D N T = D :` delete_ T N.


  OPNS (binSearchTree,integer) :=` data :: binSearchTree.
  EQNS (L,N) :=` D = exchange_ D N L.


{ == updates/exchanges the first suitable element of a binSearchTree using }
{ == a select and map function                                             }

  OPNS exchange :: (data -> (boolean,data)) -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


  OPNS exchange_ :: (data -> (boolean,data)) -> binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


{ == test if a binSearchTree is single-elemented                           }

  OPNS single :: binSearchTree -> boolean.
  EQNS single (bin _ mt mt) = true.
      $single _ = false.


{ == test if a binSearchTree is empty                                      }

  OPNS ismt :: binSearchTree -> boolean.
  EQNS ismt mt = true.
      $ismt _ = false.


{ == split binSearchTree in two parts with first part containing n elements}

  OPNS split :: integer -> binSearchTree -> (binSearchTree,binSearchTree).
  EQNS { see LOCAL }


  OPNS split_ :: integer -> binSearchTree -> (binSearchTree,binSearchTree).
  EQNS { see LOCAL }


{ == same as above but use a predicate to find the split position          }

  OPNS split :: (data -> boolean) -> binSearchTree
             -> (binSearchTree,binSearchTree).
  EQNS { see LOCAL }


  OPNS split_ :: (data -> boolean) -> binSearchTree
              -> (binSearchTree,binSearchTree).
  EQNS { see LOCAL }


{ == does a predicate hold for all (forall) or for some (exist) data?      }

  OPNS forall :: (data -> boolean) -> binSearchTree -> boolean.
  EQNS forall _ mt = true.
       forall P (bin X L R) = P X && forall P L && forall P R.


  OPNS exist :: (data -> boolean) -> binSearchTree -> boolean.
  EQNS exist _ mt = false.
       exist P (bin X L R) = P X || exist P L || exist P R.


{ == is a binSearchTree depth-balanced                                     }

  OPNS depthbal :: binSearchTree -> boolean.
  EQNS depthbal mt = true.
       depthbal (bin _ L R) = abs (depth L - depth R) <= 1 &&
                              depthbal L && depthbal R.


{ == re-balance a tree assuming its subtrees are themselves balanced       }

  OPNS rebal :: binSearchTree -> binSearchTree.
  EQNS { see LOCAL }


{ == right-rotate a binSearchTree                                          }

  OPNS rotr :: binSearchTree -> binSearchTree.
  EQNS rotr (bin X (bin Y L1 L2) R) = bin Y L1 (bin X L2 R).
      $rotr T = T.


{ == left-rotate a binSearchTree                                           }

  OPNS rotl :: binSearchTree -> binSearchTree.
  EQNS rotl (bin X L (bin Y R1 R2)) = bin Y (bin X L R1) R2.
      $rotl T = T.


{ == folding over a binSearchTree                                          }

  OPNS fold :: (data -> data -> data) -> binSearchTree -> data.


{ ======================================================================== }

 LOCAL

  Error +


{ OPNS binSearchTree ! integer :: data. }
  EQNS mt ! _ = error "subscript out of range".
       (bin D L R) ! N = if size L >  N then L ! N
                      elsif size L == N then D
                                        else R ! (N - size L).


{ OPNS binSearchTree -- data :: binSearchTree. }
  EQNS mt -- (_::data) = mt.
       (bin X L R) -- Y = if compare X Y == less then bin X (L--Y) R
                       elsif compare X Y == eq   then join L R
                                                 else bin X L (R--Y).


  OPNS join :: binSearchTree -> binSearchTree -> binSearchTree.
  EQNS join L R = if L == mt then R
                              else let (X,T) = split L. in
                                   bin X T R.


  OPNS split :: binSearchTree -> (data,binSearchTree).
  EQNS split mt = error "split mt (INTERNAL)".
       split (bin X L R) = if R == mt then (X,L)
                                       else let (Y,T) = split R. in
                                            (Y,bin X L T).


{ OPNS binSearchTree --` data :: binSearchTree. }
  EQNS mt --` (_::data) = mt.
       (bin X L R) --` Y = if compare X Y == less then rebal (bin X (L--Y) R)
                        elsif compare X Y == eq   then join L R
                                                  else rebal (bin X L (R--Y)).


  OPNS join_ :: binSearchTree -> binSearchTree -> binSearchTree.
  EQNS join_ L R = if L == mt then R
                               else let (X,T) = split_ L. in
                                    rebal (bin X T R).


  OPNS split_ :: binSearchTree -> (data,binSearchTree).
  EQNS split_ mt = error "split mt (INTERNAL)".
       split_ (bin X L R) = if R == mt then (X,L)
                                        else let (Y,T) = split_ R. in
                                             (Y,rebal (bin X L T)).


{ OPNS hd :: binSearchTree -> data. }
  EQNS hd mt = error "hd of empty binSearchTree".
       hd (bin X mt _) = X.
      $hd (bin _ T   _) = hd T.


{ OPNS tl :: binSearchTree -> binSearchTree. }
  EQNS tl mt = error "tl of empty binSearchTree".
       tl (bin _ mt R) = R.
      $tl (bin D L R) = bin D (tl L) R.


{ OPNS tl_ :: binSearchTree -> binSearchTree. }
  EQNS tl_ mt = error "tl of empty binSearchTree".
       tl_ (bin _ mt R) = R.
      $tl_ (bin D L R) = rebal (bin D (tl L) R).


{ OPNS init :: binSearchTree -> binSearchTree. }
  EQNS init mt = error "init of empty binSearchTree".
       init (bin _ L mt) = L.
      $init (bin X L R ) = bin X L (init R).


{ OPNS init_ :: binSearchTree -> binSearchTree. }
  EQNS init_ mt = error "init of empty binSearchTree".
       init_ (bin _ L mt) = L.
      $init_ (bin X L R ) = rebal (bin X L (init_ R)).


{ OPNS last :: binSearchTree -> data. }
  EQNS last mt = error "last of empty binSearchTree".
       last (bin X _ mt) = X.
      $last (bin _ _ R ) = last R.


{ OPNS take :: integer -> binSearchTree -> binSearchTree. }
  EQNS take _ mt   = mt.
       take N (bin X L R) = 
           if size L == N     then L
        elsif size L == (N-1) then bin X L mt
        elsif size L <  N     then take N L
                              else bin X L (take (N-size L-1) R).


{ OPNS take_ :: integer -> binSearchTree -> binSearchTree. }
  EQNS take_ _ mt = mt.
       take_ N (bin X L R) = 
           if size L == N     then L
        elsif size L == (N-1) then X :` L
        elsif size L <  N     then take_ N L
                              else X :` L ++` (take (N-size L-1) R).


{ OPNS drop :: integer -> binSearchTree -> binSearchTree. }
  EQNS drop _ mt = mt.
       drop N (bin X L R) =
           if size L == N     then bin X mt R
        elsif size L == (N-1) then R
        elsif size L <  N     then bin X (drop N L) R
                              else drop (N-size L-1) R.


{ OPNS drop_ :: integer -> binSearchTree -> binSearchTree. }
  EQNS drop_ _ mt = mt.
       drop_ N (bin X L R) =
            if size L == N     then X :` R
         elsif size L == (N-1) then R
         elsif size L <  N     then X :` (drop_ N L) ++` R
                               else drop_ (N-size L-1) R.


{ OPNS takewhile :: (data -> boolean) -> binSearchTree -> binSearchTree. }
  EQNS takewhile F T = takewhile F T 0 (size T).


  OPNS takewhile :: (data -> boolean) -> binSearchTree -> integer -> integer
                 -> binSearchTree.
  EQNS takewhile F T N Max =
             if N >= Max then T
          elsif F (T!N)  then takewhile F T (N+1) Max
                         else take (N-1) T.


{ OPNS takewhile_ :: (data -> boolean) -> binSearchTree -> binSearchTree. }
  EQNS takewhile_ F T = takewhile_ F T 0 (size T).


  OPNS takewhile_ :: (data -> boolean) -> binSearchTree -> integer -> integer
                  -> binSearchTree.
  EQNS takewhile_ F T N Max =
             if N >= Max then T
          elsif F (T!N)  then takewhile_ F T (N+1) Max
                         else take_ (N-1) T.


{ OPNS dropwhile :: (data -> boolean) -> binSearchTree -> binSearchTree. }
  EQNS dropwhile F T = dropwhile F T 0 (size T).


  OPNS dropwhile :: (data -> boolean) -> binSearchTree -> integer -> integer
                 -> binSearchTree.
  EQNS dropwhile F T N Max =
             if N >= Max then T
          elsif F (T!N)  then dropwhile F T (N+1) Max
                         else drop (N-1) T.


{ OPNS dropwhile_ :: (data -> boolean) -> binSearchTree -> binSearchTree. }
  EQNS dropwhile_ F T = dropwhile_ F T 0 (size T).


  OPNS dropwhile_ :: (data -> boolean) -> binSearchTree -> integer -> integer
                  -> binSearchTree.
  EQNS dropwhile_ F T N Max =
             if N >= Max then T
          elsif F (T!N)  then dropwhile_ F T (N+1) Max
                         else drop_ (N-1) T.


{ OPNS select :: (data -> data -> boolean) -> binSearchTree -> data. }
  EQNS select _ mt = error "incorrect use of select".
       select F (bin D L R) = let L = select D F L.
                                  R = select D F R.
                              in if F L R then L else R.


  OPNS select :: data -> (data -> data -> boolean) -> binSearchTree -> data.
  EQNS select A _ mt = A.
       select A F (bin D L R) =
         if F A D then select (select A F L) F R
                  else select (select D F L) F R.


{ OPNS intersect :: binSearchTree -> binSearchTree -> binSearchTree. }
  EQNS intersect mt _ = mt.
       intersect (bin X L R) Y = let L = intersect L Y.
                                     R = intersect R Y.
                                 in if member Y X
                                    then bin X L R
                                    else join L R.


{ OPNS intersect_ :: binSearchTree -> binSearchTree -> binSearchTree. }
  EQNS intersect_ mt _ = mt.
       intersect_ (bin X L R) Y = let L = intersect_ L Y.
                                      R = intersect_ R Y.
                                  in if member Y X
                                     then rebal (bin X L R)
                                     else join_ L R.


{ OPNS delete :: binSearchTree -> integer -> binSearchTree. }
  EQNS delete mt _ = error "wrong index in delete".
       delete (bin X L R) N =
          if size L <  N then bin X (delete L N) R
       elsif size L == N then join L R
                         else bin X L (delete R (N-size L-1)).


{ OPNS delete_ :: binSearchTree -> integer -> binSearchTree. }
  EQNS delete_ mt _ = error "wrong index in delete".
       delete_ (bin X L R) N =
          if size L <  N then rebal (bin X (delete_ L N) R)
       elsif size L == N then join_ L R
                         else rebal (bin X L (delete_ R (N-size L-1))).


{ OPNS exchange :: (data -> (boolean,data)) -> binSearchTree -> binSearchTree. }
  EQNS exchange (_::data -> (boolean,data)) mt = mt.
       exchange F (bin X L R) = let (Ok,From,To) = lookup X F (bin X L R).
                                in To : (bin X L R -- From).


{ OPNS exchange_ :: (data -> (boolean,data)) -> binSearchTree -> binSearchTree.}
  EQNS exchange_ (_::data -> (boolean,data)) mt = mt.
       exchange_ F (bin X L R) = let (Ok,From,To) = lookup X F (bin X L R).
                                 in if Ok
                                    then To :` (bin X L R --` From)
                                    else bin X L R.


  OPNS lookup :: data -> (data -> (boolean,data)) -> binSearchTree
              -> (boolean,data,data).
  EQNS lookup D _ mt = (false,D,D).
       lookup D F (bin X L R) = let (Ok,From,To) = lookup D F L. in
                                if Ok then (Ok,From,To) else
                                let (Ok,To) = F X. in
                                if Ok then (Ok,X,To)
                                      else lookup D F R.


{ OPNS split :: integer -> binSearchTree -> (binSearchTree,binSearchTree). }
  EQNS split (_::integer) mt = (mt,mt).
       split N (bin D L R) =
          if size L == N     then (L,D:R)
       elsif size L == (N-1) then (D:L,R)
       elsif size L >  N     then let (A,B) = split N L.
                                  in (A,D:B++R)
                             else let (A,B) = split (N-size L-1) R.
                                  in (D:A++L,B).


{ OPNS split_ :: integer -> binSearchTree -> (binSearchTree,binSearchTree). }
  EQNS split_ (_::integer) mt = (mt,mt).
       split_ N (bin D L R) =
          if size L == N     then (L,D:`R)
       elsif size L == (N-1) then (D:`L,R)
       elsif size L >  N     then let (A,B) = split_ N L.
                                  in (A,D:`B++`R)
                             else let (A,B) = split_ (N-size L-1) R.
                                  in (D:`A++`L,B).


{ OPNS split :: (data -> boolean) -> binSearchTree
             -> (binSearchTree,binSearchTree). }
  EQNS split F T = let (Ok,I) = split F T. in
                   if Ok
                   then (take (I+1) T,drop (I+1) T)
                   else (T,mt).


{ OPNS split_ :: (data -> boolean) -> binSearchTree
              -> (binSearchTree,binSearchTree). }
  EQNS split_ F T = let (Ok,I) = split F T. in
                    if Ok
                    then (take_ (I+1) T,drop_ (I+1) T)
                    else (T,mt).


  OPNS split :: (data -> boolean) -> binSearchTree -> (boolean,integer).
  EQNS split _ mt = (false,0).
       split F (bin D L R) = let (InL,IL) = split F L. (InR,IR) = split F R. in
                             if InL then (InL,IL)
                          elsif F D then (true,size L)
                                    else (InR,size L+1+IR).


{ OPNS rebal :: binSearchTree -> binSearchTree. }
  EQNS rebal T = if slope T ==  2 then shiftr T
              elsif slope T == -2 then shiftl T
                                  else T.


  OPNS shiftr :: binSearchTree -> binSearchTree.
  EQNS shiftr (bin D L R) = if slope L == -1 then rotr (bin D (rotl L) R)
                                             else rotr (bin D L R).
       shiftr mt = mt.


  OPNS shiftl :: binSearchTree -> binSearchTree.
  EQNS shiftl (bin D L R) = if slope R == 1 then rotl (bin D L (rotr R))
                                            else rotl (bin D L R).
       shiftl mt = mt.


{ OPNS fold :: (data -> data -> data) -> binSearchTree -> data. }
  EQNS fold _ mt   = error "fold of empty binSearchTree".
       fold _ (bin X mt mt) = X.
       fold F (bin X (bin Y L R) mt) = F (fold F (bin Y L R)) X.
       fold F (bin X mt (bin Y L R)) = F X (fold F (bin Y L R)).
      $fold F (bin X L R) = F (F (fold F L) X) (fold F R).


END.
