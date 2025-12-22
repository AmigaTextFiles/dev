{
 ==
 == Dictionary (mapping with hashing)
 ==
 == Version 2.0 (3.1.1993, JvH)
 ==  Version 1.0 (21.12.1992, Mattias Werner)
 ==
}
SPEC Dictionary =

 FORMAL

{ == the domain (key) and co-domain (value) of the dictionary              }

  SORTS dom. codom.


{ == the entry of a dictionary. This should be a combination of 'dom'      }
{ == and 'codom', that is sufficient for your problem.                     }

  SORTS entry.


{ == List of entry, because sometimes more than one entry has the same     }
{ == hashed dom.                                                           }

  SORTS content ::= [entry].


{ == Hash-function that maps 'dom' to 'integer'.                           }

  OPNS hash :: dom -> integer.


{ == Function to store a 'codom' associated to a 'dom' into a list of      }
{ == 'entry'. This function can take care of the uniqueness of 'dom'.      }

  OPNS (dom,codom) : content :: content.


{ == Function to delete the 'entry' associated to 'dom' from a list of     }
{ == 'entry'.  Counterpart to (:).                                         }

  OPNS content -- dom :: content.


{ == Function to get the 'codom' associated to 'dom'. If there is an entry }
{ == for 'dom', 'boolean' will be true, otherwise false.                   }

  OPNS content ?! dom :: (boolean,codom).


{ == Special instance of 'codom', that represents an errorvalue.           }

  OPNS errorval :: codom.


{ == GLOBAL ============================================================== }

 GLOBAL


{ == the dictionary sort                                                   }

{ SORTS dictionary. (only currently -- we are working on that) }


{ == Creates a empty dictionary; terminate in case of an error.            }

  OPNS mt :: dictionary.


{ == (Re)define dictionary at point.                                       }

  OPNS (dom,codom) : dictionary :: dictionary.
  EQNS (Dom,CoDom) : Dict = (Dict,Dom) := CoDom.


  OPNS (dictionary,dom) := codom :: dictionary.


{ == Define dictionary at point only if undefined before. If 'boolean' is  }
{ == true 'codom' is the 'old' value (no change); otherwise the new one    }

  OPNS (dictionary,dom) :? codom :: (boolean,codom,dictionary).


{ == Cardinality of dom                                                    }

  OPNS size :: dictionary -> integer.


{ == Get the co-domain at point (fail if undefined)                        }

  OPNS dictionary ! dom :: codom.


{ == as above but does not fail but delivers errorval                      }

  OPNS dictionary !` dom :: codom.
  EQNS Dict !` Dom = codom (Dict ?! Dom).


{ == as above but does not fail but delivers errorval and definedness      }

  OPNS dictionary ?! dom :: (boolean,codom).


{ == undefine dictionary at point                                          }

  OPNS dictionary -- dom :: dictionary.


{ == definedness: is a dictionary defined at a point                       }

  OPNS dictionary ? dom :: boolean.
  EQNS Dict ? Dom = boolean (Dict ?! Dom).


{ == test if dictionary is single-elemented                                }

  OPNS single :: dictionary -> boolean.
  EQNS single Dict = size Dict == 1.


{ == test if a dictionary is empty                                         }

  OPNS ismt :: dictionary -> boolean.
  EQNS ismt Dict = size Dict == 0.


{ == collect all co-domains of the defined points                          }

  OPNS get_content :: dictionary -> content.


