/* Alcune costanti per le exceptions (ERR_NONE è zero: no errore) */
ENUM ERR_NONE, ERR_LEN, ERR_NEW, ERR_OPEN, ERR_READ

/* Rendiamo automatica qualche exceptions */
RAISE ERR_LEN  IF FileLength()<=0,
      ERR_NEW  IF New()=NIL,
      ERR_OPEN IF Open()=NIL

PROC main() HANDLE
  /* Nota la prudente inizializzazione di buffer e filehandle */
  DEF buffer=NIL, filehandle=NIL, len, filename
  filename:='datafile'
  /* Legge quanto è lungo il file */
  len:=FileLength(filename)
  /* Alloca solo lo spazio necessario per i dati + un NIL finale */
  buffer:=New(len+1)
  filehandle:=Open(filename, OLDFILE)
  /* Legge l'intero file, controllando la quantità da leggere */
  IF len<>Read(filehandle, buffer, len) THEN Raise(ERR_READ)
  /* Terminare buffer con un NIL solo in caso... */
  buffer[len]:=NIL
  process_buffer(buffer, len)
EXCEPT DO
  /* Entrambe queste sono sicure grazie alla inizializzazione */
  IF buffer THEN Dispose(buffer)
  IF filehandle THEN Close(filehandle)
  /* Rapporto sull'errore (se ne capita uno) */
  SELECT exception
  CASE ERR_LEN;   WriteF('Errore: "\s" è un file vuoto\n', filename)
  CASE ERR_NEW;   WriteF('Errore: Insufficiente memoria per caricare il file\n')
  CASE ERR_OPEN;  WriteF('Errore: Apertura fallita di "\s"\n', filename)
  CASE ERR_READ;  WriteF('Errore: Errore leggendo il file\n')
  ENDSELECT
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
