	.set AbsExecBase,0x00000004
	.set RawDoFmt,-0x20a

	.text
	.globl _Sprintf

_Sprintf:
	movem.l a2/a3/a6,SP@-
	move.l SP@(16),a3
	move.l SP@(20),a0
	lea SP@(24),a1
	lea PutChProc,a2
	move.l AbsExecBase:W,a6
	jsr a6@(RawDoFmt)
	movem.l SP@+,a2/a3/a6
	rts
PutChProc:
	move.b d0,a3@+
	rts
