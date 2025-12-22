SPEC TowersOfHanoi =

  STREAM +
  LISTOPS +
  
SORTS move  ::= move integer integer.
      moves ::= [move].
     
OPNS hanoi :: (integer,integer,integer,integer) -> moves.
EQNS hanoi (N,Source,Help,Dest) =
       if N <=1 then [move Source Dest]
                else hanoi (N-1,Source,Dest,Help) ++
                     [move Source Dest | hanoi (N-1,Help,Source,Dest)].
                     
OPNS goal:: system -> system.
EQNS goal S = system(write(hanoi(11,1,2,3),S)) + "\n".

END.