{ == LOCAL =============================================================== }


  IMPORTS Array ACTUAL SORTS codom = content. array = dictionary. 
                       OPNS  errorval = mt.
                       { == and lots of renamings since we are going to  }
                       { == define all these functions differently but   }
                       { == they should remain overloaded                }
                             maxsize = xx_dict_maxsize.  { useless       }
                             mt      = xx_dict_mt.       { redefined     }
                             (:)     = xx_dict_ins.      { redefined     }
                             (:=)    = xx_dict_assign.   { redefined     }
                             size    = xx_dict_size.     { redefined     }
                             (!)     = xx_dict_get.      { redefined     }
                             (!`)    = xx_dict_get_ne.   { redefined     }
                             (?!)    = xx_dict_qg.       { redefined     }
                             update  = xx_dict_update.   { not supported }
                             (--)    = xx_dict_undef.    { redefined     }
                             (?)     = xx_dict_query.    { redefined     }
                             single  = xx_dict_single.   { redefined     }
                             ismt    = xx_dict_ismt.     { redefined     }
                END +



 LOCAL

  Integer +
  String +
  Error +
  ListOps +


{ OPNS mt :: dictionary.}
  EQNS mt = xx_dict_mt xx_dict_maxsize.


{ OPNS (dictionary,dom) := codom :: dictionary. }
  EQNS (Dict,Dom) := CoDom =
          let Hash = abs(hash Dom % xx_dict_maxsize).
              (Got,Content) = xx_dict_qg Dict Hash.
          in if Got
             then xx_dict_assign (Dict,Hash) ((Dom,CoDom) : Content)
             else error "Implemenation failed in Dictionary.(:=)".

        
{ OPNS (dictionary,dom) :? codom :: (boolean,codom,dictionary). }
  EQNS (Dict,Dom) :? CoDom =
          let Hash = abs(hash Dom % xx_dict_maxsize).
              (Got,Content) = xx_dict_qg Dict Hash.
          in if Got
             then let (Got,CoDom2) = Content ?! Dom.
                  in if Got
                     then (Got,CoDom2,Dict)
                     else (Got,CoDom,
                           xx_dict_assign (Dict,Hash) ((Dom,CoDom) : Content))
             else error "Implemenation failed in Dictionary.(:?)".


{ OPNS size :: array -> integer. }
  EQNS size Dict =
         size (xx_dict_size Dict) 0 Dict.


  OPNS size :: integer -> integer -> dictionary -> integer.
  EQNS size Hash All Dict = 
         let (_,Content) = xx_dict_qg Dict Hash.
         in if Hash == 0
            then length Content + All
            else size (Hash-1) (length Content + All) Dict.


{ OPNS dictionary ! dom :: codom. }
  EQNS Dict ! Dom = 
          let Hash = abs(hash Dom % xx_dict_maxsize).
              (Got,Content) = xx_dict_qg Dict Hash.
          in if Got
             then let (Got,CoDom) = Content ?! Dom.
                  in if Got
                     then CoDom
                     else error "(!) on undefined domain in dictionary"
             else error "Implemenation failed in Dictionary.(!)".


{ OPNS dictionary ?! dom :: (boolean,codom). }
  EQNS Dict ?! Dom = 
          let Hash = abs(hash Dom % xx_dict_maxsize).
              (Got,Content) = xx_dict_qg Dict Hash.
          in if Got
             then let (Got,CoDom) = Content ?! Dom.
                  in if Got
                     then (true,CoDom)
                     else (false,errorval)
             else error "Implemenation failed in Dictionary.(?!)".


{ OPNS dictionary -- dom :: dictionary. }
  EQNS Dict -- Dom =
          let Hash = abs(hash Dom % xx_dict_maxsize).
              (Got,Content) = xx_dict_qg Dict Hash.
          in if Got
             then xx_dict_assign (Dict,Hash) (Content -- Dom)
             else error "Implemenation failed in Dictionary.(--)".


{ OPNS get_content :: dictionary -> content. }
  EQNS get_content Dict =
         get_content (xx_dict_size Dict) [] Dict.


  OPNS get_content :: integer -> content -> dictionary -> content.
  EQNS get_content Hash All Dict = 
         let (_,Content) = xx_dict_qg Dict Hash.
         in if Hash == 0
            then Content ++ All
            else get_content (Hash-1) (Content++All) Dict.


END.
