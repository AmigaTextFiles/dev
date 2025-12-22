/* Una sufficiente dimensione per il buffer del record */
CONST BUFFERSIZE=512

PROC main()
  DEF filehandle, status, buffer[BUFFERSIZE]:STRING, filename
  filename:='datafile'
  IF filehandle:=Open(filename, OLDFILE)
    REPEAT
      status:=ReadStr(filehandle, buffer)
 /*Questo è il modo per controllare se ReadStr() in effetti legge qualcosa*/
      IF buffer[] OR (status<>-1) THEN process_record(buffer)
    UNTIL status=-1
    /* Se Open() riesce allora dobbiamo Close() il file */
    Close(filehandle)
  ELSE
    WriteF('Errore: Apertura fallita di "\s"\n', filename)
  ENDIF
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
