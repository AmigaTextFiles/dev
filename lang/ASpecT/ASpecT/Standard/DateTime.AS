{
 ==
 == The combination of date and time
 == Version 2.0 (18.12.1992, JvH)
 ==
 ==  (Use 'Clock' to get some dates)
}

SPEC DateTime =

  Date +
  Time +


{ == it can be local-time or greenwich-mean-time                          }

  SORTS time_area ::= local | gm.


{ == the combination of time, date and time_area                          }

  SORTS date_time ::= td(area :: time_area,
                         time :: time,
                         date :: date).


{ == some initializer                                                     }

  OPNS no_date_time :: date_time.
  EQNS no_date_time = td(local,no_time,no_date).


{ == the ususal comparisons ...                                           }

  OPNS (<), (<=), (>), (>=) :: date_time -> date_time -> boolean.
  FORALL DT1, DT2 :: date_time.
  EQNS DT1 <  DT2 = compare DT1 DT2 == less.
       DT1 <= DT2 = (compare DT1 DT2 == less)
                     || (compare DT1 DT2 == eq).
       DT1 >  DT2 = compare DT1 DT2 == greater.
       DT1 >= DT2 = (compare DT1 DT2 == greater)
                     || (compare DT1 DT2 == eq).


{ == and the compare they are based on                                    }
{ == note that the time areas must be identically                         }

  OPNS compare :: date_time -> date_time -> comparison.
  EQNS compare (td(A1,T1,D1)) (td(A2,T2,D2)) =
            if A1 == A2 then
               if compare D1 D2 == eq
               then compare T1 T2
               else compare D1 D2
            else incomparable.

{ == is a date_time value valid                                           }

  OPNS valid :: date_time -> boolean.
  EQNS valid DT = valid (time DT) && valid (date DT).


END.
