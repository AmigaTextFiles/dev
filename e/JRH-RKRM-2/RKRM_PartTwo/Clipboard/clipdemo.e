-> Clipdemo.e
->
-> Demonstrate use of clipboard I/O.  Uses general functions provided in the
-> module cbio.  Important note: when this code is run with older versions of
-> the Amiga OS (i.e., before V36) a memory loss of 536 bytes will occur due
-> to bugs in the clipboard device.
 
->>> Header (globals)
MODULE '*cbio',
       'devices/clipboard',
       'dos/dos',
       'exec/ports',
       'amigalib/ports',
       'other/split'

ENUM ERR_NONE, ERR_ARGS, ERR_PORT

ENUM FORGETIT, READIT, WRITEIT, POSTIT
->>>

->>> PROC main()
PROC main() HANDLE
  DEF todo, string, arglist:PTR TO LONG
  todo:=FORGETIT
  -> Very simple code to parse for arguments - will suffice for the sake of
  -> this example
  -> E-Note: use argSplit() to get arguments
  IF NIL=(arglist:=argSplit()) THEN Raise(ERR_ARGS)
  IF ListLen(arglist)>0
    IF StrCmp(arglist[], '-r')
      todo:=READIT
    ELSEIF StrCmp(arglist[], '-w')
      todo:=WRITEIT
    ELSEIF StrCmp(arglist[], '-p')
      todo:=POSTIT
    ENDIF

    string:=NIL

    IF ListLen(arglist)>1 THEN string:=arglist[1]
  ENDIF

  SELECT todo
  CASE READIT
    readClip()
  CASE POSTIT
    postClip(string)
  CASE WRITEIT
    writeClip(string)
  DEFAULT
    WriteF('\nPossible switches are:\n\n'+
'-r            Read, and output contents of clipboard.\n\n'+
'-w [string]   Write string to clipboard.\n\n'+
'-p [string]   Write string to clipboard using the clipboard POST mechanism.\n\n'+
'              The Post can be satisfied by reading data from\n'+
'              the clipboard.  Note that the message may never\n'+
'              be received if some other application posts, or\n')
    WriteF(
'              performs an immediate write to the clipboard.\n\n'+
'              To run this test you must run two copies of this example.\n'+
'              Use the -p switch with one to post data, and the -r switch\n'+
'              with another to read the data.\n\n'+
'              The process can be stopped by using the BREAK command,\n'+
'              in which case this example checks the CLIP write ID\n'+
'              to determine if it should write to the clipboard before\n'+
'              exiting.\n\n')
  ENDSELECT
EXCEPT DO
  SELECT exception
  CASE ERR_ARGS;  WriteF('Error: could not split arguments\n')
  ENDSELECT
ENDPROC
->>>

->>> PROC readClip()
-> Read, and output FTXT in the clipboard.
PROC readClip() HANDLE
  DEF ior=NIL, buf:PTR TO cbbuf
  -> Open clipboard.device unit 0
  ior:=cbOpen(0)
  -> Look for FTXT in clipboard
  IF cbQueryFTXT(ior)
    -> Obtain a copy of the contents of each CHRS chunk
    WHILE buf:=cbReadCHRS(ior)
      -> Process data
      WriteF('\s\n', buf.mem)
      -> Free buffer allocated by cbReadCHRS()
      cbFreeBuf(buf)
    ENDWHILE

    -> The next call is not really needed if you are sure you read to the end of
    -> the clip.
    cbReadDone(ior)
  ELSE
    WriteF('No FTXT in clipboard\n')
  ENDIF
EXCEPT DO
  IF ior THEN cbClose(ior)
  SELECT exception
  CASE "CBOP";  WriteF('Error opening clipboard unit 0\n')
  CASE "CBRD";  WriteF('Error reading from clipboard\n')
  ENDSELECT
  ReThrow()
ENDPROC
->>>

