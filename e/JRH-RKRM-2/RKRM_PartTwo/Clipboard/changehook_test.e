-> Changehook_Test.e
->
-> Demonstrate the use of CBD_CHANGEHOOK command.  The program will set a hook
-> and wait for the clipboard data to change.  You must put something in the
-> clipboard in order for it to return.
->
-> Requires Kickstart 36 or greater.

->>> Header (globals)
MODULE '*cbio',
       'tools/inithook',
       'devices/clipboard',
       'dos/dos',
       'utility/hooks'

DEF version=1

-> Data to pass around with the clipHook
OBJECT chData
  task
  clipID
ENDOBJECT

-> E-Note: clip_port is not actually used...
DEF hook:hook, ch:chData
->>>

->>> PROC clipHook(h:PTR TO hook, o, msg:PTR TO cliphookmsg)
PROC clipHook(h:PTR TO hook, o, msg:PTR TO cliphookmsg)
  DEF ch:PTR TO chData
  ch:=h.data
  IF ch
    -> Remember the ID of clip
    ch.clipID:=msg.clipid

    -> Signal the task that started the hook
    Signal(ch.task, SIGBREAKF_CTRL_E)
  ENDIF
ENDPROC
->>>

->>> PROC openCB(unit)
PROC openCB(unit)
  DEF clipIO:PTR TO ioclipreq
  -> Open clipboard
  -> E-Note: the C version opens 0 instead of using the parameter!
  clipIO:=cbOpen(unit)
  -> Fill out the IORequest
  clipIO.data:=hook
  clipIO.length:=1
  clipIO.command:=CBD_CHANGEHOOK

  -> Set up the hook data
  ch.task:=FindTask(NIL)

  -> Prepare the hook
  inithook(hook, {clipHook}, ch)

  -> Start the hook
  WriteF(IF DoIO(clipIO) THEN 'Unable to set hook\n' ELSE 'Hook set\n')
ENDPROC clipIO
->>>

->>> PROC closeCB(clipIO:PTR TO ioclipreq)
PROC closeCB(clipIO:PTR TO ioclipreq)
  -> Fill out the IO request
  clipIO.data:=hook
  clipIO.length:=0
  clipIO.command:=CBD_CHANGEHOOK

  -> Stop the hook
  WriteF(IF DoIO(clipIO) THEN 'Unable to stop hook\n' ELSE 'Hook is stopped\n')

  cbClose(clipIO)
ENDPROC
->>>

->>> PROC main()
PROC main() HANDLE
  DEF clipIO=NIL, sig_rcvd
  WriteF('Test v\d\n', version)

  clipIO:=openCB(0)
  
  sig_rcvd:=Wait(SIGBREAKF_CTRL_C OR SIGBREAKF_CTRL_E)

  IF sig_rcvd AND SIGBREAKF_CTRL_C
    WriteF('^C received\n')
  ENDIF

  IF sig_rcvd AND SIGBREAKF_CTRL_E
    WriteF('Clipboard change, current ID is \d\n', ch.clipID)
  ENDIF
EXCEPT DO
  IF clipIO THEN closeCB(clipIO)
  SELECT exception
  CASE "CBOP";  WriteF('Error: could not open clipboard device\n')
  ENDSELECT
ENDPROC
->>>

