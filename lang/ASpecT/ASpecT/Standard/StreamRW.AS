{
 ==
 == Streambased generic I/O of ASpecT terms
 == Version 1.0 (1.2.1992, JvH)
 ==
}

SPEC StreamRW =

 FORMAL SORTS term.

 GLOBAL

  StreamIO +


{ == textual read a term from inStream                                     }

  OPNS EXTERN read  :: (term,inStream) -> (boolean,term,inStream).


{ == textual write a term to outStream                                     }

  OPNS EXTERN write :: (term,outStream) -> (boolean,outStream).


{ == textual write a term to doutStream                                    }

  OPNS EXTERN write :: (term,doutStream) -> (boolean,doutStream).


END.
