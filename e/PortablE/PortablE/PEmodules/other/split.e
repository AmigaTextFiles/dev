OPT MODULE, POINTER
MODULE 'dos', 'exec'

PRIVATE
ENUM A_BEGIN, A_SPACE, A_QUOTE, A_QUOTE2, A_END

CONST NUM="\a"+1
PUBLIC

-> Split the string "str" (which defaults to the arguments string "arg")
PROC argSplit(str=NILA:ARRAY OF CHAR) IS splitStr_(IF str THEN str ELSE arg)

PRIVATE
-> A small function to split an argument string like "arg" into a C-like array
-> of arguments, handling quoted arguments properly.  Uses recursion to collect
-> list contents, then allocate list and set contents.  Result is NIL if out of
-> memory, or an E-list of pointers to (normal) strings (this list is also NIL
-> terminated so you have a choice of how to use it).  The original string is
-> effectively destroyed and should not be used after calling this function.
PROC splitStr_(str:ARRAY OF CHAR, len=0)
  DEF tmp, s, tmp2:LIST
  tmp:=A_BEGIN
  s:=str
  WHILE tmp<>A_END
    SELECT NUM OF str[0]
    CASE 0, "\n", "\b"
      IF tmp=A_BEGIN THEN s:=NIL
      str[0]:=0
      tmp:=A_END
    CASE "\q"
      SELECT A_END OF tmp
      CASE A_BEGIN; tmp:=A_QUOTE; s++
      CASE A_QUOTE; tmp:=A_END;   str[0]:=0
      ENDSELECT
      str++
    CASE "\a"
      SELECT A_END OF tmp
      CASE A_BEGIN;  tmp:=A_QUOTE2; s++
      CASE A_QUOTE2; tmp:=A_END;    str[0]:=0
      ENDSELECT
      str++
    CASE " ", "\t"
      SELECT A_END OF tmp
      CASE A_BEGIN;  s++
      CASE A_SPACE;  tmp:=A_END; str[0]:=0
      ENDSELECT
      str++
    DEFAULT
      IF tmp=A_BEGIN THEN tmp:=A_SPACE
      str++
    ENDSELECT
  ENDWHILE
  
  IF s  -> If not the last one...
    IF FreeStack()>=1000  -> (Check stack since recursing...)
      tmp2:=splitStr_(str, len+1)  -> ... split the rest,
      IF tmp2 THEN tmp2[len]:=s   -> and add this one in
    ELSE
      tmp2:=NILL
    ENDIF
  ELSE  -> Else reached the end of arg...
    tmp2:=NewList(len+1)  -> ... allocate list and set length
    IF tmp2               -> (Extra element is for NIL termination)
      tmp2[len]:=NIL
      SetList(tmp2, len)
    ENDIF
  ENDIF
ENDPROC tmp2  -> Returns NILL if List() fails
PUBLIC
