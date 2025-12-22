OPT MODULE

MODULE  'oomodules/library',
        'oomodules/object',

        'gadtools',
        'libraries/gadtools'

EXPORT OBJECT gadtools OF library
ENDOBJECT

EXPORT PROC init() OF gadtools

  self.version:=0
  self.open()

ENDPROC

PROC open() OF gadtools

  IF gadtoolsbase THEN RETURN

  IF (gadtoolsbase := OpenLibrary('gadtools.library', self.version))=NIL THEN Throw("lib", 'Unable to open gadtools.library')

ENDPROC

PROC close() OF gadtools
/****** locale/close ******************************

    NAME
        close() of locale --

    SYNOPSIS
        locale.close()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/

  IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)

ENDPROC


PROC end() OF gadtools
/****** locale/end ******************************

    NAME
        end() of locale --

    SYNOPSIS
        locale.end()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        locale

********/

  self.close()

ENDPROC



PROC name() OF gadtools IS 'Gadtools'
/*EE folds
-1
12 4 15 5 18 27 22 27 
EE folds*/
