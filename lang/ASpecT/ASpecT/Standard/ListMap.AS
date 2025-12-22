{
 ==
 == Mappings (map, scan) on lists
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC ListMap =

 FORMAL
 
  SORTS from. from_list ::= [from].
        to.   to_list   ::= [to].

 GLOBAL

{ == map the elements of a list                                            }

  OPNS map :: (from->to) -> from_list -> to_list.
  EQNS map _ [] = [].
       map F (A:X) = F A : map F X.


{ == map the elements of a list and put the resulting list in front of     }
{ == another one -- this saves a additional (++) call                      }

  OPNS map_con :: (from->to) -> from_list -> to_list -> to_list.
  EQNS map_con _ []    Y = Y.
       map_con F (A:X) Y = F A : map_con F X Y.


{ == map the elements of a list but take them only in case of true -- this }
{ == this saves one sweep over the list                                    }

  OPNS filtered_map :: (from->(boolean,to)) -> from_list -> to_list.
  EQNS filtered_map _ []    = [].
       filtered_map F (A:X) = let (Ok,B) = F A. in
                              if Ok then B : filtered_map F X
                                    else     filtered_map F X.


{ == map the elements of a list but take them only in case of true -- this }
{ == this saves one sweep over the list                                    }

  OPNS filtered_map_con :: (from->(boolean,to)) -> from_list -> to_list
                        -> to_list.
  EQNS filtered_map_con _ []    Y = Y.
       filtered_map_con F (A:X) Y = let (Ok,B) = F A. in
                                    if Ok then B : filtered_map_con F X Y
                                          else     filtered_map_con F X Y.


{ == generate a list of (intermediate)-results calculated by successive    }
{ == applying a function to the elements of a list and the previous        }
{ == (intermediate) result. the startvalue is given as parameter.          }

  OPNS scan :: (to -> from -> to) -> to -> from_list -> to_list.
  EQNS scan _ E [] = [E].
       scan F E (A:X) = E : scan F (F E A) X.


END.
