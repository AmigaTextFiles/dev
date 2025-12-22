OPT MODULE

EXPORT PROC findChar(str:PTR TO CHAR, char)
   WHILE str[] <> char DO str++
ENDPROC str


/* special! :) letar reda på nästa rad med nåt */
/* intressant på :) */
/* skippar rader som _börjar_ med ; */
EXPORT PROC newLineS(ptr:PTR TO CHAR)
   WHILE (ptr[] <> 10) DO ptr++
   ptr++
   IF (ptr[] = 10) THEN ptr:=newLineS(ptr)
   IF (ptr[] = ";") THEN ptr:=newLineS(ptr)
ENDPROC ptr

/* kopierar fstr till buf, slutar när den hittar char */
/* avslutar med nollbyte i buf */
EXPORT PROC strCopy2Char(fstr:PTR TO CHAR, buf:PTR TO CHAR, char)
   WHILE (fstr[] <> char) AND (fstr[] <> NIL) DO buf[]++ := fstr[]++
   buf[] := 0
ENDPROC buf

/* Byter ut ochar mot nchar i str */
EXPORT PROC strRepChar(str:PTR TO CHAR, ochar, nchar)
   WHILE str[] <> NIL
      IF str[] = ochar THEN str[] := nchar
      str ++
   ENDWHILE
ENDPROC


