OPT MODULE

MODULE 'dos/dos'
MODULE 'dos/dostags'
MODULE 'geta4'
MODULE 'utility/tagitem'

ENUM THREAD_INITING=1, THREAD_RUNNING, THREAD_EXITING, THREAD_DEAD

EXPORT OBJECT thread
   PRIVATE
   mothertask
   threadtask
   threadstatus:INT
   proc2bethread
   name[34]:ARRAY OF CHAR
   arg
ENDOBJECT


DEF proc2bethread, threadclass:PTR TO thread

PROC threadstart()
   geta4()
   proc2bethread(threadclass)
ENDPROC

PROC signalCTRL_F(task)
   Signal(task, SIGBREAKF_CTRL_F)
ENDPROC

PROC waitCTRL_F()
   Wait(SIGBREAKF_CTRL_F)
ENDPROC

PROC thread(proc, name=NIL) OF thread
   self.proc2bethread := proc
   self.mothertask := FindTask(0)
   self.threadstatus := THREAD_DEAD
   IF name THEN AstrCopy(self.name, name, 33) ELSE AstrCopy(self.name, 'unnamed', 33)
ENDPROC

PROC setArg(arg) OF thread
   self.arg := arg
ENDPROC

PROC start(pri=NIL, tags=NIL) OF thread
   /* globals */
   threadclass := self
   proc2bethread := self.proc2bethread
   /* start it */
   self.threadtask:=CreateNewProc(
    [
    NP_ENTRY,{threadstart}, -> where the thread process begins
    NP_NAME, self.name,
    NP_PRIORITY, pri,
    IF tags = NIL THEN TAG_END ELSE TAG_MORE,
    tags
    ])
   /* wait for it to initialize */
   IF self.threadtask THEN waitCTRL_F()
   /* we are in buissiness */
   self.threadstatus := THREAD_RUNNING
ENDPROC self.threadtask

PROC kill() OF thread
   IF self.threadtask
      signalCTRL_F(self.threadtask)
      waitCTRL_F()
      RETURN TRUE
   ENDIF
ENDPROC NIL

PROC end() OF thread IS self.kill()

PROC ready() OF thread IS signalCTRL_F(self.mothertask)

PROC getArg() OF thread IS self.arg

PROC imGone() OF thread IS signalCTRL_F(self.mothertask)



