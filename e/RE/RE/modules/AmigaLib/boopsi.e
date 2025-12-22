OPT MODULE

MODULE 'intuition/classes',
       'intuition/classusr',
       'utility/hooks'

#define DoMethodA(o, m) CoerceMethodA(o::_Object[-1].Class.Dispatcher, o, m)
#define DoSuperMethodA(c, o, m) CoerceMethodA(c::IClass.Super.Dispatcher, o, m)
#define SetSuperAttrsA(c, o, m) CoerceMethodA(c::IClass.Super.Dispatcher, o, [OM_SET, m, NIL])

EXPORT PROC CallHookA(h REG a0,o REG a2,m REG a1)='movem.l\ta2-a3,-(a7) \n\tmove.l\t(8,a0),a3\n\tjsr\t(a3) \n\tmovem.l\t(a7)+,a2-a3'
->ENDPROC

EXPORT PROC CoerceMethodA(h, o, m)
ENDPROC IF h AND o AND m THEN CallHookA(h, o, m) ELSE 0

EXPORT PROC DoMethod(o,m:LIST OF LONG)
ENDPROC CoerceMethodA(o::_Object[-1].Class.Dispatcher, o, m)

EXPORT PROC InstallHook(hook:PTR TO Hook, func)
  hook.SubEntry:=func
  hook.Entry:={hookentry}
ENDPROC hook

PROC hookentry()
ASM
  movem.l d2-d7/a2-a6,-(a7)  ; Save regs
  move.l  a0,-(a7)           ; Stuff parameters on stack for proc call
  move.l  a2,-(a7)
  move.l  a1,-(a7)
  move.l  12(a0),a0          ; Get sub-entry
  jsr     (a0)               ; Execute function
  lea     12(a7),a7          ; Remove parameters
  movem.l (a7)+,d2-d7/a2-a6  ; Restore regs
ENDASM
ENDPROC


