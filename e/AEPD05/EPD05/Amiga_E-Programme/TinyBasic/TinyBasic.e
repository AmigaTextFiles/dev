/* ** Tiny BASIC Interpreter **


    Dieser BASIC-Interpreter basiert auf einen Interpreter von
    David Benn.

    Konvertiert in Amiga_E und erweitert von Jörg Wach (=JCL_POWER)
    in 1994.

    Version 0.1: 13.01.1994
                 Lockere Übersetzung.

    Version 0.2: 21.01.94
                 - Ausbau des Gurus bei zwei Variablen
                 - Änderungen aller Variablen auf FFP

    Version 0.3: 24.01.94
                 - EDIT-Mode
                 - LIST-Befehl überarbeitet
                 - RUN -Befehl überarbeitet
                 - Save-Befehl überarbeitet
                 - Load-Befehl überarbeitet
                 - LABEL's für GOTO
                 - LET Befehl auch ohne LET

    Version 0.4: 24.01.1994
                 - SAVE - Befehl neu geschrieben.
                 - LOAD - Befehl neu geschrieben.
                 - PRINT- Befehl überarbeitet.
                 - Vergleiche auf FFP umgestellt.
                 - Stringliterale überarbeitet.

    Version 0.5: 28.01.1994
                 - INPUT-Befehl für begleitende Strings eingerichtet
                 - PRINT Befehl erweitert um ?, ","
                 - FFP-Routinen für Wandlung angepasst.
                 - Tuning vorgenommen.

    Version 0.6: 29.01.1994
                 - Zuweisungen für negative Zahlen korrigiert.

*/

MODULE 'mathtrans'


CONST MAXSTACK=100          /* Unser max. Stack. */
CONST MAXFUNC=7             /* Unsere Anzahl an Funktionen -1. */
CONST MAXSYM=35             /* maximale Anzahl an Symbolen -1. */

                            /* Spezielle Symbole. */
ENUM ALPHA=0, NUMBER, STRINGLITERAL, PLUS, MINUS, MULT, DIV,
     POW,   LPAREN, RPAREN, EQ, LT, GT, LTOREQ, GTOREQ, NOTEQ,
     COMMA, COLON, LABEL, EOS

                            /* Reservierte Wörter. */
ENUM CLSSYM=20 , ELSESYM, GOTOSYM, IFSYM, INPUTSYM, LETSYM, LISTSYM,
     LOADSYM, NEWSYM, PRINTSYM, RUNSYM, SAVESYM, STOPSYM, THENSYM,
     EDITSYM, UNDEF

CONST MAXWORD = 14          /* Max. Anzahl reservierter Wörter -1. */

                            /* Unsere möglichen Fehler. */
ENUM  DIVBYZERO=1, SYNTAX, STKOVFL, STKUFL, LINEOUTOFRANGE, NOLABEL,
      OUTOFMEMORY, CANNOTOPENFILE, FILENOTFOUND, NOMATHTRANS, NOCON,
      FFPFMT, NOMEM, NOASSIGN

CONST MAXLINES=1000         /* Max. Anzahl an Programmzeilen. */


DEF stack[MAXSTACK]: ARRAY OF LONG  /* Der Stack wird definiert. */
DEF stacktop                        /* Das Stackende. */
DEF funcs: PTR TO LONG              /* Unsere Funktionswörter. */
DEF word : PTR TO LONG              /* Unserer reservierten Wörter. */
DEF bad                             /* Enthält die Fehlernummer. */

DEF code_ptr[MAXLINES]: ARRAY OF LONG  /* Enthält die Zeiger auf die
                                          Programmzeilen. Die Programmzeilen
                                          wiederum sind EStrings! */

DEF topline=0                       /* letzte Zeile. */

DEF pc, old_pc                      /* Unser Programm-Counter. */

                                    /* ... und sonstige globale Variablen. */
DEF n, length, halt_requested, ch=0, ut_ch=0
DEF buf[255]: STRING, ut_buf[255]: STRING, obj[255] : STRING,
    sym = UNDEF, printstring[255]: STRING

