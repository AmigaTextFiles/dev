
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
