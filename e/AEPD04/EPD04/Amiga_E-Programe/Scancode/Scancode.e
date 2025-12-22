/*

    Scancode

Dieses ist ein Programm, welches die benötigte Zeit von Assemblerbefehlen
dokumentieren soll.

Hieraus lassen sich leicht Optimierungen in Richtung Laufzeit ermitteln.

Alle Befehle, die sich nicht in der Tabelle befinden, werden überlesen.

*/
OPT LARGE

MODULE 'dos/dos',
       'exec/memory', 'exec/interrupts', 'exec/nodes',
       'hardware/intbits'

CONST TABCOUNT = 274 /* Anzahl der in der Tabelle enthaltenen Befehle */

OBJECT  tabellendef
        befehl      : LONG      /* Hier stehen die 68000 Befehle */
        sourceop    : LONG      /* Bestimmt, welcher Operand (1 oder 2)
                                  für die Ermittlung der Taktzyklen
                                  herangezogen wird. Ist es keiner, so
                                  muß hier eine 0 stehen und die An-
                                  zahl der Taktzyklen steht im ersten
                                  Feld. Gibts es keine weiteren Operan-
                                  den für den Befehl so muß hier eine
                                  9 stehen und die Anzahl der Zyklen
                                  steht im ersten Feldelement. Besteht
                                  der Fall wie oben beschrieben und es
                                  gibt eine Abhängigkeit zu dem folgen-
                                  den Operanden, so muß eine 8
                                  drin stehen.*/
        sourceopin  : LONG      /* und was darin stehn muß (A = Adress-
                                  Register, D = Datenregister, '(' =
                                  (ax), '+' = (ax)+, '-' = -(ax), ')' =
                                  d(ax), '&' = d(ax,Rx), 'w' = $xx.W,
                                  'l' = $xxxx.L, 'c' = CCR, 's' = SR,
                                  'u' = USP, 'r' = Registerliste, '#'
                                  = # - absolut, ' '
                                  = Inhalt ist egal */

        z1          : LONG   /* Taktzyklen Datenregister (z.B. d1) */
        z2          : LONG   /* Taktzyklen Adressregister (z.B. a1) */
        z3          : LONG   /* Taktzyklen Adressregister indirekt (z.B. (a0))  */
        z4          : LONG   /* Taktzyklen Adressregister indirekt mit inkrement (z.B. (a0)+) */
        z5          : LONG   /* Taktzyklen Adressregister indirekt mit dekrement (z.B. -(a0)) */
        z6          : LONG   /* Taktzyklen Adressregister indirekt mit Distanz (z.B. 10(a0)) */
        z7          : LONG   /* Taktzyklen Adressregister indirekt mit Distanz und Register (z.B. 10(a0,d0)) */
        z8          : LONG   /* Taktzyklen Speicher mit Word (z.B. 4711) */
        z9          : LONG   /* Taktzyklen Speicher mit Long (z.B. 47114711) */
        z10         : LONG   /* Taktzyklen Programcounter und Distanz (z.B. 10(pc)) */
        z11         : LONG   /* Taktzyklen Programcounter und Distanz und Register (z.B. 10(pc,a0)) */
        z12         : LONG   /* Taktzyklen absolut (z.B. #10) */
        z13         : LONG   /* Taktzyklen Conditioncode Register/ Supervisor Stackpointer */
ENDOBJECT

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
/*                Variablen für readstrbuf                                 */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

CONST   STRBUFSIZE=512     /* Hier steht die variable Buffergröße. */

DEF strbuf = NIL, bufpos = 0, bufend = STRBUFSIZE /* Globale Variablen. */
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */

DEF inputline[255]: STRING, inputfilename[255] : STRING, inputfile,
    outputline[255] : STRING, outputfilename[255] : STRING, outputfile,
    kennzeichen[255] : STRING, asbefehl [10]: STRING

DEF total, zwisch, ergebnis,
    verarb,          /* Kennzeichnet ob eine Zwischensumme gebildet wird. */
    verarb1          /* Kennzeichnet ob auf rts, rtr, rte, jsr, jmp
                        oder test reagiert wird. */

DEF dummy1          /* Nur Zwischenvariable. */

DEF datum : datestamp /* Für die Darstellung des Datums */
DEF d1,d2,dd1,dd2

DEF von, bis              /* Globale Variablen für die Ermittlung der Position */
DEF op1, op2              /* Globale Variablen für die Ermittlung der Operanden */


/*** was: DEF tabelle[29]:ARRAY OF tabellendef */
DEF tabelle:PTR TO tabellendef      /* Hier definieren wir die Arbeitstabelle */
DEF tab[9]:ARRAY OF LONG

DEF vbint : PTR TO is, vbcounter, timer1

PROC main()

