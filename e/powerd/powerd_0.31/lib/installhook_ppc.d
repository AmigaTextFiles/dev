OPT	NOEXE,PPC

MODULE	'utility/hooks'

PROC InstallHook(hook:PTR TO Hook,sub:PTR)(PTR TO Hook)
	hook.SubEntry:=sub
	hook.Entry:=[
		$48e7,$3f3e,	// movem.l	d2-d7/a2-a6,-(a7)
		$2f08,			// move.l	a0,-(a7)
		$2f0a,			// move.l	a2,-(a7)
		$2f09,			// move.l	a1,-(a7)
		$2068,$000c,	// move.l	(12,a0),a0
		$4e90,			// jsr		(a0)
		$4fef,$000c,	// lea		(12,a7),a7
		$4cdf,$7cfc		// movem.l	(a7)+,d2-d7/a2-a6
		]:UW
ENDPROC hook
