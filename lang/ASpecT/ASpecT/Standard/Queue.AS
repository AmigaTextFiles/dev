{
 ==
 == Queue
 == Version 1.0 (24.12.1992, JvH)
 ==
}

SPEC Queue =

 FORMAL

  SORTS data.


 GLOBAL

  Integer +


{ == the datatype queue                                                    }

  SORTS queue ::= empty | join queue data.


{ == number of elements in a queue                                         }

  OPNS length :: queue -> integer.
  EQNS length empty = 0.
       length (join Q _) = 1+length Q.


{ == get the front of a queue                                              }

  OPNS front :: queue -> data.
  EQNS { see LOCAL }


{ == remove the front of a queue                                           }

  OPNS reduce :: queue -> queue.
  EQNS { see LOCAL }



 LOCAL

  Error +


{ OPNS front :: queue -> data. }
  EQNS front empty = error "front of empty queue".
       front (join empty X) = X.
       front (join (join Q X) _) = front (join Q X).


{ OPNS reduce :: queue -> queue. }
  EQNS reduce empty = error "reduce of empty queue".
       reduce (join empty _) = empty.
       reduce (join (join Q X) Y) = join (reduce (join Q X)) Y.


END.
