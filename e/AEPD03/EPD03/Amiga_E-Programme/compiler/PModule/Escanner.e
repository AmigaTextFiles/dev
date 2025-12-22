

/*  Der Mini-Compiler.
    Umgesetzt aus dem Sonderheft Amiga-Plus 1/93 in AMIGA_E.
*/

/* Symbole */
ENUM CPROGRAM=0, CVAR, CBEGIN, CEND, CWHILE, CDO, CPRINT, CCOMMA, CEQUAL,
     CPLUS, CMINUS, CIDENT, CCONST, CEOF

CONST MAXIDLEN = 79


DEF source,    /* Quelltextdatei                         */
    char=32,      /* zuletzt gelesenes Zeichen (0X bei EOF) */
    sym        /* das letzte Symbol (program, var, etc.) */
DEF identifier[MAXIDLEN]: STRING,  /* der Bezeichner bei sym=ident */
    constant   /* die Konstante bei sym=const            */

PROC getchar()
     char := FgetC(source)
     IF char = -1 THEN char := 0
ENDPROC

PROC getSym()
DEF i=0

  WHILE (char>0) AND (char<=" ") DO getchar()     /* Space, LF, etc. */
  IF (char > 96) AND (char < 123) THEN char := char - 32

  IF (char > 64) AND (char < 91)                 /* Bezeichner oder Schlüsselwort */
     REPEAT
        identifier[i] := char
        i++
        getchar()
        IF (char > 96) AND (char < 123) THEN char := char - 32
     UNTIL (i=MAXIDLEN) OR (char<"A") OR (char>"Z")
     identifier[i] := 0
     IF     StrCmp(identifier,'PROGRAM',ALL)
            sym := CPROGRAM
     ELSEIF StrCmp(identifier,'VAR'    ,ALL)
            sym := CVAR
     ELSEIF StrCmp(identifier,'BEGIN'  ,ALL)
            sym := CBEGIN
     ELSEIF StrCmp(identifier,'END'    ,ALL)
            sym := CEND
     ELSEIF StrCmp(identifier,'WHILE'  ,ALL)
            sym := CWHILE
     ELSEIF StrCmp(identifier,'DO'     ,ALL)
            sym := CDO
     ELSEIF StrCmp(identifier,'PRINT'  ,ALL)
            sym := CPRINT
     ELSE
        sym := CIDENT          /* Kein Schlüsselwort, also Bezeichner */
     ENDIF

  ELSEIF (char >= "0") AND (char <= "9")
      constant := 0;
      REPEAT
        constant := 10*constant + (char-"0"); getchar()
      UNTIL (char<"0") OR (char>"9")
      sym := CCONST

  ELSE      /* Sonderzeichen */
    SELECT char
    CASE "="
        sym := CEQUAL
        getchar()
    CASE ","
        sym := CCOMMA
        getchar()
    CASE "+"
        sym := CPLUS
        getchar()
    CASE "-"
        sym := CMINUS
        getchar()
    CASE 0
        sym := CEOF
    DEFAULT
        error('Unerwartetes Zeichen!')
    ENDSELECT
  ENDIF
ENDPROC /* GetSym */
