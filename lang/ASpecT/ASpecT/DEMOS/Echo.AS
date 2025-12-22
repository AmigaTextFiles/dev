{ ==
  == The UNIX echo program (without parameters)
  == Version 1.0 (2.1.93, JvH)
  ==
  == }

SPEC Echo = StreamIO + Combinator +

OPNS goal :: system -> system.
EQNS goal Sys = let (_,In,Sys) = stdin Sys.
                    (_,   Out) = copy (In,char) (mt,(+)).
                    (_,   Sys) = stdout Out Sys.
                in Sys.
END.
