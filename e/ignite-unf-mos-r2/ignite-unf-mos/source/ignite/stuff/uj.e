OPT POWERPC, PREPROCESS


-> arg: single lowercase character a-z followed by :INT/FLT
-> local: $ followed by single lowercase character $a-z followed by :INT/FLT
-> keywords: all uppercase
->    FUNC/LOC/IF/ELSE/ELSEIF/ENDIF/WHILE/ENDWHILE/LOOP/ENDLOOP/REPEAT/UNTIL
->    SELECT/CASE/DEFAULT
-> comparison: < > <> <= >= =
-> comment: # this line is commented out

ENUM IT_VAR=128,
     KEY_FUNC,
     KEY_FLT,
     KEY_INT,
     KEY_RET,
     KEY_IF,
     KEY_ELSEIF,
     KEY_ELSE,
     KEY_ENDIF,
     KEY_WHILE,
     KEY_ENDWHILE

OBJECT item
   char:CHAR
   type:CHAR
   info:PTR TO var
ENDOBJECT

OBJECT var
   saveofs
   rtype:CHAR -> 0:Rx, 1:Fx
   rnum:CHAR
ENDOBJECT

PROC compileSource(ascii, memory:PTR TO LONG)
   DEF args[26]:ARRAY OF LONG, locs[26]:ARRAY OF LONG, a
   DEF c, linenum=1, linebuf[256]:ARRAY OF item, ipos=0
   DEF t, openbrackdepth=0

   -> clear table
   FOR a := 0 TO 25 DO args[a] := NIL
   FOR a := 0 TO 25 DO locs[a] := NIL

   WHILE (c := ascii[])
      SELECT 128 OF c
      CASE " ", "\t"
         ascii++
      CASE 10
         linenum++
         IF (ipos>0) AND (openbrackdepth=0)
            t := linebuf[ipos-1].char
            SELECT 128 OF t
            CASE "+", "-", "/", "*", ","
            DEFAULT
               linebuf[ipos++].char := 10
               memory := compileLine(linebuf, memory)
               ipos := 0
            ENDSELECT
         ENDIF
         ascii++
      CASE "#"
         t := InStr(ascii, '\n')
         ascii := ascii + IF t = -1 THEN StrLen(ascii) ELSE t
      CASE "("
         linebuf[ipos++].char := "("
         openbackdepth++
         ascii++
      CASE ")"
         linebuf[ipos++].char := ")"
         IF openbrackdepth < 1 THEN RETURN ER_UNMATCHEDBRACK, linenum
         openbrackdepth--
         ascii++
      CASE "A" TO "Z"
         t := getLabelLen(ascii)
         StrCopy(str, ascii, t)
         a := getKey(str)
         IF a = NIL THEN RETURN ER_UNKNOWNKEY, linenum
         linebuf[ipos++].char := a
         ascii := ascii + t
      CASE "a" TO "z"
         linebuf[ipos++].char := c
      CASE "@"
         ascii++
         c := ascii[]++
         IF c < "a" THEN RETURN ER_VARLEX, linenum
         IF c > "z" THEN RETURN ER_VARLEX, linenum
         v := args[c-97]
         IF v = NIL THEN RETURN ER_UNKOWNARG, linenum
         linebuf[ipos].char := IT_VAR
         linebuf[ipos++].info := v
      CASE "&"
         ascii++
         c := ascii[]++
         IF c < "a" THEN RETURN ER_VARLEX, linenum
         IF c > "z" THEN RETURN ER_VARLEX, linenum
         v := locs[c-97]
         IF v = NIL THEN RETURN ER_UNKOWNLOC, linenum
         linebuf[ipos].char := IT_VAR
         linebuf[ipos++].info := v
      DEFAULT
      ENDSELECT
   ENDWHILE



ENDPROC memory

