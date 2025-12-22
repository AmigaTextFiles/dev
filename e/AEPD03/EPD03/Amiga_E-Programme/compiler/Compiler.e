



DEF labels=0







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




MODULE 'dos/dos'

OPT OSVERSION=37

DEF code


PROC chk(symb, msg)
     IF symb=sym THEN getSym() ELSE error(msg)
ENDPROC

PROC varDeclaration()
/* VarDeclaration -> VAR Identifier {"," Identifier} . */

  REPEAT
    getSym()
    IF sym<>CIDENT THEN error('Bezeichner in erwartet!')
    codeDCL(identifier)
    getSym()
  UNTIL sym <>CCOMMA

ENDPROC /* VarDeclaration */

PROC factor()
/* factor         -> Identifier | Constant . */

  SELECT sym

  CASE CIDENT
       codeMOVEvarD0 (identifier)
       getSym()

  CASE CCONST
       codeMOVEconstD0(constant)
       getSym()

  DEFAULT
       error('Faktor erwartet')
  ENDSELECT
ENDPROC /* factor */

PROC expression()
/* expression     -> [ "+" | "-" ] factor { ( "+" | "-" ) factor } . */
DEF neg = FALSE   /* muß D0 negiert werden? */

  IF (sym = CPLUS) OR (sym = CMINUS)
     IF sym = CMINUS THEN neg := TRUE ELSE neg := FALSE
     getSym()
  ENDIF
  factor()
  IF neg THEN codeNEGD0()
  WHILE (sym = CPLUS) OR (sym = CMINUS)
     IF sym = CMINUS THEN neg := TRUE ELSE neg := FALSE
     getSym()
     codeMOVED0D1()
     factor()
     IF neg THEN codeNEGD0()
     codeADDD1D0()
  ENDWHILE
ENDPROC /* expression */

PROC statement()
/* statement      -> Assignment | While | Print .            */
/* Assignment     -> Identifer "=" expression .              */
/* While          -> WHILE expression DO { statement } END . */
/* Print          -> PRINT expression                        */

DEF varname[MAXIDLEN]:STRING             /* Ziel einer Zuweisung */
DEF start,end                            /* Labels bei einer Schleife */

  SELECT sym
  CASE CIDENT
       StrCopy(varname,identifier,ALL); getSym()  /* Zuweisung */
       chk(CEQUAL,' "=" erwartet!')
       expression()
       codeMOVED0var(varname)
  CASE CWHILE
       getSym()                                    /* Schleife */
       start := codeGetLabel(); end := codeGetLabel()
       codeLabel(start)
       expression()
       chk(CDO,'DO erwartet!')
       codeTSTD0(); codeBLE(end)
       WHILE sym <> CEND DO statement()
       chk(CEND,'END erwartet!')
       codeBRA(start); codeLabel(end);
  CASE CPRINT
       getSym(); expression(); codeprintD0()           /* Ausgabe */
  DEFAULT
       error('statement erwartet!')
  ENDSELECT
ENDPROC /* statement */

PROC program()
/* Program -> PROGRAM [ VarDeclaration ] BEGIN { statement } END. */
DEF start

  getSym(); chk(CPROGRAM,'PROGRAM erwartet!')
  start := codeGetLabel(); codeBRA(start)
  IF sym=CVAR THEN varDeclaration()
  chk(CBEGIN,'BEGIN erwartet!')
  codeStartUp(start)
  WHILE sym<>CEND DO statement()
  codeCleanUp()
  chk(CEND,'END erwartet!')
ENDPROC /* Program */
PROC codeW (s)
     writeString(s)
ENDPROC /* codeW */

PROC codeWL(s)
     codeW(s); writeLn()
ENDPROC /* codeWL */

PROC codeDCL(var)   /* Speicher für var reservieren */
     codeW(var); codeWL(': DC.L 0')
ENDPROC /* codeDCL */

PROC codeMOVEvarD0(var)     /* var nach D0 kopieren */
     codeW('    MOVE.L  '); codeW(var); codeWL(',D0')
ENDPROC /* codeMOVEvarD0 */

PROC codeMOVEconstD0(c)      /* Konstante c nach D0 laden */
     codeW('    MOVE.L  #'); writeInt(c); codeWL(',D0')
ENDPROC /* codeMOVEconstD0 */

