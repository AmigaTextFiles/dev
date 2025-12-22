/* Patches AMOS1.36 to load it's envoironment from T:AMOS1_3.Env */

MODULE 'ReqTools','libraries/reqtools','utility/tagitem','Dos/Dos'


PROC main() HANDLE

  DEF filename[108]:STRING
  DEF file=0

  IF (filename := filereq()) = '' THEN CleanUp(1)


  IF (file := Open(filename,MODE_OLDFILE)) = 0
	WriteF('Could Not Open AMOS1.3\n')
	CleanUp(1)
  ENDIF

  Seek(file,$C08,-1)
  Write(file,'T:AMOS1_3.Env',14)
  Seek(file,$C25,-1)
  Write(file,'T:AMOS1_3.Env',14)
  Seek(file,$C43,-1)
  Write(file,'T:AMOS1_3.Env',14)

  Close(file)
  WriteF('Patching completed OK')

EXCEPT
  IF file=0
     WriteF('Internal Error Occured - File Not Patched\n')
  ELSE
     WriteF('Error while patching file - AMOS1.3 may be corrupted\n')
     Close(file)
  ENDIF
ENDPROC



PROC filereq()

  CONST FILEREQ=0,REQINFO=1

  DEF filebuf[120]:STRING
  DEF dirbuf[256]:STRING
  DEF req:PTR TO rtfilerequester
  DEF tempstr[1]:STRING

  IF reqtoolsbase:=OpenLibrary('reqtools.library',37)

    IF req:=RtAllocRequestA(FILEREQ,0)
      filebuf := 'AMOS1_3.Env'
      RtChangeReqAttrA(req,[RTFI_DIR,'SYS:',TAG_DONE])
      RtFileRequestA(req,filebuf,'Select your AMOS1.3 file',0)
      StrCopy(dirbuf,req.dir,ALL)
      RtFreeRequest(req)

      RightStr(tempstr,dirbuf,1)
      IF StrCmp(tempstr,':',1)=FALSE THEN StrAdd(dirbuf,'/',ALL)
    
      StrAdd(dirbuf,filebuf,ALL)
    ENDIF

    CloseLibrary(reqtoolsbase)
  ELSE

    WriteF('Could not open reqtools.library!\n')

  ENDIF

ENDPROC dirbuf
