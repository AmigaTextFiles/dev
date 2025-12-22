{ ==
  == The UNIX sort program (without parameters)
  == Version 1.0 (18.11.92, JvH)
  ==
  == }

SPEC Sort =

  STREAM +
  STRINGS +
  QSORT +
  FOLD +

OPNS getlines :: system -> (strings,system).
EQNS getlines S = let (Ok,Line,S) = readln S.
                  in if Ok
                     then let (Lines,S) = getlines S.
                          in ([Line|Lines],S)
                     else ([],S).


     OPNS readln :: system -> (boolean,string,system).
     EQNS readln S = let (Ok,Char,S) = read_char S.
                     in if Ok 
	                then if Char == '\n'
	                     then (true,"",S)
	                     else let (_,Chars,S) = readln S.
	                          in (true,char_string Char + Chars,S)
	                else (false,"",S).


OPNS goal :: system -> system.
EQNS goal S = let (Lines,S) = getlines S.
              in foldl (@) S (qsort (>=) Lines).


END.
