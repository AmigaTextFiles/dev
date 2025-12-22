
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a small example showing the wla 6502 syntax
; written by ville helin <vhelin@cc.hut.fi> in 1998-2000
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.INCLUDE "defines.i"

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; main
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.DEFINE _CTRLA $12
.DEFINE _CTRLB $56
.DEFINE _CTRLSEL $90
.DEFINE _CTRLSTA $34


.BANK 0 SLOT 0
.ORG 0


.SECTION "Beginning" FORCE

MAIN:	STA	$1234
	STA	$12
	STA	$1234, X
	STA	($12, X)
	STA	$12, X
	STA	($12), Y
	STA	$1234, Y
	JMP	MORE_ACTION
.ENDS


.SECTION "Action" SEMIFREE

MORE_ACTION:
	AND	#%10101010
	AND	%10101010
	AND	1,X
	AND	%1010101010101010
	AND	$1234,X
	AND	$1234,Y
	AND	($12,X)
	AND	($12),Y
	INC	$10
	INC	$1000
.ENDS


.ORG 0

.SECTION "Mohammed" OVERWRITE
	LSR
	LSR	A
	LSR	10,X
	LSR	1000,X
	LSR	10
	LSR	1000

        LDA     $4016
        LSR
        LDA     $4016
        LSR
        BCS     _CTRLB
        LDA     $4016
        LSR
        BCS     _CTRLSEL
        LDA     $4016
        LSR
.ENDS
