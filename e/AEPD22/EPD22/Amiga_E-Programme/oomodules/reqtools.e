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

PROC new() OF reqtools
  self.open('reqtools.library', 0)
  IF self.base = NIL
    Raise("LIB")
  ELSE
    reqtoolsbase := self.base
  ENDIF
ENDPROC

PROC ez(body,gadgets,dunno,arglist,taglist) OF reqtools
  IF reqtoolsbase
    RETURN RtEZRequestA(body,gadgets,dunno,arglist,taglist)
  ENDIF
ENDPROC

PROC string(title=NIL,maxlen=200,dunno=NIL,dunno2=NIL) OF reqtools
  IF self.stringbuf THEN Dispose(self.stringbuf)
  self.stringbuf := New(maxlen)

  RtGetStringA(self.stringbuf,maxlen,title,dunno,dunno2)
ENDPROC

PROC end() OF reqtools
  IF self.stringbuf THEN Dispose(self.stringbuf)
  CloseLibrary(reqtoolsbase)
ENDPROC

PROC palette(title,dunno=NIL,dunno2=NIL) OF reqtools
  self.number :=  RtPaletteRequestA(title,dunno,dunno2)
ENDPROC self.number

PROC long(title,dunno=NIL,dunno2=NIL) OF reqtools
DEF number
  RtGetLongA({number}, title, dunno, dunno2)
  self.number := number
ENDPROC self.number

PROC file(title,maxlen=200) OF reqtools HANDLE
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
