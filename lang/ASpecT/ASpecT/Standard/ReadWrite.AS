{
 ==
 == Generic I/O of ASpecT terms (old fashioned style)
 == Version 2.0 (3.1.1993, JvH)
 ==
}

SPEC ReadWrite =

 FORMAL SORTS term.

 GLOBAL

{ == These operations are old fashioned style output operations which      }
{ == should only be used if a raw-IO is intended. Otherwise use operations }
{ == of StreamRW. Note that the IO on system depends on the currently set  }
{ == in/out channel (which is normally set to stdin/stdout). In some cases }
{ == (normally while a operation of StreamRW is the caller - that is in    }
{ == programming some IO operations for external sorts in ASpecT) the      }
{ == channels are redirected to some stream which may course confusion.    }


{ == textual read a term from current input                                }

  OPNS EXTERN read  :: (term,system) -> (boolean,term,system).


{ == textual write a term to current input                                 }

  OPNS EXTERN write :: (term,system) -> (boolean,system).


END.
