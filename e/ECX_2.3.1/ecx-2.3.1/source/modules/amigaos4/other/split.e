OPT MODULE, AMIGAOS4

ENUM A_BEGIN, A_SPACE, A_QUOTE, A_QUOTE2, A_END

CONST NUM="\a"+1

-> Split the string "str" (which defaults to the arguments string "arg")
EXPORT PROC argSplit(str=NIL) IS splitStr_(IF str THEN str ELSE arg)

-> A small function to split an argument string like "arg" into a C-like array
-> of arguments, handling quoted arguments properly.  Uses recursion to collect
-> list contents, then allocate list and set contents.  Result is NIL if out of
-> memory, or an E-list of pointers to (normal) strings (this list is also NIL
-> terminated so you have a choice of how to use it).  The original string is
-> effectively destroyed and should not be used after calling this function.
PROC splitStr_(str, len=0)
  DEF tmp=A_BEGIN:PTR TO LONG, s  -> Reuse tmp to save stack space
  s:=str
  WHILE tmp<>A_END
    SELECT NUM OF str[]
    CASE 0, "\n", "\b"
      IF tmp=A_BEGIN THEN s:=NIL
      str[]:=0
      tmp:=A_END
    CASE "\q"
      SELECT A_END OF tmp
      CASE A_BEGIN; tmp:=A_QUOTE; s++
      CASE A_QUOTE; tmp:=A_END;   str[]:=0
      ENDSELECT
      str++
    CASE "\a"
      SELECT A_END OF tmp
      CASE A_BEGIN;  tmp:=A_QUOTE2; s++
      CASE A_QUOTE2; tmp:=A_END;    str[]:=0
      ENDSELECT
      str++
    CASE " ", "\t"
      SELECT A_END OF tmp
      CASE A_BEGIN;  s++
      CASE A_SPACE;  tmp:=A_END; str[]:=0
      ENDSELECT
      str++
    DEFAULT
      IF tmp=A_BEGIN THEN tmp:=A_SPACE
      str++
    ENDSELECT
  ENDWHILE
  IF s  -> If not the last one...
    IF FreeStack()>=1000  -> (Check stack since recursing...)
      tmp:=splitStr_(str, len+1)  -> ... split the rest,
      IF tmp THEN tmp[len]:=s   -> and add this one in
    ELSE
      tmp:=NIL
    ENDIF
  ELSE  -> Else reached the end of arg...
    tmp:=List(len+1)  -> ... allocate list and set length
    IF tmp            -> (Extra element is for NIL termination)
      tmp[len]:=NIL
      SetList(tmp, len)
    ENDIF
  ENDIF
ENDPROC tmp  -> Returns NIL if List() fails