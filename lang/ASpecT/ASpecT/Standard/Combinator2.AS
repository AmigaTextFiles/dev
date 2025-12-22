{
 ==
 == Combinators with two formals
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC Combinator2 =

 FORMAL

  SORTS a. b.

 
 GLOBAL


{ == yet another 'if then else'                                            }

  OPNS cond :: (a -> boolean) -> (a -> b) -> (a -> b) -> a -> b.
  EQNS cond P F G X = if P X then F X else G X.


{ == k-combinator; k returns the first of two arguments                    }

  OPNS k :: a -> b -> a.
  EQNS k X _ = X.


  OPNS const :: a -> b -> a. { Miranda style of k }
  EQNS const = k.


{ == a special version of the k-combinator which enforces b to be          }
{ == calculated. The normal version (k, const) may be unfolded by the      }
{ == compiler such that the evaluation of the second parameter may         }
{ == be thrown away.                                                       }

  OPNS EXTERN a >> b :: a.
{ EQNS (>>) = k. }


{ == ck-combinator; ck returns the second of two arguments                 }

  OPNS ck :: a -> b -> b.
  EQNS ck _ Y = Y.


{ == w-combinator; (w f) returns a function of one argument that passes    }
{ == that argument to both arguments of f                                  }

  OPNS w :: (a -> a -> b) -> a -> b.
  EQNS w F X = F X X.


{ == y-combinator; the fixed point combinator. If F is an operation on     }
{ == functions that returns a function of the same type, then (y F) is     }
{ == the (least) fixed point of F satisfying F(y F) = (y F)                }

  OPNS y :: ((a -> b) -> a -> b) -> a -> b.
  EQNS y F = F (y F).


{ == some tuple projections                                                }

  OPNS first :: (a,b) -> a.
  EQNS first (A,_) = A.

  OPNS second :: (a,b) -> b.
  EQNS second (_,B) = B.


END.
