OPT MORPHOS, MODULE, NODEFMODS

-> aboxlib/tasks.e
-> ECX V47: now creates ppc task!

MODULE 'exec/memory',
       'exec/nodes',
       'morphos/exec/tasks',
       'morphos/amigalib/lists',
       'morphos/exec'



EXPORT PROC createTask(name, pri, initPC, stackSize, data=NIL)
   DEF newTask
   newTask := NewCreateTaskA([
      TASKTAG_CODETYPE, CODETYPE_PPC,
      TASKTAG_PC, initPC,
      TASKTAG_STACKSIZE, stackSize,
      TASKTAG_STACKSIZE_M68K, 8192,
      TASKTAG_USERDATA, data,
      TASKTAG_PRI, pri,
      NIL])

ENDPROC newTask



EXPORT PROC deleteTask(tc) IS RemTask(tc)




