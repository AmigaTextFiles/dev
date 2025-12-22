{
 ==
 == the option datatype
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC Option = 

 FORMAL

{ == the data which should be optional                                     }

  SORTS data.

 GLOBAL

  SORTS option ::= nil
                 | avail data.


{ == check on avail                                                        }

  OPNS avail :: option -> boolean.
  EQNS avail nil       = false.
       avail (avail _) = true.


{ == get the data (fail on access to nil)                                  }

  OPNS cont :: option -> data.
  EQNS { see LOCAL }


 LOCAL


  Error +
      
{ OPNS cont :: option -> data. }
  EQNS cont nil       = error "cont nil".
       cont (avail D) = D.

END.
