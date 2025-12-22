-> very simple lex module

OPT MODULE
OPT POINTER

MODULE 'tools/ctype'

PRIVATE
DEF begin:PTR TO CHAR, cur:PTR TO CHAR, end:PTR TO CHAR, free:BOOL, line, comment            -> private
PUBLIC

PROC lex_init(start:PTR TO CHAR,size,freeform=FALSE:BOOL,onelinecomment=-2)
  end:=(begin:=cur:=start)+size; free:=freeform; line:=1
  comment:=onelinecomment
ENDPROC

ENUM LEX_EOF=256, LEX_EOL, LEX_INTEGER, LEX_IDENT,
            LEX_STRINGA, LEX_STRINGQ

PROC lex()
  DEF ret, value
  DEF a,b,c:CHAR
  DEF p:PTR TO CHAR
  LOOP
    SELECT 256 OF c:=cur[]++
      CASE "\n"
        IF cur>end THEN RETURN (cur:=end) BUT LEX_EOF
        line++
        IF free=FALSE THEN RETURN LEX_EOL
      CASE " ", "\t"
        /* whitespace, do nothing */
      CASE "0" TO "9", "$", "%", "-"
        a,b:=Val(cur-1)
        IF b=0 THEN RETURN c
        cur:=cur+b-1
        RETURN LEX_INTEGER, a
      CASE "a" TO "z", "A" TO "Z", "_"
        a:=cur; c:=cur[]
        WHILE isalnum(c) OR (c="_") DO cur++ BUT c:=cur[]
        RETURN LEX_IDENT,a
      CASE "\q", "\a"
        p:=cur
        WHILE (p[]<>c) AND (p[]<>"\n") DO p++
        IF p[]="\n" THEN RETURN c
        b:=cur
        cur:=p+1
        RETURN IF c="\a" THEN LEX_STRINGQ ELSE LEX_STRINGA, b
      DEFAULT
        IF c=comment
          WHILE cur[]++<>"\n"
          ENDWHILE
          line++
        ELSE
          RETURN c
        ENDIF
    ENDSELECT
  ENDLOOP
ENDPROC ret, value

PROC lex_curline() IS line
PROC lex_current() IS cur

PROC lex_getline(s:STRING)
  DEF b:PTR TO CHAR,e:PTR TO CHAR
  b:=e:=cur
  WHILE b[]--<>"\n" DO EMPTY
  b++
  WHILE e[]<>"\n" DO e++
  StrCopy(s,b,e-b)
ENDPROC cur-b
