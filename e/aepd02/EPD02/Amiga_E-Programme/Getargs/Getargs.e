/*
        GetArgs
        -------

        Zwei Prozeduren, um die Argumente des CLI auch unter
        Kick 1.2 oder 1.3 zurückgeben zu können.

*/

PROC main()
DEF i,j,k, str1[50]: STRING
  i := getargs(0,str1)  /* Aufruf um festzustellen, wieviel Argumente
                           vorhanden sind. */
  IF i = -1             /* -1 ---> KEINE! */
     WriteF('No Args!\n')
  ELSE                  /* <> 0 die Anzahl der Argumente. */
     WriteF('Argumente: \d\n',i)
     FOR j := 1 TO i
        k := getargs(j,str1)    /* In dieser Schleife wird jedes Argument
                                   in den String str1 gelesen und an-
                                   schließend ausgegeben. */

        WriteF('\d. Argument = \s.\n',j,str1)
     ENDFOR
  ENDIF
ENDPROC

PROC getargs(nummer, str : PTR TO LONG)
/* Kopiert das Argument nummer in den String str. Der Rückgabewert
   ist bei Aufruf nummer = 0 die Anzahl der Argumente. Sonst enthält
   der Rückgabewert die Nummer des Arguments oder -1 (wenn kein
   Argument vorhanden gewesen ist).  */
DEF tt=0, tt1=0

   IF nummer = 0 THEN RETURN searchargs(0) /* Wieviele haben wir denn? */
   tt := searchargs(nummer) /* welche Position hat dieses Argument? */
   tt1 := searchargs(nummer+1) /* Und welche das nachfolgende? */
   tt1--                       /* Korrigieren !!! */
   MidStr(str, arg, tt, tt1-tt) /* Und jetzt heraus damit!!! */
   RETURN nummer                /* Dies wars. */
ENDPROC

PROC searchargs(com)
/* Liefert bei com=0 die Anzahl der Argumente zurück oder
   bei com = 1 die Position des ersten Buchstaben des com.ten Arguments.
   Ist der Returnwert = -1 dann gab es keine Argumente. */
DEF tt=0, tt1=0, tt2=1

    IF (tt:=StrLen(arg)) = 0 THEN RETURN -1

    IF com = 0
        FOR tt1 := 0 TO tt
            IF arg[tt1] = " " THEN tt2++ /* arg als String behandeln. */
        ENDFOR
        RETURN tt2
    ELSE
        FOR tt1 := 0 TO tt
            IF tt2 = com THEN RETURN tt1
            IF arg[tt1] = " "   /* Wo sind die Blanks? */
               tt2 ++
               IF tt2 = com
                  tt1 ++
                  RETURN tt1
               ENDIF
            ENDIF
        ENDFOR
        RETURN tt1
    ENDIF
ENDPROC
