{
 ==
 == ListsOps
 == Version 2.0 (3.1.1993, JvH)
 ==
}
SPEC ListsOps = 

 FORMAL 

  SORTS data.
        list ::= [data].
        lists ::= [list].

 GLOBAL

  ListOps +

{ == Concatenate all lists of a list (flatten)                             }

  OPNS flatten :: lists -> list.
  EQNS flatten [] = [].
       flatten (A:X) = A ++ flatten X.


  OPNS concat :: lists -> list.
  EQNS concat = flatten.


{ == convert every element of a list to a single elemented list            }

  OPNS blow :: list -> lists.
  EQNS blow [] = [].
       blow (A:X) = [A]:blow X.


{ == append a element to all lists                                         }

  OPNS postfix :: lists -> data -> lists.
  EQNS postfix ([]::lists) _ = [].
       postfix (A:X) Y = postfix Y A:postfix X Y.


{ == concatenate a list with all lists                                     }

  OPNS concat_to_all :: lists -> list -> lists.
  EQNS concat_to_all [] _ = [].
       concat_to_all (A:X) Y = A ++ Y : concat_to_all X Y.


{ == insert a element into all lists                                       }

  OPNS insert_all :: data -> lists -> lists.
  EQNS insert_all _ [] = [].
       insert_all A (B:Y) = A : B : insert_all A Y.


{ == make a list of all first elements                                     }

  OPNS first_col :: lists -> (list,lists).
  EQNS first_col ((A:X):Y) = let (D,L) = first_col Y. in (A:D,X:L).
      $first_col _ = ([],[]).


{ == transpose a matrix                                                   }

  OPNS transpose :: lists -> lists.
  EQNS transpose [] = [].
       transpose (A:X) = join A (transpose X).

{ == put a element before all list (new column)                           }

  OPNS join :: list -> lists -> lists.
  EQNS join [] Y = Y.
       join (A:X) [] = [A]:join X [].
       join (A:X) (B:Y) = (A:B):join X Y.


END.
