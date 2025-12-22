{
 ==
 == A multi purpose clock which is
 ==  a normal clock,
 ==  a stopwatch (measuring the user-time of the process) and
 ==  a filedate examiner
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC Clock =

  DateTime +
  String +


{ == What time/date is it?                                                }

  OPNS EXTERN time :: system -> time_area -> (boolean,system,date_time).


{ == A stopwatch (timer) with the functions ...                           }

{ == ... to check if a stopwatch is available - if not, all functions     }
{ == of the stopwatch do nothing and the elapsed time is always 0.        }

  OPNS EXTERN timer_available :: system -> (boolean,system).


{ == ... start/stop the timer (start resets the stopwatch to 0)           }

  OPNS EXTERN start_timer, stop_timer :: system -> system.


{ == ... look at the stopwatch for the elapsed time which is given in     }
{ ==  seconds and 1/100 seconds.                                          }

  OPNS EXTERN look_timer :: system -> (integer,integer,system).


{ == A filedate examination function                                      }

  OPNS EXTERN modify_time :: system -> time_area -> string
                          -> (boolean,system,date_time).


END.
