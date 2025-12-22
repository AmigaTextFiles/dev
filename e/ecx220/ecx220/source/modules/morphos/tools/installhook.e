OPT MODULE, PREPROCESS, MORPHOS

MODULE 'morphos/emul/emulinterface', 'morphos/emul/emulregs', 'utility/hooks'

-> toolsabox/installhook.e

EXPORT PROC installhook(hook:PTR TO hook, proc)
   hook.subentry := proc
   hook.entry := [TRAP_LIB SHL 16, {hookentry}]
   hook.data := R13
ENDPROC hook

->gate: INT TRAP_LIB, NIL ; LONG hookentry

PROC hookentry()
   DEF r13
   STW R13, r13
   LWZ R3, REG_A0 -> hook (A0)
   LWZ R4, REG_A2 -> obj (A2)
   LWZ R5, REG_A1 -> msg (A1)
   LWZ R13, .data(R3:hook)
   LWZ R0, .subentry(R3:hook) -> get subentry (PROC)
   MTSPR 9, R0    -> in ctr
   BCCTRL 20, 0   -> call PROC
   LWZ R13, r13
ENDPROC R3