DEF var[25]: ARRAY OF LONG          /* Unsere Laufzeitvariablen. */
DEF con                             /* Unser Fenster. */
DEF debugger=FALSE                  /* Debugger an/aus */

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Die Hauptsteuerung (MAIN)                                               */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC main()
DEF i
    mathtransbase:=OpenLibrary('mathtrans.library',0) /* Wir brauchen diese
                                                         Lib. */
    IF mathtransbase=NIL
      error(NOMATHTRANS)
      RETURN
    ENDIF
    IF (con:=Open('con:0/0/640/200/Tiny Basic in E © 1994 Jörg Wach',NEWFILE))= NIL
       error(NOCON)
       RETURN
    ENDIF

    con := SetStdOut(con)

    initall() /* Alles initialisieren. */

    REPEAT
       WriteF('->')
       pc:= 0
       ReadStr(stdout,ut_buf)               /* Befehl einlesen. */
       StrCopy(buf,ut_buf,ALL)
       UpperStr(buf)
       SetStr(buf,EstrLen(ut_buf))          /* Um den Bufferzähler auf den
                                               richtigen Wert zu bringen. */
       IF finished()=FALSE THEN parse_line()   /* Wir machen so lange einen
                                                  Parse, bis wir das Ende
                                                  erreicht haben. */
    UNTIL finished()=TRUE

    /* Wir löschen unsere Strings. */
    FOR i:=0 TO MAXLINES
        IF code_ptr[i]<> NIL THEN SetStr(code_ptr[i],0)
    ENDFOR

    Close(stdout)           /* Unser Arbeitsfenster schließen. */
    CloseLibrary(mathbase)
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Initialisiert alle Variablen.                                           */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC initall()
/* initialisiert alle benötigten Variablen */

DEF t1

    /* Erstmal unsere Funktionen als PTR TO LONG, also Strings. */
    funcs := ['SIN', 'COS', 'TAN', 'LOG', 'SQR', 'FIX', 'INT', 'RND']

    /* Und nun kommen die reservierten Wörter ran. */
    word := [ 'CLS', 'ELSE', 'GOTO', 'IF', 'INPUT', 'LET', 'LIST',
              'LOAD', 'NEW', 'PRINT', 'RUN', 'SAVE', 'STOP', 'THEN',
              'EDIT' ]

    /* Wir löschen die Zeilen-Pointer. */
    FOR t1:=0 TO MAXLINES DO code_ptr[t1]:=NIL

    /* Wir löschen die Variablen-Inhalte. */
    FOR t1:=0 TO 25 DO var[t1]:=0
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Checkt, ob TinyBasic verlassen werden soll. Gibt bei Verlasen ein TRUE  */
/* zurück.                                                                 */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC finished() RETURN IF InStr(buf,'SYSTEM',0) = -1 THEN FALSE ELSE TRUE

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* cap - Proc für das umsetzen von kleinen Zeichen in große Zeichen */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC cap(c) RETURN IF (c > 96) AND (c < 123) THEN c := c - 32 ELSE c

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* parse_line sucht nach den Befehlen. Hauptsteuerung!                                     */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC parse_line()
  ch := n :=0               /* Zeichen und Anzahl auf 0. */
  length := EstrLen(buf)    /* Max. Länge. */
  bad := FALSE
  halt_requested := FALSE
  stacktop := 0
  nextch()                  /* Hole das erste Zeichen. */
  REPEAT
    insymbol()
    statement()
    IF (sym<>COLON) AND (sym<>EOS) THEN insymbol()
  UNTIL sym<>COLON
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* Zentrale Fehlerausgabeprozedur.                                         */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC error(n)
/* Ausgabe der Fehlertexte. */
  IF bad THEN RETURN     /* Nur Ausgabe eines Fehlers pro Zeile. */
  SELECT n
    CASE DIVBYZERO
         WriteF('DIVISION BY ZERO ')
    CASE SYNTAX
         WriteF('SYNTAX ERROR ')
    CASE STKOVFL
         WriteF('STACK OVERFLOW ')
    CASE STKUFL
         WriteF('STACK UNDERFLOW ')
    CASE LINEOUTOFRANGE
         WriteF('LINE OUT OF RANGE 1 TO \d ',MAXLINES)
    CASE NOLABEL
         WriteF('Kein passendes Label gefunden.')
    CASE OUTOFMEMORY
         WriteF('OUT OF MEMORY ')
    CASE CANNOTOPENFILE
         WriteF('CAN\aT OPEN FILE FOR WRITING ')
    CASE FILENOTFOUND
         WriteF('FILE NOT FOUND ')
    CASE NOMATHTRANS
         WriteF('Keine Mathtrans-Library vorhanden!')
    CASE NOCON
         WriteF('Kein Arbeitsfenster zu öffnen!')
    CASE FFPFMT
         WriteF('Fehler beim FFP-Format!')
    CASE NOMEM
         WriteF('Kein Speicher für Alloc von String!')
    CASE NOASSIGN
         WriteF('Keine Variablenzuweisung möglich!')

  ENDSELECT
  IF pc<>0 THEN WriteF('IN LINE \d.\n',old_pc) ELSE WriteF('\n')
  bad:=TRUE
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* nextch()                                                                */
/* Hole das nächsten Zeichen aus der Eingabe vom Bildschirm oder,          */
/* wenn wir im RUN-Mode sind, das nächste Zeichen aus dem Programmspeicher.*/
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC nextch()
/* Holt das nächste Zeichen. */

  IF n<=length
     ch := buf[n]
     ut_ch := ut_buf[n]
     n++
  ELSE
    ch := 0
  ENDIF
