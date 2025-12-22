MODULE 'bbbf','libraries/bbbf','dos/dos'

DEF readerror
DEF version[30]:ARRAY OF CHAR
->DEF boot[1024]:ARRAY OF CHAR
DEF drive:LONG

DEF boot

OBJECT vinfo
 virus:INT
ENDOBJECT

DEF virusinfo:PTR TO vinfo



PROC main()

boot:=New(1024)

bootblockbase:=OpenLibrary('Bootblock.library',0)
IF bootblockbase=0
  WriteF('couldnt open Bootblock.library\n')
ELSE
  readerror:=ReadBBBF('l:Bootblock.brainfile')

  SELECT readerror
    CASE BBBF_LOADED
      WriteF('OK\n')
    CASE BBBF_ALREADY_LOADED
      WriteF('Brainfile already loaded\n')
    CASE BBBF_NOT_BBBF
      WriteF('File is not a brainfile\n')
    CASE BBBF_CHECKSUM_ERROR 
      WriteF('Brainfile has been corrupted\n')
    CASE BBBF_OUT_OF_MEMORY
      WriteF('No memory for brainfile\n')
    CASE ERROR_OBJECT_NOT_FOUND
      WriteF('Unable to find brainfile\n')
  ENDSELECT

  IF readerror=BBBF_LOADED OR readerror=BBBF_ALREADY_LOADED
    GetBBBFInfo(virusinfo.virus,version)
    WriteF('brainfile \s knows \d virii\n',version,virusinfo.virus)
  ENDIF
  
  readerror:=ReadBoot(0,boot)

  WriteF('\d\n',readerror)
  
  CloseLibrary(bootblockbase)
ENDIF

ENDPROC