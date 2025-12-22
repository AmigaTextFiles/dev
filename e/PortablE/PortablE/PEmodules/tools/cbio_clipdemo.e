/* Clipdemo.e
	
	Demonstrate use of clipboard I/O.  Uses general functions provided in the
	module 'cbio'.
*/
OPT POINTER
MODULE '*cbio'
MODULE 'exec'
MODULE 'devices/clipboard', 'dos/dos', 'exec/ports', 'exec/io', 'amigalib/ports', 'other/split'

PRIVATE
ENUM ERR_NONE=0, ERR_ARGS, ERR_PORT
ENUM FORGETIT, READIT, WRITEIT, POSTIT

PROC ior2io(ior:PTR TO ioclipreq) IS ior !!PTR!!PTR TO io
PUBLIC


PROC main()
	DEF todo, string:ARRAY OF CHAR, arglist:LIST
	
	todo := FORGETIT
	->Very simple code to parse for arguments - will suffice for the sake of
	->this example
	->E-Note: use argSplit() to get arguments
	IF (arglist := argSplit())=NILL THEN Raise(ERR_ARGS)
	IF ListLen(arglist) > 0
		IF StrCmp(arglist[0]!!ARRAY OF CHAR, '-r')
			todo := READIT
		ELSE IF StrCmp(arglist[0]!!ARRAY OF CHAR, '-w')
			todo := WRITEIT
		ELSE IF StrCmp(arglist[0]!!ARRAY OF CHAR, '-p')
			todo := POSTIT
		ENDIF
		
		string := NILA
		IF ListLen(arglist) > 1 THEN string := arglist[1] !!ARRAY OF CHAR
	ENDIF
	
	SELECT todo
	CASE READIT
		readClip()
	CASE POSTIT
		postClip(string)
	CASE WRITEIT
		writeClip(string)
	DEFAULT
		Print('\n'+
'Possible switches are:\n\n'+
'-r            Read, and output contents of clipboard.\n\n'+
'-w [string]   Write string to clipboard.\n\n'+
'-p [string]   Write string to clipboard using the clipboard POST mechanism.\n\n'+
'              The Post can be satisfied by reading data from\n'+
'              the clipboard.  Note that the message may never\n'+
'              be received if some other application posts, or\n')
		Print(''+
'              performs an immediate write to the clipboard.\n\n'+
'              To run this test you must run two copies of this example.\n'+
'              Use the -p switch with one to post data, and the -r switch\n'+
'              with another to read the data.\n\n'+
'              The process can be stopped by using the BREAK command,\n'+
'              in which case this example checks the CLIP write ID\n'+
'              to determine if it should write to the clipboard before\n'+
'              exiting.\n\n')
	ENDSELECT
FINALLY
	SELECT exception
	CASE ERR_ARGS;  Print('Error: could not split arguments\n')
	ENDSELECT
ENDPROC


/*	Read, and output FTXT in the clipboard.
*/
PROC readClip()
	DEF ior:PTR TO ioclipreq, buf:PTR TO cbbuf
	
	->Open clipboard.device unit 0
	ior := cbOpen(0)
	->Look for FTXT in clipboard
	IF cbQueryFTXT(ior)
		->Obtain a copy of the contents of each CHRS chunk
		WHILE buf := cbReadCHRS(ior)
			->Process data
			Print('\s\n', buf.mem)
			->Free buffer allocated by cbReadCHRS()
			cbFreeBuf(buf)
		ENDWHILE
		
		->The next call is not really needed if you are sure you read to the end of
		->the clip.
		cbReadDone(ior)
	ELSE
		Print('No FTXT in clipboard\n')
	ENDIF
FINALLY
	IF ior THEN cbClose(ior)
	SELECT exception
	CASE "CBOP";  Print('Error opening clipboard unit 0\n')
	CASE "CBRD";  Print('Error reading from clipboard\n')
	ENDSELECT
ENDPROC