ENDPROC

PROC rsvd_wd(x)
/* Prüft den String x ab, ob es ein reserviertes Wort ist. */
DEF i,num

    i:=0
    num := -1
    WHILE (i <= MAXWORD) AND (num=-1)
        IF StrCmp(x,word[i],ALL) THEN num := i    /* Haben wir so ein Wort? */
/*        debug(word[i],0,0) */
        i++
    ENDWHILE

/*    debug('rsvd_wd',num,0) */
    IF num=-1 THEN RETURN ALPHA ELSE RETURN (num+EOS+1)
ENDPROC

PROC insymbol()
/* Prüft das Symbol ab. */
DEF periods=0, tt1

 obj[0] :=0
 sym:=UNDEF                     /* Erstmal vorbelegen. */

 /* Leerzeichen überspringen. */
 IF (ch<=" ") AND (ch<>0)
   REPEAT
     nextch()
   UNTIL (ch>" ") OR (ch=0)
 ENDIF

 /* Ende des Strings erreicht? */
 IF ch=0
    sym := EOS
    debug('Ende String',0,0)
    RETURN
 ENDIF

 /* Zeichen */
 tt1 := n - 1
 IF (ch>="A") AND (ch<="Z")
    WHILE ((ch>="A") AND (ch<="Z")) OR ((ch>="0") AND (ch<="9"))
        nextch()
    ENDWHILE
    MidStr(obj,buf,tt1,n-tt1-1)
    sym := rsvd_wd(obj)
    debug(obj,sym,0)
 ELSE
   /* Vorzeichenlose Zahlen. */
   IF ((ch>="0") AND (ch<="9")) OR (ch=".")
    debug('insymbol-zahl',0,0)
     sym := NUMBER
     WHILE ((ch>="0") AND (ch<="9")) OR (ch=".")
       IF ch="." THEN periods++
       nextch()
     ENDWHILE
     MidStr(obj,buf,tt1,n-tt1-1)
     debug(obj,0,0)
     IF periods > 1         /* Dezimalpunkt mehrmals gefunden. */
       sym := UNDEF
       error(SYNTAX)
     ENDIF
   ELSE
     /* Ein Text-Literal. */
     IF ch=34
       INC tt1
       sym := STRINGLITERAL
       nextch()
       WHILE (ch<>34) AND (ch<>0)
         nextch()
       ENDWHILE
       MidStr(obj,ut_buf,tt1,n-tt1-1)
       debug(obj,0,0)
       IF ch<>34
          error(SYNTAX);sym := UNDEF; RETURN
       ENDIF
       nextch()
     ELSE
       /* Ein einzelnes Zeichen. */
    debug('insymbol-zeichen',buf[tt1],0)
       MidStr(obj,buf,tt1,1)
       SELECT ch
         CASE "+"
             sym := PLUS
         CASE "-"
             sym := MINUS
         CASE "*"
             sym := MULT
         CASE "/"
             sym := DIV
         CASE "^"
             sym := POW
         CASE "("
             sym := LPAREN
         CASE ")"
             sym := RPAREN
         CASE "="
             sym := EQ
         CASE "<"
             sym := LT
         CASE ">"
             sym := GT
         CASE ","
             sym := COMMA
         CASE ":"
             sym := COLON
         CASE "?"
             sym := PRINTSYM

       ENDSELECT

       nextch()

       /* <= <> >= ? */
       IF (sym=LT) AND (ch="=")
         sym := LTOREQ;nextch()
       ELSE
         IF (sym=LT) AND (ch=">")
           sym := NOTEQ;nextch()
         ELSE
           IF (sym=GT) AND (ch="=")
             sym := GTOREQ;nextch()
           ENDIF
         ENDIF
       ENDIF

       IF sym=UNDEF THEN error(SYNTAX)
     ENDIF
   ENDIF
 ENDIF
