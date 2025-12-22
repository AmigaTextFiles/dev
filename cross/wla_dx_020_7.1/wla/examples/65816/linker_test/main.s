
;»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
; a small example showing the wla 65816 syntax
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
	AND	$1234
	AND	$123456
	AND	($12)
	AND	[$12]
	AND	$12,X
	AND	$1234,X
	AND	$123456,X
	AND	$1234,Y
	AND	$12,S
	AND	($12,X)
	AND	($12),Y
	AND	($12,S),Y
	AND	[$12],Y
	BRK
.ENDS


.ORG $100
.SECTION "Testing" FORCE
.16BIT
	AND	XYZ+1
.8BIT
.ENDS


.ORG $120
	AND	$665544
.ORG $130
.24BIT
	AND	$100000+XYZ
.8BIT


.ORG $140
	ADC	#$A
	LDX	#$A
	REP	#%00010000
	ADC	#$A
	LDX	#$A
	NOP
