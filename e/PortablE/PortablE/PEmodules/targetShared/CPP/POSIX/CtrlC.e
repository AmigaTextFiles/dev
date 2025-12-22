OPT NATIVE, POINTER
MODULE 'target/signal'

PRIVATE

DEF ctrlc=FALSE:BOOL

PROC handleCtrlC(sig:NATIVE {int} VALUE)
	ctrlc := TRUE
	sig := 0	->dummy
ENDPROC

PROC new()
	signal(SIGINT, CALLBACK handleCtrlC())
ENDPROC

PUBLIC


PROC CtrlC() RETURNS pressed:BOOL
	pressed := ctrlc
	ctrlc := FALSE
ENDPROC
