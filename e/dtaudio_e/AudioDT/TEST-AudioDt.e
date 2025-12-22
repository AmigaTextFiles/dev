/* Mini player, using datatypes.library and sound.datatype */

MODULE	'shark/audiodt',
	'reqtools',
	'libraries/reqtools',

	'datatypes/pictureclass'    -> bmhd

PROC main()
DEF file,audio:PTR TO audiodt

file:=filereq('Please choose file');

NEW audio

IF audio.load(file)=0 ; END audio ; CleanUp(0) ; ENDIF

WriteF('SAMPLE POSITION IN MEMORY: $\h\nSAMPLE LENGTH: \d\n',audio.buf,audio.buflen);

audio.setvolume(64);
audio.setperiod(330);
audio.setcycles(1);

audio.play()

WriteF('Ctrl+C to quit...');

REPEAT ; Delay(10); UNTIL CtrlC()

WriteF('\n')
audio.dispose()

END audio

ENDPROC



/********** File Requester (REQTOOLS) ********/
PROC filereq(title)
DEF dir[4096]:STRING,buf[512]:STRING,req:PTR TO rtfilerequester
IF reqtoolsbase:=OpenLibrary('reqtools.library',37)
	IF req:=RtAllocRequestA(0,0)
			RtFileRequestA(req,buf,title,0)
			RtFreeRequest(req)
	ENDIF
CloseLibrary(reqtoolsbase)
IF StrCmp(req.dir,'')=0 THEN StringF(dir,'\s/\s',req.dir,buf) ELSE StrCopy(dir,buf);
RETURN dir
ELSE
WriteF('Cannot open reqtools.library V37\n')
ENDIF
ENDPROC