ENDPROC

PROC push(x)
/* Packe auf den Stack. */

  IF stacktop>MAXSTACK
    error(STKOVFL)
  ELSE
    stack[stacktop] := x
    stacktop++
  ENDIF
ENDPROC

PROC pop()
/* Hole vom Stack. */

  stacktop--
  IF stacktop<0
     error(STKUFL)
  ELSE
     RETURN stack[stacktop]
  ENDIF

ENDPROC

PROC func()
/* Funktionsauswertungen. */
DEF found, funct, i

  /* Suche nach der Funktion. */
  found := funct := FALSE
  i := 0
  WHILE (i<=MAXFUNC) AND (found = FALSE)
    IF StrCmp(funcs[i],obj,ALL)
       funct := i; found := TRUE
    ELSE
       INC i
    ENDIF
  ENDWHILE

  IF funct = FALSE THEN RETURN FALSE        /* Variable. */

  /* Push das Argument. */
  IF funct<8
    insymbol()
    IF sym<>LPAREN
      error(SYNTAX)
      funct := 0
    ELSE
      insymbol()
      expr()
      IF bad THEN RETURN FALSE
      IF sym<>RPAREN
         error(SYNTAX)
         funct := 0
      ENDIF
    ENDIF
  ENDIF

  /* Ausführbare Funktion. */
  SELECT funct
    CASE 0 ; push(SpSin(pop()))
    CASE 1 ; push(SpCos(pop()))
    CASE 2 ; push(SpTan(pop()))
    CASE 3 ; push(SpLog(pop()))
    CASE 4 ; push(SpSqrt(pop()))
    CASE 5 ; push(SpFloor(pop()))
    CASE 7
           i := SpFix(pop())
           i := Rnd(i)
           i := SpDiv(100000|,SpFlt(i))
           push(i)
  ENDSELECT

ENDPROC TRUE

PROC var_index(x) RETURN x-"A"

PROC factor()

  debug(obj,sym,20)
  IF sym=NUMBER
    /* Numerisches Literal. */
    debug('factor0',0,0)
    push(make_float(obj))
  ELSE
    /* Klammerausdruck? */
    IF sym=LPAREN
    debug('factor1',0,0)
      insymbol()
      IF sym=EOS
         error(SYNTAX);RETURN
      ENDIF
      expr()
      IF bad THEN RETURN
      IF sym<>RPAREN
         error(SYNTAX);RETURN
      ENDIF
    ELSE
      /* Funktion oder Variable? */
    debug('factor2',0,0)
      IF func() = FALSE
    debug('factor3',sym,0)
        IF sym=ALPHA THEN push(var[var_index(obj[0])]) ELSE error(SYNTAX)
    debug('factor4',0,0)
      ENDIF
    ENDIF
  ENDIF
  insymbol()
