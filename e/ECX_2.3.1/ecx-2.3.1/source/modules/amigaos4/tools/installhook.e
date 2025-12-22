OPT MODULE, PREPROCESS, AMIGAOS4

MODULE 'utility/hooks'

-> tools/installhook.e by LS 2008

EXPORT PROC installhook(hook:PTR TO hook, proc)
   hook.subentry := proc
   hook.entry := {hookentry}
   hook.data := R13
ENDPROC hook

PROC hookentry()
   DEF r13
   STW R13, r13
   LWZ R13, .data(R3:hook)
   LWZ R0, .subentry(R3:hook) -> get subentry (PROC)
   MTSPR 9, R0    -> in ctr
   BCCTRL 20, 0   -> call PROC
   LWZ R13, r13
ENDPROC R3
