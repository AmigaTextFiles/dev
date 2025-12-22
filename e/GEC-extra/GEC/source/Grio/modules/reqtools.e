OPT MODULE



MODULE 'reqtools','libraries/reqtools','utility/tagitem'


EXPORT OBJECT reqtools
    dirbuf
    filebuf
    result
    number
    strbuf
    PRIVATE
    filemulti
    base
    oldbase
    req
    type
ENDOBJECT




EXPORT ENUM ERR_NONE,ERR_LIB,ERR_ALLOC,ERR_BADREQ


RAISE ERR_LIB    IF OpenLibrary()=NIL
RAISE ERR_ALLOC  IF RtAllocRequestA()=NIL


PROC rtopen() OF reqtools
 IF self.base=NIL
    self.oldbase:=reqtoolsbase
    self.base:=reqtoolsbase:=OpenLibrary('reqtools.library',37)
 ENDIF
ENDPROC D0


PROC rtclose() OF reqtools
 reqtoolsbase:=self.oldbase
 IF self.base THEN CloseLibrary(self.base)
 self.base:=NIL
ENDPROC D0


PROC change(tags) OF reqtools IS
 RtChangeReqAttrA(self.req,tags)


PROC new(type,tags=NIL) OF reqtools
IF  reqtoolsbase
    self.rtopen()
    self.req:=RtAllocRequestA(type,tags)
    self.type:=type
ENDIF
ENDPROC D0


PROC file(title,chdir=NIL,maxsize=200,renember=TRUE,tags=NIL) OF reqtools
  DEF res,file,dir
  self.checktype(RT_FILEREQ)
  IF chdir
     self.change([RTFI_DIR,chdir,TAG_DONE])
  ENDIF
  IF file:=New(maxsize)
     IF dir:=New(maxsize)
        IF renember
           IF self.filebuf THEN AstrCopy(file,self.filebuf,maxsize)
           IF self.dirbuf THEN AstrCopy(dir,self.dirbuf,maxsize)
        ENDIF
        self.result:=res:=RtFileRequestA(self.req,file,title,tags)
        self.filemulti:=IF res>1 THEN res ELSE NIL
        AstrCopy(dir,self.req::rtfilerequester.dir,maxsize)
     ELSE
        Raise(ERR_ALLOC)
     ENDIF
  ELSE
     Raise(ERR_ALLOC)
  ENDIF
  Dispose(self.filebuf)
  self.filebuf:=file
  Dispose(self.dirbuf)
  self.dirbuf:=dir
ENDPROC res


PROC ez(title,body,gads=NIL,args=NIL,tags=NIL) OF reqtools
  DEF res
  self.checktype(RT_REQINFO)
  self.result:=res:=RtEZRequestA(body,IF gads THEN gads ELSE 'Ok',
               self.req,args,[RTEZ_REQTITLE,title,IF tags THEN
               TAG_MORE ELSE TAG_DONE,tags,TAG_END])
ENDPROC res


PROC long(title,tags=NIL) OF reqtools
  DEF res
  self.checktype(RT_REQINFO)
  self.result:=res:=RtGetLongA({self.number},title,self.req,tags)
ENDPROC res


PROC string(title,buffsize=200,renember=TRUE,tags=NIL) OF reqtools
  DEF res,str
  self.checktype(RT_REQINFO)
  IF str:=New(buffsize)
     IF self.strbuf
        IF renember THEN AstrCopy(str,self.strbuf,buffsize)
        Dispose(self.strbuf)
     ENDIF
  ENDIF
  self.strbuf:=str
  IF str
     self.result:=res:=RtGetStringA(self.strbuf,buffsize,title,self.req,tags)
  ELSE
     Raise(ERR_ALLOC)
  ENDIF
ENDPROC res


PROC end() OF reqtools
   IF self.filemulti THEN RtFreeFileList(self.filemulti)
   RtFreeRequest(self.req)
   Dispose(self.filebuf)
   Dispose(self.dirbuf)
   Dispose(self.strbuf)
ENDPROC self.rtclose()


PROC checktype(type) OF reqtools
 IF self.type<>type THEN Raise(ERR_BADREQ)
ENDPROC D0




