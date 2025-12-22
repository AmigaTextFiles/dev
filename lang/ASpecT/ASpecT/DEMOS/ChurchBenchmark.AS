{ ==
  == A benchmark based on the church-representation of numbers
  ==
  ==  Attention: ASpecT 2.0 needs about 200 seconds to execute
  ==             on a SUN 4-75. It allocates 19603 cells and
  ==             uses 4807040 (reuse factor : 245). Nearly all
  ==             of them (4804851) are used to build up the
  ==             closures.
  == }

SPEC ChurchBenchmark =

 Church +
 INTEGER +
 READWRITE +
 
SORTS nat ::= z | succ nat.

OPNS z :: (nat,nat).
EQNS z = (z,z).

OPNS succ :: (nat,nat) -> (nat,nat).
EQNS succ (N,M) = (succ N,succ M).

OPNS to_int :: (nat,nat) -> integer.
EQNS to_int (_,z) = 0.
     to_int (Y,succ X) = 1 + to_int (Y,X). 


OPNS goal :: system -> system.
EQNS goal S = 
          let Three = succ (succ (succ zero)).
              Seven = succ (succ (succ (succ (succ (succ (succ zero)))))).
              Calc  = to_int (((Three ^ Seven) succ zero) succ z).
          in system(write(Calc,S)).

END.