ENDPROC

PROC expterm()
DEF op1, op2

  factor()
  debug('expterm0',0,0)
  WHILE sym=POW
    insymbol()
    factor()
    IF bad THEN RETURN
    op2:=pop()
    op1:=pop()
    push(SpPow(op2,op1))
  ENDWHILE
  debug('expterm1',0,0)
ENDPROC

PROC negterm()
DEF negate
  negate := FALSE
  IF sym=MINUS
    negate := TRUE
    insymbol()
  ELSE
    IF sym=PLUS THEN insymbol()
  ENDIF
  expterm()
  IF bad THEN RETURN
  IF negate THEN push(SpNeg(pop()))
ENDPROC

PROC term()
DEF op, op1, op2
  negterm()
  debug('term0',0,0)
  WHILE (sym=MULT) OR (sym=DIV)
    op := sym
    insymbol()
    negterm()
    IF bad THEN RETURN
    op2 := pop()
    op1 := pop()
    IF op=MULT
      push(SpMul(op2,op1))
    ELSE
      IF SpTst(op2)<>0 THEN push(SpDiv(op2,op1)) ELSE error(DIVBYZERO)
    ENDIF
  ENDWHILE
  debug('term1',0,0)
ENDPROC

PROC simple_expr()
DEF op, op1, op2
  term()
  debug('simple_expr0',0,0)
  WHILE (sym=PLUS) OR (sym=MINUS)
    op:=sym
    insymbol()
    term()
    IF bad THEN RETURN
    op2:=pop()
    op1:=pop()
    IF op=PLUS THEN push(SpAdd(op2,op1)) ELSE push(SpSub(op2,op1))
  ENDWHILE
  debug('simple_expr1',0,0)
ENDPROC

