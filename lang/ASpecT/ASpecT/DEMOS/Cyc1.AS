{ ==
  == Demonstration of recursive instantiation (part 3)
  ==  File Nro. 1
  ==       same as Cyc0 but 'f' and 'g' are interchanged
  == }

SPEC Cyc1 =

 FORMAL SORTS a. b.
        OPNS  f :: integer -> b.

 GLOBAL OPNS  g :: a -> b.
        EQNS  g _ = f 1.

END.
