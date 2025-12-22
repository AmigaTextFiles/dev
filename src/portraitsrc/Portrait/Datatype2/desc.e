OPT PREPROCESS
MODULE 'libraries/iffparse','iffparse','datatypes/datatypes'
PROC main()
  DEF iffhandle=NIL:PTR TO iffhandle, ifferror=NIL
  IF iffparsebase:=OpenLibrary('iffparse.library', 39)
    IF iffhandle:=AllocIFF()
      iffhandle.stream:=Open('WORK', MODE_NEWFILE)
      IF iffhandle.stream<>NIL
        InitIFFasDOS(iffhandle)
        IF (ifferror:=OpenIFF(iffhandle, IFFF_WRITE))=NIL
          IF (ifferror:=PushChunk(iffhandle, ID_DTYP, ID_FORM, IFFSIZE_UNKNOWN))=NIL
            IF (ifferror:=PushChunk(iffhandle, NIL, ID_DTHD, IFFSIZE_UNKNOWN))=NIL
              IF WriteChunkBytes(iffhandle, [], SIZEOF datatypeheader)<>SIZEOF datatypeheader
                ifferror:=IFFERR_WRITE
              ENDIF
              PopChunk(iffhandle)
            ENDIF
          ENDIF
          CloseIFF(iffhandle)
        ENDIF
        IF ifferror<>NIL THEN WriteF('iff error:\d\n', ifferror)
        Close(iffhandle.stream)
      ELSE
        WriteF('no stream!\n')
      ENDIF
      FreeIFF(iffhandle)
    ELSE
      WriteF('no handle!\n')
    ENDIF
    CloseLibrary(iffparsebase)
  ENDIF
ENDPROC