PROC codeMOVED0var(name)       /* D0 in D0 kopieren */
     codeW('    MOVE.L  D0,'); codeWL(name)
ENDPROC /* codeMOVED0var */

PROC codeMOVED0D1()
     codeWL('    MOVE.L  D0,D1')
ENDPROC /* codeMOVED0D1 */

PROC codeADDD1D0()
     codeWL('    ADD.L   D1,D0')
ENDPROC /* ADDD1D0 */

PROC codeNEGD0()
     codeWL('    NEG.L   D0'   )
ENDPROC /* codeNEGD0 */

PROC codeTSTD0()
     codeWL('    TST.L   D0'   )
ENDPROC /* codeTSTD0 */

PROC codeGetLabel() RETURN (labels++)        /* neues Label anfordern */

PROC codeLabel(l)                   /* Label <l> ausgeben */
     codeW('L'); writeHex(l); codeWL(':')
ENDPROC /* Label */

PROC codeBLE(l)                       /* BLE <l> erzeugen */
     codeW('    BLE     L'); writeHex(l); codeWL(' ')
ENDPROC /* codeBLE */

PROC codeBRA(l)                       /* BRA <l> erzeugen */
     codeW('    BRA     L'); writeHex(l); codeWL(' ')
ENDPROC /*  BRA */

PROC codeprintD0()                           /* Wert von D0 ausgeben */

  codeWL('    LEA     _format,A0')
  codeWL('    MOVE.L  A0,D1     ')
  codeWL('    LEA     _print,A0 ')
  codeWL('    MOVE.L  A0,D2     ')
  codeWL('    MOVE.L  D0,(A0)   ')
  codeWL('    MOVE.L  _dos,A6   ')
  codeWL('    JSR     -954(A6)  ')
ENDPROC /* PrintD0 */

PROC codeStartUp(start)       /* Dos-Library öffnen, etc. */

  codeWL('_dos:      DC.L    0              ')
  codeWL('_dosname:  DC.B    "dos.library",0')
  codeWL('_format:   DC.B    "%ld",10,0     ')
  codeWL('           DS.L    0              ')
  codeWL('_print:    DC.L    0              ')
  codeLabel(start)
  codeWL('    LEA     _dosname,A1           ');
  codeWL('    MOVE.L  #37,D0                ');
  codeWL('    MOVE.L  $4,A6                 ');
  codeWL('    JSR     -552(A6)              ');
  codeWL('    TST.L   D0                    ');
  codeWL('    BNE.S   _ok                   ');
  codeWL('    RTS                           ');
  codeWL('_ok:                              ');
  codeWL('    MOVE.L  D0,_dos               ');
ENDPROC /* StartUp */

PROC codeCleanUp()                    /* Dos-Library schließen, etc. */

  codeWL('    MOVE.L  _dos,A1  ');
  codeWL('    MOVE.L  $4,A6    ');
  codeWL('    JSR     -414(A6) ');
  codeWL('    MOVE.L  #0,D0    ');
  codeWL('    RTS              ');
  codeWL('    END              ');
ENDPROC /* CleanUp */
PROC writeString(s)
     Fputs(code,s)
ENDPROC

PROC writeLn()
     FputC(code,10)
ENDPROC

PROC writeInt(c)
DEF s[10]:STRING
     StringF(s,'\d',c)
     writeString(s)
ENDPROC

PROC writeHex(c)
DEF s[10]:STRING
    StringF(s,'\h',c)
    writeString(s)
ENDPROC


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
PROC main()
DEF myargs:PTR TO LONG,rdargs

    myargs:=[0,0]
    IF rdargs:=ReadArgs('SOURCE/A,DESTINATION/A',myargs,NIL)
       IF (source := Open(myargs[0], OLDFILE)) = 0 THEN error('Source nicht gefunden! ')
       IF (code   := Open(myargs[1], NEWFILE)) = 0 THEN error('Ausgabedatei nicht zu öffnen!')
       program()
    ELSE
       error('Aufruf: Mini <Quelltext> <AssemblerFile>')
    ENDIF
    error('Alles O.K !!!')
ENDPROC /* main */

PROC error(s)
    WriteF('\s\n',s)
    IF source THEN Close(source)
    IF code   THEN Close(code)
    CleanUp(10)
ENDPROC
