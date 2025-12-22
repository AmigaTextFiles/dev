{
 ==
 == Integer basic operations
 == Version 2.0 (12.11.1992, JvH)
 ==
}

SPEC Integer =

  Boolean +
  Comparison +


{ == addition                                                              }

  OPNS EXTERN integer + integer :: integer.


{ == increment                                                             }

  OPNS (++) :: integer -> integer.
  EQNS (++) = (+) 1.


  OPNS succ :: integer -> integer.
  EQNS succ = (++).


{ == subtraction                                                           }

  OPNS EXTERN integer - integer :: integer.


{ == decrement                                                             }

  OPNS (--) :: integer -> integer.
  EQNS (--) = subtract 1.


  OPNS pred :: integer -> integer.
  EQNS pred = (--).


{ == another subtraction (reversed)                                        }

  OPNS subtract :: integer -> integer -> integer.
  EQNS subtract X Y = Y - X.


{ == negation(s)                                                           }

  OPNS EXTERN negate :: integer -> integer.


  OPNS (-) :: integer -> integer.
  EQNS (-) = negate.


{ == absolute value                                                        }

  OPNS abs :: integer -> integer.
  EQNS abs X = if X < 0 then (-) X else X.


{ == multiplication                                                        }

  OPNS EXTERN integer * integer :: integer.


{ == division                                                              }

  OPNS EXTERN integer _div integer :: integer.


  OPNS integer / integer :: integer.
  EQNS (/) = div.


{ == modulo                                                                }

  OPNS EXTERN integer _mod integer :: integer.


  OPNS integer % integer :: integer.
  EQNS (%) = mod.


{ == division and modulo in as function                                    }

  OPNS divmod :: integer -> integer -> (integer,integer).
  EQNS divmod X Y = (X / Y, X % Y).


{ == square                                                                }

  OPNS sqr :: integer -> integer.
  EQNS sqr X = X * X.


{ == signum                                                                }

  OPNS sgn :: integer -> integer.
  EQNS sgn X = if X < 0 then -1 elsif X > 0 then 1 else 0.


{ == maximum and minimum of two integers                                   }

  OPNS max :: integer -> integer -> integer.
  EQNS max X Y = if X > Y then X else Y.


  OPNS min :: integer -> integer -> integer.
  EQNS min X Y = if X > Y then Y else X.


{ == the comparisions between integers                                     }

  OPNS EXTERN integer <   integer :: boolean.
       EXTERN integer <=  integer :: boolean.
       EXTERN integer >   integer :: boolean.
       EXTERN integer >=  integer :: boolean.


  OPNS compare :: integer -> integer -> comparison.
  FORALL X, Y :: integer.
  EQNS compare X Y = if X < Y then less elsif X > Y then greater else eq.


{ == limits (system dependent)                                             }

  OPNS EXTERN maxint :: integer.


  OPNS minint :: integer.
  EQNS minint = negate maxint.


END.