PROC expr()
DEF op, op1, op2
  simple_expr()
  debug('expr0',0,0)
  WHILE (sym=EQ) OR (sym=LT) OR (sym=GT) OR (sym=LTOREQ) OR
        (sym=GTOREQ) OR (sym=NOTEQ)
    op:=sym
    insymbol()
    simple_expr()
    IF bad THEN RETURN
    op2:=pop()
    op1:=pop()
    SELECT op
      CASE EQ
           IF SpCmp(op2,op1) = 0 THEN push(TRUE) ELSE push(FALSE)
      CASE LT
           IF SpCmp(op2,op1) = 1 THEN push(TRUE) ELSE push(FALSE)
      CASE GT
           IF SpCmp(op2,op1) = -1 THEN push(TRUE) ELSE push(FALSE)
      CASE LTOREQ
           IF (SpCmp(op2,op1) = 0) OR (SpCmp(op2,op1) = 1) THEN push(TRUE) ELSE push(FALSE)
      CASE GTOREQ
           IF (SpCmp(op2,op1) = 0) OR (SpCmp(op2,op1) = -1) THEN push(TRUE) ELSE push(FALSE)
      CASE NOTEQ
           IF SpCmp(op2,op1) <> 0 THEN push(TRUE) ELSE push(FALSE)
    ENDSELECT
  ENDWHILE
  debug('expr1',0,0)
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* assign_to_variable                                                      */
/* Erkennt eine Variable und weisst ihr einen Wert zu.                     */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
PROC assign_to_variable(mit_let)
DEF variable[255] :STRING

 IF mit_let = TRUE THEN insymbol()             /* Hole die Variable. */
 IF sym<>ALPHA
   error(SYNTAX);RETURN
 ENDIF
 StrCopy(variable,obj,ALL)
 insymbol()                 /* Hole die Zuweisung */
    SELECT sym
        CASE EQ
             insymbol()
             IF sym=EOS
                error(SYNTAX);RETURN
             ENDIF
             expr()
             IF bad THEN RETURN
             var[var_index(variable[0])] := pop()
        CASE COLON              /* Ist es ein Label? */
             sym := LABEL
        DEFAULT
             error(NOASSIGN)
    ENDSELECT
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* if_statement                                                            */
/* Prüft eine Bedingung                                                    */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC if_statement()

    /* IF ... THEN ... ELSE */

    insymbol()
    expr()
    IF bad THEN RETURN          /* War nicht zu prüfen! */

       /* THEN */

    IF sym=THENSYM
       IF pop() = TRUE
          debug('THENSYM',0,0)
          REPEAT
            insymbol()
            statement()
          UNTIL sym=EOS
          debug('ENDE THENSYM',0,0)
       ELSE
          WHILE (sym<>ELSESYM) AND (sym<>EOS) DO insymbol()

      /* ELSE (optional) */

         IF sym=ELSESYM
           insymbol()
           statement()
         ENDIF
       ENDIF
    ELSE
       error(SYNTAX)
    ENDIF
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* modify_programm                                                         */
/* Erstellt neue Zeilen bzw. löscht bestehende Zeilen im Programmfragment. */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC modify_program()
DEF strptr, x[255]:STRING
DEF num, ln

    WriteF('Edit-Mode\n---------\n')
  LOOP
    WriteF('-»')
    IF topline  = MAXLINES              /* Haben wir schon die letzte Zeile */
       error(LINEOUTOFRANGE);RETURN     /* zu fassen? */
    ENDIF

    num := topline                      /* Und in num übergeben. */

    strptr := code_ptr[num]             /* zeiger auf die Zeile holen     */
    IF strptr                           /* und wenn was drinsteht erstmal */
       SetStr(strptr,0)                 /* löschen.                       */
       code_ptr[num] := NIL
    ENDIF

    ReadStr(stdout,x)                   /* Jetzt lesen wir die neue Zeile */
    IF InStr(x,'EDIT',0) <>-1 THEN RETURN                   /* ENDE EDIT? */
    IF InStr(x,'edit',0) <>-1 THEN RETURN                   /* ENDE EDIT? */

    basic_line(x)

     strptr := String(ln)               /* Speicher für neue Zeile holen. */
     IF strptr=NIL
        error(OUTOFMEMORY);RETURN
     ENDIF
     code_ptr[num] := strptr            /* Speicherpointer übergeben. */
     StrCopy(strptr,x,ALL)              /* und ... kopieren.          */
     INC topline                        /* Neue Zeile. */
   ENDLOOP
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* list_programm()                                                         */
/* Listet unser Programm auf den Bildschirm.                               */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC list_program()
DEF strptr, i

  i :=0
  WHILE i<=topline
    strptr := code_ptr[i]
    IF strptr THEN WriteF('\d\t \s\n',i,strptr)
    INC i
  ENDWHILE
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* clear_programm()                                                        */
/* Löscht den Programmspeicher.                                            */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC clear_program()
DEF strptr, i

  /*{ clear program memory } */

  FOR i:=0 TO MAXLINES
    strptr := code_ptr[i]
    IF strptr
      SetStr(strptr,0)
      code_ptr[i] := NIL
    ENDIF
  ENDFOR

  topline := 0
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* run_programm()                                                          */
/* Führt ein gespeichertes Programm aus.                                   */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC run_program()
DEF strptr

    IF topline=0 THEN RETURN        /* War wohl nichts. */

    pc:=0
    REPEAT
        strptr := code_ptr[pc]
        old_pc := pc
        INC pc
        IF strptr
           StrCopy(buf,strptr,ALL)
           StrCopy(ut_buf,buf, ALL)
           UpperStr(buf)
           parse_line()
        ENDIF
    UNTIL (bad) OR (halt_requested) OR (pc>topline)
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* load_programm()                                                         */
/* Lädt ein gespeichertes Programm ein.                                    */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

