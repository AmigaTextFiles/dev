OPT MODULE
OPT EXPORT

MODULE 'oomodules/library', 'reqtools', 'libraries/reqtools'

CONST FILEREQ=0

OBJECT reqtools OF library
  stringbuf
  filebuf
  dirbuf
  number
ENDOBJECT

PROC init() OF reqtools
  self.base := {reqtoolsbase}
  self.name := 'reqtools.library'
  self.version := 37
ENDPROC

PROC name() OF reqtools IS 'ReqTools'

/*
NAME

  ez of reqtools

SYNOPSIS

  ez(body,gadgets,reqinfo=NIL,arglist=NIL,taglist=NIL)

DESCRIPTION

Opens an easy request by calling RtEZRequest with the given arguments.
See there for a description of the avilable tags.

INPUTS

  body - the body text, may contain sequences like \t,\n,\d etc.
  gadgets - the buttons to be drawn, separated with '|'

etc.

SEE ALSO

  RtEZRequest()
*/

PROC ez(body,gadgets,reqinfo=NIL,arglist=NIL,taglist=NIL) OF reqtools

  self.openIfClosed()

  RETURN RtEZRequestA(body,gadgets,reqinfo,arglist,taglist)

ENDPROC

/*
NAME

  string of reqtools

SYNOPSIS

  string(title=NIL,maxlen=200,reqinfo=NIL,taglist=NIL)

DESCRIPTION

  Opens a string requester with RtGetStringA(), see there for a description
  of the parameter.

NOTE

  If the library isn't open already it is opened.
  The resulting string is copied to the entry 'stringbuf' of the object.

SEE ALSO

  RtGetStringA()
*/

PROC string(title=NIL,maxlen=200,reqinfo=NIL,taglist=NIL) OF reqtools

  IF self.base=NIL THEN self.new()

  IF self.stringbuf THEN Dispose(self.stringbuf)
  self.stringbuf := New(maxlen)

  RETURN RtGetStringA(self.stringbuf,maxlen,title,reqinfo,taglist)
ENDPROC

/*
NAME

  end of reqtools

SYNOPSIS

  end()

DESCRIPTION

  Frees all allocated memory for the strings and closes the library.

*/

PROC end() OF reqtools
  IF self.stringbuf THEN Dispose(self.stringbuf)
  IF self.filebuf THEN Dispose(self.filebuf)
  IF self.dirbuf THEN Dispose(self.dirbuf)
  IF reqtoolsbase THEN CloseLibrary(reqtoolsbase)
ENDPROC

/*
NAME

  palette of reqtools

SYNOPSIS

  palette(title=NIL,reqinfo=NIL,taglist=NIL)

DESCRIPTION

  Opens a palette requester with RtPaletteRequestA(), see there for a description
  of the parameters.

SEE ALSO

  RtPaletteRequestA()
*/
PROC palette(title=NIL,reqinfo=NIL,taglist=NIL) OF reqtools

  IF self.base=NIL THEN self.new()

  self.number :=  RtPaletteRequestA(title,reqinfo,taglist)
ENDPROC self.number

PROC long(title=NIL,reqinfo=NIL,taglist=NIL) OF reqtools
DEF number

  IF self.base=NIL THEN self.new()

  RtGetLongA({number}, title, reqinfo, taglist)
  self.number := number
ENDPROC self.number

/*
NAME

  file of reqtools

SYNOPSIS

  file(title=NIL,maxlen=200,tags=NIL)

DESCRIPTION

  Opens a file requester with RtFilerequestA(), see there and associated functions
  for a full description of the parameters.

*/

PROC file(title=NIL,maxlen=200,tags=NIL) OF reqtools HANDLE
DEF req:PTR TO rtfilerequester

  IF self.base=NIL THEN self.new()

  IF req:=RtAllocRequestA(FILEREQ,0)

    IF self.filebuf THEN Dispose(self.filebuf)
    IF self.dirbuf THEN Dispose(self.dirbuf)
    self.filebuf := NewR(maxlen)
    self.dirbuf := NewR(maxlen)

     RtFileRequestA(req,self.filebuf,title,tags)
     AstrCopy(self.dirbuf,req.dir,maxlen)
     RtFreeRequest(req)
 ENDIF

EXCEPT
  NOP
ENDPROC

PROC openIfClosed() OF reqtools
  self.new(["name",'reqtools.library',"vers",37])
ENDPROC
