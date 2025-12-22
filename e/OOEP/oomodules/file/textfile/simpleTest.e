MODULE 'oomodules/file/textfile','oomodules/file/recognize','dos/dos'

PROC main()
DEF datei:PTR TO textfile

  NEW datei.new(["suck",arg])

  WriteF('\a\s\a contains \d bytes', arg, datei.getSize())
  WriteF(' in \d lines.\n', datei.numberOfLines)

  WriteF('Writing the file to ram:textfile.\n')

  datei.writeTo('ram:textfile')

  END datei
ENDPROC

