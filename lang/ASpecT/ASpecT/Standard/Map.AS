{
 ==
 == Mappings from a domain to a co-domain
 ==   with a given order of the domain elements
 == Version 1.0 (26.12.1992, JvH)
 ==
}

SPEC Map =

 FORMAL

  Comparison +


  SORTS dom. codom.
  OPNS compare :: dom -> dom -> comparison.
       errorval :: codom.


 GLOBAL

{ == Due to an implementation restriction in the current version of ASpecT }
{ == the implementation details need to be global. Your should not rely on }
{ == that since we are working on the problem.      The sort map should be }
{ == anonymous in the future and doco should be local of course.           }

  Error +
  BSTree ACTUAL SORTS data = doco.
                      binSearchTree = map.
                OPNS  compare :: data -> data -> comparison = comp.
                      (++`) = update.
         END +

  SORTS doco ::= d dom codom.
  
  OPNS comp :: doco -> doco -> comparison.
  EQNS comp (d D0 _) (d D1 _) = compare D0 D1.


{ == the empty map                                                         }

{ OPNS mt :: map.   /* comes directly from BinSearchTree */ }


{ == (re)define map at point                                               }

  OPNS (dom,codom) : map :: map.
  EQNS (D,C) : M = (M,D) := C.

  
  OPNS (map,dom) := codom :: map.
  EQNS (M,D) := C = d D C :` M.


{ == cardinality of the domain                                             }

{ OPNS size :: map -> integer.   /* comes directly from BinSearchTree */ }


{ == get the co-domain at point (fail if its not there)                    }

  OPNS map ! dom :: codom.
  EQNS mt ! (_::dom) = error "map undefined".
       (bin (d D C) L R) ! D0 = if compare D D0 == eq   then C
                             elsif compare D D0 == less then L ! D0
                             			        else R ! D0.


{ == as above but does not fail but delivers errorval                      }

  OPNS map !` dom :: codom.
  EQNS mt !` _ = errorval.
       (bin (d D C) L R) !` D0 = if compare D D0 == eq   then C
                              elsif compare D D0 == less then L !` D0
                             			         else R !` D0.


{ == as above but does not fail but delivers errorval and definedness      }

  OPNS map ?! dom :: (boolean,codom).
  EQNS mt ?! _ = (false,errorval).
       (bin (d D C) L R) ?! D0 = if compare D D0 == eq   then (true,C)
                              elsif compare D D0 == less then L ?! D0
                             			         else R ?! D0.


{ == lifting of (:=) to maps                                               }

{ OPNS update :: map -> map -> map. /* comes directly from BinSearchTree */ }


{ == undefine map at point                                                 }

  OPNS map -- dom :: map.
  EQNS M -- D = M --` (d D errorval).


{ == definedness: is a map defined at a point                              }

  OPNS map ? dom :: boolean.
  EQNS mt ? _ = false.
       (bin (d D _) L R) ? D0 = if compare D D0 == eq   then true
                             elsif compare D D0 == less then L ? D0
                             			        else R ? D0.


{ == test if a map is single-elemented                                     }

{ OPNS single :: map -> boolean. /* comes directly from BinSearchTree */ }


{ == test if a map is empty                                                }

{ OPNS ismt :: map -> boolean. /* comes directly from BinSearchTree */ }


END.
