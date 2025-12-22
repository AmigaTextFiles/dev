/* Copies a selected Envoironment to T:AMOS1_3.Env */

MODULE 'ReqTools','libraries/reqtools','utility/tagitem','Dos/Dos'


PROC main()

  DEF filename[108]:STRING
  DEF infile,outfile,buffer,filesize
  DEF amossys[40]:STRING

  /* Set the default AMOS_System path if no arguments */

  IF arg [] <= 0
    amossys := 'SYS:AMOS_System'
  ELSE
    StrCopy(amossys,arg,ALL)
  ENDIF
    
  /* get The filename */

  IF (filename := filereq(arg)) = '' THEN CleanUp(1)

  /* Copy the file */

  IF (infile := Open(filename,MODE_OLDFILE)) = 0
	WriteF('Could Not Load Envoironment\n')
	CleanUp(1)
  ENDIF

  IF (outfile := Open('T:AMOS1_3.Env',MODE_NEWFILE)) = 0
	WriteF('Could Not Open T:AMOS1_3.Env\n')
	Close(infile)
	CleanUp(1)
  ENDIF

  buffer := New(filesize := FileLength(filename))
  

  IF Read(infile,buffer,filesize) <> filesize
	WriteF('Error Reading Envoironment\n') 
	Close(outfile)
	Close(infile)
	CleanUp(1)
  ENDIF


  IF Write(outfile,buffer,filesize) <> filesize
	WriteF('Error Writing Envoironment\n')
	Close(outfile)
	Close(infile)
	CleanUp(1)
  ENDIF

  Close(outfile)
  Close(infile)

ENDPROC



PROC filereq(amossys)

  CONST FILEREQ=0,REQINFO=1

  DEF filebuf[120]:STRING
  DEF dirbuf[256]:STRING
  DEF req:PTR TO rtfilerequester
  DEF tempstr[1]:STRING

  IF reqtoolsbase:=OpenLibrary('reqtools.library',37)

    /* Setup the requester */

    IF req:=RtAllocRequestA(FILEREQ,0)
      filebuf := 'AMOS1_3.Env'
      RtChangeReqAttrA(req,[RTFI_DIR,amossys,RTFI_MATCHPAT,'#?.Env',TAG_DONE])
      RtFileRequestA(req,filebuf,'Select AMOS Envoironment',[RTFI_FLAGS,FREQF_PATGAD,TAG_DONE])

      /* combine the directory & filename */

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