->>> PROC writeClip(string)
-> Write a string to the clipboard
PROC writeClip(string) HANDLE
  DEF ior=NIL:PTR TO ioclipreq
  IF string=NIL
    WriteF('No string argument given\n')
    RETURN
  ENDIF

  -> Open clipboard.device unit 0
  ior:=cbOpen(0)
  cbWriteFTXT(ior, string)
EXCEPT DO
  IF ior THEN cbClose(ior)
  SELECT exception
  CASE "CBWR";  WriteF('Error writing to clipboard: error = \d\n', ior.error)
  CASE "CBOP";  WriteF('Error opening clipboard.device\n')
  ENDSELECT
  ReThrow()
ENDPROC
->>>

->>> PROC postClip(string)
-> Write a string to the clipboard using the POST mechanism
->
-> The POST mechanism can be used by applications which want to defer writing
-> text to the clipboard until another application needs it (by attempting to
-> read it via CMD_READ).  However note that you still need to keep a copy of
-> the data until you receive a SatisfyMsg from the clipboard.device, or your
-> program exits.
->
-> In most cases it is easier to write the data immediately.
->
-> If your program receives the SatisfyMsg from the clipboard.device, you MUST
-> write some data.  This is also how you reply to the message.
->
-> If your program wants to exit before it has received the satisfymsg, you
-> must check the clipid field at the time of the post against the current
-> post ID which is obtained by sending the CBD_CURRENTWRITEID command.
->
-> If the value in clipid (returned by CBD_CURRENTWRITEID) is greater than
-> your post ID, it means that some other application has performed a post, or
-> immediate write after your post, and that you're application will never
-> receive the satisfymsg.
->
-> If the value in clipid (returned by CBD_CURRENTWRITEID) is equal to your
-> post ID, then you must write your data, and send CMD_UPDATE before exiting.
PROC postClip(string) HANDLE
  DEF satisfy=NIL:PTR TO mp, sm:PTR TO satisfymsg, ior=NIL:PTR TO ioclipreq,
      mustwrite, postID
  IF string=NIL
    WriteF('No string argument given\n')
    RETURN
  ENDIF

  IF NIL=(satisfy:=createPort(0, 0)) THEN Raise(ERR_PORT)
  -> Open clipboard.device unit 0
  ior:=cbOpen(0)
  mustwrite:=FALSE

  -> Notify clipboard we have data
  ior.data:=satisfy
  ior.clipid:=0
  ior.command:=CBD_POST
  DoIO(ior)

  postID:=ior.clipid

  WriteF('\nClipID = \d\n', postID)

  -> Wait for CTRL-C break, or message from clipboard
  Wait(SIGBREAKF_CTRL_C OR Shl(1, satisfy.sigbit))

  -> See if we got a message, or a break
  WriteF('Woke up\n')

  IF sm:=GetMsg(satisfy)
    WriteF('Got a message from the clipboard\n\n')

    -> We got a message - we MUST write some data
    mustwrite:=TRUE
    -> E-Note: I think we should reply to the msg...
    ReplyMsg(sm)
  ELSE
    -> Determine if we must write before exiting by checking to see if our
    -> POST is still valid
    ior.command:=CBD_CURRENTWRITEID
    DoIO(ior)

    WriteF('CURRENTWRITEID = \d\n', ior.clipid)

    IF postID>=ior.clipid THEN mustwrite:=TRUE
  ENDIF

  -> Write the string of text
  IF mustwrite
    cbWriteFTXT(ior, string)
  ELSE
    WriteF('No need to write to clipboard\n')
  ENDIF
EXCEPT DO
  IF ior THEN cbClose(ior)
  IF satisfy THEN deletePort(satisfy)
  SELECT exception
  CASE ERR_PORT;  WriteF('Error creating message port\n')
  CASE "CBOP";    WriteF('Error opening clipboard.device\n')
  CASE "CBWR";    WriteF('Error writing to clipboard\n')
  ENDSELECT
  ReThrow()
ENDPROC
->>>

