{ ==
  == A benchmark based on the peano-representation of numbers
  ==
  == }

SPEC NatBenchmark =

 SYSTEM +
 READWRITE +

SORTS nat ::= z | s nat.

OPNS nat + nat,
     nat * nat,
     nat ^ nat :: nat.
EQNS z   + Y = Y.
     s X + Y = s(X+Y).


{ == This is the critical equation in combination with the equations
  ==  for the addition, because here we force the larger term to stand
  ==  as left hand side of the addition and therefore to be traversed fully.
  ==  By using "X+(X*Y)" the whole thing is not worth to think about. }
     X * s Y = X * Y + X.
     _ * z   = z.


     _ ^ z = s z.
     X ^ s Y = X * (X ^ Y).


OPNS int :: nat -> integer.
EQNS int z     = 0.
     int (s X) = 1+int X.


OPNS nat :: integer -> nat.
EQNS nat X = if X < 1 then z else s(nat(X-1)).


OPNS goal :: system -> system.
EQNS goal S = 
        let (Ok,S) = write_string "Please enter exponent of 3^ :\n" S.
        in if Ok
           then let (Ok,I,S) = read(0,S).
                in if Ok
                   then let Seven = s(s(s(s(s(s(s z)))))).
                            (_,S) = write(int(s(s(s z))^nat I),S).
                            (_,S) = write_string "\n" S.
                        in  S
                   else S
           else S.

END.