PROC load_program()
DEF strptr, handle, x[255]:STRING

    insymbol()
    IF sym=STRINGLITERAL
       handle := Open(obj,OLDFILE)
        IF handle<>NIL
           clear_program()
           WriteF('LOADING \s ..\n',obj)
            WHILE ReadStr(handle,x) <> -1
                IF (strptr:=String(EstrLen(x))) = NIL
                   error(OUTOFMEMORY)
                   Close(handle)
                   RETURN
                ENDIF
                StrCopy(strptr,x,ALL)
                basic_line(strptr)
                code_ptr[topline] := strptr
                INC topline
                IF topline> MAXLINES        /* Zu viele Zeilen ?*/
                   error(LINEOUTOFRANGE)
                   Close(handle)
                   RETURN
                ENDIF
            ENDWHILE
           Close(handle)
           WriteF( 'PROGRAM LOADED.\n')
        ELSE
           error(FILENOTFOUND)
        ENDIF
    ELSE
        error(SYNTAX)
    ENDIF
ENDPROC

/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
/* save_programm()                                                         */
/* Speichert ein eingegebenes Programm ab.                                 */
/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
PROC save_program()
DEF strptr,handle,i

    IF topline=0 THEN RETURN    /* War wohl nichts. */

    insymbol()
    IF sym=STRINGLITERAL
       handle := Open(obj,NEWFILE)
       IF handle<>NIL
          WriteF( 'SAVING \s..\n',obj)
          FOR i:=0 TO topline
              strptr := code_ptr[i]
              IF strptr
                 Fputs(handle,strptr)
                 FputC(handle,10)
              ENDIF
          ENDFOR
          WriteF('PROGRAM SAVED.\n')
          Close(handle)
       ELSE
           error(CANNOTOPENFILE)
       ENDIF
    ELSE
       error(SYNTAX)
    ENDIF
ENDPROC

PROC statement()
DEF tt[255]:STRING, tt1

 /* '..EMPTY STATEMENT */
 IF sym=EOS THEN RETURN

 /* EDIT : Einfügen von Programmzeilen */
 IF sym=EDITSYM
    modify_program()
    RETURN
 ENDIF

 /* '..CLS */
 IF sym=CLSSYM
    WriteF('\c',7);RETURN
 ENDIF

 /* '..GOTO */
 IF sym=GOTOSYM
   insymbol()
   IF sym=EOS
      error(SYNTAX); RETURN
   ENDIF
   debug(obj,99,0)
   FOR tt1:=0 TO topline
       debug(code_ptr[tt1],100,0)
       IF StrCmp(code_ptr[tt1],obj,EstrLen(obj)) = TRUE
          pc := tt1
          RETURN
       ENDIF
   ENDFOR
   error(NOLABEL)
   RETURN
 ENDIF

 /* '..IF */
 IF sym=IFSYM
   if_statement()
   RETURN
 ENDIF

    /* '..INPUT */
     IF sym=INPUTSYM
        insymbol()
        IF sym=EOS
           error(SYNTAX);RETURN
        ENDIF
        IF sym=STRINGLITERAL    /* Ist ein Text auszugeben? */
           WriteF('\s', obj)
           insymbol()           /* Komma überspringen. */
           insymbol()           /* Variable holen. */
        ENDIF
        IF sym=ALPHA
           ReadStr(stdout,tt)
           var[var_index(obj[0])] := make_float(tt)
        ELSE
           error(SYNTAX)
        ENDIF
        RETURN
    ENDIF

 /* '..LET */
 IF sym=LETSYM
   assign_to_variable(TRUE)
   RETURN
 ENDIF

 /* '..LIST */
 IF sym=LISTSYM
   list_program()
   RETURN
 ENDIF

 /* '..LOAD */
 IF sym=LOADSYM
   load_program()
   RETURN
 ENDIF

 /* '..NEW */
 IF sym=NEWSYM
   clear_program()
   RETURN
 ENDIF

    /* '..PRINT */
   IF sym=PRINTSYM
      tt1 := TRUE
      insymbol()
      IF sym=EOS
         error(SYNTAX);RETURN
      ENDIF
      REPEAT
          SELECT sym
            CASE STRINGLITERAL
                 WriteF('\s', obj)
                 insymbol()
            CASE ALPHA
                 expr()
                 IF bad=FALSE
                    get_float(pop())
                    WriteF('\s',printstring)
                 ENDIF
            CASE COMMA
                 WriteF('\c',9)
                 insymbol()
            DEFAULT
                 WriteF('\n')
                 tt1 := FALSE
            ENDSELECT
      UNTIL tt1 = FALSE
      RETURN
    ENDIF

 /* '..RUN */
 IF sym=RUNSYM
   run_program()
   RETURN
 ENDIF

 /* '..SAVE */
 IF sym=SAVESYM
   save_program()
   RETURN
 ENDIF

 /* '..STOP */
 IF sym=STOPSYM
   halt_requested := TRUE
   RETURN      /* '..see run_program */
 ENDIF

    /* + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + +
       ALPHA-Symbol
       Hier machen wir nochmal eine Prüfung, ob es
        - ein LABEL ist
        oder
        - eine Variablen-Zuweisung.
     + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + + */

    IF sym = ALPHA
       assign_to_variable(FALSE)
       RETURN
    ENDIF


 /* '..UNKNOWN */
 error(SYNTAX)