DEF i, ii, iii, dummy2=TRUE

    VOID 'Copyright = © Jörg Wach '
    VOID 'CopyrightVersion = Version 1.64'
    VOID 'Copyrightdate = Date 20.06.1993 '

    inittab()   /* Erstmal die Tabelle initialisieren. */

    WriteF('\e[1;32;41m');
    WriteF('+----------------------------------------------------------------+\n');
    WriteF('\e[1;31;40m');
    WriteF('\e[1;32;41m');
    WriteF('! ScanCode Version 1.64                                          !\n');
    WriteF('! Copyright © 1992, 1993 by Jörg Wach (JCL POWER)                !\n');
    WriteF('\e[1;31;40m');
    WriteF('\e[1;32;41m');
    WriteF('+----------------------------------------------------------------+\n');
    WriteF('\e[0;31;40m');

    dummy1 := getargs(0,kennzeichen)
    IF dummy1=-1 OR dummy1>3  THEN anleitung()
    dummy1 := getargs(1,kennzeichen)

    bis := 0;
    von := 0;
    IF (kennzeichen[bis] = "h") OR
       (kennzeichen[bis] = "H") OR
       (kennzeichen[bis] = "?") THEN anleitung()

    verarb1 := 0;
    REPEAT
        IF kennzeichen[bis] = "b" THEN verarb1 := 1;
        IF kennzeichen[bis] = "j" THEN verarb1 := verarb1 + 2;
        IF kennzeichen[bis] = "r" THEN verarb1 := verarb1 + 4;
        IF kennzeichen[bis] = "t" THEN verarb1 := verarb1 + 8;
        IF kennzeichen[bis] = "l" THEN verarb1 := verarb1 + 16;

    /* * Jetzt bleibt uns nur noch die Dialogverarbeitung oder die
        Information über einen befehl. * */
        IF kennzeichen[bis] = "i"
           befinf()
           RETURN
        ENDIF

        IF kennzeichen[bis] = "d"
           WriteF('Direktdialog - Ende mit \ax\a\n');
           REPEAT
                WriteF('Bitte befehl ---> ');
                ReadStr(stdout,inputline);
                StrCopy(kennzeichen,' ',ALL)
                StrAdd(kennzeichen, inputline,ALL);
                StrCopy(inputline, kennzeichen,ALL);
                LowerStr(inputline)
                IF inputline[1] <> "x"
                   bis := 0
                   ergebnis := holetakt();
                   IF (ergebnis = 0) OR (ergebnis = -1) THEN WriteF('Kein Befehl!\n');
                   IF ergebnis = -2 THEN WriteF('Falscher Befehl!\n');
                   IF ergebnis > 0  THEN WriteF('Taktzyklen: \d\n',ergebnis);
                ENDIF
           UNTIL inputline[1] = "x";
           WriteF('bye bye ...\n');
           CleanUp(0);
        ENDIF
        IF verarb1 = 0 THEN anleitung();
        bis++
    UNTIL bis > StrLen(kennzeichen)

    dummy1 := getargs(0,kennzeichen)
    IF dummy1 = 2
        dummy1 := getargs(2,inputfilename)
        StrCopy(outputfilename,inputfilename,ALL);
        StrAdd(outputfilename,'.TAKT',ALL);
    ELSE
        dummy1 := getargs(2,inputfilename)
        dummy1 := getargs(3,outputfilename)
    ENDIF

    IF (inputfile := Open(inputfilename, OLDFILE)) = 0
        WriteF('Could not open Input file: \s\n', inputfilename);
        RETURN 10
    ENDIF

    IF (outputfile := Open(outputfilename, NEWFILE)) = 0
        WriteF('Could not open output file: \s\n', outputfilename);
        RETURN 10
    ENDIF

    initvb()

    DateStamp(datum);
    d1 := datum.minute;
    d2 := datum.tick;
    d2 := d2 / 50;
    dummy1 := SetStdOut(outputfile) /* Ausgabe auf Datei. */


    WHILE dummy2
        bis := readstrbuf(inputfile,inputline) /* Bis zum Ende lesen. * */
        IF  bis <> -1

            bis := 0
            ergebnis := holetakt()

            IF (ergebnis = 0) OR (ergebnis = 1) THEN writef(inputline) BUT writef('\n')
            IF ergebnis = -2
               writef(inputline)
               writef('---> Falscher befehl! <---\n')
            ENDIF

         /* * Jetzt gehts ans aufbereiten. * */

            IF ergebnis > 0
               total  := total  + ergebnis
               zwisch := zwisch + ergebnis

               IF (verarb1 AND 8) = 8
                  outputfile := SetStdOut(dummy1) /* Umlenken. */
                  WriteF('von= \d  ',bis);
                  dummy1 := SetStdOut(outputfile) /* Ausgabe auf Datei. */
               ENDIF

               WHILE inputline[bis] > " " DO bis++

               IF (verarb1 AND 8) = 8
                  outputfile := SetStdOut(dummy1) /* Umlenken. */
                  WriteF('bis= \d  ',bis);
                  dummy1 := SetStdOut(outputfile) /* Ausgabe auf Datei. */
               ENDIF

               IF bis > 60 THEN bis := 60

               i := 0; ii := 0; iii := 0

               REPEAT
                    outputline[i] := inputline[i];
                    IF iii > 8 THEN iii := 0
                    IF inputline[i] = 9
                       ii := ii + 8 - iii
                       iii := 0
                    ENDIF
                    iii++
                    ii++
                    i++
               UNTIL (i >= bis) OR (ii >= 60)

               FOR i := ii TO 60
                   outputline[bis] := " ";
                   bis++;
               ENDFOR
               outputline[bis] := 0;

               writef(outputline);
               WriteF('\d\n',ergebnis);
               FOR i := 0 TO 60 DO outputline[i] := " "
            ENDIF

            IF verarb = 1
               writef( '                                 ----------------------- \n')
               writef( '                                 Zwischenergebnis: ')
               WriteF('\d\n',zwisch)
               writef( '                                 ======================= \n')
               zwisch := 0
               verarb := 0
            ENDIF

        ELSE
            dummy2 := FALSE
        ENDIF
    ENDWHILE
    writef('\n\n\n\n\n')
    WriteF('Gesamte Anzahl Taktzyklen: \d\n',total);
    outputfile := SetStdOut(dummy1) /* Zurücksetzen. */

    DateStamp(datum);
    dd1 := datum.minute;
    dd2 := datum.tick;
    dd2 := dd2 / 50;
    d1 := ((dd1*60) + dd2) - ((d1*60) + d2);
    WriteF('Verbrauchte Zeit in Sekunden: \d\n',d1);

    exitvb()
    Close(inputfile);
    Close(outputfile);

ENDPROC /* MAIN */

PROC writef(s)  /*** dummy version with no normatting */
  Write(stdout,s,StrLen(s))
ENDPROC

PROC inittab()

tab[0] := [   'abcd.b',1,'d', 6,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'abcd.b',1,'-',-1,-1,-1,-1,18,-1,-1,-1,-1,-1,-1,-1,-1,

            'add.b',2,'d',  4,-1, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'add.w',2,'d',  4, 4, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'add.l',2,'d',  6, 8,14,14,16,18,20,18,22,18,20,14,-1,

            'add.b',1,'d',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'add.w',1,'d',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'add.l',1,'d',  6,-1,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'add.w',2,'a', 8, 8,12,12,14,16,18,16,20,16,18,12,-1,
            'add.l',2,'a', 6, 8,14,14,16,18,20,18,22,20,20,14,-1,

            'adda.w',2,'a', 8, 8,12,12,14,16,18,16,20,16,18,12,-1,
            'adda.l',2,'a', 6, 8,14,14,16,18,20,18,22,20,20,14,-1,

            'addi.b',1,'#', 8,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'addi.w',1,'#', 8,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'addi.l',1,'#',16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'add.b',1,'#', 8,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'add.w',1,'#', 8,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'add.l',1,'#',16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'addq.b',1,'#', 4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'addq.w',1,'#', 4, 8,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'addq.l',1,'#', 8, 8,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'addx.b',1,'d',  4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'addx.w',1,'d',  4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'addx.l',1,'d',  8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'addx.b',1,'-', -1,-1,-1,-1,18,-1,-1,-1,-1,-1,-1,-1,-1,
            'addx.w',1,'-', -1,-1,-1,-1,18,-1,-1,-1,-1,-1,-1,-1,-1,
            'addx.l',1,'-', -1,-1,-1,-1,30,-1,-1,-1,-1,-1,-1,-1,-1,

            'and.b',2,'d',  4,-1, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'and.w',2,'d',  4,-1, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'and.l',2,'d',  6,-1,14,14,16,18,20,18,22,18,20,14,-1]

