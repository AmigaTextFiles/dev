{
 ==
 == Multi value dictionary -- more than one codom for each dom
 ==
 == Version 2.0 (3.1.1993, JvH)
 ==  Version 1.0 (24.11.92, Michael Froehlich)
 ==  Version 1.1 (1.12.92, Mattias Werner)
 ==
}
SPEC MultiDict =

 FORMAL

{ == the domain (key) and co-domain (value) of the dictionary              }

  SORTS dom. codom.


{ == Hash-function that maps 'dom' to 'integer'.                           }

  OPNS hash :: dom -> integer.


{ == GLOBAL ============================================================== }

  GLOBAL


    Dictionary ACTUAL SORTS dom         = dom.
                            codom       = codoms.
                            entry       = entry.
                            content     = content.
                      OPNS  hash                              = hash.
                            (dom,codom) : content :: content  = (:).
                            content -- dom :: content         = (--).
                            content ?! dom :: (boolean,codom) = (?!).
                            errorval                          = mt.
               END +
    ListOps +


  SORTS entry   ::= e dom::dom codoms::codoms.
        codoms  ::= [codom].
        content ::= [entry].

{ == some function to insert a single codom -- since the actualization     }
{ == delivers a '(dom,codoms) : dictionary :: dictionary' only             }   

  OPNS (dom,codom) : dictionary :: dictionary.
  EQNS (Dom,CoDom) : Dict = (Dom,[CoDom]) : Dict.


  OPNS (dictionary,dom) := codom :: dictionary.
  EQNS (Dict,Dom) := CoDom = (Dom,[CoDom]) : Dict.


{ == FOR ACTUALIZATION: insert some codomains to others with the same key  }

  OPNS (dom,codoms) : content :: content.
  EQNS (Dom,CoDoms) : [] = [e Dom CoDoms].
       (Dom,CoDoms) : (e Dom2 CoDoms2 : Cont) =
          if Dom == Dom2
          then e Dom2 (CoDoms ++ CoDoms2) : Cont
          else e Dom2 CoDoms2 : ((Dom,CoDoms) : Cont).


{ == FOR ACTUALIZATION: remove all values with this domain                 }

  OPNS content -- dom :: content.
  EQNS ([]::content) -- (_::dom) = [].
       (e Dom CoDoms : X) -- Dom2 = if Dom == Dom2
                                    then X
                                    else e Dom CoDoms : (X -- Dom2).


{ == FOR ACTUALIZATION: test/select function                               }

  OPNS content ?! dom :: (boolean,codoms).
  EQNS ([]::content) ?! _ = (false,[]).
       (e Dom CoDoms : X) ?! Dom2 = if Dom == Dom2
                                    then (true,CoDoms)
                                    else X ?! Dom2.


END.