ENDPROC

PROC debug(string, op1, op2)
/* Zeigt die übergebenen Zeichen an. */

    IF debugger THEN WriteF('\s,\d,\d\n', string, op1, op2)

/*    Delay(50) */
ENDPROC

PROC make_float(str)
/* floatvalue: in goes a nil-terminated string, out comes an FFP float!
   note that "num" and "com" contain the float in int format: com is
   the amount num should be divided with to obtain the float value.
   NOTE: this function raises an ER_FLOAT if something goes wrong.
   Modifiziert, da für FFP nur 6-Stellen erlaubt sind!!! Inkl.
   Nachkommastellen. Jörg Wach in 1994. */

  DEF num=0,com=1,tt1=0,neg=FALSE
  WHILE str[]=" " DO INC str            /* deal with leading spaces */
  IF str[]="-"
    INC str
    neg:=TRUE
  ENDIF

  WHILE (str[]>="0") AND (str[]<="9") AND (tt1<7)
        num:=str[]++-"0"+(num*10)
        INC tt1
  ENDWHILE
  IF str[]="."
    INC str
    WHILE (str[]>="0") AND (str[]<="9") AND (tt1<7)
      num:=str[]++-"0"+(num*10)
      com:=Mul(com,10)
      INC tt1
    ENDWHILE
  ENDIF
  IF neg = TRUE THEN num:= -num
ENDPROC SpDiv(SpFlt(com),SpFlt(num))

PROC get_float(ffp)
/* Macht aus einer 32-Bit-FFP-Zahl einen String. Der gewandelte String steht
   in printstring.
*/
  DEF tt1, tt2
  tt1 := SpFix(ffp)                     /* Vorkommazahl holen */
  tt2 := SpSub(SpFlt(tt1),ffp)          /* und von FFP-Zahl abziehen =
                                           Nachkommazahl */
  tt2 := (SpFix(SpMul(tt2,1000000|)))   /* Nachkommazahl auf 6-Stellen
                                           LONG bringen */
  StringF(printstring,'\d.\d',tt1,tt2)  /* Und ab in den String. */
ENDPROC

PROC basic_line(string)
/* Übersetzt eingabezeilen unter Beachtung von strings, in Große Buchstaben.
*/
DEF tt=0, tt1
                                        /* Nun suchen wir nach Anführungs-*/
                                        /* striche, da diese nicht in     */
                                        /* Großbuchstaben übersetzt werden*/
                                        /* dürfen.                        */
     tt1:=EstrLen(string)
     WHILE tt<=tt1
        IF string[tt] = 34
           REPEAT
              INC tt
           UNTIL string[tt] = 34
        ELSE
           string[tt] := cap(string[tt])
        ENDIF
        INC tt
     ENDWHILE
ENDPROC
