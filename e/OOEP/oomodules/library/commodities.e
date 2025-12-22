OPT MODULE

MODULE  'oomodules/library',
        'oomodules/object',

        'commodities',
        'libraries/commodities'

EXPORT OBJECT commodities OF library
/****** library/commodities ******************************

    NAME
        commodities() of library --

    SYNOPSIS
        library.commodities()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        library

********/
ENDOBJECT

EXPORT PROC init() OF commodities
/****** commodities/init ******************************

    NAME
        init() of commodities --

    SYNOPSIS
        commodities.init()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        commodities

********/

  self.version:=0
  self.open()

ENDPROC

PROC open() OF commodities
/****** commodities/open ******************************

    NAME
        open() of commodities --

    SYNOPSIS
        commodities.open()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        commodities

********/

  IF cxbase THEN RETURN

  IF (cxbase := OpenLibrary('commodities.library', self.version))=NIL THEN Throw("lib", 'Unable to open commodities.library')

ENDPROC

PROC close() OF commodities
/****** commodities/close ******************************

    NAME
        close() of commodities --

    SYNOPSIS
        commodities.close()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        commodities

********/

  IF cxbase THEN CloseLibrary(cxbase)

ENDPROC



PROC end() OF commodities
/****** commodities/end ******************************

    NAME
        end() of commodities --

    SYNOPSIS
        commodities.end()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        commodities

********/

  self.close()

ENDPROC




PROC name() OF commodities IS 'Commodities'
