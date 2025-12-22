OPT MODULE, POINTER

MODULE 'amigalib/lists',
       'exec/memory',
       'exec/nodes',
       'exec/tasks'
MODULE 'exec'

PRIVATE
OBJECT fakememlist
  ln_succ:PTR TO ln
  ln_pred:PTR TO ln
  ln_type:CHAR
  ln_pri:CHAR
  ln_name:ARRAY OF CHAR
  numentries:INT
  
  tsk_reqs:VALUE
  tsk_length:VALUE
  stk_reqs:VALUE
  stk_length:VALUE
ENDOBJECT
PUBLIC

PROC createTask(name:ARRAY OF CHAR, pri, initPC:ARRAY, stackSize, data=NILA:ARRAY)
  DEF ml:PTR, newTask:PTR TO tc
  stackSize:=(stackSize+3) AND -4  -> Not(3) is -4 (honest!)
  CopyMem([NIL, NIL, 0, 0, NILA, 2,
           MEMF_PUBLIC OR MEMF_CLEAR, SIZEOF tc,
           MEMF_CLEAR, stackSize]:fakememlist,
          ml, SIZEOF fakememlist !!UINT)
  IF ml:=AllocEntry(ml !!PTR TO ml)
    newTask:=ml::fakememlist.tsk_reqs !!PTR TO tc
    newTask.splower:=ml::fakememlist.stk_reqs !!ARRAY
    newTask.spupper:=newTask.splower+stackSize
    newTask.spreg:=newTask.spupper
    newTask.userdata:=data
    newTask.ln.type:=NT_TASK
    newTask.ln.pri:=pri !!BYTE
    newTask.ln.name:=name
    newList(newTask.mementry)
    AddHead(newTask.mementry, ml !!PTR TO ln)
    IF (AddTask(newTask, initPC, NILA)=NIL) AND KickVersion(37)
      FreeEntry(ml !!PTR TO ml)
      RETURN NIL
    ENDIF
  ENDIF
ENDPROC newTask

PROC deleteTask(tc:PTR TO tc) IS RemTask(tc)
