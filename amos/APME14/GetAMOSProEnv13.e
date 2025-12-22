/* Get AMOS Env Pro - V1.3 By Paul Hickman ©Mar 1994 */

/* Copies a selected Envoironment to T:AMOSPro_Interpreter_Config */

/* Changes V1.0  ----> V1.1

 * Exception Handling for errors used now

 * If you press Cancel in the file requester, a WARN value is returned

 * If an error occurs, code 20 is returned, add a requester appears.

 * Allows initial pathname argument to be quoted with ""



 * Changes V1.1 ----> V1.2

 * Request title changed




 * Changes V1.2 ----> V1.3

*/

MODULE 'ReqTools','libraries/reqtools','utility/tagitem','Dos/Dos'

ENUM	ER_OPEN=20,ER_READ,ER_WRITE,ER_MEM,FR_LIB,FR_ALLOC

CONST	RW_ERR=-1

RAISE ER_OPEN IF Open()=NIL
RAISE ER_READ IF Read()=RW_ERR
RAISE ER_WRITE IF Write()=RW_ERR
RAISE ER_MEM IF New()=NIL

DEF quitstring[5]:STRING


PROC main() HANDLE

  DEF filename[256]:STRING
  DEF infile,outfile,buffer,filesize
  DEF amossys[256]:STRING

  /* Set the default AMOS_System path if no arguments */

  quitstring := 'Quit'

  IF arg [] <= 0
    amossys := 'SYS:AMOS_Pro/APSystem/Interpreter_Configs'
  ELSE
    IF (arg[0] = 34) AND (arg[StrLen(arg)-1] = 34)
      MidStr(amossys,arg,1,StrLen(arg)-2)
    ELSE
      StrCopy(amossys,arg,ALL)
    ENDIF
  ENDIF

  /* get The filename */

  filereq(filename,amossys)
  IF filename = '' THEN CleanUp(5)

  /* Copy the file */

  infile := Open(filename,MODE_OLDFILE)
  outfile := Open('T:AMOSPro_Interpreter_Config',MODE_NEWFILE)
  buffer := New(filesize := FileLength(filename))
  Read(infile,buffer,filesize) 
  Close(infile)
  Write(outfile,buffer,filesize) 
  Close(outfile)
  



EXCEPT

SELECT exception
  CASE ER_OPEN;      request('Error: Could Not Open A File',quitstring,NIL)
  CASE ER_READ;      request('Error: Could Not Read The Envoironment File',quitstring,NIL)
  CASE ER_WRITE;     request('Error: Could Not Write To The Temporary File',quitstring,NIL)
  CASE ER_MEM;       request('Error: Out Of Memory Error',quitstring,NIL)
  DEFAULT;           request('Error: An IO Error Has Occured',quitstring,NIL)
ENDSELECT

ENDPROC



PROC filereq(dirbuf,amossys) HANDLE

  RAISE FR_LIB IF OpenLibrary()=NIL
  RAISE FR_ALLOC IF RtAllocRequestA()=NIL

  CONST FILEREQ=0,REQINFO=1

  DEF filebuf[120]:STRING
  DEF req:PTR TO rtfilerequester
  DEF tempstr[1]:STRING

  reqtoolsbase:=OpenLibrary('reqtools.library',37)
  req:=RtAllocRequestA(FILEREQ,0)
  filebuf := 'Default.Config'
  RtChangeReqAttrA(req,[RTFI_DIR,amossys,RTFI_MATCHPAT,'#?.Config',TAG_DONE])
  IF RtFileRequestA(req,filebuf,'Select AMOS Pro Configuration',[RTFI_FLAGS,FREQF_PATGAD,TAG_DONE])=FALSE THEN CleanUp(5)

  /* combine the directory & filename */

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
  
ENDPROC

PROC request(body,gadgets,args)
ENDPROC EasyRequestArgs(0,[20,0,'AMOSPro Loader V1.3',body,gadgets],0,args)
