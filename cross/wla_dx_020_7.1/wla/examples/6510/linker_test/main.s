
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a small example showing the wla 6510 syntax
; written by ville helin <vhelin@cc.hut.fi> in 1998-2000
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.INCLUDE "defines.i"

;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; main
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»

.BANK 0 SLOT 0
.ORG 0


.SECTION "Beginning"

MAIN:	NOP
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

	ARR	#20
	AXS	#20
	XAA	#20
.ENDS
