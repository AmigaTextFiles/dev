OPT MODULE
OPT REG=5


MODULE  'oomodules/GUI/requester',
        'oomodules/library/asl',

        'asl',
        'libraries/asl'

EXPORT CONST SR_WINDOW=ASL_WINDOW,
      SR_DIR=ASL_DIR,
      SR_TITLE=ASL_HAIL,
      SR_USESTOREDDIR=42,
      SR_STOREDIR=43

CONST MAXSTORAGE=255

EXPORT OBJECT standardRequester OF requester
/****** requester/standardRequester ******************************

    NAME
        standardRequester() of requester --

    SYNOPSIS
        requester.standardRequester(ARRAY OF CHAR)

        requester.standardRequester(dirStorage)

    FUNCTION

    INPUTS
        dirStorage:ARRAY OF CHAR -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        requester

********/
  dirStorage[255]:ARRAY OF CHAR
ENDOBJECT



DEF asl:PTR TO asl,
    winToAppearOn -> the window the requester should appear on

PROC init() OF standardRequester
/****** standardRequester/init ******************************

    NAME
        init() of standardRequester --

    SYNOPSIS
        standardRequester.init()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/

  IF aslbase=NIL THEN NEW asl.new()
  asl.open()

ENDPROC

EXPORT PROC message(text:PTR TO CHAR) OF standardRequester
/****** standardRequester/message ******************************

    NAME
        message() of standardRequester --

    SYNOPSIS
        standardRequester.message(PTR TO CHAR)

        standardRequester.message(text)

    FUNCTION

    INPUTS
        text:PTR TO CHAR -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/

  EasyRequestArgs(winToAppearOn,[20,0,0,text,'Ok'],0,NIL)

ENDPROC

EXPORT PROC choice(text:PTR TO CHAR) OF standardRequester
/****** standardRequester/choice ******************************

    NAME
        choice() of standardRequester --

    SYNOPSIS
        standardRequester.choice(PTR TO CHAR)

        standardRequester.choice(text)

    FUNCTION

    INPUTS
        text:PTR TO CHAR -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/

  RETURN EasyRequestArgs(winToAppearOn,[20,0,0,text,'Yes|No'],0,NIL)

ENDPROC

EXPORT PROC query(text:PTR TO CHAR, choices:PTR TO CHAR) OF standardRequester
/****** standardRequester/query ******************************

    NAME
        query() of standardRequester --

    SYNOPSIS
        standardRequester.query(PTR TO CHAR, PTR TO CHAR)

        standardRequester.query(text, choices)

    FUNCTION

    INPUTS
        text:PTR TO CHAR -- 

        choices:PTR TO CHAR -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/

  RETURN EasyRequestArgs(winToAppearOn,[20,0,0,text,choices],0,NIL)

ENDPROC

EXPORT PROC getFile(pattern=NIL:PTR TO CHAR, taglist=NIL) OF standardRequester
/****** standardRequester/getFile ******************************

    NAME
        getFile() of standardRequester --

    SYNOPSIS
        standardRequester.getFile(PTR TO CHAR=NIL, LONG=NIL)

        standardRequester.getFile(pattern, taglist)

    FUNCTION

    INPUTS
        pattern:PTR TO CHAR -- 

        taglist:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/

  IF asl THEN RETURN asl.getFileWithPattern(pattern, taglist)

ENDPROC

EXPORT PROC getFont() OF standardRequester IS EMPTY
/****** standardRequester/getFont ******************************

    NAME
        getFont() of standardRequester --

    SYNOPSIS
        standardRequester.getFont()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/

EXPORT PROC getScreen() OF standardRequester IS EMPTY

EXPORT PROC getNumber()  OF standardRequester IS EMPTY

EXPORT PROC getString() OF standardRequester IS EMPTY

EXPORT PROC getLastFileChosen() OF standardRequester
  RETURN asl.lastFileChosen
ENDPROC

EXPORT PROC getLastDirChosen() OF standardRequester
/****** standardRequester/getLastDirChosen ******************************

    NAME
        getLastDirChosen() of standardRequester --

    SYNOPSIS
        standardRequester.getLastDirChosen()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/
  RETURN asl.lastDirChosen
ENDPROC

PROC end() OF standardRequester
/****** standardRequester/end ******************************

    NAME
        end() of standardRequester --

    SYNOPSIS
        standardRequester.end()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/

  asl.close()

ENDPROC

EXPORT PROC setWindowToAppearOn(window) OF standardRequester
/****** standardRequester/setWindowToAppearOn ******************************

    NAME
        setWindowToAppearOn() of standardRequester --

    SYNOPSIS
        standardRequester.setWindowToAppearOn(LONG)

        standardRequester.setWindowToAppearOn(window)

    FUNCTION

    INPUTS
        window:LONG -- 

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/
  winToAppearOn := window
ENDPROC

EXPORT PROC getWindowToAppearOn() OF standardRequester
/****** standardRequester/getWindowToAppearOn ******************************

    NAME
        getWindowToAppearOn() of standardRequester --

    SYNOPSIS
        standardRequester.getWindowToAppearOn()

    FUNCTION

    RESULT

    EXAMPLE

    CREATION

    HISTORY

    NOTES

    SEE ALSO
        standardRequester

********/
  RETURN winToAppearOn
ENDPROC


