{
 ==
 == The date datatype
 == Version 2.0 (18.12.1992, JvH)
 ==
 ==  (Use 'Clock' to get some dates)
}

SPEC Date =

  Comparison +
  Integer +


{ == date is (obviously) a combination of years, months and days          }

  SORTS date ::= date(year  :: integer,
                      month :: integer,
                      day   :: integer).


{ == some initializer                                                     }

  OPNS no_date :: date.
  EQNS no_date = date (0,0,0).


{ == the ususal comparisons ...                                           }

  OPNS (<), (<=), (>), (>=) :: date -> date -> boolean.
  FORALL Date1, Date2 :: date.
  EQNS Date1 <  Date2 = compare Date1 Date2 == less.
       Date1 <= Date2 = (compare Date1 Date2 == less)
                     || (compare Date1 Date2 == eq).
       Date1 >  Date2 = compare Date1 Date2 == greater.
       Date1 >= Date2 = (compare Date1 Date2 == greater)
                     || (compare Date1 Date2 == eq).


{ == and the compare they are based on                                    }

  OPNS compare :: date -> date -> comparison.
  EQNS compare (date(Y1,M1,D1)) (date(Y2,M2,D2)) =
            if Y1 < Y2 then less
         elsif Y1 > Y2 then greater
         elsif M1 < M2 then less
         elsif M1 > M2 then greater
                       else compare D1 D2.


{ == is a date-value valid? (just a guess)                                }

  OPNS valid :: date -> boolean.
  EQNS valid (date(Y,M,D)) =
         (D >= 1) && (D <= days_of_month (leapyear Y) M) &&
         (M >= 1) && (M <= 12).


{ == how many days has a month                                            }

  OPNS days_of_month :: boolean -> integer -> integer.
  EQNS days_of_month _  1 = 31.
       days_of_month L  2 = if L then 29 else 28.
       days_of_month _  3 = 31.
       days_of_month _  4 = 30.
       days_of_month _  5 = 31.
       days_of_month _  6 = 30.
       days_of_month _  7 = 31.
       days_of_month _  8 = 31.
       days_of_month _  9 = 30.
       days_of_month _ 10 = 31.
       days_of_month _ 11 = 30.
       days_of_month _ 12 = 31.
      $days_of_month _ _  = 0.


{ == is it a leapyear?                                                    }

  OPNS leapyear :: integer -> boolean.
  EQNS leapyear Year =
          if (Year _mod 4) == 0
          then if (Year _mod 100) == 0
               then (Year _mod 400) == 0
               else true
          else false.


END.
