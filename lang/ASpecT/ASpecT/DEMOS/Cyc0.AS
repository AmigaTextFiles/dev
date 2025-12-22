{ ==
  == Demonstration of recursive instantiation (part 3)
  ==  File Nro. 0 (similar to Cyc1)
  ==       exports an 'f' operation defined on a formal
  ==               'b' operation by forgetting its argument.
  == }

SPEC Cyc0 =
 
 FORMAL SORTS a. b.
        OPNS  g :: integer -> b.

 GLOBAL OPNS  f :: a -> b.
        EQNS  f _ = g 1.

END.
