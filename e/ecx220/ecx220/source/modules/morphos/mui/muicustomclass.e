OPT MORPHOS, MODULE, PREPROCESS
-> muiabox/muicustomclass.e
-> edited for powerpc abox by LS 2003,04

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

MODULE 'muimaster', 'libraries/mui', 'intuition/classes',
       'morphos/emul/emulinterface', 'morphos/emul/emulregs'

OBJECT data
  user:LONG         -> for userdata (use iclass.userdata[] instead of iclass.userdata)
  dispfunc:LONG     -> holds the address of the dispatcher-function
  globreg:LONG      -> R13 is stored here
ENDOBJECT

EXPORT PROC eMui_CreateCustomClass(base,supername,supermcc,datasize,dispfunc) HANDLE
  DEF mem:PTR TO data,
      mcc:PTR TO mui_customclass

  mcc := Mui_CreateCustomClass(base,supername,supermcc,datasize,
  [TRAP_LIB SHL 16, {dispentry}])
  IF mcc = NIL THEN RETURN NIL

  NEW mem        -> get some memory

  mem.globreg := R13
  mem.dispfunc := dispfunc
  mcc.mcc_class.userdata := mem

EXCEPT

  RETURN NIL

ENDPROC mcc

PROC dispentry()
   DEF r13
   STW R13, r13 -> save globreg
   LWZ R3, REG_A0 -> hook (class)
   LWZ R4, REG_A2 -> object
   LWZ R5, REG_A1 -> message
   LWZ R6, .userdata(R3:iclass) -> iclass.userdata
   LWZ R13, .globreg(R6:data) -> setup globreg
   LWZ R0, .dispfunc(R6:data)  -> dispfunc
   MTSPR 9, R0
   BCCTRL 20, 0   -> call dispatcher PROC
   LWZ R13, r13 -> restore globreg
ENDPROC R3







