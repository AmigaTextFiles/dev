{ ==
  == Demonstration of recursive instantiation (part 3)
  ==
  ==  Attention: goal does not terminate due the construction in Cyc2
  ==}

SPEC Cyc =

  Cyc2 ACTUAL SORTS a=boolean. b=boolean. END+
  READWRITE +

OPNS goal :: system -> system.
EQNS goal S = system(write(f true,S)).

END.
