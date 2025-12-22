OPT MODULE
OPT EXPORT

MODULE 'whatis', 'libraries/whatis', 'oomodules/file/file'

PROC recognize(file:PTR TO file, typestring)
DEF type, buffer[80]:STRING

  IF file
    NameFromFH(file.handle,buffer,79)

    IF whatisbase=NIL THEN whatisbase := OpenLibrary('whatis.library',0)

    IF whatisbase
      Close(file.handle)
      type := WhatIs(buffer,[WI_DEEP,DEEPTYPE,0,0])
      file.type := type
      IF (CmpFileType( type, GetIDType(typestring)) = 0)
        CloseLibrary(whatisbase)
        file.handle := Open(buffer, file.status)
        RETURN TRUE
      ELSE
        file.handle := Open(buffer, file.status)
      ENDIF
    ENDIF

    CloseLibrary(whatisbase)
  ENDIF

ENDPROC FALSE
