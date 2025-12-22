OPT MODULE,EXPORT

MODULE 'dos','dos/dos','exec','exec/memory'

PROC loadFile(filename)
  DEF file=0,filelen=0,mem=0:PTR TO LONG

  IF file:=Open(filename,OLDFILE)
    filelen:=FileLength(filename)

    IF mem := AllocVec(filelen+1,MEMF_PUBLIC + MEMF_CLEAR)
      IF Read(file,mem,filelen)<>filelen
        FreeVec(mem)
        mem:=0
        SetIoErr(310) ->random number! since there is not an ERROR_READ
      ENDIF
    ELSE
      SetIoErr(ERROR_NO_FREE_STORE)
    ENDIF
    Close(file)
  ENDIF
ENDPROC mem,filelen

PROC freeFile(mem:PTR TO LONG)
  IF mem THEN FreeVec(mem)
ENDPROC
