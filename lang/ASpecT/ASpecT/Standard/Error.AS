{
 ==
 == Error abort
 == Version 2.0 (12.11.1992, JvH)
 ==
}


SPEC Error =

FORMAL SORTS data.

GLOBAL


{ == `error' applied to a string creates an error value with  the  associated  }
{ == message.   It causes the program to  terminate  and  print the string as  }
{ == a diagnostic.                                                             }

  OPNS EXTERN error :: string -> data. 


{ == `undef' is a name for  the  completely  undefined  value.   Any  attempt  }
{ == access  it  results  in  an error message.  Note that `undef' belongs to  }
{ == every type.                                                               }

  OPNS undef :: data.
  EQNS undef = error "undefined".


END.