tab[1] := [   'and.b',1,'d',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'and.w',1,'d',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'and.l',1,'d',  6,-1,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'andi.b',1,'#',  8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'andi.w',1,'#',  8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'andi.l',1,'#', 16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'and.b',1,'#',  8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'and.w',1,'#',  8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'and.l',1,'#', 16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'asl.b',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'asl.w',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'asl.l',2,'d', 36,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,13,-1,

            'asl.w',8,' ', -1,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,

            'asr.b',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'asr.w',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'asr.l',2,'d', 36,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,13,-1,

            'asr.w',8,' ', -1,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,

            'bcc.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'bcs.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'bchg.b',1,'d',-1,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'bchg.l',1,'d', 8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'bchg.b',1,'#',-1,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'bchg.l',1,'#',12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'bclr.b',1,'d',-1,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'bclr.l',1,'d', 8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'bclr.b',1,'#',-1,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'bclr.l',1,'#',12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'beq.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'bge.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'bgt.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]

tab[2] := [   'bhi.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'ble.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'bls.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'blt.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'bmi.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'bne.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'bpl.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'bra.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'bset.b',1,'d',-1,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'bset.l',1,'d', 8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'bset.b',1,'#',-1,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'bset.l',1,'#',12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'bsr.s',9,' ', 18,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'btst.b',1,'d',-1,-1, 8, 8,10,12,14,12,16,12,14,-1,-1,
            'btst.l',1,'d', 6,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'btst.b',1,'#',-1,-1,12,12,14,16,18,16,20,16,18,-1,-1,
            'btst.l',1,'#',10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'bvc.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'bvs.s',9,' ', 10,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'clr.b',8,' ',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'clr.w',8,' ',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'clr.l',8,' ',  6,-1,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'cmp.b',2,'d',  4,-1, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'cmp.w',2,'d',  4, 4, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'cmp.l',2,'d',  6, 6,14,14,16,18,20,18,22,18,20,14,-1,

            'cmp.w',2,'a', 6, 6,10,10,12,14,16,14,18,14,16, 8,-1,
            'cmp.l',2,'a', 6, 6,14,14,16,18,20,18,22,18,20,18,-1,

            'cmpa.w',2,'a', 6, 6,10,10,12,14,16,14,18,14,16, 8,-1,
            'cmpa.l',2,'a', 6, 6,14,14,16,18,20,18,22,18,20,18,-1,

            'cmpi.b',1,'#',  8,-1,12,12,14,16,18,16,20,-1,-1,-1,-1]

tab[3] := [   'cmpi.w',1,'#',  8,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'cmpi.l',1,'#', 14,-1,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'cmp.b',1,'#',  8,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'cmp.w',1,'#',  8,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'cmp.l',1,'#', 14,-1,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'cmpm.b',1,'-', -1,-1,-1,-1,12,-1,-1,-1,-1,-1,-1,-1,-1,
            'cmpm.w',1,'-', -1,-1,-1,-1,12,-1,-1,-1,-1,-1,-1,-1,-1,
            'cmpm.l',1,'-', -1,-1,-1,-1,20,-1,-1,-1,-1,-1,-1,-1,-1,

            'dbcc.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbcs.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbeq.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbf.s',9,' ',  14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbge.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbgt.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbhi.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dble.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbls.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dblt.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbmi.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbne.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbpl.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbra.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbvc.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'dbvs.s',9,' ', 14,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'divs.w',2,'d',158,-1,162,162,164,166,168,166,170,166,168,162,-1,
            'divu.w',2,'d',140,-1,144,144,146,148,150,148,152,148,150,144,-1,

            'eor.b',1,'d',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'eor.w',1,'d',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'eor.l',1,'d',  8,-1,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'eori.b',1,'#', 8,-1,16,16,18,20,22,20,24,-1,-1,-1,20]

tab[4] := [   'eori.w',1,'#', 8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'eori.l',1,'#',16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'eor.b',1,'#', 8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'eor.w',1,'#', 8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'eor.l',1,'#',16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'exg.l',2,'d',  6, 6,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'exg.l',2,'a', -1, 6,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'ext.w',8,' ',  4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'ext.l',8,' ',  4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'illegal',9,' ', 34,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'jmp',8,' ', -1,-1, 8,-1,-1,10,14,10,12,10,14,-1,-1,
            'jsr',8,' ', -1,-1,16,-1,-1,18,22,18,20,18,22,-1,-1,

            'lea.l',2,'a', -1,-1, 4,-1,-1, 8,12, 8,12, 8,12,-1,-1,

            'link',9,' ',18,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'lsl.b',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'lsl.w',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'lsl.l',2,'d', 36,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,13,-1,

            'lsl.w',8,' ', -1,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,

            'lsr.b',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'lsr.w',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'lsr.l',2,'d', 36,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,13,-1,

            'lsr.w',8,' ', -1,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,

            'move.b',2,'d', 4,-1, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'move.w',2,'d', 4, 4, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'move.l',2,'d', 4, 4,12,12,14,14,18,16,20,16,18,12,-1,

            'move.b',2,'(', 8,-1,12,12,14,16,18,16,20,16,18,12,-1,
            'move.w',2,'(', 8, 8,12,12,14,16,18,16,20,16,18,12,-1,
            'move.l',2,'(',12,12,20,20,22,24,26,24,28,24,26,20,-1,

            'move.b',2,'+', 8,-1,12,12,14,16,18,16,20,16,18,12,-1,
            'move.w',2,'+', 8, 8,12,12,14,16,18,16,20,16,18,12,-1 ]

tab[5] := [ 'move.l',2,'+',12,12,20,20,22,24,26,24,28,24,26,20,-1,

            'move.b',2,'-', 8,-1,12,12,14,16,18,16,20,16,18,12,-1,
            'move.w',2,'-', 8, 8,12,12,14,16,18,16,20,16,18,12,-1,
            'move.l',2,'-',14,14,20,20,22,24,26,24,28,24,26,20,-1,

            'move.b',2,')',12,-1,16,16,18,20,22,20,24,20,22,16,-1,
            'move.w',2,')',12,12,16,16,18,20,22,20,24,20,22,16,-1,
            'move.l',2,')',16,16,24,24,26,28,30,28,32,28,30,24,-1,

            'move.b',2,'&',14,-1,18,18,20,22,24,22,26,22,24,18,-1,
            'move.w',2,'&',14,14,18,18,20,22,24,22,26,22,24,18,-1,
            'move.l',2,'&',18,18,26,26,28,30,32,20,34,30,32,26,-1,

            'move.b',2,'w',12,-1,16,16,18,20,22,20,24,20,22,16,-1,
            'move.w',2,'w',12,12,16,16,18,20,22,20,24,20,22,16,-1,
            'move.l',2,'w',16,16,24,24,26,28,30,28,32,28,30,24,-1,

            'move.b',2,'l',16,-1,20,20,22,24,26,24,28,24,26,20,-1,
            'move.w',2,'l',16,16,20,20,22,24,26,24,28,24,26,20,-1,
            'move.l',2,'l',20,20,28,28,30,32,34,32,36,32,34,28,-1,

            'move.w',2,'c',12,-1,16,16,18,20,22,20,24,20,22,16,-1,

            'move.w',2,'s',12,-1,16,16,18,20,22,20,24,20,22,16,-1,

            'move.w',1,'s', 6,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,

            'move.l',1,'u',-1, 4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'move.l',2,'u',-1, 4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'move.w',2,'a', 4, 4, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'move.l',2,'a', 4, 4,12,12,14,16,18,16,20,16,18,12,-1,

            'movea.w',2,'a', 4, 4, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'movea.l',2,'a', 4, 4,12,12,14,16,18,16,20,16,18,12,-1,

            'movem.w',2,'r',-1,-1,12,12,-1,16,18,16,20,16,18,-1,-1,
            'movem.l',2,'r',-1,-1,12,12,-1,16,18,16,20,16,18,-1,-1,

            'movem.w',1,'r',-1,-1, 8,-1, 8,12,14,12,16,-1,-1,-1,-1,
            'movem.l',1,'r',-1,-1, 8,-1, 8,12,14,12,16,-1,-1,-1,-1,

            'movep.w',8,' ',-1,-1,-1,-1,-1,16,-1,-1,-1,-1,-1,-1,-1 ]

tab[6] :=   [ 'movep.l',8,' ',-1,-1,-1,-1,-1,24,-1,-1,-1,-1,-1,-1,-1,

            'moveq.l',2,'d',-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1, 4,-1,

            'muls.w',2,'d',70,-1,74,74,76,78,80,78,82,78,80,74,-1,

            'mulu.w',2,'d',70,-1,74,74,76,78,80,78,82,78,80,74,-1,

            'nbcd.b',8,' ', 6,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,

            'neg.b',8,' ',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'neg.w',8,' ',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'neg.l',8,' ',  6,-1,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'nop',0,' ',    4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'not.b',8,' ',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'not.w',8,' ',  4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'not.l',8,' ',  6,-1,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'or.b',2,'d',   4,-1, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'or.w',2,'d',   4,-1, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'or.l',2,'d',   6,-1,14,14,16,18,20,18,22,18,20,14,-1,

            'or.b',1,'d',   4,-1, 8, 8,10,12,14,12,16,-1,-1,-1,-1,
            'or.w',1,'d',   4,-1, 8, 8,10,12,14,12,16,-1,-1,-1,-1,
            'or.l',1,'d',   6,-1,14,14,16,18,20,18,22,-1,-1,-1,-1,

            'ori.b',1,'#',  8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'ori.w',1,'#',  8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'ori.l',1,'#', 16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'or.b',1,'#',  8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'or.w',1,'#',  8,-1,16,16,18,20,22,20,24,-1,-1,-1,20,
            'or.l',1,'#', 16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'pea.l',8,' ', -1,-1,12,-1,-1,16,20,16,20,16,20,-1,-1,

            'reset',0,' ',124,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'rol.b',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'rol.w',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'rol.l',2,'d', 36,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,13,-1,

            'rol.w',8,' ', -1,-1,12,12,14,16,18,16,20,-1,-1,-1,-1]

tab[7] := [ 'ror.b',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'ror.w',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'ror.l',2,'d', 36,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,13,-1,

            'ror.w',8,' ', -1,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,

            'roxl.b',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'roxl.w',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'roxl.l',2,'d', 36,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,13,-1,

            'roxl.w',8,' ', -1,-1,12,12,14,16,16,16,20,-1,-1,-1,-1,

            'roxr.b',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'roxr.w',2,'d', 35,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,11,-1,
            'roxr.l',2,'d', 36,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,13,-1,

            'roxr.w',8,' ', -1,-1,12,12,14,16,16,16,20,-1,-1,-1,-1,

            'rte',9,' ',  20,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'rtr',9,' ',  20,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'rts',9,' ',  12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'sbcd.b',1,'d', 6,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'sbcd.b',1,'-',-1,-1,-1,-1,18,-1,-1,-1,-1,-1,-1,-1,-1,

            'scc.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'scs.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'shi.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'seq.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'sge.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'sgt.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'shi.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'sle.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'sls.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'slt.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'smi.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'sne.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'spl.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1]

tab[8] := [ 'sub.b',2,'d',   4,-1, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'sub.w',2,'d',   4, 4, 8, 8,10,12,14,12,16,12,14, 8,-1,
            'sub.l',2,'d',   6, 8,14,14,16,18,20,18,22,18,20,14,-1,

            'sub.b',1,'d',   4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'sub.w',1,'d',   4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'sub.l',1,'d',   6,-1,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'sub.w',2,'a',   8, 8,12,12,14,16,18,16,20,16,18,12,-1,
            'sub.l',2,'a',   8, 8,14,14,16,18,20,18,22,18,20,14,-1,

            'suba.w',2,'a',   8, 8,12,12,14,16,18,16,20,16,18,12,-1,
            'suba.l',2,'a',   8, 8,14,14,16,18,20,18,22,18,20,14,-1,

            'subi.b',1,'#',   8,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'subi.w',1,'#',   8,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'subi.l',1,'#',  16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'sub.b',1,'#',   8,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'sub.w',1,'#',   8,-1,16,16,18,20,22,20,24,-1,-1,-1,-1,
            'sub.l',1,'#',  16,-1,28,28,30,32,34,32,36,-1,-1,-1,-1,

            'subq.b',1,' ',   4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'subq.w',1,' ',   4, 8,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'subq.l',1,' ',   8, 8,20,20,22,24,26,24,28,-1,-1,-1,-1,

            'subx.b',1,'d',  4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'subx.w',1,'d',  4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,
            'subx.l',1,'d',  8,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'subx.b',1,'-', -1,-1,-1,-1,18,-1,-1,-1,-1,-1,-1,-1,-1,
            'subx.w',1,'-', -1,-1,-1,-1,18,-1,-1,-1,-1,-1,-1,-1,-1,
            'subx.l',1,'-', -1,-1,-1,-1,30,-1,-1,-1,-1,-1,-1,-1,-1,

            'svc.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,
            'svs.b',8,' ',   5,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,

            'swap.w',8,' ',   4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,

            'tas.b',8,' ',    4,-1,14,14,16,18,20,18,22,-1,-1,-1,-1,

            'trap',9,' ',  34,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]

tab[9] := [ 'tst.b',8,' ',    4,-1, 8, 8,10,12,14,12,16,-1,-1,-1,-1,
            'tst.w',8,' ',    4,-1, 8, 8,10,12,14,12,16,-1,-1,-1,-1,
            'tst.l',8,' ',    4,-1,12,12,14,16,18,16,20,-1,-1,-1,-1,

            'unlk.l',8,' ',   -1,12,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
ENDPROC


/*************************************************************************/
PROC anleitung();

    WriteF('\e[1;32;41m');
    WriteF('Usage: Scancode Option(s) Inputfile [Outputfile]               \n');
    WriteF('where                                                          \n');
    WriteF('Options = b ---> make after every branches a sum of the        \n');
    WriteF('                 time befor.                                   \n');
    WriteF('          j ---> make after every jmp or jsr a sum of the      \n');
    WriteF('                 time befor.                                   \n');
    WriteF('          r ---> make after every rte, rtr or rts a sum of the \n');
    WriteF('                 time befor.                                   \n');
    WriteF('          l ---> take after every "blank" Line a sum           \n');
    WriteF('          d ---> direct dialog TO get the time of each machine-\n');
    WriteF('                 command you entered.                          \n');
    WriteF('          t ---> only FOR intern use!                          \n');
    WriteF('          i ---> not realized (YET)!                           \n');
    WriteF('Inputfile   ---> must be a assembler-sourcecode.               \n');
    WriteF('Outputfile  ---> IF you do not enter it, Scancode will give    \n');
    WriteF('                 his output TO a file naming your Inputfile    \n');
    WriteF('                 with the appending .TAKT  .                   \n');
    WriteF('Have a nice day .....                                          \n');
    WriteF('\e[0;31;40m');
    Delay(50);  /* Und wir warten 2 Sekunden. */
    CleanUp(0);
ENDPROC /* Anleitung */

/*************************************************************************/
PROC lesetab(was, el)
/*  lesetab ermittelt aufgrund des übergebenden Zeichens das entsprechen-
    de Tabellenelement und gibt die Taktzyklen zurück. Tabelle muß dabei
    auf die richtige Teiltabelle gesetzt sein. */

    SELECT was
    CASE   "1"
           IF tabelle[el].z1 <> -1 THEN RETURN tabelle[el].z1
    CASE   "2"
           IF tabelle[el].z2 <> -1 THEN RETURN tabelle[el].z2;
    CASE   "3"
           IF tabelle[el].z3 <> -1 THEN RETURN tabelle[el].z3;
    CASE   "4"
           IF tabelle[el].z4 <> -1 THEN RETURN tabelle[el].z4;
    CASE   "5"
           IF tabelle[el].z5 <> -1 THEN RETURN tabelle[el].z5;
    CASE   "6"
           IF tabelle[el].z6 <> -1 THEN RETURN tabelle[el].z6;
    CASE   "7"
           IF tabelle[el].z7 <> -1 THEN RETURN tabelle[el].z7;
    CASE   "8"
           IF tabelle[el].z8 <> -1 THEN RETURN tabelle[el].z8;
    CASE   "9"
           IF tabelle[el].z9 <> -1 THEN RETURN tabelle[el].z9;
    CASE   "A"
           IF tabelle[el].z10 <> -1 THEN RETURN tabelle[el].z10;
    CASE   "B"
           IF tabelle[el].z11 <> -1 THEN RETURN tabelle[el].z11;
    CASE   "C"
           IF tabelle[el].z12 <> -1 THEN RETURN tabelle[el].z12;
    CASE   "D"
           IF tabelle[el].z13 <> -1 THEN RETURN tabelle[el].z13;
    DEFAULT
           RETURN -1
    ENDSELECT

    RETURN -1
ENDPROC /* * lesetab * */

/*************************************************************************/
PROC testvaradr(tt1)
/* Testet den STRING ab, ob eine Variable und eine Adressenadressierung
   vorliegt. Wenn dieses der Fall ist enthält tt den entsprechenden
   aufbereiteten Wert, ansonsten 'x'. * */

DEF tt

    tt := "x";
    REPEAT
    IF inputline[von] = "("
       von++;
       IF (inputline[von] = "a") OR (inputline[von] = "A") OR (inputline[von] = "s") OR (inputline[von] = "S")
                    von := von +2
                    IF (inputline[von] = ")") THEN tt := "6";
                    IF (inputline[von] = ",") THEN tt := "7";
                    IF tt1 = 1 THEN op1 := tt ELSE op2 := tt
                    IF tt <> "x" THEN RETURN;
       ENDIF
       IF (inputline[von] = "p") OR (inputline[von] = "P")
                    von := von +2
                    IF (inputline[von] = ")") THEN tt := "A";
                    IF (inputline[von] = ",") THEN tt := "B";
                    IF tt1 = 1 THEN op1 := tt ELSE op2 := tt
                    IF tt <> "x" THEN RETURN;
       ENDIF
    ENDIF
    von++
    UNTIL (inputline[von] <= " ") OR (inputline[von] = ",") OR (tt <> "x")
ENDPROC  /* testvaradr */

/*************************************************************************/
PROC holebefehl()
/*  Ermittelt den Befehl und gibt dessen Position in von - bis zurück.
    Erfolgt von der PROC die Rückgabe von FALSE dann gabs keinen
    Befehl.  */
DEF tt

    tt := von;
    IF inputline[tt] = 0  /* * Leerzeilen überlesen * */
       von := 0
       IF (verarb1 AND 16) = 16 THEN verarb := 1
       RETURN FALSE
    ENDIF

    IF (inputline[tt] = "*") OR (inputline[tt] = ";") /* * Kommentar überlesen * */
       von := 0;
       RETURN FALSE;
    ENDIF

    IF (inputline[tt] > " ")    /* * Label überlesen * */
          REPEAT
            tt++;
          UNTIL (inputline[tt] <= " ")
    ENDIF

    /* * Jetzt müßten wir am Anfang des Befehls stehen oder .... * */
    IF (inputline[tt] <> "*")  AND
       (inputline[tt] <> ";")  AND
       (inputline[tt] <> 0)
       WHILE inputline[tt] <= " "        /* Leerstelle oder sonstiges */
             tt++;                  /* * Dann Zähler + 1 * */
       ENDWHILE

       /* * So, jetzt müßten wir am Anfang des Befehls stehen. Da
           es aber auch eine Kommentarzeile sein kann, prüfen
           wir dieses noch ab. * */
       IF (inputline[tt] <> "*") OR
          (inputline[tt] <> ";")
          von := tt;   /* * Position merken. * */
          REPEAT
            tt++;
          UNTIL (inputline[tt] <= " ")
          bis := tt
          RETURN TRUE
       ENDIF
    ENDIF
    von := 0;
    RETURN FALSE
ENDPROC /* holebefehl*/

/*************************************************************************/
PROC holeop()
/* Die Funktion ermittelt ab der Position von die OperANDen und
   bereitet sie auf. Wenn op1 oder op2 = ' ' dann gab es keinen
   OperANDen. Gleichzeitig wird die letzte Stelle mitgegeben, wo das
   letzte Zeilenzeichen steht.
*/
DEF tt

    /* * OperANDen vORbesetzen. * */
    op1 := "x";
    op2 := "x";

    /* * Wir suchen solange bis wir ein Zeichen oder EOL gefunden haben. * */
    tt := TRUE;
    WHILE tt
        IF inputline[von] = 0
           op1 := " ";
           op2 := " ";
           RETURN;
        ENDIF
        IF (inputline[von] = ";") OR (inputline[von] = "*")
           op1 := " ";
           op2 := " ";
           RETURN;
        ENDIF
        IF inputline[von] <= " " THEN von++
        IF inputline[von] > " " THEN tt := FALSE /* * Gefunden. * */
    ENDWHILE

    /* * Jetzt haben wir den Anfang des ersten OperANDen gefunden. Jetzt
        gehts ans Auswerten. * */

    /* Liegt eine Speicheradresse vor? */
    IF (inputline[von] = "$") OR ((inputline[von] >= "1") AND (inputline[von] <= "9"))
                REPEAT
                    von++;
                UNTIL (inputline[von] = "(") OR (inputline[von] = ",") OR
                      (inputline[von] <= " ")
                IF inputline[von] = "("
                            von++;
                            IF (inputline[von] = "a") OR
                               (inputline[von] = "A") OR
                               (inputline[von] = "s") OR
                               (inputline[von] = "S")
                               von := von +2   /* * Registernummer überspringen. * */
                               IF (inputline[von] = ")") THEN op1 := "6";
                               IF (inputline[von] = ",")
                                  op1 := "7"
                                  von++
                               ENDIF
                            ENDIF
                            IF (inputline[von] = "p") OR
                               (inputline[von] = "P")
                               von := von +2;   /* * "C" überspringen. * */
                               IF (inputline[von] = ")") THEN op1 := "A";
                               IF (inputline[von] = ",")
                                  op1 := "B"
                                  von++
                               ENDIF
                            ENDIF
                ELSEIF (inputline[von] <= " ")
                            op1 := "9";
                            op2 := " ";
                            RETURN;
                ELSE
                       IF (inputline[von] = ",") THEN op1 := "9";
                ENDIF
    ELSEIF (inputline[von] = "#")
                op1 := "C";
    ELSEIF (inputline[von] = "a") OR
           (inputline[von] = "A")
                von++;
                IF (inputline[von] >= "0") AND
                   (inputline[von] <= "7")
                   von++
                   IF (inputline[von] = ",") OR
                      (inputline[von] = " ")
                      op1 := "2";
                   ENDIF
                   IF (inputline[von] = "-") OR
                      (inputline[von] = "/")
                      op1 := "E";
                   ENDIF
                   IF inputline[von] = 0
                      op1 := "2";
                      op2 := " ";
                      RETURN;
                   ENDIF
                ENDIF
                IF op1 = "x" THEN testvaradr(1);
                IF op1 = "x" THEN op1 := "9";
    ELSEIF (inputline[von] = "d") OR
           (inputline[von] = "D")
                von++;
                IF (inputline[von] >= "0") AND
                   (inputline[von] <= "7")
                   von++;
                   IF (inputline[von] = ",") OR
                      (inputline[von] = " ")
                      op1 := "1";
                   ENDIF
                   IF (inputline[von] = "-") OR
                      (inputline[von] = "/")
                      op1 := "E";
                   ENDIF
                   IF (inputline[von] = 0)
                      op1 := "1";
                      op2 := " ";
                      RETURN;
                   ENDIF
                ENDIF
                IF op1 = "x" THEN testvaradr(1);
                IF op1 = "x" THEN op1 := "9";

    ELSEIF (inputline[von] = "-")
                testvaradr(1);
                IF op1 = "x" THEN op1 := "9";

    ELSEIF (inputline[von] = "(")
                von++;
                IF (inputline[von] = "a") OR
                   (inputline[von] = "A") OR
                   (inputline[von] = "s") OR
                   (inputline[von] = "S")
                   von := von +2;    /*  Registernummer überspringen. * */
                   IF inputline[von] = ","
                      op1 := "7"
                      von++
                   ELSEIF inputline[von] = ")"
                       von++;
                       IF (inputline[von] = "+") THEN op1 := "4"
                       IF (inputline[von] <> "+") THEN op1 := "3"
                   ENDIF
                ENDIF
    ELSEIF (inputline[von] = "c") OR
           (inputline[von] = "C")
                von++;
                IF (inputline[von] = "c") OR
                   (inputline[von] = "C")
                   IF (inputline[von] = "r") OR
                      (inputline[von] = "R")
                      op1 := "D";
                   ENDIF
                ENDIF
                IF op1 = "x" THEN testvaradr(1);
                IF op1 = "x" THEN op1 := "9";

    /* Kommt jetzt der Stackpointer (SP)? */
    ELSEIF (inputline[von] = "s") OR
           (inputline[von] = "S")
                von++;
                IF (inputline[von] = "p") OR
                   (inputline[von] = "P")
                   op1 := "2";
                ENDIF
                IF (inputline[von] = "r") OR
                   (inputline[von] = "R")
                   op1 := "D";
                ENDIF
                IF op1 = "x" THEN testvaradr(1);
                IF op1 = "x" THEN op1 := "9";
    ELSE
                testvaradr(1);
                IF op1 = "x" THEN op1 := "9";
    ENDIF

    /* * Dieses war der erste Streich und der zweite folgt zugleich. * */
    /* * Jetzt suche wir solange bis wir ein EOL oder ein , gefunden
        haben. * */
    tt := TRUE;
    von--;   /* * KORrektur wg. WHILE * */
    WHILE tt
        von++;
        IF (inputline[von] = 39)
           von := von +2;  /* * Das blöde Leerzeichen überspringen * */
           IF (inputline[von] <> 39) THEN von := von +3;
        ENDIF

        IF (inputline[von] = 34)
           von := von +2;  /* * Das blöde Leerzeichen überspringen * */
           IF (inputline[von] <> 34) THEN von := von + 3;
        ENDIF

        IF (inputline[von] <= " ") OR (inputline[von] = ";")
           op2 := " ";
           RETURN;
        ENDIF
        IF inputline[von] = "," THEN tt := FALSE  /* * Gefunden. * */
    ENDWHILE

    /* * Jetzt haben wir den Anfang des zweiten OperANDen gefunden. Jetzt
        gehts ans Auswerten. * */

    von++;   /* * Komma überspringen * */

    IF (inputline[von] = "$") OR ((inputline[von] >= "1") AND (inputline[von] <= "9"))   /* * Zweiten OperANDen holen. * */
                REPEAT
                    von++
                UNTIL (inputline[von] = "(") OR (inputline[von] = ",") OR
                      (inputline[von] <= " ")
                IF inputline[von] = "("
                            von++
                            IF (inputline[von] = "a") OR
                               (inputline[von] = "A") OR
                               (inputline[von] = "s") OR
                               (inputline[von] = "S")
                               von := von +2;   /* * Registernummer überspringen. * */
                               IF (inputline[von] = ")") THEN op2 := "6";
                               IF (inputline[von] = ",")
                                  op2 := "7"
                                  von++
                               ENDIF
                            ENDIF
                            IF (inputline[von] = "p") OR
                               (inputline[von] = "P")
                               von := von +2;   /* * "C" überspringen. * */
                               IF (inputline[von] = ")") THEN op2 := "A";
                               IF (inputline[von] = ",")
                                  op2 := "B"
                                  von++
                               ENDIF
                            ENDIF
                ELSEIF (inputline[von] <= " ")
                            op2 := "9";
                            RETURN;
                ELSE
                       IF (inputline[von] = ",") THEN op2 := "9"
                ENDIF
    ELSEIF inputline[von] = "#"
           op2 := "C";
    ELSEIF (inputline[von] = "a") OR
           (inputline[von] = "A")
                von++
                IF (inputline[von] >= "0") AND
                   (inputline[von] <= "7")
                   von++
                   IF (inputline[von] = ",") OR
                      (inputline[von] <= " ")       /* Merken! */
                      op2 := "2";
                   ENDIF
                   IF (inputline[von] = "-") OR
                      (inputline[von] = "/")
                      op2 := "E";
                   ENDIF
                   IF (inputline[von] = 0)
                      op2 := "2"
                      RETURN
                   ENDIF
                ENDIF
                IF op2 = "x" THEN testvaradr(2);
                IF op2 = "x" THEN op2 := "9";
    ELSEIF (inputline[von] = "d") OR
           (inputline[von] = "D")
                von++
                IF (inputline[von] >= "0") AND
                   (inputline[von] <= "7")
                   von++
                   IF (inputline[von] = ",") OR
                      (inputline[von] <= " ")       /* Merken! */
                      op2 := "1";
                   ENDIF
                   IF (inputline[von] = "-") OR
                      (inputline[von] = "/")
                      op2 := "E";
                   ENDIF
                   IF (inputline[von] = 0)
                      op2 := "1";
                      RETURN;
                   ENDIF
                ENDIF
                IF op2 = "x" THEN testvaradr(2);
                IF op2 = "x" THEN op2 := "9";

    ELSEIF (inputline[von] = "-")
                testvaradr(2);
                IF op2 = "x" THEN op2 := "9";

    ELSEIF (inputline[von] = "(")
                von++
                IF (inputline[von] = "a") OR
                   (inputline[von] = "A") OR
                   (inputline[von] = "s") OR
                   (inputline[von] = "S")
                   von := von +2;    /** Registernummer überspringen. * */
                   IF inputline[von] = ","
                      op2 := "7"
                      von++
                   ELSEIF inputline[von] = ")"
                      von++
                      IF (inputline[von] = "+") THEN op2 := "4";
                      IF (inputline[von] <> "+") THEN op2 := "3";
                   ENDIF
                ENDIF
    ELSEIF (inputline[von] = "c") OR
           (inputline[von] = "C")
                von++
                IF (inputline[von] = "c") OR
                   (inputline[von] = "C")
                   IF (inputline[von] = "r") OR
                      (inputline[von] = "R")
                      op2 := "D";
                   ENDIF
                ENDIF
                IF op2 = "x" THEN testvaradr(2);
                IF op2 = "x" THEN op2 := "9";

    /* Kommt jetzt der Stackpointer (SP)? */
    ELSEIF (inputline[von] = "s") OR
           (inputline[von] = "S")
                von++
                IF (inputline[von] = "p") OR
                   (inputline[von] = "P")
                   op2 := "2";
                ENDIF
                IF (inputline[von] = "r") OR
                   (inputline[von] = "R")
                   op2 := "D";
                ENDIF
                IF op2 = "x" THEN testvaradr(2);
                IF op2 = "x" THEN op2 := "9";
    ELSE
                testvaradr(2);
                IF op2 = "x" THEN op2 := "9";
    ENDIF
ENDPROC /* * Hole Op, Ufff. * */

/*** made PROC out of innerloop of holetakt for profiling */

PROC findtabelle(tt)
    DEF tt8,tt9,aslen,skip,start,start2,to
    IF (asbefehl[]>="a") AND (asbefehl[]<="u")
    skip:=[0,0, 1,17, 2,19, 3,8, 3,26, 9,0, 9,0, 9,0,
           4,9, 4,10, 9,0, 4,12, 4,22, 6,4, 6,12, 6,24,
           9,0, 6,25, 7,15, 8,28, 9,3, 9,0, 9,0, 9,0,
           9,0, 9,0]:CHAR
    start:=skip[asbefehl[]-97*2]
    start2:=skip[asbefehl[]-97*2+1]
    aslen:=EstrLen(asbefehl)
    FOR tt8:= start TO 9
        tabelle := tab[tt8]
        IF tt8<>start THEN start2:=0
        to:=IF tt8=9 THEN 3 ELSE 29
/*
        FOR tt9:= start2 TO to
            IF StrCmp(tabelle[tt9].befehl,asbefehl,aslen) THEN JUMP out
        ENDFOR
*/
        MOVE.L start2,D0
        MOVE.L to,D1
        MOVE.L asbefehl,D2
        MOVE.L aslen,D3
        MOVE.L #SIZEOF tabellendef,D5
        MOVE.L tabelle,A0
        SUBQ.L #1,D3
        SUB.L  D0,D1                    /* D1=counter */
        MULU   D5,D0
        ADDA.L D0,A0                    /* A0=start */
find:   MOVE.L (A0),A1
        MOVE.L D2,A2
        MOVE.L D3,D4
comp:   CMPM.B (A1)+,(A2)+
        BNE.S  next
        DBRA   D4,comp
        BRA.S  out
next:   ADDA.L D5,A0
        DBRA   D1,find

    ENDFOR
    /* Hier darf das Programm eigentlich nie hinkommen. */
    RETURN -1
    out:
    SUB.L  tabelle,A0
    MOVE.L A0,D0
    DIVU   D5,D0
    EXT.L  D0
    MOVE.L D0,tt9

    ^tt:=tt8
    ELSE
      RETURN -1
    ENDIF
ENDPROC tt9

/*************************************************************************/
PROC holetakt()
/* * Ermittelt die Taktzyklen der einzelnen Befehle. Rückgabewerte:
    0  : Kein Befehl in der Zeile,
    -1 : Befehl konnte nicht ermittelt werden,
    -2 : falsche Befehlsart.
* */
DEF tt, tt1, tt2, tt3, tt4,
    tt6, tt7, ttflag
DEF tt8,tt9, temp1

    von := 0; bis := 0
    ttflag := holebefehl()
    tt := von
    tt1 := bis

    IF (verarb1 AND 8) = 8 THEN WriteF('von \d bis \d ',tt,tt1);

    IF ttflag = FALSE THEN RETURN 0; /* * Kein Befehl. * */
    tt2 := bis-von
    MidStr(asbefehl, inputline,von, tt2); /* * Befehl sichern. * */
    LowerStr(asbefehl)

    /* * Jetzt holen wir uns die Operanden und bis wohin die Zeile geht. * */
    von := bis
    holeop(); /* * Operanden aufbereiten. * */
    bis := von
    tt6 := op1
    tt7 := op2

    IF (verarb1 AND 8) = 8 THEN
       WriteF('Inhalt: op1 \d op2 \d Befehl \s\n',tt6,tt7,asbefehl);

    /* * Die Variablen enthalten jetzt folgende Werte:
        tt1 ---> Zeiger auf das letzte Zeilenzeichen nach dem letzten
                 OperANDen,
        asbefehl ---> Befehl,
        tt6 ---> ersten OperANDen,
        tt7 ---> zweiten OperANDen.
        Jetzt müßen wir uns den richtigen tabellenplatz holen.
    * */
    tt4 := 1;

    IF (tt9 := tt4 := findtabelle({tt8}))=-1
        RETURN -1  /*** added */
    ENDIF


    /* * Jetzt prüfen wir, ob eine Zwischensumme ausgegeben wird. * */
    IF (verarb1 AND 1) = 1
       IF (StrCmp(tabelle[tt4].befehl, 'bcc.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bcs.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'beq.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bge.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bgt.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bhi.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'ble.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bls.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'blt.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bmi.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bne.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bpl.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bra.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bsr.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bvc.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'bvs.s',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'dbra.s',ALL))
          verarb := 1;
       ENDIF
    ENDIF

    IF (verarb1 AND 2) = 2
       IF (StrCmp(tabelle[tt4].befehl, 'jmp',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'jsr',ALL)) THEN verarb := 1;
    ENDIF

    IF (verarb1 AND 4) = 4
       IF (StrCmp(tabelle[tt4].befehl, 'rte',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'rtr',ALL)) OR
          (StrCmp(tabelle[tt4].befehl, 'rts',ALL)) THEN verarb := 1;
    ENDIF

    /* * Jetzt wiederholen wir solange die Suche, bis die befehle nicht
        mehr zueinANDer passen. * */
    REPEAT

    IF (verarb1 AND 8) = 8 THEN WriteF('tabellenglied: \d\t',tt4);

    /* * Jetzt müßen wir sicherstellen, daß alles zueinANDer passt. * */
    /* * sourceop * */
    IF StrCmp(asbefehl,tabelle[tt4].befehl, EstrLen(asbefehl))

/* Blöd */
       tt2 := tabelle[tt4].sourceop
       temp1:=Char(tabelle[tt4].sourceopin)
       SELECT tt2
       CASE     0
                    RETURN( tabelle[tt4].z1)
       CASE     9
                    RETURN( tabelle[tt4].z1)
       CASE     8
                    IF tt6 = "x" THEN RETURN(-2)
                    IF tt6 = "1" THEN IF tabelle[tt4].z1 <> -1 THEN RETURN(tabelle[tt4].z1)
                    IF tt6 = "2" THEN IF tabelle[tt4].z2 <> -1 THEN RETURN(tabelle[tt4].z2)
                    IF tt6 = "3" THEN IF tabelle[tt4].z3 <> -1 THEN RETURN(tabelle[tt4].z3)
                    IF tt6 = "4" THEN IF tabelle[tt4].z4 <> -1 THEN RETURN(tabelle[tt4].z4)
                    IF tt6 = "5" THEN IF tabelle[tt4].z5 <> -1 THEN RETURN(tabelle[tt4].z5)
                    IF tt6 = "6" THEN IF tabelle[tt4].z6 <> -1 THEN RETURN(tabelle[tt4].z6)
                    IF tt6 = "7" THEN IF tabelle[tt4].z7 <> -1 THEN RETURN(tabelle[tt4].z7)
                    IF tt6 = "8" THEN IF tabelle[tt4].z8 <> -1 THEN RETURN(tabelle[tt4].z8)
                    IF tt6 = "9" THEN IF tabelle[tt4].z9 <> -1 THEN RETURN(tabelle[tt4].z9)
                    IF tt6 = "A" THEN IF tabelle[tt4].z10 <> -1 THEN RETURN(tabelle[tt4].z10)
                    IF tt6 = "B" THEN IF tabelle[tt4].z11 <> -1 THEN RETURN(tabelle[tt4].z11)
                    IF tt6 = "C" THEN IF tabelle[tt4].z12 <> -1 THEN RETURN(tabelle[tt4].z12)
                    IF tt6 = "D" THEN IF tabelle[tt4].z13 <> -1 THEN RETURN(tabelle[tt4].z13)
       CASE     1
                    IF tt6 <> "x"
                       IF (tt7 <> "x") AND ((temp1 = " ") OR

                          ((temp1 = "d") AND (tt6 = "1")) OR
                          ((temp1 = "a") AND (tt6 = "2")) OR
                          ((temp1 = "(") AND (tt6 = "3")) OR
                          ((temp1 = "+") AND (tt6 = "4")) OR
                          ((temp1 = "-") AND (tt6 = "5")) OR
                          ((temp1 = ")") AND (tt6 = "6")) OR
                          ((temp1 = "&") AND (tt6 = "7")) OR
                          ((temp1 = "w") AND (tt6 = "8")) OR
                          ((temp1 = "l") AND (tt6 = "9")) OR
                          ((temp1 = "c") AND (tt6 = "D")) OR
                          ((temp1 = "s") AND (tt6 = "D")) OR
                          ((temp1 = "u") AND (tt6 = "D")) OR
                          ((temp1 = "#") AND (tt6 = "C")) OR
                          ((temp1 = "r") AND (tt6 = "E")))
                               tt3 := lesetab(tt7,tt4)
                               IF tt3 <> -1 THEN RETURN(tt3)
                       ENDIF
                    ENDIF
           CASE 2

                    IF tt7 <> "x"
                       IF (tt6 <> "x") AND ((temp1 = " ") OR
                          ((temp1 = "d") AND (tt7 = "1")) OR
                          ((temp1 = "a") AND (tt7 = "2")) OR
                          ((temp1 = "(") AND (tt7 = "3")) OR
                          ((temp1 = "+") AND (tt7 = "4")) OR
                          ((temp1 = "-") AND (tt7 = "5")) OR
                          ((temp1 = ")") AND (tt7 = "6")) OR
                          ((temp1 = "&") AND (tt7 = "7")) OR
                          ((temp1 = "w") AND (tt7 = "8")) OR
                          ((temp1 = "l") AND (tt7 = "9")) OR
                          ((temp1 = "c") AND (tt7 = "D")) OR
                          ((temp1 = "s") AND (tt7 = "D")) OR
                          ((temp1 = "u") AND (tt7 = "D")) OR
                          ((temp1 = "#") AND (tt7 = "C")) OR
                          ((temp1 = "r") AND (tt7 = "E")))
                               tt3 := lesetab(tt6,tt4);
                               IF tt3 <> -1 THEN RETURN(tt3)
                       ENDIF
                    ENDIF
       ENDSELECT
    ENDIF
    /* * Tja, wer an diese Stelle noch ankommt, für den passte alles
        nicht. Deshalb wiederholen wir es solange, bis der Befehl
        abweicht. * */
    tt4++
    IF tt4>29
        tt4 := 0
        tt8++
        IF tt8>8
           IF (tt8*30+tt9) > TABCOUNT THEN RETURN -2
        ENDIF
        tabelle := tab[tt8]
    ENDIF
  UNTIL (StrCmp(tabelle[tt4].befehl,asbefehl, 3) = FALSE)
ENDPROC /* * holetakt. * */

PROC getargs(nummer, str : PTR TO LONG)
/* Kopiert das Argument nummer in den String str. Der Rückgabewert
   ist bei Aufruf nummer = 0 die Anzahl der Argumente. Sonst enthält
   der Rückgabewert die Nummer des Arguments oder -1 (wenn kein
   Argument vorhanden gewesen ist).  */
DEF tt=0, tt1=0

   IF nummer = 0 THEN RETURN searchargs(0)
   tt := searchargs(nummer)
   IF tt = -1 THEN RETURN -1
   tt1 := searchargs(nummer+1)
   tt1--
   MidStr(str, arg, tt, tt1-tt)
   RETURN nummer
ENDPROC

PROC searchargs(com)
/* Liefert bei com=0 die Anzahl der Argumente zurück oder
   bei com = 1 die Position des ersten Buchstaben des com.ten Arguments.
   Ist der Returnwert = -1 dann gab es keine Argumente. */
DEF tt=0, tt1=0, tt2=1

    IF (tt:=StrLen(arg)) = 0 THEN RETURN -1
    IF com = 0
        FOR tt1 := 0 TO tt
            IF arg[tt1] = " " THEN tt2++
        ENDFOR
        RETURN tt2
    ELSE
        FOR tt1 := 0 TO tt
            IF tt2 = com THEN RETURN tt1
            IF arg[tt1] = " "
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

PROC    befinf()    /* Gibt Informationen über einen Befehl aus. */
DEF tt1, tt2

    WriteF('Information über einen Befehl. Ende mit \ax\a\n');
    REPEAT
      WriteF('Bitte befehl eingeben ---> ');
      ReadStr(stdout,inputline);
      IF inputline[0] <> "x"
        FOR tt1:= 0 TO 9
            tabelle := tab[tt1]
            FOR tt2:= 0 TO 29
                IF (tt1*30+tt2) > TABCOUNT
                   JUMP befinf1
                ENDIF
                IF StrCmp(tabelle[tt2].befehl,inputline,StrLen(inputline)) = TRUE THEN JUMP befinf2
            ENDFOR
        ENDFOR

befinf1:
        WriteF('Befehl nicht gefunden!\n')
        JUMP befinf3

befinf2:    /* Befehl gefunden, jetzt gehts ans aufbereiten. */
        REPEAT
            WriteF('Befehl: \s\n',tabelle[tt2].befehl)
            WriteF('Dn  An  (An) (An)+ -(An) d(An) d(An,Rx) $xx.W $xx.L d(PC) d(PC,Rx) #xx SR/CCR\n')
            WriteF('-----------------------------------------------------------------------------\n')

            IF tabelle[tt2].z1 = -1 THEN WriteF(' -  ') ELSE WriteF('\z\d[3] ',tabelle[tt2].z1)
            IF tabelle[tt2].z2 = -1 THEN WriteF(' -  ') ELSE WriteF('\z\d[3] ',tabelle[tt2].z2)
            IF tabelle[tt2].z3 = -1 THEN WriteF(' -   ') ELSE WriteF(' \z\d[3] ',tabelle[tt2].z3)
            IF tabelle[tt2].z4 = -1 THEN WriteF(' -    ') ELSE WriteF(' \z\d[3]  ',tabelle[tt2].z4)
            IF tabelle[tt2].z5 = -1 THEN WriteF(' -    ') ELSE WriteF(' \z\d[3]  ',tabelle[tt2].z5)
            IF tabelle[tt2].z6 = -1 THEN WriteF(' -    ') ELSE WriteF(' \z\d[3]  ',tabelle[tt2].z6)
            IF tabelle[tt2].z7 = -1 THEN WriteF(' -      ') ELSE WriteF('  \z\d[3]    ',tabelle[tt2].z7)
            IF tabelle[tt2].z8 = -1 THEN WriteF(' -    ') ELSE WriteF(' \z\d[3]  ',tabelle[tt2].z8)
            IF tabelle[tt2].z9 = -1 THEN WriteF(' -    ') ELSE WriteF(' \z\d[3]  ',tabelle[tt2].z9)
            IF tabelle[tt2].z10 = -1 THEN WriteF(' -    ') ELSE WriteF(' \z\d[3]  ',tabelle[tt2].z10)
            IF tabelle[tt2].z11 = -1 THEN WriteF(' -       ') ELSE WriteF('  \z\d[3]    ',tabelle[tt2].z11)
            IF tabelle[tt2].z12 = -1 THEN WriteF(' -  ') ELSE WriteF('\z\d[3] ',tabelle[tt2].z12)
            IF tabelle[tt2].z13 = -1 THEN WriteF('  - \n') ELSE WriteF('  \z\d[3]\n\n',tabelle[tt2].z13)

            tt2++
        UNTIL (StrCmp(tabelle[tt2].befehl,inputline, 3) = FALSE)

      ENDIF
befinf3:

    UNTIL inputline[0] = "x";
    WriteF('bye bye ...\n');
    CleanUp(0)
ENDPROC

/* Hier kommt der Assemblercode. */
initvb0:
        ADDI.L  #1,(A1)          /* increments counter is_Data points to */
        MOVEQ.L #0,D0            /* set Z flag to continue to process other vb-servers */
        RTS                      /* return to exec */

PROC initvb()
DEF vbln : ln
    vbcounter := 0
    vbint := AllocMem(SIZEOF is, MEMF_PUBLIC+MEMF_CLEAR)   /* interrupt node. */
    vbln  := vbint.ln
    vbln.type := NT_INTERRUPT;         /* Initialize the node. */
    vbln.succ := 0;
    vbln.pred := 0;
    vbln.pri  := -60;
    vbln.name := 'VertB-Example';
    vbint.data := {vbcounter};
    vbint.code := {initvb0};
    AddIntServer(INTB_VERTB, vbint); /* Kick this interrupt server to life. */
ENDPROC

PROC exitvb()
     WriteF('Ticks: \d\n', vbcounter)
     RemIntServer(INTB_VERTB, vbint);
     FreeMem(vbint, SIZEOF is);
ENDPROC

PROC settime()
     timer1 := vbcounter
ENDPROC

PROC gettime()
     WriteF('Ticks: \d\t', vbcounter-timer1)
ENDPROC

PROC readstrbuf(fileh, str:PTR TO CHAR)
/* Liest aus dem Filehandler fileh den String str. */
DEF tt=0
    IF strbuf = NIL
        strbuf := New(STRBUFSIZE)
        IF strbuf = NIL THEN CleanUp(10)
        bufpos := bufend +1
    ENDIF
    LOOP
        IF bufpos > bufend
           IF bufend < STRBUFSIZE THEN RETURN -1 /* EOF */
           bufend := Read(fileh, strbuf, STRBUFSIZE)
           IF (bufend = 0) OR (bufend = -1) THEN RETURN -1 /* EOF */
           bufpos := 0
           tt--
           IF tt < 0 THEN tt:=0
        ENDIF
        str[tt] := strbuf[bufpos]
        bufpos++
        tt++
        IF str[tt-1] = 10
           str[tt-1] := 0
           RETURN 0 /* EOL */
        ENDIF
    ENDLOOP
ENDPROC
