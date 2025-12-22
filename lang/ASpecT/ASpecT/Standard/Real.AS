{
 ==
 == Real (floating points) basic operations
 == Version 2.0 (1.1.1993, JvH)
 ==
}

SPEC Real =

  Boolean +
  Comparison +


{ == the real sort. Its is normally based on C's float datatype but by     }
{ == modifying the Real.xc file (change two #defines) one can base it on   }
{ == C's double datatype too.                                              }

  SORTS EXTERN real.


{ == some conversions                                                      }

  OPNS EXTERN real   :: string  -> real.
       EXTERN string :: real    -> string.
       EXTERN real   :: integer -> real.
       EXTERN integer:: real    -> (boolean,integer).


{ == addition                                                              }

  OPNS EXTERN real + real :: real.


{ == increment                                                             }

  OPNS (++) :: real -> real.
  EQNS (++) = (+) (real 1).


{ == subtraction                                                           }

  OPNS EXTERN real - real :: real.


{ == decrement                                                             }

  OPNS (--) :: real -> real.
  EQNS (--) = subtract (real 1).


{ == another subtraction (reversed)                                        }

  OPNS subtract :: real -> real -> real.
  EQNS subtract X Y = Y - X.


{ == negation(s)                                                           }

  OPNS EXTERN negate :: real -> real.


  OPNS (-) :: real -> real.
  EQNS (-) = negate.


{ == absolute value                                                        }

  OPNS abs :: real -> real.
  EQNS abs X = if X < (real 0) then (-) X else X.


{ == multiplication                                                        }

  OPNS EXTERN real * real :: real.


{ == division                                                              }

  OPNS EXTERN real / real :: real.


{ == square                                                                }

  OPNS sqr :: real -> real.
  EQNS sqr X = X * X.


{ == signum                                                                }

  OPNS sgn :: real -> integer.
  EQNS sgn X = if X < real 0 then -1 elsif X > real 0 then 1 else 0.


{ == maximum and minimum of two reals                                      }

  OPNS max :: real -> real -> real.
  EQNS max X Y = if X > Y then X else Y.


  OPNS min :: real -> real -> real.
  EQNS min X Y = if X > Y then Y else X.


{ == the comparisions between reals                                        }

  OPNS EXTERN real <   real :: boolean.
       EXTERN real <=  real :: boolean.
       EXTERN real >   real :: boolean.
       EXTERN real >=  real :: boolean.

  OPNS compare :: real -> real -> comparison.
  FORALL X, Y :: real.
  EQNS compare X Y = if X < Y then less elsif X > Y then greater else eq.


{ ======================================================================== }

 LOCAL 

  Char +
  String +
  System +


  OPNS valid_real_char :: char -> boolean -> boolean.
  EQNS valid_real_char C GotPoint = digit C || (C=='.' && not GotPoint).


  OPNS read_real_str :: (string,boolean) -> system -> (boolean,string,system).
  EQNS read_real_str (Str,GotPoint) Sys =
         let (Ok,Ch,Sys) = read_char Sys.
         in if Ok
            then if valid_real_char Ch GotPoint
                 then read_real_str(postfix Ch Str,Ch=='.' || GotPoint) Sys
                 else (not(Str==""),Str,system(unread_char Ch Sys))
            else (not(Str==""),Str,Sys).


  OPNS read_real:: system -> (boolean,real,system).
  EQNS read_real Sys = let (Ok,Str,Sys) = read_real_str("",false) Sys.
                       in (Ok,real Str,Sys).


  OPNS write_real :: system -> real -> system.
  EQNS write_real Sys R = system(write_string(string R) Sys).


END.
