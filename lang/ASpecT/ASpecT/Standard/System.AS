{
 ==
 == Operations on system (old fashioned style)
 == Version 2.0 (3.1.1993, JvH)
 ==
}

SPEC System =

{ == These operations are old fashioned style output operations which      }
{ == should only be used if a raw-IO is intended. Otherwise use operations }
{ == of StreamIO. Note that the IO on system depends on the currently set  }
{ == in/out channel (which is normally set to stdin/stdout). In some cases }
{ == (normally while a operation of StreamRW is the caller - that is in    }
{ == programming some IO operations for external sorts in ASpecT) the      }
{ == channels are redirected to some stream which may course confusion.    }


{ == the 'old' SYSTEM module imported a lot of modules ...                 }

  Boolean + Integer + Char + String + ReadWrite +


{ == write a string on the (current) standard output                       }

  OPNS EXTERN write_string :: string -> system -> (boolean,system).

{ == same as above but ignore any errors                                   }

  OPNS system + string :: system.
  EQNS Sys + Str = system(write_string Str Sys).


{ == same as above but write a carriage return afterwards                  }

  OPNS system @ string :: system.
  EQNS Sys @ Str = Sys + Str + "\n".


{ == read a char from the (current) standard input                         }

  OPNS EXTERN read_char :: system -> (boolean,char,system).


{ == unread A SINGLE char. This may not be called twice in a row.          }

  OPNS EXTERN unread_char :: char -> system -> (boolean,system).


END.
