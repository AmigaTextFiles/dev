{
 ==
 == Identifier table
 ==
 == Version 2.0 (4.1.1993, JvH) (Just a redesign for the new library)
 ==  Version 1.0 (1992, Ric)
 ==
}

SPEC Identifier =

  Strings +

{ == This module implements an efficient string table often useful while   }
{ ==  programming compilers. The table is implemented as part of system;   }
{ ==  meaning as 'global structure'. One can put strings into this table   }
{ ==  (add_id) and receive an 'identifier' which is unique for this string }
{ ==  (just a pointer) and may be compared very efficiently (==). Putting  }
{ ==  an equal string into the table results in the same indentifier of    }
{ ==  course. There is no way of removing some entries!                    }
{ == Identifiers can be converted into 'integer' and into the original     }
{ ==  'string' again. All stored identifiers can be obtained by get_ids.   }
{ ==  The built-in read/write operation for identifier can be masked to    }
{ ==  either read/write an identifier as 'integer' which is of course more }
{ ==  efficient as reading/writing it as 'string'. Thus it is possible to  } 
{ ==  have the identifier-table written (as_string - mode) and in other    }
{ ==  programs loaded (as_string - mode). At the same time a possible      }
{ ==  large datastructure (e.g. abstract syntax term) with lots of         }
{ ==  identifiers stored in it may be written (as_integer - mode) and      }
{ ==  reloaded (as_integer - mode) more efficiently. Because the stored    }
{ ==  table is the base for the structure one has to prepare the table     }
{ ==  before reading a new table by clearing the previous numbering. This  }
{ ==  is done by clear_numbering. This operation sets all numbers of the   }
{ ==  currently stored identifiers to (-1). By loading a table those       }
{ ==  identifiers which are added get new numbers; the yet stored too.     }
{ ==  This makes it possible to read the datastructure now (which contains }
{ ==  only those numbers. The remaining (unnumbered) identifers will get   }
{ ==  new numbers if they are written by write.                            }
{ ==  Another way to set up a new numbering for some identifiers is        }
{ ==  calling renumber.                                                    }

  SORTS EXTERN identifier.


{ ==                                                                       }

  SORTS identifiers ::= [identifier].


{ == Some errorvalue                                                       }

  OPNS EXTERN no_ident :: identifier.


{ == Conversion identifier -> string                                       }

  OPNS EXTERN string :: identifier -> string.


{ == Conversion identifier -> integer                                      }

  OPNS EXTERN integer :: identifier -> integer.


{ == Insert a new string into the table                                    }

  OPNS add_id :: string -> system -> (boolean,identifier,system). 


{ == repeated add_id                                                       }

  OPNS add_ids :: strings -> system -> (identifiers,system).


{ == all stored ids                                                        }

  OPNS get_ids :: system -> (identifiers,system).


{ == a sort to determine in which way read/write should work               }

  SORTS io_mode ::= as_string | as_integer.


{ == set/get io_mode                                                       }

  OPNS EXTERN set_io_mode :: io_mode -> system -> system.


  OPNS EXTERN get_io_mode :: system -> (io_mode,system).


{ ==                                                                       }

  OPNS renumber :: identifiers -> system -> system.


{ ==                                                                       }

  OPNS clear_numbering :: system -> system.


{ == LOCAL =============================================================== }


 LOCAL

  Hashtable  ACTUAL SORTS data       = entry.
                          datas      = entries. 
                    OPNS  hash       = hash_id.
                          compare    = compare_id.
                          errorval   = err_entry.
             END +
  Array      ACTUAL SORTS codom    = entry.
                          array    = e_array.
                    OPNS  errorval = err_entry.
             END +
  String +
  Error +
  ReadWrite +
  ListOps +
  ListFold +


  SORTS entry ::= n id :: string
                    nr :: integer.


  SORTS e_arrays ::= [e_array].


  SORTS idtree ::= ids max    :: integer
                       table  :: hashtable
                       arrays :: e_arrays.


  OPNS hash_id :: entry -> integer.
  EQNS hash_id (n E _) = hash E.


  OPNS compare_id :: entry -> entry -> comparison.
  EQNS compare_id (n E1 _) (n E2 _) = compare E1 E2.


  OPNS no_entry :: entry.
  EQNS no_entry = id_entry no_ident.


  OPNS err_entry :: entry.
  EQNS err_entry = n "" 0.


  OPNS EXTERN entry_id :: entry -> identifier.


  OPNS EXTERN id_entry :: identifier -> entry.


  OPNS EXTERN set_nr :: integer -> identifier -> identifier.  /* Pfu-usch */ 

  OPNS EXTERN set_idtree :: idtree -> system -> system.              


  OPNS EXTERN get_idtree :: system -> (idtree,system).


{ OPNS add_id :: string -> system -> (boolean,identifier,system). }
  EQNS add_id STR S = let (Tree,S) = get_idtree S.
                          (Exists,E,Tree) = add_id STR Tree.
                          S = set_idtree Tree S.
                      in (Exists,E,S).


       OPNS add_id :: string -> idtree -> (boolean,identifier,idtree).
       EQNS add_id Id (ids Max Table Arrays) =
              let (Exists,E,Table) = Table :? n Id Max.
              in if Exists && (nr E >= 0)
                 then (true,entry_id E,ids Max Table Arrays)
                 else let Arrays = assign Max E Arrays.
                      in (false,set_nr Max (entry_id E),
                          ids (Max+1) Table Arrays).


{ OPNS add_ids :: strings -> system -> (identifiers,system). }
  EQNS add_ids STRS S = let (Tree,S) = get_idtree S.
                            (Ids,Tree) = add_ids STRS Tree.
                            S = set_idtree Tree S.
                        in (Ids,S).


       OPNS add_ids :: strings -> idtree -> (identifiers,idtree).
       EQNS add_ids [    ] (Tree::idtree) = ([],Tree).
            add_ids [S|SS] (Tree::idtree) =
               let (_,Id,Tree) = add_id  S  Tree.
                   (Ids, Tree) = add_ids SS Tree.
               in ([Id|Ids],Tree).


{ OPNS get_ids :: system -> (identifiers,system). }
  EQNS get_ids S = let (Tree,S) = get_idtree S.
                       S = set_idtree Tree S.
                   in (get_ids (max Tree) (arrays Tree),S).


       OPNS get_ids :: integer -> e_arrays -> identifiers.
       EQNS get_ids _ [] = [].
            get_ids I (A:As) =
               if I < maxsize
               then get_ids 0 I       A []
               else get_ids 0 maxsize A (get_ids (I-maxsize) As).


            OPNS get_ids :: integer -> integer -> e_array
                         -> identifiers -> identifiers.
            EQNS get_ids I N Array Ids =
                   if I == N
                   then Ids
                   else entry_id (Array !` I) : (get_ids (I+1) N Array Ids).


{ OPNS clear_numbering :: system -> system. }
  EQNS clear_numbering S = let (Tree,S) = get_idtree S.
                           in set_idtree (clear_numbering Tree) S.


       OPNS clear_numbering :: idtree -> idtree.
       EQNS clear_numbering (ids Max Table Arrays) =
              ids 0 Table (clear_numberings Max Arrays).


            OPNS clear_numberings :: integer -> e_arrays -> e_arrays.
            EQNS clear_numberings _ [] = [].
                 clear_numberings N (A:As) =
                   if N < maxsize
                   then [clear_numbering 0 N A]
                   else clear_numbering 0 maxsize A
                        : clear_numberings (N-maxsize) As.


                 OPNS clear_numbering :: integer -> integer
                                      -> e_array -> e_array.
                 EQNS clear_numbering I N A =
                        if I == N
                        then A
                        else let A = (A,I) := 
                                     id_entry (set_nr (-1) (entry_id (A !` I))).
                             in clear_numbering (I+1) N A.


