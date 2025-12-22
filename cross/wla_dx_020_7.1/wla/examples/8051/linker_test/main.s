
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a small example showing the wla 8051 syntax
; written by ville helin <vhelin@cc.hut.fi> in 2001
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.INCLUDE "defines.i"

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; main
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.BANK 0 SLOT 0
.ORG 0


MAIN:	MOV	A, MAIN-MAIN+32
	MOVC	A, @A+PC
	RET

.SECTION "ahem" FREE

	XRL	A, #%10101011
	ADD	A, 20
	MOV	10, 20
	CJNE	A, 10, 20

.ENDS

.DB "SONG 1" 0
.DEFINE X $80
	ORL C,/X
.DEFINE TMOD $89
	MOV TMOD,$90
.DEFINE T $89
	MOV T,$90
