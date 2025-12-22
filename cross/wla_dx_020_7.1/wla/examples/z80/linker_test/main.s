
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a small example showing the wla z80 syntax
; written by ville helin <vhelin@cc.hut.fi> in 1998-2000
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.INCLUDE "defines.i"

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a dummy macro
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.MACRO JESUS
.DB \1, " ", \2, 0
.ENDM

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; main
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.DEFINE SKELETOR $10*2


.BANK 0 SLOT 0
.ORG 0

	
.SECTION "Beginning" FORCE
.DB	"BS"

MAIN:	NOP
	LD	(MAIN+3), HL
	LD	HL, MAIN+3
	LD	(MAIN+3), DE
	LD	HL, MAIN+3
	JP	MORE_ACTION
	RST

.DB	"BE"
.ENDS


.SECTION "Action" SEMIFREE
.DB	"AS"

MORE_ACTION:
	EXX
	DEC	A
	JR	NC, MORE_ACTION
	JP	MORE_ACTION
	RST	$10
	RST	SKELETOR

.DB	"AE"
.ENDS


.SECTION "Copier_1000"
.DB	"CS"

grid_put_sprite:
	PUSH	HL
	POP	IX
	SRL	D
	RRA
	AND	$80
	OR	E
	LD	E, A
	LD	HL, $FC00
	ADD	HL, DE
	LD	B, 8
	LD	DE, 16
_loop:	
/*	LD	A, (IX + 0) */
	LD	(HL), A
	INC	IX
	ADD	HL, DE
	DJNZ	_loop
	RET

.DB	"CE"
.ENDS




.SECTION "BANKHEADER_$20"
.DB	"HS"

.DW MAIN, MORE_ACTION, grid_put_sprite
.DW $FE00

	LD	(MAIN+3), HL
	LD	HL, MAIN+3
	LD	(MAIN+3), DE
	LD	HL, MAIN+3

	JESUS "accept", "rules ok"

.DB	"HE"
.ENDS
