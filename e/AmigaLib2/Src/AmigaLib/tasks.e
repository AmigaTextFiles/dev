OPT MODULE

MODULE 'amigalib/lists',
       'exec/memory',
       'exec/nodes',
       'exec/tasks'

OBJECT fakememlist
  ln_succ:LONG
  ln_pred:LONG
  ln_type:CHAR
  ln_pri:CHAR
  ln_name:LONG
  numentries:INT
  tsk_reqs:LONG
  tsk_length:LONG
  stk_reqs:LONG
  stk_length:LONG
ENDOBJECT

EXPORT PROC createTask(name, pri, initPC, stackSize, data=NIL)
  DEF ml:fakememlist, newTask=NIL:PTR TO tc
  stackSize:=(stackSize+3) AND -4  -> Not(3) is -4 (honest!)
  CopyMem([0, 0, 0, 0, 0, 2,
           MEMF_PUBLIC OR MEMF_CLEAR, SIZEOF tc,
           MEMF_CLEAR, stackSize]:fakememlist,
          ml, SIZEOF fakememlist)
  IF ml:=AllocEntry(ml)
    newTask:=ml.tsk_reqs
    newTask.splower:=ml.stk_reqs
    newTask.spupper:=newTask.splower+stackSize
    newTask.spreg:=newTask.spupper
    newTask.userdata:=data
    newTask.ln.type:=NT_TASK
    newTask.ln.pri:=pri
    newTask.ln.name:=name
    newList(newTask.mementry)
    AddHead(newTask.mementry, ml)
    IF (AddTask(newTask, initPC, 0)=NIL) AND KickVersion(37)
      FreeEntry(ml)
      RETURN NIL
    ENDIF
  ENDIF
ENDPROC newTask

EXPORT PROC deleteTask(tc) IS RemTask(tc)
