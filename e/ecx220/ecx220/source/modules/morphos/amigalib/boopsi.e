OPT MORPHOS, MODULE, EXPORT, PREPROCESS

-> aboxlib/boopsi.e by LS 2003,4

MODULE 'intuition/classes',
       'intuition/classusr',
       'utility/hooks',
       'morphos/emul/emulinterface',
       'morphos/emul/emulregs'

PROC setSuperAttrsA(cl:PTR TO iclass, obj, msg)
ENDPROC doSuperMethodA(cl, obj, [OM_SET, msg, NIL])

PROC coerceMethodA(cl:PTR TO iclass, obj, msg)
ENDPROC callHookA(cl.dispatcher, obj, msg)

PROC doSuperMethodA(cl:PTR TO iclass, obj, msg)
ENDPROC callHookA(cl.super.dispatcher, obj, msg)

PROC callHookA(hook,obj,msg) -> we receive args in R3,R4,R5
   STW R3, REG_A0 -> hook
   STW R4, REG_A2 -> obj
   STW R5, REG_A1 -> msg
   LWZ R3, .entry(R3:hook)
   LWZ R0, .emulcalldirect68k(R2:emulhandle)
   MTSPR 9, R0
   BCCTRL 20, 0 -> call entry
ENDPROC R3

EXPORT PROC doMethodA(obj, msg:PTR TO msg) -> R3, R4
   ADDI R5, R3, -SIZEOF object /* instance data is to negative offset */
   LWZ R5, .class(R5:object)
   STW R5, REG_A0 -> hook
   STW R4, REG_A1 -> msg
   STW R3, REG_A2 -> obj
   LWZ R3, .entry(R5:hook)   /* get dispatcher from hook in iclass */
   LWZ R0, .emulcalldirect68k(R2:emulhandle)
   MTSPR 9, R0 -> emulfunc to ctr
   BCCTRL 20, 0 -> call func
ENDPROC R3







