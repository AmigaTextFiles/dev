OPT MODULE

MODULE 'exec/tasks'

EXPORT PROC fakestack(param=0)
DEF st:stackswapstruct,stackptr
DEF task:tc,x,stack:PTR TO stackswapstruct
  
  stack:=param
  IF param=0
    stack:=st
    MOVE.L A7,stackptr
    stack.lower:=stackptr-FreeStack()
    stack.upper:=stackptr+136
  ENDIF
  IF KickVersion(37)
    MOVE.L A7,stackptr
    stack.pointer:=stackptr
    StackSwap(stack)
  ELSE
    Forbid()
    task:=FindTask(0)

    x:=task.splower
    task.splower:=stack.lower
    stack.lower:=x

    x:=task.spupper
    task.spupper:=stack.upper
    stack.upper:=x

    Permit()
  ENDIF
ENDPROC stack
