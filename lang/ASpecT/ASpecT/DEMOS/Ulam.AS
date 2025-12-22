{ ==
  == The ULAM function
  ==
  ==}

SPEC Ulam =

 READWRITE +

 SORTS nat ::= zero               { 0         }
             | x2 nat             { 2 * x     }
             | x2_inc nat.        { 2 * x + 1 }

 OPNS one, two, three :: nat.
 EQNS one   = x2_inc zero.
      two   = x2 one.
      three = x2_inc one.

 OPNS ulam :: nat -> nat.
 EQNS ulam zero = zero.
      ulam (x2 X) = ulam X.
      ulam (x2_inc zero) = x2_inc zero.
     $ulam (x2_inc X) = 
          ulam (div_2 (inc (three * (x2_inc X)))).


 OPNS div_2 :: nat -> nat.
 EQNS div_2 zero = zero.
      div_2 (x2 X) = X.
      div_2 (x2_inc X) = X.


 OPNS inc :: nat -> nat.
 EQNS inc zero = one.
      inc (x2 X) = x2_inc X.
      inc (x2_inc X) = x2 (inc X).


 OPNS nat + nat :: nat.
 EQNS zero + X = X.
    $ X + zero = X.
      (x2 X) + (x2 Y) = x2 (X+Y).
      (x2 X) + (x2_inc Y) = x2_inc (X+Y).
      (x2_inc X) + (x2 Y) = x2_inc (X+Y).
      (x2_inc X) + (x2_inc Y) =
           x2 (inc (X+Y)).


 OPNS nat * nat :: nat.
 EQNS zero * _ = zero.
      (x2 X) * Y = x2 (X*Y).
      (x2_inc X) * (x2_inc Y) =
         x2_inc ((x2 (X*Y)) + (X+Y)).
    $ _ * zero = zero.
    $ X * (x2 Y) = x2 (X*Y).


 OPNS goal :: system -> system.
 EQNS goal S = system (write (ulam (three * three),S)).


END.
