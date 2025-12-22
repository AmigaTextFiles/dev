/*****************************************************
** Easy use of MUI-custom-classes in E.
** Written by Jan Hendrik Schulz
**
** Usage: Simply use eMui_CreateCustomClass() instead of
**        the original Mui_CreateCustomClass()-function.
**        Your dispatcher-function should look like this:
**
**        PROC myDispatcher(cl:PTR TO iclass,obj,msg:PTR TO msg)
**            DEF methodID
**
**            methodID:=msg.methodid
**            SELECT methodID
**                CASE ...
**                ...
**            ENDSELECT
**
**            RETURN doSuperMethodA(cl,obj,msg)
**        ENDPROC
******************************************************/

OPT MODULE

MODULE 'muimaster', 'libraries/mui', 'intuition/classes'

OBJECT data
  user:LONG         -> for userdata (use iclass.userdata[] instead of iclass.userdata)
  dispfunc:LONG     -> holds the address of the dispatcher-function
  storea4:LONG      -> A4 is stored here
ENDOBJECT

EXPORT PROC eMui_CreateCustomClass(base,supername,supermcc,datasize,dispfunc) HANDLE
  DEF mem:PTR TO data, 
      mcc:PTR TO mui_customclass
  
  NEW mem                     -> get some memory
  
  IF (mcc:=Mui_CreateCustomClass(base,supername,supermcc,datasize,{dispentry}))=NIL
    END mem
    RETURN NIL
  ENDIF
  
  MOVE.L mem,A0               -> ptr to data to A0
  MOVE.L mcc,A1               -> ptr to mui_customclass to A1
  MOVE.L 24(A1),A1            -> ptr to iclass to A1
  MOVE.L A0,36(A1)            -> store ptr to data in iclass.userdata
  MOVE.L A4,8(A0)             -> store A4 in data.storea4
  MOVE.L dispfunc,4(A0)       -> store address of dispfunc in data.dispfunc
  
EXCEPT
  RETURN NIL
ENDPROC mcc

dispentry:
  MOVEM.L D2-D7/A2-A6,-(A7)   -> save registers to stack
  
  MOVE.L  A0,-(A7)            -> PTR TO iclass as PROC-arg to stack
  MOVE.L  A2,-(A7)            -> the object as PROC-arg
  MOVE.L  A1,-(A7)            -> the message as PROC-arg
  
  MOVE.L  36(A0),A1           -> iclass.userdate to A1
  MOVE.L  8(A1),A4            -> data.storea4 to A4
  MOVE.L  4(A1),A0            -> data.dispfunc to A0
  JSR     (A0)                -> jump to dispfunc
  
  LEA     12(A7),A7           -> reset stack
  MOVEM.L (A7)+,D2-D7/A2-A6   -> restore registers
  RTS                         -> return to caller

