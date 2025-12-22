SPEC LetDemo = INTEGER +

{ This module demonstrates 'let ... in' only and is not intended to run. }



{ Just a very simple one ... }

OPNS fac :: integer -> integer.
EQNS fac 0 = 1.
    $fac X = let Rec = fac (X-1).
             in X * Rec.

{ Note that the lhs of lets may only consist of variables  and
  nested tuples of those ... no application (parametric) lets }

OPNS turn :: integer -> (integer,integer).
EQNS turn X = let Rec   = turn (X-1). 
                  (A,B) = if X > 1 then Rec else (0,1).
              in (B,A).

{ This is illegal }

{ To show up the nesting rule ... }

OPNS ack :: integer -> integer.
EQNS ack 0 = 1.
     ack 1 = 1.
    $ack N = let N1 = ack (N-1).
                 N2 = ack (N-2).
             in  N1+N2.

{ which is semantically transformed into ... }

OPNS ack1 :: integer -> integer.
EQNS ack1 0 = 1.
     ack1 1 = 1.
    $ack1 N = let N1 = ack1 (N-1).
              in  let N2 = ack1 (N-2).
                  in  N1+N2.


{ variables are defined till redefined ... on rhs of the redefining
  eqn its still visible so ... }
  
OPNS plus2 :: integer -> integer.
EQNS plus2 X = let X = X + 1.
                   X = X + 1.
               in X.

{ ... that one contains three (!!!) different variables X }

{ Lets are translated to macros ... as shown for the last example 

MACROS #X1 = X+1.
       #X2 = #X1+1.
EQNS   plus2 X = #X2.

meaning that there are the same restrictions for lets as for
macros (beyond the additional ones).

Advantages:
  - increased locality
  - more state-of-art for functional languages
  - forget about the '#'



WE PLAN TO EXTEND THE LET CONCEPT TO REAL LOCAL SCOPES (INCLUDING
IMPORTS, SORT-DEFINITIONS ... COMPARABLE TO THE 'LOCAL' BLOCK BUT
(RELATIVE) FULL USAGE OF THE BOUND VARIABLES IN FAR FUTURE.
IF THIS SUCCEEDS WE WILL KICK OUT THE MACROS (MAYBE). SO GET USED
TO THE NEW FEATURE!

}

END.
