{
 ==
 == Boolean basic operations
 == Version 2.0 (12.11.1992, JvH)
 ==
}

SPEC Boolean =

  Comparison +

{ == the 'boolean' sort (commented out because it is built-in)             }

{ SORTS boolean ::= true | false. }


{ == the logical 'negation'                                                }

  OPNS not :: boolean -> boolean.
  EQNS not false = true.
       not true  = false. 


{ == the logical 'and' -- lazy in the second argument                      }

  OPNS boolean && boolean :: boolean.
  EQNS true    && X       = X.
       false   && _       = false.


{ == the logical 'and' -- strict in both arguments                         }

  OPNS boolean /\ boolean :: boolean.
  EQNS X /\ Y = if X && Y then true else false.


{ == the logical 'or' -- lazy in the second argument                       }

  OPNS boolean || boolean :: boolean. 
  EQNS true    || _       = true.
       false   || X       = X.


{ == the logical 'or' -- strict in both arguments                          }

  OPNS boolean \/ boolean :: boolean.
  EQNS X \/ Y = if X || Y then true else false.


{ == the comparisons between booleans                                      }

  OPNS boolean <  boolean,
       boolean <= boolean,
       boolean >  boolean,
       boolean >= boolean :: boolean.

  EQNS false <  true  = true.
     $ _     <  _     = false.
  
       true  <= false = false.
     $ _     <= _     = true.

       true  >  false = true.
     $ _     >  _     = false.

       false >= true  = false.
     $ _     >= _     = true.


  OPNS compare :: boolean -> boolean -> comparison.
  EQNS compare X Y = if X < Y then less elsif X > Y then greater else eq.


END.
