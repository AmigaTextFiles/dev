OPT MODULE

MODULE 'dos/dos'
MODULE 'dos/dostags'
MODULE 'geta4'
MODULE 'utility/tagitem'

DEF proc2bethread, mother

EXPORT PROC birth(proc, name, pri=0, tags=NIL)
   DEF mythread
   /* setting the global */
   proc2bethread:=proc
   /* store A4 */
   storea4()
   /* save mothertask for possible use... */
   mother:=FindTask(0)
   /* the usual...*/
   mythread:=CreateNewProc(
    [
    NP_ENTRY,{threadstart}, -> where the thread process begins
    NP_NAME, name,
    NP_PRIORITY, pri,
    IF tags = NIL THEN TAG_END ELSE TAG_MORE,
    tags
    ])
   IF mythread THEN waitCTRL_F()
ENDPROC mythread

PROC threadstart()
   geta4()
   proc2bethread(mother)
ENDPROC

EXPORT PROC cutstring(mama) IS signalCTRL_F(mama)

EXPORT PROC signalCTRL_F(task)
   Signal(task, SIGBREAKF_CTRL_F)
ENDPROC

EXPORT PROC waitCTRL_F()
   Wait(SIGBREAKF_CTRL_F)
ENDPROC
