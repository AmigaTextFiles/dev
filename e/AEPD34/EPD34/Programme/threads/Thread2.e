-> thread2.e - a safer way to implement threads than thread.e

MODULE 'dos/dos'
MODULE 'dos/dostags'
MODULE 'dos/dosextens'
MODULE 'utility/tagitem'

MODULE 'exec/nodes'
MODULE 'exec/ports'
MODULE 'exec/memory'

MODULE '*modules/geta4'

PROC main()
  -> message for interprocess communication
  DEF message:PTR TO mn
  -> port of main process
  DEF port:PTR TO mp
  -> pointer to the thread process
  DEF mythread:PTR TO process

  storea4()

  -> port to talk with thread
  IF port:=CreateMsgPort()

    -> allocate message
    IF message:=AllocMem(SIZEOF mn,MEMF_CLEAR OR MEMF_PUBLIC)

      -> fill in message node
      message::ln.type:=NT_MESSAGE
      message.length:=SIZEOF mn
      message.replyport:=port

      -> create a thread process
      IF mythread:=CreateNewProc(
        [
        NP_ENTRY,{thread}, -> where the thread process begins
        NP_NAME,'MyThread', -> the thread process name
        TAG_DONE
        ])

        -> send the thread a startup message
        PutMsg(mythread.msgport,message)

        /* main program here */

       -> wait for the threads' death
        WaitPort(port)

      ENDIF

      FreeMem(message,SIZEOF mn)
    ENDIF
    DeleteMsgPort(port)
  ENDIF
ENDPROC

PROC thread()
  -> pointer to this process
  DEF thisthread:PTR TO process
  -> pointer to the received message
  DEF message:PTR TO mn

  -> get the global data pointer, previously stored by the main process.
  -> IMPORTANT: do this before using global variables or functioncalls.
  geta4()

  -> find out about ourselves
  thisthread:=FindTask(0)

  -> wait for the startup message (sent by the main process)
  WaitPort(thisthread.msgport)

  -> get the startup message
  message:=GetMsg(thisthread.msgport)

  /* thread program begins here */

  -> useless program, just waits a second
  PrintF('Hello, I\am a newbie thread. It\as nice to be here.\n')
  Delay(50)

  /* thread program ends here */

  -> make sure there is no taskswitching after we replied the message
  Forbid()

  -> reply to main process
  ReplyMsg(message)

-> thread dies here
ENDPROC
