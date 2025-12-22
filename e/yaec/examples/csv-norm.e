/* A suitably large size for the record buffer */
CONST BUFFERSIZE=512


PROC main()
  DEF filehandle, status, buffer[BUFFERSIZE]:STRING, filename
  filename:='datafile'
  IF filehandle:=Open(filename, OLDFILE)
    REPEAT
      status:=ReadStr(filehandle, buffer)
      /* This is the way to check ReadStr() actually read something */
      IF buffer[] OR (status<>-1) THEN process_record(buffer)
    UNTIL status=-1
    /* If Open() succeeded then we must Close() the file */
    Close(filehandle)
  ELSE
    WriteF('Error: Failed to open \"\s\"\n', filename)
  ENDIF
ENDPROC

PROC process_record(line)
  DEF i=1, start=0, end, s
  /* Show the whole line being processed */
  WriteF('Processing record: \"\s\"\n', line)
  REPEAT
    /* Find the index of a comma after the start index */
    end:=InStr(line, ',', start)
    /* If a comma was found then terminate with a NIL */
    IF end<>-1 THEN line[end]:=NIL
    /* Point to the start of the field */
    s:=line+start
    IF s[]
      /* At this point we could do something useful... */
      WriteF('\t\d) \"\s\"\n', i, s)
    ELSE
      WriteF('\t\d) Empty Field\n', i)
    ENDIF
    /* The new start is after the end we found */
    start:=end+1
    i++
  /* Once a comma is not found we've finished */
  UNTIL end=-1
ENDPROC
