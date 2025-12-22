{
 ==
 == Conversions list <-> string
 == Version 1.0 (16.11.1992, JvH)
 ==
}

SPEC Chars =

  ListOps +
  String +


{ == a sort chars being a list of char                                     }

  SORTS chars ::= [char].


{ == conversion chars -> string                                            }

  OPNS string :: chars -> string.
  EQNS string [] = "".
       string (A:X) = A : string X.


{ == conversion string -> chars                                            }

  OPNS chars  :: string -> chars.
  EQNS chars S = let (Ok,A,X) = hd S. in
                 if Ok then A : chars X else [].


END.
