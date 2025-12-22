OPT MODULE
OPT EXPORT

MODULE 'oomodules/library', 'reqtools', 'libraries/reqtools'

CONST FILEREQ=0

-> NOTE: some modifications by JEVR3 here and there.

OBJECT reqtools OF library
/****** library/--library-- ******************************************

    NAME 
        library of object

    PURPOSE
        Basic implementation of a simple library module.

    ATTRIBUTES
        stringbuf -- Address of the buffer for the last character input.

        filebuf -- Address of the buffer for the last file choice.

        dirbuf -- Address of the buffer for the last directory choice.

        number -- Address of the variable that contains the last number
            entered.

    CREATION
        Back in February of 1995 by Gregor Goldbach

    HISTORY

******************************************************************************

History


*/
  stringbuf
  filebuf
  dirbuf
  number
ENDOBJECT

-> JEVR3 addition: init() sets 'reqtools.library' and no version.

PROC init() OF reqtools
/****** reqtools/init ******************************************

    NAME 
        init() -- Initialization of the object.

    SYNOPSIS
        reqtools.init()

    FUNCTION
        Sets the library's name and the version to 0. After that the library
        is opened.

    SEE ALSO
        open()
******************************************************************************

History


*/
 self.name:='reqtools.library'
 self.version:=0
 self.open()
ENDPROC

-> JEVR3 modification: made it one-line (I'm demented)

PROC open() OF reqtools
/****** reqtools/open ******************************************

    NAME 
        open() -- Open reqtools.library

    SYNOPSIS
        reqtools.open()

    FUNCTION
        Opens the reqtools.library.

    EXCEPTIONS
        "lib",{reqtoolOpen} will be raised if the opening fails.

******************************************************************************

History


*/
 IF (reqtoolsbase:=OpenLibrary(self.name,self.version)) = NIL THEN Throw("lib",{reqtoolOpen})
ENDPROC

PROC ez(body,gadgets,dunno=NIL,arglist=NIL,taglist=NIL) OF reqtools
/****** reqtools/ez ******************************************

    NAME 
        ez() -- Display an eazy requester.

    SYNOPSIS
        reqtools.ez(LONG,LONG,LONG=NIL,LONG=NIL,LONG=NIL)

    FUNCTION
        Displays one of those nice ez requesters. Refer to the reqtools
        documentation for input details.

******************************************************************************

History


*/

  IF reqtoolsbase
    RETURN RtEZRequestA(body,gadgets,dunno,arglist,taglist)
  ENDIF
ENDPROC

-> JEVR3 modification; string() returns stringbuf, New() now String()

PROC string(title=NIL,maxlen=200,dunno=NIL,dunno2=NIL) OF reqtools
/****** reqtools/string ******************************************

    NAME 
        string() -- Asks for a character input.

    SYNOPSIS
        reqtools.string(LONG=NIL,LONG=NIL,LONG=NIL,LONG=NIL)

    FUNCTION
        Asks for a string input. For further documentation refer to the
        reqtools document.

    RESULT
        PTR TO CHAR -- Address of the string entered.

******************************************************************************

History


*/
  IF self.stringbuf THEN Dispose(self.stringbuf)
  self.stringbuf := String(maxlen)

  RtGetStringA(self.stringbuf,maxlen,title,dunno,dunno2)
ENDPROC self.stringbuf

-> JEVR3 modification; changed 'end()' to 'close()'.  'end()' still works,
-> since it calls 'self.close()'

PROC close() OF reqtools
/****** reqtools/close ******************************************

    NAME 
        close() -- Close the library.

    SYNOPSIS
        reqtools.close()

    FUNCTION
        Closes the library.

    SEE ALSO
        open()
******************************************************************************

History


*/
  IF self.stringbuf THEN DisposeLink(self.stringbuf)
  CloseLibrary(reqtoolsbase)
ENDPROC

PROC palette(title,dunno=NIL,dunno2=NIL) OF reqtools
/****** reqtools/palette ******************************************

    NAME 
        palette() -- Pop up palette requester.

    SYNOPSIS
        reqtools.palette(LONG,LONG=NIL,LONG=NIL)

    FUNCTION
        Display reqtools' palette requester.

    RESULT
        number of colour chosen.

******************************************************************************

History


*/
  self.number :=  RtPaletteRequestA(title,dunno,dunno2)
ENDPROC self.number

PROC long(title,number=NIL,dunno=NIL,dunno2=NIL) OF reqtools
/****** reqtools/long ******************************************

    NAME
        long() -- Pop up long integer requester.

    SYNOPSIS
        reqtools.long(LONG,LONG=NIL,LONG=NIL,LONG=NIL)

    FUNCTION
        Display a requester that asks for a long integer to be entered.
        For more documentation refer to the reqtools manual.

******************************************************************************

History


*/
  RtGetLongA({number}, title, dunno, dunno2)
  self.number := number
ENDPROC self.number

PROC file(title,maxlen=200) OF reqtools HANDLE
/****** reqtools/file ******************************************

    NAME 
        file() -- Get file via requester.

    SYNOPSIS
        reqtools.file(PTR TO CHAR,LONG)

    FUNCTION
        Select a file via file requester. The file and directory choices
        are copied to the according attributes.

******************************************************************************

History


*/
DEF req:PTR TO rtfilerequester

  IF req:=RtAllocRequestA(FILEREQ,0)

    IF self.filebuf THEN Dispose(self.filebuf)
    IF self.dirbuf THEN Dispose(self.dirbuf)
    self.filebuf := NewR(maxlen)
    self.dirbuf := NewR(maxlen)

     RtFileRequestA(req,self.filebuf,title,0)
     AstrCopy(self.dirbuf,req.dir,maxlen)
     RtFreeRequest(req)
 ENDIF

EXCEPT
  NOP
ENDPROC

reqtoolOpen:
 CHAR 'Unable to open reqtools.library.',0
/*EE folds
-1
10 34 14 23 19 21 22 22 27 25 33 21 36 21 39 20 42 34 
EE folds*/
