/* Una sufficiente dimensione per il buffer del record*/
CONST BUFFERSIZE=512

PROC main()
  DEF filehandle, status, buffer[BUFFERSIZE]:STRING, filename
  filename:='datafile'
  IF filehandle:=Open(filename, OLDFILE)
    REPEAT
      status:=ReadStr(filehandle, buffer)
 /*Questo è il modo per controllare se ReadStr() in effetti legge qualcosa */
      IF buffer[] OR (status<>-1) THEN process_record(buffer)
    UNTIL status=-1
    /* Se Open() riesce allora dobbiamo Close() il file */
    Close(filehandle)
  ELSE
    WriteF('Errore: Apertura fallita di "\s"\n', filename)
  ENDIF
ENDPROC

PROC process_record(line)
  DEF i=1, start=0, end, len, s
  /* Mostra l'intera linea da processare */
  WriteF('Processo del record: "\s"\n', line)
  REPEAT
    /* Trova l'indice di una virgola dopo l'indice start */
    end:=InStr(line, ',', start)
    /* La lunghezza è l'indice finale meno l'indice start */
    len:=(IF end<>-1 THEN end ELSE EstrLen(line))-start
    IF len>0
      /* Alloca la lunghezza corretta della E-string */
      IF s:=String(len)
        /* Copia parte della linea nella E-string s */
        MidStr(s, line, start, len)
        /* A questo punto possiamo fare qualcosa di utile... */
        WriteF('\t\d) "\s"\n', i, s)
        /* Abbiamo finito con la E-string quindi la disallochiamo */
        DisposeLink(s)
      ELSE
        /* Non è un errore fatale se la chiamata a String() fallisce */
        WriteF('\t\d) Memoria esaurita! (len=\d)\n', len)
      ENDIF
    ELSE
      WriteF('\t\d) Campo Vuoto\n', i)
    ENDIF
    /* Il nuovo start è dopo la end che abbiamo trovato */
    start:=end+1
    INC i
  /* Quando la virgola non viene trovata abbiamo finito */
  UNTIL end=-1
ENDPROC
