SPEC Church =

 FORMAL

  SORTS a. 

GLOBAL

  SORTS church ::= ((a -> a) -> a -> a).


  OPNS zero :: church.         
  EQNS zero _ Y = Y.


  OPNS succ :: church -> church.
  EQNS succ X A B = A (X A B).


  OPNS one :: church.
  EQNS one = succ zero.


  OPNS two :: church.
  EQNS two = succ one.


  OPNS church + church :: church.
  EQNS (X + Y) A B = X A (Y A B).


  OPNS church * church :: church.
  EQNS (X * Y) Z = X (Y Z).


  OPNS church ^ (church -> church) :: church.
  EQNS X ^ Y = Y X.

END.
