OPT INLINE, NATIVE
MODULE 'target/dos/dos', 'target/exec'

PROC CtrlC() RETURNS pressed:BOOL IS SetSignal(0, SIGBREAKF_CTRL_C) AND SIGBREAKF_CTRL_C <> 0
