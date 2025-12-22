{
 ==
 == Stack
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC Stack =

 FORMAL

  SORTS data.


 GLOBAL

  Integer +

{ == the datatype stack                                                    }

  SORTS stack ::= empty | push stack data.


{ == number of elements in a stack                                         }

  OPNS size :: stack -> integer.
  EQNS size empty = 0.
       size (push S _) = 1+size S.


{ == get the top of a stack                                                }

  OPNS top :: stack -> data.
  EQNS { see LOCAL }


{ == pop the top of a stack                                                }

  OPNS pop :: stack -> stack.
  EQNS { see LOCAL }



 LOCAL

  Error +


{ OPNS top :: stack -> data. }
  EQNS top empty = error "top of empty stack".
       top (push _ X) = X.


{ OPNS pop :: stack -> stack. }
  EQNS pop empty = error "pop of empty stack".
       pop (push S _) = S.


END.
