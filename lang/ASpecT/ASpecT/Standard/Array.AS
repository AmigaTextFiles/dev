{
 ==
 == Array (mapping of an integer domain to a (formal) codomain)
 ==   (the order of the integer domain elements is as usual)
 == Version 2.0 (26.12.1992, JvH)
 ==
}

SPEC Array =

 FORMAL

{ == only the codomain sort is formal, the domain is integer               }

  SORTS codom.


{ == some suitable error value                                             }

  OPNS errorval :: codom.


 GLOBAL

  Boolean +
  Integer +


{ == the array sort is implemented extern as efficient C-array             }

  SORTS EXTERN array.


{ == an implementation dependent limit (maximal size of an array)          }

  OPNS EXTERN maxsize :: integer.


{ == create an array with a given maximal size and initialize all          }
{ == points with errorval. The domain then ranges [0..size[                }
{ == mt 0 is possible too (empty domain)                                   }

  OPNS EXTERN mt :: integer -> array.


{ == (re)define array at point; fails on exceeding domain ranges           }

  OPNS (integer,codom) : array :: array.
  EQNS (D,C) : M = (M,D) := C.

  
  OPNS EXTERN (array,integer) := codom :: array.


{ == cardinality of the domain (trivially the set maximal size)            }

  OPNS EXTERN size :: array -> integer.


{ == get the co-domain at point (fail on exceeding domain ranges)          }

  OPNS array ! integer :: codom.
  EQNS { see LOCAL }


{ == as above but does not fail but delivers errorval                      }

  OPNS array !` integer :: codom.
  EQNS A !` I = codom (A ?! I).


{ == as above but does not fail but delivers errorval and definedness      }

  OPNS EXTERN array ?! integer :: (boolean,codom).


{ == lifting of (:=) to arrays (fails if second arrays sizse is too large) }

  OPNS update :: array -> array -> array.
  EQNS { see LOCAL }


{ == undefine array at point (here: set co-domain on errorval)             }

  OPNS array -- integer :: array.
  EQNS A -- I = (A,I) := errorval.


{ == definedness: is an array defined at a point (here: check range)       }

  OPNS array ? integer :: boolean.
  EQNS A ? I = (I>=0) && (I < size A).


{ == test if an array is single-elemented                                  }

  OPNS single :: array -> boolean.
  EQNS single A = size A == 1.


{ == test if an array is empty                                             }

  OPNS ismt :: array -> boolean.
  EQNS ismt A = size A == 0.


 LOCAL

  Error +


{ OPNS array ! integer :: codom. }
  EQNS A ! I = let (Ok,C) = A ?! I. in
               if Ok then C else error "array index out of range".


{ OPNS update :: array -> array -> array. }
  EQNS update A1 A2 = if size A1 < size A2
                      then error "large array cannot be merged into small one"
                      else copy A1 A2 (size A2).


  OPNS copy :: array -> array -> integer -> array.
  EQNS copy A1 A2 I = if I < 0
                      then A1
                      else let E = A2!I.
                           in if E == errorval
                              then copy A1 A2 (I-1)
                              else copy ((A1,I) := (A2!I)) A2 (I-1).

END.
