-> thread.e - the very basic way to setup a thread under v37+

MODULE 'dos/dos'
MODULE 'dos/dostags'
MODULE 'dos/dosextens'
MODULE 'utility/tagitem'

MODULE '*modules/geta4'

PROC main()
  -> pointer to the thread process
  DEF mythread:PTR TO process

  -> store the global data pointer (a4) so the thread can later get this.
  -> IMPORTANT: this must be done before any thread does a geta4().
  -> to be safe, just do it at the begin of main(), as done here.
  storea4()

  -> create a thread process
  IF mythread:=CreateNewProc(
    [
    NP_ENTRY,{thread}, -> where the thread process begins
    NP_NAME,'MyThread', -> the thread process name
    TAG_DONE
    ])

  ENDIF
  Delay(50)

  -> IMPORTANT: the main process may never end when threads are running.
  -> In this small example, we simply wait a while, which is NOT RIGHT!!
  Delay(50)

ENDPROC

PROC thread()
  -> get the global data pointer, previously stored by the main process.
  -> IMPORTANT: do this before using global variables or functioncalls.
  geta4()

  PrintF('Hello, it\as me, your newly created thread.\n')
  PrintF('I stopped now\n')

ENDPROC
