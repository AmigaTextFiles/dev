
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; Change CPU speed on CGB
; Written by Ville Helin <vhelin@cc.hut.fi> in 2000
; v1.1 (08.04.2000) - WLA v3.0+ compatible.
; v1.2 (05.06.2000) - Optimized syntax, WLA v4.3+ required.
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.BANK 0
.ORG $150

.SECTION "SET_CPU_SPEED" FREE

SET_CPU_SPEED_1X:
	LDH	A, ($4D)
	RLCA
	RET	NC			;mode was already 1x.
	JR	_SET_CPU_SPEED_TOGGLE

SET_CPU_SPEED_2X:
	LDH	A, ($4D)
	RLCA
	RET	C			;mode was already 2x.

_SET_CPU_SPEED_TOGGLE:
	DI

	LDH	A, ($FF)
	PUSH	AF

	XOR	A
	LD	(HL), A
	LDH	($0F), A
	LD	A, $30
	LDH	($00), A
	LD	A, %00000001
	LDH	($4D), A

	STOP
	NOP

	POP	AF
	LDH	($FF), A

	EI
	RET

.ENDS
