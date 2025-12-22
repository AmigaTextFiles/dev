{
 ==
 == Array (mapping of an integer domain to a (formal) codomain)
 ==   (the order of the integer domain elements is as usual)
 ==
 == BUT this one has no upper and lower limit in the domain as
 ==   array of Array.AS; it is defined at ALL points (at least with
 ==   errorval)
 ==
 == Version 1.0 (6.1.1993, JvH)
 ==
}

SPEC XArray =

 FORMAL

{ == only the codomain sort is formal, the domain is integer               }

  SORTS codom.


{ == some suitable error value                                             }

  OPNS errorval :: codom.


 GLOBAL

  Boolean +
  Integer +


{ == the xarray sort                                                       }

{ SORTS xarray. (commented out due to an ASpecT bug) }


{ == an implementation dependent limit (maximal size of an xarray)         }

  OPNS maxsize :: integer.
  EQNS maxsize = maxint.


{ == create an xarray                                                      } 

  OPNS mt :: xarray.


{ == (re)define xarray at point; fails on exceeding domain ranges          }

  OPNS (integer,codom) : xarray :: xarray.
  EQNS (D,C) : (M::xarray) = (M,D) := C.


  OPNS (xarray,integer) := codom :: xarray.


{ == cardinality of the domain (trivially the maximal integer)             }

  OPNS size :: xarray -> integer.
  EQNS size (_::xarray) = maxint.


{ == get the co-domain at point (all points are defined)                   }

  OPNS xarray ! integer :: codom.
  EQNS (A::xarray) ! I = codom (A ?! I).


{ == as above (for xarray)                                                 }

  OPNS xarray !` integer :: codom.
  EQNS (A::xarray) !` I = codom (A ?! I).


{ == as above but does not fail but delivers errorval and definedness      }
{ == the later is always true                                              }

  OPNS xarray ?! integer :: (boolean,codom).


{ == lifting of (:=) to xarrays                                            }

  OPNS update :: xarray -> xarray -> xarray.
  EQNS update _ XA = XA :: xarray.


{ == undefine xarray at point (here: set co-domain on errorval)            }

  OPNS xarray -- integer :: xarray.
  EQNS (A::xarray) -- I = (A,I) := errorval.


{ == definedness: is an xarray defined at a point (here: always true)      }

  OPNS xarray ? integer :: boolean.
  EQNS (_::xarray) ? _ = true.


{ == test if an xarray is single-elemented (always false for xarray)       }

  OPNS single :: xarray -> boolean.
  EQNS single (_::xarray) = false.


{ == test if an xarray is empty (always false for xarray)                  }

  OPNS ismt :: xarray -> boolean.
  EQNS ismt (_::xarray) = false.


{ ======================================================================== }

  IMPORTS
   Array ACTUAL SORTS codom = codom.
                      array = xa_array.
                OPNS  errorval = errorval.
                      maxsize = xa_maxsize.
         END +

  SORTS xarray   ::= xa_mt | xa_bin xa_token xarray xarray.
        xa_token ::= xa_tok integer integer xa_array.

 LOCAL


{ OPNS mt :: xarray. }
  EQNS mt = xa_mt.


{ OPNS (xarray,integer) := codom :: xarray. }
  EQNS (xa_mt,I) := C =
         let Lower = if I < 0
                     then I / xa_maxsize * xa_maxsize - xa_maxsize
                     else I / xa_maxsize * xa_maxsize.
             Upper = Lower + xa_maxsize - 1.
             I     = if I < 0
                     then abs I + Lower
                     else I - Lower.
             New   = mt xa_maxsize.
         in xa_bin (xa_tok Lower Upper ((I,C):New)) xa_mt xa_mt.
       (xa_bin (xa_tok Low High Arr) L R,I) := C =
          if I > High
          then xa_bin (xa_tok Low High Arr) L ((R,I) := C)
          elsif I < Low
          then xa_bin (xa_tok Low High Arr) ((L,I) := C) R
          else let I = if I < 0
                       then abs I + Low
                       else I - Low.
               in xa_bin (xa_tok Low High ((I,C):Arr)) L R.


{ OPNS xarray ?! integer :: (boolean,codom). }
  EQNS xa_mt ?! _ = (true,errorval).
       xa_bin (xa_tok Low High Arr) L R ?! I =
          if I > High then R ?! I
       elsif I < Low  then L ?! I
                      else let I = if I < 0
                                   then abs I + Low
                                   else I - Low.
                           in Arr ?! I.


END.
