{
 ==
 == The time datatype
 == Version 2.0 (18.12.1992, JvH)
 ==
 ==  (Use 'Clock' to get some times)
}

SPEC Time =

  Comparison +
  Integer +


{ == time is (obviously) a combination of hours, minutes and seconds      }

  SORTS time ::= time(hour   :: integer,
                      minute :: integer,
                      second :: integer).


{ == some initializer                                                     }

  OPNS no_time :: time.
  EQNS no_time = time(0,0,0).


{ == the ususal comparisons ...                                           }

  OPNS (<), (<=), (>), (>=) :: time -> time -> boolean.
  FORALL Time1, Time2 :: time.
  EQNS Time1 <  Time2 = compare Time1 Time2 == less.
       Time1 <= Time2 = (compare Time1 Time2 == less)
                     || (compare Time1 Time2 == eq).
       Time1 >  Time2 = compare Time1 Time2 == greater.
       Time1 >= Time2 = (compare Time1 Time2 == greater)
                     || (compare Time1 Time2 == eq).


{ == and the compare they are based on                                    }

  OPNS compare :: time -> time -> comparison.
  EQNS compare (time(H1,M1,S1)) (time(H2,M2,S2)) =
            if H1 < H2 then less
         elsif H1 > H2 then greater
         elsif M1 < M2 then less
         elsif M1 > M2 then greater
                       else compare S1 S2.


{ == is a time-value valid?                                               }

  OPNS valid :: time -> boolean.
  EQNS valid (time(H,M,S)) =
         (H >= 0) && (H < 24) &&
         (M >= 0) && (M < 60) &&
         (S >= 0) && (S < 60).


{ == convert to seconds                                                   }

  OPNS seconds :: time -> integer.
  EQNS seconds (time(H,M,S)) = S + (60*M) + (3600*H).


END.
