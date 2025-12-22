{
 ==
 == A hashtable
 ==
 == Version 2.0 (3.1.1993, JvH)
 ==
}
SPEC Hashtable =

 FORMAL

  Comparison +


{ == the data to be hashed                                                 }

  SORTS data.


{ == Hash-function that maps 'data' to 'integer'.                          }

  OPNS hash :: data -> integer.


{ == Compare function on datas                                             }

  OPNS compare :: data -> data -> comparison.


{ == Special instance of 'data', that represents an errorvalue.            }

  OPNS errorval :: data.


{ == GLOBAL ============================================================== }

  GLOBAL


    Dictionary ACTUAL SORTS dom         = data.
                            codom       = data.
                            entry       = data.
                            content     = datas.
                            dictionary  = hashtable.
                      OPNS  hash                              = hash.
                            (dom,codom) : content :: content  = (:).
                            content -- dom :: content         = (--).
                            content ?! dom :: (boolean,codom) = (?!).
                            errorval                          = errorval.
               END +


  SORTS datas ::= [data].


{ == some of Dictionary operations are having an unsuitable interface.     }
{ == Here are the new ones:                                                }

  OPNS data : hashtable :: hashtable.
  EQNS Data : (Hashtable::hashtable) = (Data,Data) : Hashtable.


  OPNS hashtable := data :: hashtable.
  EQNS Hashtable := Data = Data : Hashtable.


  OPNS hashtable :? data :: (boolean,data,hashtable).
  EQNS (Hashtable::hashtable) :? Data = (Hashtable,Data) :? Data.


{ == FOR ACTUALIZATION: insert some data                                   }

  OPNS (data,data) : datas :: datas.
  EQNS (_,  CoDom) : ([]::datas) = [CoDom].
       (Dom,CoDom) : (A : (X::datas)) =
             if compare CoDom A == less    then CoDom : (A : X)
          elsif compare CoDom A == greater then A : ((Dom,CoDom) : X)
                                           else A : X.


{ == FOR ACTUALIZATION: remove all values with this domain                 }

  OPNS datas -- data :: datas.
  EQNS ([]::datas) -- (_::data) = [].
       (A : (X::datas)) -- Dom =
            if compare Dom A == less    then A : X
         elsif compare Dom A == greater then A : (X -- Dom)
                                        else X.


{ == FOR ACTUALIZATION: test/select function                               }

  OPNS datas ?! data :: (boolean,data).
  EQNS ([]::datas) ?! _ = (false,errorval).
       (A : (X::datas)) ?! Dom =
            if compare Dom A == less    then (false,A)
         elsif compare Dom A == greater then X ?! Dom
                                        else (true,A).


END.
