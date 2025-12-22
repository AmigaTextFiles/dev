{
 ==
 == Vectors which allow arithmetic
 == Version 2.0 (21.12.1992, JvH)
 ==
}

SPEC Vector =

 FORMAL

{ == a spec that allows addtion and multiplication                         }

  SORTS data.


{ == the neutral elements of addition and multiplication, respectively     }

  OPNS multident, addident :: data.


{ == the addition and multiplication on data                               }

  OPNS (+), (*) :: data -> data -> data.


 GLOBAL

  List ACTUAL SORTS data = data. list = vector. END +


{ == create a vector of a specific length filled with addident             }

  OPNS rep :: integer -> vector.
  EQNS rep R = rep R addident.


{ == product of two vectors                                                }

  OPNS vector * vector :: data.
  EQNS { see LOCAL }


{ == scalar product                                                        }

  OPNS vector * data :: vector.
  EQNS { see LOCAL }


  OPNS data * vector :: vector.
  EQNS { see LOCAL }


{ == sum of two vectors                                                    }

  OPNS vector + vector :: vector.
  EQNS { see LOCAL }


 LOCAL

   Error +
   ListMap +


{ OPNS vector * vector :: data. }
  FORALL A, B :: vector.
  EQNS A * B = mult addident A B.


  OPNS mult :: data -> vector -> vector -> data.
  EQNS mult X []     []     = X.
       mult X (A:AX) (B:BX) = mult (X+(A*B)) AX BX.
      $mult _ _      _      = error "multiply vectors of differnt dimension!".


{ OPNS vector * data :: vector. }
  FORALL A :: vector. X :: data.
  EQNS A * X = map ((*) X) A.


{ OPNS data * vector :: vector. }
  FORALL A :: vector. X :: data.
  EQNS X * A = A * X.


{ OPNS vector + vector :: vector. }
  EQNS []     + []     = [].
       (A:AX) + (B:BX) = (A + B) : (AX + BX).
      $ _     +  (_ :: vector) = error "add vectors of different dimension!".


END.
