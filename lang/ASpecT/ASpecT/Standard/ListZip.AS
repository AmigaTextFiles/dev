{
 ==
 == zip/unzip on lists
 == Version 2.0 (16.11.1992, JvH)
 ==
}

SPEC ListZip =

 FORMAL

  SORTS a. as ::= [a]. b. bs ::= [b]. c. cs ::= [c].


 GLOBAL

{ == zip two lists of the same length together. If one of the list is      }
{ == longer than the other the surplus elements are lost                   }

  OPNS zip :: (a -> b -> c) -> as -> bs -> cs.
  EQNS zip F (A:X) (B:Y) = F A B : zip F X Y.
      $zip _ _ _ = [].


{ == unzip a list in two of the same length                                }

  OPNS unzip :: (a -> (b,c)) -> as -> (bs,cs).
  EQNS unzip _ [] = ([],[]).
       unzip F (A:X) = let (B, C)  = F A.
                           (Bs,Cs) = unzip F X.
                       in (B:Bs,C:Cs).


END.
