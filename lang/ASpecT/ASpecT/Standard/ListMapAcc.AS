{
 ==
 == more Mapping on lists
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC ListMapAcc =

 FORMAL
 
  SORTS data.
        from. from_list ::= [from].
        to.   to_list   ::= [to].

 GLOBAL

{ == map the elements of a list (with an additional accumulator parameter) }

  OPNS map :: (data->from->(data,to)) -> data -> from_list -> (data,to_list).
  EQNS map _ D []    = (D,[]).
       map F D (A:X) = let (D,B) = F D A.
                           (D,Y) = map F D X.
                       in (D,B:Y).
    
END.
