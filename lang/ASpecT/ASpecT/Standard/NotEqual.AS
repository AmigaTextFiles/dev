{
 ==
 == Inequality
 == Version 2.0 (12.11.1992, JvH)
 ==
}


SPEC NotEqual =

FORMAL SORTS data.

GLOBAL Boolean +
       
       OPNS data != data :: boolean.
       EQNS X != Y = not (X==Y).

       { == The equality (==) is built-in }

END.
