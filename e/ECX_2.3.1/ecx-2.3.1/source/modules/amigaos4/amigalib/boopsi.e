OPT AMIGAOS4, MODULE, EXPORT, PREPROCESS

-> amigalib/boopsi.e by LS 2008

MODULE 'intuition/classes',
       'intuition/classusr',
       'utility/hooks'

PROC setSuperAttrsA(cl:PTR TO iclass, obj, msg)
ENDPROC doSuperMethodA(cl, obj, [OM_SET, msg, NIL])

PROC coerceMethodA(cl:PTR TO iclass, obj, msg)
ENDPROC callHookA(cl.dispatcher, obj, msg)

PROC doSuperMethodA(cl:PTR TO iclass, obj, msg)
ENDPROC callHookA(cl.super.dispatcher, obj, msg)

PROC callHookA(hook,obj,msg) -> we receive args in R3,R4,R5
   LWZ R0, .entry(R3:hook)
   MTSPR 9, R0
   BCCTRL 20, 0 -> call entry
ENDPROC R3

EXPORT PROC doMethodA(obj, msg:PTR TO msg) -> R3, R4
   OR R5, R4, R4
   OR R4, R3, R3
   ADDI R3, R3, -SIZEOF object /* instance data is to negative offset */
   LWZ R3, .class(R3:object)
   LWZ R0, .entry(R3:hook)   /* get dispatcher from hook in iclass */
   MTSPR 9, R0 ->  func to ctr
   BCCTRL 20, 0 -> call func
ENDPROC R3







