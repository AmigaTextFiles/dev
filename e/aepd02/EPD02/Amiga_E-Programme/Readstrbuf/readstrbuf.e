/*
        readstrbuf
        - Eine Routine für das lesen von gebufferten Strings

*/

MODULE 'dos/dos'

CONST   STRBUFSIZE=256     /* Hier steht die variable Buffergröße. */

DEF strbuf = NIL, bufpos = 0, bufend = STRBUFSIZE /* Globale Variablen. */
DEF inputfile, befehl[255] : STRING, ergebnis,auf

PROC main()
    IF (inputfile := Open('readstrbuf.e', OLDFILE)) = 0 /* Wer wollen den
                                                           Source lesen. */
        WriteF('Could not open Input file!\n');
        RETURN 10 /* Ab dafür, weil nicht da! */
    ENDIF

    REPEAT      /* Solange lesen, bis wir eine -1 bekommen, da EOF erreicht ist. */
        auf++
        ergebnis := readstrbuf(inputfile,befehl)
        WriteF('\s\n',befehl)
    UNTIL ergebnis = -1
    Close(inputfile)

ENDPROC

PROC readstrbuf(fileh, str:PTR TO CHAR)
/* Liest aus dem Filehandler fileh den String str. */
DEF tt=0
    IF strbuf = NIL     /* Wurde der Buffer schon angelegt? */
        strbuf := New(STRBUFSIZE) /* Nein, also Speicher holen. */
        IF strbuf = NIL THEN CleanUp(10) /* Ging schief. */
        bufpos := bufend +1 /* Wichtig, wg. dem Loop. */
    ENDIF
    LOOP    /* Jetzt erfolgt die Berechnung, ob der Buffer noch gelesen
               werden kann oder ob wir wieder Daten von der Disk holen
               müßen. */
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
