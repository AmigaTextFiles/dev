PROC main()
  DEF buffer, filehandle, len, filename
  filename:='datafile'
  /* Legge quanto è lungo il file */
  IF 0<(len:=FileLength(filename))
    /* Alloca solo lo spazio necessario per i dati + un NIL finale */
    IF buffer:=New(len+1)
      IF filehandle:=Open(filename, OLDFILE)
        /* Legge l'intero file, controllando la quantità da leggere */
        IF len=Read(filehandle, buffer, len)
          /* Terminare buffer con un NIL solo in caso... */
          buffer[len]:=NIL
          process_buffer(buffer, len)
        ELSE
          WriteF('Errore: Errore leggendo il file\n')
        ENDIF
        /* Se Open() riesce allora dobbiamo Close() il file */
        Close(filehandle)
      ELSE
        WriteF('Errore: Apertura fallita "\s"\n', filename)
      ENDIF
      /* Disallochiamo il buffer (non necessario in questo esempio) */
      Dispose(buffer)
    ELSE
      WriteF('Errore: Insufficiente memoria per caricare il file\n')
    ENDIF
  ELSE
    WriteF('Errore: "\s" è un file vuoto\n', filename)
  ENDIF
ENDPROC

/* buffer è visto come una normale stringa se è terminato con NIL */
PROC process_buffer(buffer, len)
  DEF start=0, end
  REPEAT
    /* Trova l'indice di un linefeed dopo l'indice di partenza */
    end:=InStr(buffer, '\n', start)
    /* Se un linefeed viene trovato allora terminare con un NIL */
    IF end<>-1 THEN buffer[end]:=NIL
    process_record(buffer+start)
    start:=end+1
  /* Abbiamo finito se siamo alla fine o non ci sono più linefeeds */
  UNTIL (start>=len) OR (end=-1)
ENDPROC

PROC process_record(line)
  DEF i=1, start=0, end, s
  /* Mostra l'intera linea da processare */
  WriteF('Processo del record: "\s"\n', line)
  REPEAT
    /* Trova l'indice di una virgola dopo l'indice start */
    end:=InStr(line, ',', start)
    /* Se viene trovata una virgola allora terminare con NIL */
    IF end<>-1 THEN line[end]:=NIL
    /* Punta all'inizio del campo */
    s:=line+start
    IF s[]
      /* A questo punto possiamo fare qualcosa di utile... */
      WriteF('\t\d) "\s"\n', i, s)
    ELSE
      WriteF('\t\d) Campo Vuoto\n', i)
    ENDIF
    /* Il nuovo start è dopo la end che abbiamo trovato */
    start:=end+1
    INC i
  /* Quando la virgola non viene trovata abbiamo finito */
  UNTIL end=-1
ENDPROC