{ OPNS renumber :: identifiers -> system -> system. }
  EQNS renumber Ids S = let (Tree,S) = get_idtree S.
                            Tree = clear_numbering Tree.
                            Tree = foldl renumber Tree Ids.
                        in set_idtree Tree S.
  

       OPNS renumber :: idtree -> identifier -> idtree.
       EQNS renumber Tree Id = 
              if integer Id >= 0 then Tree
                                 else idtree (adjust Id Tree).


  OPNS adjust :: identifier -> idtree -> (integer,idtree).
  EQNS adjust Id (ids Max Tree Arrays) =
          (Max,ids (Max+1) Tree (assign Max (id_entry(set_nr Max Id)) Arrays)).


  OPNS adjust :: identifier -> system -> (integer,system).
  EQNS adjust Id S = let (Tree,S) = get_idtree S.
                       (Nr,Tree) = adjust Id Tree.
                   in (Nr,set_idtree Tree S).




  OPNS assign :: integer -> entry -> e_arrays -> e_arrays.
  EQNS assign _ E [] = [(mt maxsize,0) := E].
       assign Idx E (A:As) =
         if Idx < maxsize
         then let A = (A,Idx) := E.
              in A : As
         else A : assign (Idx-maxsize) E As.


  OPNS read_ident :: (identifier,system) -> (boolean,identifier,system).
  EQNS read_ident (Id,S) = let (IO,S) = get_io_mode S. in
         if IO == as_string
         then let (Ok,Str,S) = read("",S).
              in if Ok
                 then let (_,Id,S) = add_id Str S.
                      in (Ok,Id,S)
                 else (Ok,Id,S)
         else let (Ok,Int,S) = read(0,S).
              in if Ok
                 then let (Found,Id,S) = lookup_id Int S.
                      in (Found,Id,S)
                 else (Ok,Id,S).

       OPNS lookup_id :: integer -> system -> (boolean,identifier,system).
       EQNS lookup_id I S = let (Tree,S) = get_idtree S.
                                (Found,Id) = lookup_id I Tree.
                            in (Found,Id,set_idtree Tree S).


           OPNS lookup_id :: integer -> idtree -> (boolean,identifier).  
           EQNS lookup_id I (ids Max _ Arrays) =
                  if I < Max
                  then let (B,E) = value I no_entry Arrays.
                       in (B,entry_id E)
                  else (false,entry_id no_entry).


                OPNS value :: integer -> entry -> e_arrays -> (boolean,entry).
                EQNS value _ E [] = (false,E).
                     value Idx E [A|As] =
                       if Idx < maxsize
                       then let (Ok,V) = A ?! Idx.
                            in if Ok then (Ok,V) else (Ok,E)
                       else value (Idx-maxsize) E As.


  OPNS write_ident :: (identifier,system) -> (boolean,system). 
  EQNS write_ident (Id,S) = let (IO,S) = get_io_mode S. in
            if IO == as_string then write (string Id,S)
         elsif integer Id >= 0 then write (integer Id,S)
                               else let (Nr,S) = adjust Id S.
                                    in write (Nr,S).


  OPNS init :: system -> (identifier,system).
  EQNS init S = let (_,NoId,Tree) = add_id "" initial.
                in (NoId,set_idtree Tree S).


       OPNS initial :: idtree.
       EQNS initial = ids 0 [] [mt maxsize].

END.
