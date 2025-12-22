OPT MODULE
OPT PREPROCESS

MODULE 'intuition/classes',
       'intuition/classusr',
       'utility/hooks'

EXPORT PROC callHookA(h:PTR TO hook, obj, msg)
-> CallHookPkt would require that caller has the utility library open
  DEF entry
  entry:=h.entry
  MOVE.L h, A0
  MOVE.L msg, A1
  MOVE.L obj, A2
  MOVE.L entry, A3
  JSR (A3)
  MOVE.L D0, entry
ENDPROC entry

EXPORT PROC setSuperAttrsA(cl:PTR TO iclass, obj, msg)
ENDPROC doSuperMethodA(cl, obj, [OM_SET, msg, NIL])

EXPORT PROC coerceMethodA(cl:PTR TO iclass, obj, msg)
  IF obj AND (cl<>NIL)
    RETURN callHookA(cl.dispatcher, obj, msg)
  ENDIF
ENDPROC NIL

EXPORT PROC doSuperMethodA(cl:PTR TO iclass, obj, msg)
  IF obj AND (cl<>NIL)
    RETURN callHookA(cl.super.dispatcher, obj, msg)
  ENDIF
ENDPROC NIL

EXPORT PROC doMethodA(obj, msg)
  DEF o:PTR TO object_
  IF obj
    o:=OBJECT_(obj) -> Get real object
    RETURN callHookA(o.class.dispatcher, obj, msg)
  ENDIF
ENDPROC NIL
