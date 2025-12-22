-> module lex très simple

OPT MODULE

MODULE 'tools/ctype'

DEF begin, cur, end, free, line, comment            -> privé

EXPORT PROC lex_init(start,size,freeform=FALSE,onelinecomment=-2)
  end:=(begin:=cur:=start)+size; free:=freeform; line:=1
  comment:=onelinecomment
ENDPROC

EXPORT ENUM LEX_EOF=256, LEX_EOL, LEX_INTEGER, LEX_IDENT,
            LEX_STRINGA, LEX_STRINGQ

EXPORT PROC lex()
  DEF a,b,c
  LOOP
    SELECT 256 OF c:=cur[]++
      CASE "\n"
        IF cur>end THEN RETURN (cur:=end) BUT LEX_EOF
        line++
        IF free=FALSE THEN RETURN LEX_EOL
      CASE " ", "\t"
        /* les espaces, ne font rien */
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
        a:=cur
        WHILE (a[]<>c) AND (a[]<>"\n") DO a++
        IF a[]="\n" THEN RETURN c
        b:=cur
        cur:=a+1
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
ENDPROC

EXPORT PROC lex_curline() IS line
EXPORT PROC lex_current() IS cur

EXPORT PROC lex_getline(s)
  DEF b,e
  b:=e:=cur
  WHILE b[]--<>"\n" DO NOP
  b++
  WHILE e[]<>"\n" DO e++
  StrCopy(s,b,e-b)
ENDPROC cur-b
