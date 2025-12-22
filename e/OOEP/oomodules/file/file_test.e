MODULE 'oomodules/file','oomodules/file/recognize','dos/dos'

PROC main()
DEF datei:PTR TO file,
    timestring

  NEW datei

  IF datei.exists(arg)

    datei.open(arg)

    WriteF('\a\s\a contains \d bytes.\n', arg, datei.fib::fileinfoblock.size)

    datei.suck()

    timestring := datei.getDate()
    IF timestring
      WriteF('Last modificated on:\n\s', timestring)
      Dispose(timestring)
    ENDIF

    ->WriteF('\a\s\a\n', datei.contents)
  ENDIF

  END datei
ENDPROC

