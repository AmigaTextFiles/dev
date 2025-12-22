OPT MODULE

MODULE 'intuition/classes', 'utility/hooks', 'intuition/classusr'

/* exemple d'appel: domethod(myobj,[METHODID,...]) */

EXPORT PROC domethod(obj:PTR TO object,msg:PTR TO msg)
  DEF h:PTR TO hook,o:PTR TO object,dispatcher
  IF obj
    o:=obj-SIZEOF object     /* données actuels est en offset négatif */
    h:=o.class
    dispatcher:=h.entry      /* prend le dispatcher du hook dans iclass */
    MOVE.L h,A0
    MOVE.L msg,A1
    MOVE.L obj,A2            /* devrait peut être utiliser CallHookPkt, mais */
    MOVE.L dispatcher,A3     /* le code original (DoMethodA()) ne le faisait pas. */
    JSR (A3)                 /* appelle classDispatcher() */
    MOVE.L D0,o
    RETURN o
  ENDIF
ENDPROC NIL
