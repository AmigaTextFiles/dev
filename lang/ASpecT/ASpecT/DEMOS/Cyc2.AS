{ ==
  == Demonstration of recursive instantiation (part 3)
  ==  File Nro. 2
  ==       This on combines Cyc0 and Cyc1 in a somewhat complicated
  ==       way which is a result of the need to obtain the formal
  ==       operations f and g. One way to get those is to actualize
  ==       Cyc0 and Cyc1 with 'integer' as 'a' as it is done in
  ==       {c} and {d}. As a result of the recursive instantiation
  ==       both Cyc0 and Cyc1 can be exported by Cyc2 which is the
  ==       the goal of the construction.
  ==	   Note that neither both f (the one obtained in {a} which is
  ==       formal in argument and result and the one constructed in {b}
  ==       with formal result and integer argument nor both g terminate
  ==       because now they call each other.
  ==
  == }

SPEC Cyc2 =

FORMAL SORTS a. b.

GLOBAL
 {a} Cyc0 ACTUAL SORTS a=a.       b=b. OPNS g=g. END+
 {b} Cyc1 ACTUAL SORTS a=a.       b=b. OPNS f=f. END+
 {c} Cyc0 ACTUAL SORTS a=integer. b=b. OPNS g=g. END+
 {d} Cyc1 ACTUAL SORTS a=integer. b=b. OPNS f=f. END+

END.
