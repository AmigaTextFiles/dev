{
 ==
 == Simple dictionary
 ==
 == Version 2.0 (3.1.1993, JvH)
 ==  Version 1.0 (24.11.92, Michael Froehlich)
 ==  Version 1.1 (1.12.92, Mattias Werner)
 ==
}
SPEC Dict =

 FORMAL

{ == the domain (key) and co-domain (value) of the dictionary              }

  SORTS dom. codom.


{ == Hash-function that maps 'dom' to 'integer'.                           }

  OPNS hash :: dom -> integer.


{ == Special instance of 'codom', that represents an errorvalue.           }

  OPNS errorval :: codom.


{ == GLOBAL ============================================================== }

  GLOBAL


    Dictionary ACTUAL SORTS dom         = dom.
                            codom       = codom.
                            entry       = entry.
                            content     = content.
                      OPNS  hash                              = hash.
                            (dom,codom) : content :: content  = (:).
                            content -- dom :: content         = (--).
                            content ?! dom :: (boolean,codom) = (?!).
                            errorval                       = errorval.
               END +
    ListOps +


  SORTS entry   ::= e dom::dom codom::codom.
        content ::= [entry].

{ == FOR ACTUALIZATION: insert some codomains to others with the same key  }

  OPNS (dom,codom) : content :: content.
  EQNS (Dom,CoDom) : [] = [e Dom CoDom].
       (Dom,CoDom) : (e Dom2 CoDom2 : Cont) =
          if Dom == Dom2
          then e Dom CoDom : Cont
          else e Dom2 CoDom2 : ((Dom,CoDom) : Cont).


{ == FOR ACTUALIZATION: remove all values with this domain                 }

  OPNS content -- dom :: content.
  EQNS ([]::content) -- (_::dom) = [].
       (e Dom CoDom : X) -- Dom2 = if Dom == Dom2
                                   then X
                                   else e Dom CoDom : (X -- Dom2).


{ == FOR ACTUALIZATION: test/select function                               }

  OPNS content ?! dom :: (boolean,codom).
  EQNS ([]::content) ?! _ = (false,errorval).
       (e Dom CoDom : X) ?! Dom2 = if Dom == Dom2
                                   then (true,CoDom)
                                   else X ?! Dom2.


END.
