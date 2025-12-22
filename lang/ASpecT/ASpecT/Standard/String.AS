{
 ==
 == String basic operations
 == Version 2.0 (18.12.1992, JvH)
 ==
}

SPEC String =

  Boolean +
  Integer +
  Char +
  Comparison +
 
{ == the 'string' sort (commented out because it is built-in)              }
{ == Note that 'string' is only conceptionally a list of 'char'            }
{ ==   so that there are no list-alike matching operation but ...          }

{ SORTS string ::= [char]. }


{ == ... the usual list constructors are available to construct strings    }
{ ==   as if it is a list of 'char' (i.e. "abc" == ['a','b','c']) and ...  }

  OPNS mt :: string.
  EQNS [] = "".


  OPNS EXTERN char : string :: string.
  EQNS { constructing }


{ == ... most of the opns of the standard set of listops (ListOps) which   }
{ ==   are available (some definitions are put into the local part to      }
{ ==   pervent Error from being global imported.                           }


{ == number of characters in a string                                      }

  OPNS EXTERN length :: string -> integer.
  EQNS { length [] = 0.             }
       { length (_:X) = 1+length X. }


{ == the nth character in a string S [0..(length S-1)] (error on failure)  }

  OPNS string ! integer :: char.
  EQNS { see LOCAL }


{ == string concatenation                                                  }
        
  OPNS EXTERN string ++ string :: string.
  EQNS { []    ++ Y = Y.       }
       { (A:X) ++ Y = A:(X+Y). }


{ == subtraction of string / char                                          }

  OPNS string -- string :: string.
  EQNS S -- R  = let (Ok,A,X) = hd R. in
                 if Ok then S -- A -- X
                       else S.


  OPNS string -- char :: string.
  EQNS S -- C = let (Ok,A,X) = hd S. in
                if Ok then if A == C then X
                                     else A : (X -- C)
                      else S.


{ == head and tail of a string                                             }

  OPNS hd :: string -> char.
  EQNS { see LOCAL }


  OPNS EXTERN hd :: string -> (boolean,char).
  EQNS { hd S = let (Ok,A,_) = hd S. in (Ok,A). }


  OPNS EXTERN hd :: string -> (boolean,char,string).
  EQNS { hd []    = (false,' ',[]). }
       { hd (A:X) = (true,A,X).     }


  OPNS tl :: string -> string.
  EQNS { see LOCAL }


{ == but-last and last (error on failure)                                  }

  OPNS init :: string -> string.
  EQNS { see LOCAL }


  OPNS last :: string -> char.
  EQNS { see LOCAL }


{ == take/drop first n chars if possible                                   }

  OPNS take :: integer -> string -> string.
  EQNS take N S = let (Ok,Take,_) = split N S. in
         if Ok then Take else "".


  OPNS drop :: integer -> string -> string.
  EQNS drop N S = let (Ok,_,Drop) = split N S. in
         if Ok then Drop else "".


{ == take/drop while a predicate succeeds as long its possible             }

  OPNS takewhile :: (char -> boolean) -> string -> string.
  EQNS takewhile P S = let (Ok,A,X) = hd S. in
         if Ok then if P A then A : (takewhile P X)
                           else ""
               else S.


  OPNS dropwhile :: (char -> boolean) -> string -> string.
  EQNS dropwhile P S = let (Ok,A,X) = hd S. in
         if Ok then if P A then dropwhile P X
                           else S
               else S.


{ == remove all double chars                                               }

  OPNS mkset :: string -> string.
  EQNS mkset S = let (Ok,A,X) = hd S. in
                 if Ok then if member X A then mkset (A : (X -- A))
                                          else A : mkset X
                       else S.


{ == reverse a string                                                      }

  OPNS reverse :: string -> string.
  EQNS { see LOCAL }


{ == append a char to a string                                             }

  OPNS postfix :: char -> string -> string.
  EQNS postfix C S = S ++ [C].


{ == repeat a char n times                                                 }

  OPNS rep :: integer -> char -> string.
  EQNS rep N C = if N <= 0 then [] else C : rep (N-1) C.


{ == is a char contained in a string                                       }

  OPNS member :: string -> char -> boolean.
  EQNS member S B = let (Ok,A,X) = hd S. in
         Ok && (A==B || member X B).


{ == extension of 'member' to string                                       }

  OPNS member :: string -> string -> boolean.
  EQNS member Y S = let (Ok,A,X) = hd S. in
         if Ok then member Y A && member Y X
               else true.


{ == choose one of the chars of a string via a selection function          }
{ == which determines by its result whether the first (true) or            }
{ == the second (false) char is 'more correct'                             }

  OPNS select :: (char -> char -> boolean) -> string -> char.
  EQNS { see LOCAL }


{ == sort merge-sorts a string with a given relation                       }
{ == merge applied to two 'sorted' strings merges them to produce a single }
{ == sorted result.                                                        }

  OPNS sort :: (char -> char -> boolean) -> string -> string.
  EQNS sort F S = let N = length S.
                      N2 = N / 2.
                  in if N <= 1
                     then S
                     else merge F (sort F (take N2 S)) (sort F (drop N2 S)).


  OPNS merge :: (char -> char -> boolean) -> string -> string -> string.
  EQNS merge F S1 S2 =
          if S1 == ""
          then S2
          else if S2 == ""
               then S1
               else let (_,A,X) = hd S1.
                        (_,B,Y) = hd S2.
                    in if F A B then A : merge F X S2
                                else B : merge F S1 Y.


{ == puts a char in front of a string if its not already contained         }

  OPNS insert :: char -> string -> string.
  EQNS insert A X = if member X A then X else A:X.


{ == extension of 'insert' to a string                                     }

  OPNS union :: string -> string -> string.
  EQNS union S Y = let (Ok,A,X) = hd S. in
                   if Ok then if member Y A then   union X Y 
                                            else A:union X Y
                         else Y.


{ == return all chars being in the first and in the second string          }

  OPNS intersect :: string -> string -> string.
  EQNS intersect S Y = let (Ok,A,X) = hd S. in
                       if Ok then if member Y A then A:intersect X Y
                                                else intersect X Y
                             else Y.


{ == insert a character before the nth element in a string                 }

  OPNS insert_before :: string -> (integer,char) -> string.
  EQNS { see LOCAL }


{ == delete the nth character in a string                                  }

  OPNS delete :: string -> integer -> string.
  EQNS { see LOCAL }


{ == evaluate the first position (index) of a given char in a string       }
{ == returns -1 if the char could not be found                             }

  OPNS idx :: string -> char -> integer.
  EQNS idx S C = let (Ok,A,X) = hd S. in
                 if Ok then if A == C then 0
                                      elsif idx X C < 0 then -1
                                                        else 1+idx X C
                       else -1.


{ == test if one string (S2) is the head of another one (S1)               }

  OPNS head_of :: string -> string -> boolean.
  EQNS head_of S1 S2 =
         let N1 = length S1.
             N2 = length S2.
         in if N2 > N1 then false
                       else let (_,S1,_) = split N2 S1.
                            in S2==S1.


{ == replace head of one string (S1) by another one (S2)                   }
{ ==  the resulting string remains of the same length                      }

  OPNS replace_head_of :: string -> string -> string.
  EQNS replace_head_of S1 S2 =
         let N1 = length S1.
             N2 = length S2.
         in if N2 >= N1 then let (_,S2,_) = split N1 S2. in S2
                        else let (_,_,S1) = split N2 S1. in S2++S1.


{ == exchange nth char of a string                                         }

  OPNS exchange :: char -> integer -> string -> string.
  EQNS { see LOCAL }


  OPNS (string,integer) := char :: string.
  EQNS (S,N) := C = exchange C N S.


{ == updates/exchanges the first suitable char of a string using a select  }
{ == and map function                                                      }

  OPNS exchange :: (char -> (boolean,char)) -> string -> string.


{ == test if a string is just one char                                     }

  OPNS single :: string -> boolean.
  EQNS single S = length S == 1.


{ == test if a string is empty                                             }

  OPNS ismt :: string -> boolean.
  EQNS ismt = (==) "".


{ == split a string in two parts with first part containing n chars        }

  OPNS split :: integer -> string -> (string,string).
  EQNS split N S = let (Ok,S1,S2) = split N S. in
         if Ok then (S1,S2)
               else (S,"").


  OPNS EXTERN split :: integer -> string -> (boolean,string,string).
  EQNS { split N []    = (N==0,[],[]).             }
       { split N (A:X) =                           }
       {   if N<=0                                 }
       {   then (N==0,[],X)                        }
       {   else let (Ok,Hd,Tl) = split (N-1) X. in }
       {        (Ok,A:Hd,Tl).                      }


{ == same as above but use a predicate to find the split position          }

  OPNS split :: (char -> boolean) -> string -> (string,string).
  EQNS split F S = let (Ok,A,X) = hd S. in
                    if Ok
                    then if F A then let (X1,X2) = split F X. in
                                     (A:X1,X2)
                                else ("",A:X)
                    else ("","").


{ == divide the chars of a string into two disjunct strings                }

  OPNS divide :: (char -> boolean) -> string -> (string,string).
  EQNS divide F S = let (Ok,A,X) = hd S. in
                    if Ok
                    then let (X1,X2) = divide F X. in
                         if F A then (A:X1,X2)
                                else (X1,A:X2)
                    else ("","").


{ == inverse version of ':'                                                }

  OPNS string | char :: string.
  EQNS S | C = C : S.


{ == take (filter) or eliminate (remove) elements using a predicate        }

  OPNS filter :: (char -> boolean) -> string -> string.
  EQNS filter P S = let (Ok,A,X) = hd S. in
                    if Ok
                    then if P A then A:filter P X else filter P X
                    else "".


  OPNS remove :: (char -> boolean) -> string -> string.
  EQNS remove P S = let (Ok,A,X) = hd S. in
                    if Ok
                    then if P A then remove P X else A:remove P X
                    else "".


{ == does a predicate hold for all (forall) or for some (exist) char?      }

  OPNS forall :: (char -> boolean) -> string -> boolean.
  EQNS forall P S = let (Ok,A,X) = hd S. in
                    if Ok
                    then P A && forall P X
                    else true.


  OPNS exist :: (char -> boolean) -> string -> boolean.
  EQNS exist P S = let (Ok,A,X) = hd S. in
                   if Ok
                   then P A || exist P X
                   else false.



{ == the comparisons between strings based on lexical order and ...       }

  OPNS string <  string,
       string <= string,
       string >  string,
       string >= string :: boolean.
  FORALL S1, S2 :: string.
  EQNS S1 <  S2 = compare S1 S2 == less.
       S1 <= S2 = (compare S1 S2 == less) || (compare S1 S2 == eq).
       S1 >  S2 = compare S1 S2 == greater.
       S1 >= S2 = (compare S1 S2 == greater) || (compare S1 S2 == eq).


{ == ... the operation all these comparisons are based on                 }

  OPNS EXTERN compare :: string -> string -> comparison.
  EQNS { compare []    []    =  eq.                                  }
       { compare (_:_) []    =  greater.                             }
       { compare []    (_:_) =  less.                                }
       { compare (A:X) (B:Y) =                                       }
       {   if A<B then less elsif A>B then greater else compare X Y. }


{ == the conversion from char to string                                   }

  OPNS char_string :: char -> string.
  EQNS char_string C = C:"".


{ == a simple hashing on strings                                          }

  OPNS EXTERN hash :: string -> integer.
  EQNS { hash [] = 0.                          }
       { hash (A:X) = char_integer C + hash S. }



 LOCAL

  Error +


{ OPNS string ! integer :: char. }
  EQNS S ! N = let (Ok,A,X) = hd S. in
         if Ok then if N==0 then A else X ! (N - 1)
               else error "subscript out of range".


{ OPNS hd :: string -> char. }
  EQNS hd S = let (Ok,Hd) = hd S. in
         if Ok then Hd else error "hd \"\"".


{ OPNS tl :: string -> string. }
  EQNS tl S = let (Ok,_,X) = hd S. in
         if Ok then X else error "tl \"\"".


{ OPNS init :: string -> string. }
  EQNS init S = let (Ok,Init,_) = split(length S-1) S. in
         if Ok then Init else error "init \"\"".


{ OPNS last :: string -> char. }
  EQNS last S = let (Ok,_,Last) = split(length S-1) S. in
         if Ok then let (_,C) = hd Last. in C else error "last \"\"".


{ OPNS reverse :: string -> string. }
  EQNS reverse = reverse "".


  OPNS reverse :: string -> string -> string.
  EQNS reverse Y S = let (Ok,A,X) = hd S. in
                     if Ok then reverse (A:Y) X else Y.


{ OPNS select :: (char -> char -> boolean) -> string -> char. }
  EQNS select F S = let (Ok,A,X) = hd S.
                    in if Ok then select F A X
                             else error "incorrect use of select".


  OPNS select :: (char -> char -> boolean) -> char -> string -> char.
  EQNS select F C S = let (Ok,A,X) = hd S.
                      in if Ok then select F (if F C A then C else A) X
                               else C.


{ OPNS insert_before :: string -> (integer,char) -> string. }
  EQNS insert_before S (N,D) =
         let (Ok,A,X) = hd S. in
         if Ok
         then if N <  0 then error "wrong index in insert_before" 
           elsif N == 0 then D:(A:X)
                        else A:insert_before X (N-1,D)
         elsif   N == 0 then [D]
                        else error "wrong index in insert_before".


{ OPNS delete :: string -> integer -> string. }
  EQNS delete S N =
         let (Ok,A,X) = hd S. in
         if Ok then if N <  0 then error "wrong index in delete"
                 elsif N == 0 then X
                              else A : delete X (N-1)
         else "".


{ OPNS exchange :: string -> char -> integer -> string. }
  EQNS exchange D N S = let (Ok,A,X) = hd S. in
                        if Ok then if N == 0 then D : X
                                             else A : exchange D N X
                              else error "wrong index in exchange".


{ OPNS exchange :: (char -> (boolean,char)) -> string -> string. }
  EQNS exchange F S = let (Ok,A,X) = hd S. in
                      if Ok then let (Found,B) = F A. in
                                 if Found then B:X else A:exchange F X
                            else S.


END.
