{
 ==
 == Combinators with four formals
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC Combinator4 =

 FORMAL

  SORTS a. b. c. d.

 
 GLOBAL


{ == c'-combinator; like c, except that an extra argument before f is      }
{ == unaltered                                                             }

  OPNS c_ :: (a -> b -> c) -> (d -> a) -> b -> d -> c.
  EQNS c_ F G Y X = F (G X) Y.
                { = c F Y (G X). }


{ == b'-combinator; like b, except that an extra argument before f is      }
{ == unaltered                                                             }

  OPNS b_ :: (a -> b -> c) -> a -> (d -> b) -> d -> c.
  EQNS b_ F Y G X = F Y (G X).
                { = b (F Y) G X. }


{ == s'-combinator; like s, except that an extra argument before f is      }
{ == unaltered                                                             }

  OPNS s_ :: (a -> b -> c) -> (d -> a) -> (d -> b) -> d -> c.
  EQNS s_ F H G X = F (H X) (G X).


{ == composition of a unary and curried binary function                    }

  OPNS (c -> d) ** (a -> b -> c) :: a -> b -> d.
  EQNS (F ** G) X Y = F (G X Y).


{ == composition of a curried binary and a unary function                  }

  OPNS (b -> c -> d) ** (a -> b) :: c -> a -> d.
  EQNS (F ** G) X Y = F (G Y) X.


{ == some tuple projections                                                }

  OPNS first :: (a,b,c,d) -> a.
  EQNS first (A,_,_,_) = A.

  OPNS second :: (a,b,c,d) -> b.
  EQNS second (_,B,_,_) = B.

  OPNS third :: (a,b,c,d) -> c.
  EQNS third (_,_,C,_) = C.

  OPNS fourth :: (a,b,c,d) -> d.
  EQNS fourth (_,_,_,D) = D.

END.