/*	Write a string to the clipboard
*/
PROC writeClip(string:ARRAY OF CHAR)
	DEF ior:PTR TO ioclipreq
	
	IF string = NILA
		Print('No string argument given\n')
		RETURN
	ENDIF
	
	->Open clipboard.device unit 0
	ior := cbOpen(0)
	cbWriteFTXT(ior, string)
FINALLY
	IF ior THEN cbClose(ior)
	SELECT exception
	CASE "CBWR";  Print('Error writing to clipboard: error = \d\n', ior.error)
	CASE "CBOP";  Print('Error opening clipboard.device\n')
	ENDSELECT
ENDPROC


/*	Write a string to the clipboard using the POST mechanism
	
	The POST mechanism can be used by applications which want to defer writing
	text to the clipboard until another application needs it (by attempting to
	read it via CMD_READ).  However note that you still need to keep a copy of
	the data until you receive a SatisfyMsg from the clipboard.device, or your
	program exits.
	
	In most cases it is easier to write the data immediately.
	
	If your program receives the SatisfyMsg from the clipboard.device, you MUST
	write some data.  This is also how you reply to the message.
	
	If your program wants to exit before it has received the satisfymsg, you
	must check the clipid field at the time of the post against the current
	post ID which is obtained by sending the CBD_CURRENTWRITEID command.
	
	If the value in clipid (returned by CBD_CURRENTWRITEID) is greater than
	your post ID, it means that some other application has performed a post, or
	immediate write after your post, and that you're application will never
	receive the satisfymsg.
	
	If the value in clipid (returned by CBD_CURRENTWRITEID) is equal to your
	post ID, then you must write your data, and send CMD_UPDATE before exiting.
*/
PROC postClip(string:ARRAY OF CHAR)
	DEF satisfy:PTR TO mp, sm:PTR TO satisfymsg, ior:PTR TO ioclipreq, mustwrite, postID
	
	IF string = NILA
		Print('No string argument given\n')
		RETURN
	ENDIF
	
	IF (satisfy := createPort(NILA, 0))=NIL THEN Raise(ERR_PORT)
	->Open clipboard.device unit 0
	ior := cbOpen(0)
	mustwrite := FALSE
	
	->Notify clipboard we have data
	ior.data    := satisfy !!PTR!!ARRAY!!ARRAY OF CHAR
	ior.clipid  := 0
	ior.command := CBD_POST
	DoIO(ior2io(ior))
	
	postID := ior.clipid
	
	Print('\nClipID = \d\n', postID)
	
	->Wait for CTRL-C break, or message from clipboard
	Wait(SIGBREAKF_CTRL_C OR (1 SHL satisfy.sigbit))
	
	->See if we got a message, or a break
	Print('Woke up\n')
	
	IF sm := GetMsg(satisfy) !!PTR!!PTR TO satisfymsg
		Print('Got a message from the clipboard\n\n')
		
		->We got a message - we MUST write some data
		mustwrite := TRUE
		->E-Note: I think we should reply to the msg...
		ReplyMsg(sm.msg)
	ELSE
		->Determine if we must write before exiting by checking to see if our
		->POST is still valid
		ior.command := CBD_CURRENTWRITEID
		DoIO(ior2io(ior))
		
		Print('CURRENTWRITEID = \d\n', ior.clipid)
		
		IF postID >= ior.clipid THEN mustwrite := TRUE
	ENDIF
	
	->Write the string of text
	IF mustwrite
		cbWriteFTXT(ior, string)
	ELSE
		Print('No need to write to clipboard\n')
	ENDIF
FINALLY
	IF ior THEN cbClose(ior)
	IF satisfy THEN deletePort(satisfy)
	SELECT exception
	CASE ERR_PORT;  Print('Error creating message port\n')
	CASE "CBOP";    Print('Error opening clipboard.device\n')
	CASE "CBWR";    Print('Error writing to clipboard\n')
	ENDSELECT
ENDPROC
