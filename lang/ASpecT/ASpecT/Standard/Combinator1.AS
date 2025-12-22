{
 ==
 == Combinators with one formal
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC Combinator1 =

 FORMAL

  SORTS a.

 
 GLOBAL

  Boolean +
  Integer +


{ == the identity function                                                 }

  OPNS id :: a -> a.
  EQNS id X = X.


{ == 'if then else' (commented out because its builtin yet)                }

{ OPNS if_then_else :: (boolean,a,a) -> a. }
{ EQNS if true  then T else _ = T.         }
{      if false then _ else E = E.         }


{ == another 'if then else' but curried                                    }

  OPNS cond :: boolean -> a -> a -> a.
  EQNS cond true  X _ = X.
       cond false _ Y = Y.


{ == a fixpoint evaluator                                                  }

  OPNS fixp :: (a -> a) -> (a -> a -> boolean) -> a -> a.
  EQNS fixp F Eq X = if Eq (F X) X then X else fixp F Eq (F X).


{ == as above but this has a maximal loop count                            }

  OPNS fixp :: (a -> a) -> (a -> a -> boolean,integer) -> a -> a.
  EQNS fixp F (Eq,N) X = if N > 0
                         then if Eq (F X) X then X
                                            else fixp F (Eq,N-1) (F X)
                         else X.


{ == while                                                                 }

  OPNS while :: (a -> boolean) -> (a -> a) -> a -> a.
  EQNS while P F X = if P X then while P F (F X) else X.


{ == until                                                                 }

  OPNS until :: (a -> boolean) -> (a -> a) -> a -> a.
  EQNS until P F X = if P (F X) then F X else until P F (F X).


{ == for                                                                   }

  OPNS for :: (integer,integer) -> (integer -> a -> a) -> a -> a.
  EQNS for (N,M) F X = if N <= M then for (N+1,M) F (F N X) else X.


{ == iter                                                                  }

  OPNS iter :: integer -> (a -> a) -> a -> a.
  EQNS iter N F X = if N > 0 then iter (N-1) F (F X) else X.


END.
