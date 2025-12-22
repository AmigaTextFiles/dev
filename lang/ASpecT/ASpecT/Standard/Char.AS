{
 ==
 == Character basic operations
 == Version 2.0 (12.11.1992, JvH)
 ==
}

SPEC Char =

  Boolean +
  Integer +
  Comparison +

{ == the comparisions between characters performed on the ASCII-values     }

  OPNS EXTERN char <  char :: boolean.
       EXTERN char <= char :: boolean.
       EXTERN char >  char :: boolean.
       EXTERN char >= char :: boolean.


  OPNS compare :: char -> char -> comparison.
  FORALL C1, C2 :: char.
  EQNS compare C1 C2 =
         if C1 < C2 then less elsif C1 > C2 then greater else eq.


{ == conversion from character to integer (ASCII-value)                    }

  OPNS EXTERN char_integer:: char -> integer.


{ == as above (Miranda style)                                              }

  OPNS code :: char -> integer.
  EQNS code = char_integer.


{ == conversion from integer to character (ASCII-value, abs, modulo 255)   }

  OPNS  EXTERN integer_char:: integer -> char.


{ == as above (Miranda style)                                              }

  OPNS decode :: integer -> char.
  EQNS decode = integer_char.


{ == is a char a digit?                                                    }

  OPNS digit :: char -> boolean.
  EQNS digit C = (C >= '0') && (C <= '9').


{ == is a char a letter?                                                   }

  OPNS letter :: char -> boolean.
  EQNS letter C = ((C >= 'a') && (C <= 'z')) || ((C >= 'A') && (C <= 'Z')).


{ == convert upper-case letters to lower-case and vice versa               }

  OPNS upper_lower :: char -> char.
  EQNS upper_lower C =
         if (C >= 'A') && (C <= 'Z')
         then decode(code C - code 'A' + code 'a')
         else C.


  OPNS lower_upper :: char -> char.
  EQNS lower_upper C =
         if (C >= 'a') && (C <= 'z')
         then decode(code C - code 'a' + code 'A')
         else C.


END.
