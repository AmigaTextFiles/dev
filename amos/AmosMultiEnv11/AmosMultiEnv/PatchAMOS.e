/* Patches AMOS1.36 to load it's envoironment from T:AMOS1_3.Env */

/* V1.1 changes 

 * Filename may be on command line 

 * Exception Handlers now used for errors

*/

MODULE 'ReqTools','libraries/reqtools','utility/tagitem','Dos/Dos'

ENUM	ER_OPEN=20,ER_READ,ER_WRITE,FR_LIB,FR_ALLOC

CONST	RW_ERR=-1

RAISE ER_OPEN IF Open()=NIL
RAISE ER_READ IF Read()=RW_ERR
RAISE ER_WRITE IF Write()=RW_ERR

DEF quitstring[5]:STRING

PROC main() HANDLE

  DEF file=0
  DEF filename

  quitstring := 'Quit'
  filename := getTheArg()

  file := Open(filename,MODE_OLDFILE)

  Seek(file,$C08,-1)
  Write(file,'T:AMOS1_3.Env',14)
  Seek(file,$C25,-1)
  Write(file,'T:AMOS1_3.Env',14)
  Seek(file,$C43,-1)
  Write(file,'T:AMOS1_3.Env',14)

  Close(file)
  WriteF('Patching completed OK')

EXCEPT

SELECT exception

  CASE ER_OPEN;      request('Error: Could Not Open A File',quitstring,NIL)
  CASE ER_READ;      request('Error: Could Not Read The Envoironment File',quitstring,NIL)
  CASE ER_WRITE;     request('Error: Could Not Write To The Temporary File',quitstring,NIL)
  DEFAULT;	     request('Error: An I/O Error has occured',quitstring,NIL)

ENDSELECT


ENDPROC



PROC filereq() HANDLE

  RAISE FR_LIB IF OpenLibrary()=NIL
  RAISE FR_ALLOC IF RtAllocRequestA()=NIL

  CONST FILEREQ=0,REQINFO=1

  DEF filebuf[120]:STRING
  DEF dirbuf[256]:STRING
  DEF req:PTR TO rtfilerequester
  DEF tempstr[1]:STRING

  reqtoolsbase:=OpenLibrary('reqtools.library',37)
  req:=RtAllocRequestA(FILEREQ,0)
  filebuf := 'AMOS1.3'
  RtChangeReqAttrA(req,[RTFI_DIR,'AMOS:',TAG_DONE])
  IF RtFileRequestA(req,filebuf,'Select your AMOS1.3 file',0)=FALSE THEN CleanUp(5)

  StrCopy(dirbuf,req.dir,ALL)
  RtFreeRequest(req)

  RightStr(tempstr,dirbuf,1)
  IF StrCmp(tempstr,':',1)=FALSE THEN StrAdd(dirbuf,'/',ALL)
  StrAdd(dirbuf,filebuf,ALL)

  CloseLibrary(reqtoolsbase)

EXCEPT

SELECT exception
  CASE FR_LIB;     request('Error: Could Not Open Reqtools Library',quitstring,NIL)
  CASE FR_ALLOC;   request('Error: Could Not Open File Requester',quitstring,NIL)	
  DEFAULT;	   Raise(exception)
ENDSELECT
  

ENDPROC dirbuf





PROC getTheArg()

DEF filename[256]:STRING

IF arg [] > 0
  IF (arg[0] = '"') AND (arg[StrLen(arg)-1] = '"')
    
    MidStr(filename,arg,1,StrLen(arg)-2)
  ELSE
    StrCopy(filename,arg,ALL)
  ENDIF
ELSE
  filename := filereq()
ENDIF

IF filename[0]=0 THEN CleanUp(20)
	
ENDPROC filename

PROC request(body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,'Patch AMOS',body,gadgets],0,args)