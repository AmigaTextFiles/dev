{
 ==
 == An inStream delivering random characters
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC RandomStream =

  SpecStreamIO +


{ == Another possibility for a inStream delivering quasi-random           }
{ == characters using the system-time as initial seed. The initial seed   }
{ == is modified by the formula   seed' = ((seed + Inc) _mod Mod) * Mul   }
{ == The quality of the sequence depends on the values for Inc, Mod and   }
{ == Mul. A set of seven standard generators are given here.              }

  OPNS random :: system -> (boolean,inStream,system).

  OPNS random :: (integer,integer,integer)
              -> system -> (boolean,inStream,system).


{ == The random generator's parameters                                    }

  OPNS random_generator :: integer -> (integer,integer,integer).
  EQNS random_generator 0 = (120050,2311,25367).
       random_generator 1 = (214326,1807,45289).
       random_generator 2 = (244944,1597,51749).
       random_generator 3 = (233280,1861,49297).
       random_generator 4 = (175000,2661,36979).
       random_generator 5 = (121500,4081,25673).
      $random_generator _ = (145800,3661,30809).


 LOCAL

  Clock +


{ OPNS random :: system -> (boolean,inStream,system). }
  EQNS random S = random (random_generator 0) S.


{ OPNS random :: (integer,integer,integer)
              -> system -> (boolean,inStream,system). }
  EQNS random G S =
         let (Ok,S,DT) = time S local.
         in if Ok
            then (Ok,  special_stream (seconds(time DT)) (rnd_stream G),S)
            else (true,special_stream 123123             (rnd_stream G),S).


  OPNS rnd_stream :: (integer,integer,integer)
                  -> integer -> (boolean,char,integer).
  EQNS rnd_stream (Mod,Mul,Inc) N =
             (true,integer_char N,((N+Inc) _mod Mod) * Mul).


END.
