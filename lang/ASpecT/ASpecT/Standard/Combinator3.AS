{
 ==
 == Combinators with three formals
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC Combinator3 =

 FORMAL

  SORTS a. b. c.

 
 GLOBAL


{ == specialized K-combinator; returns the function applied to its value   }
{ == (second parameter) by ignoring the third parameter. This is often     }
{ == called function suspension and used with e.g. void as formal c.       }

  OPNS suspend :: (a->b) -> a -> c -> b.
  EQNS suspend F A _ = F A.


{ == b-combinator; the function composition of curried functions           }

  OPNS b :: (b -> c) -> (a -> b) -> a -> c.
  EQNS b F G X = F (G X).

  
  OPNS (b -> c) * (a -> b) :: a -> c. { infix style of b }
  EQNS (*) = b.


{ == specialized b-combinator                                              }

  OPNS (a -> b) + (a -> c) :: a -> (b,c).
  EQNS (F + G) X = (F X,G X).


{ == the inverse function composition                                      }

  OPNS (a -> b) ; (b -> c) :: a -> c.
  EQNS (F ; G) X = G (F X).


{ == curry a uncurried function                                            }

  OPNS curry :: ((a,b) -> c) -> a -> b -> c.
  EQNS curry F X Y = F (X,Y).


{ == uncurry a curried function                                            }

  OPNS uncurry :: (a -> b -> c) -> (a,b) -> c.
  EQNS uncurry F (X,Y) = F X Y.


{ == c-combinator; swaps the arguments of a curried function               }

  OPNS c :: (a -> b -> c) -> b -> a -> c.
  EQNS c F X Y = F Y X.


  OPNS converse :: (a -> b -> c) -> b -> a -> c. { Miranda style of c }
  EQNS converse = c.


{ == s-combinator                                                          }

  OPNS s :: (a -> b -> c) -> (a -> b) -> a -> c.
  EQNS s F G X = F X (G X).


{ == 'copy' some data from 'a' to 'b' using get/insert functionals         }

  OPNS copy :: (a,a->(boolean,c,a)) -> (b,b->c->b) -> (a,b).
  EQNS copy (A,Fa) (B,Fb) = let (Ok,C,A1) = Fa A. in
         if Ok then copy (A1,Fa) (Fb B C,Fb) else (A,B).


{ == some tuple projections                                                }

  OPNS first :: (a,b,c) -> a.
  EQNS first (A,_,_) = A.

  OPNS second :: (a,b,c) -> b.
  EQNS second (_,B,_) = B.

  OPNS third :: (a,b,c) -> c.
  EQNS third (_,_,C) = C.

END.
